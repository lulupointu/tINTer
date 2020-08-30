import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/scolaire/binome_pair_match.dart';
import 'package:tinterapp/Logic/models/scolaire/relation_status_binome_pair.dart';
import 'package:tinterapp/Logic/models/scolaire/relation_status_scolaire.dart';
import 'package:tinterapp/Logic/repository/scolaire/matched_binome_pair_matches_repository.dart';

part 'matched_pair_matches_event.dart';

part 'matched_pair_matches_state.dart';

class MatchedBinomePairMatchesBloc extends Bloc<MatchedBinomePairMatchesEvent, MatchedBinomePairMatchesState> {
  MatchedBinomePairMatchesRepository matchedBinomePairMatchesRepository;
  AuthenticationBloc authenticationBloc;

  MatchedBinomePairMatchesBloc(
      {@required this.matchedBinomePairMatchesRepository, @required this.authenticationBloc})
      : assert(matchedBinomePairMatchesRepository != null),
        super(MatchedBinomePairMatchesInitialState());

  @override
  Stream<MatchedBinomePairMatchesState> mapEventToState(MatchedBinomePairMatchesEvent event) async* {
    if (event is MatchedBinomePairMatchesRequestedEvent) {
      yield* _mapMatchedBinomePairMatchesRequestedEventToState();
      return;
    } else if (event is ChangeStatusMatchedBinomePairMatchesEvent) {
      if (state is MatchedBinomePairMatchesLoadSuccessState) {
        yield* _mapChangeBinomePairMatchStatusEventToState(event);
      } else {
        _addError(
            'ChangeStatusMatchedBinomePairMatchesEvent was called while state is not MatchedBinomePairMatchesLoadSuccessState');
      }
      return;
    }

    print('event: ' + event.toString() + ' no treated');
  }

  Stream<MatchedBinomePairMatchesState> _mapMatchedBinomePairMatchesRequestedEventToState() async* {
    yield MatchedBinomePairMatchesInitializingState();
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield MatchedBinomePairMatchesInitialState();
      return;
    }

    List<BuildBinomePairMatch> binomePairMatches;
    try {
      binomePairMatches = await matchedBinomePairMatchesRepository.getBinomePairMatches();
    } catch (error) {
      print(error);
      yield MatchedBinomePairMatchesInitializingFailedState();
      return;
    }
    yield MatchedBinomePairMatchesLoadSuccessState(binomePairMatches: binomePairMatches);
  }

  Stream<MatchedBinomePairMatchesState> _mapChangeBinomePairMatchStatusEventToState(
      ChangeStatusMatchedBinomePairMatchesEvent event) async* {
    BuildBinomePairMatch newBinomePairMatch = event.binomePairMatch.rebuild((b) => b..status = event.binomePairMatchStatus);

    MatchedBinomePairMatchesLoadSuccessState successState = MatchedBinomePairMatchesLoadSuccessState(
        binomePairMatches:
            (state as MatchedBinomePairMatchesLoadSuccessState).withUpdatedBinomePairMatch(event.binomePairMatch, newBinomePairMatch));

    yield MatchedBinomePairMatchesSavingNewStatusState(
        binomePairMatches: (state as MatchedBinomePairMatchesLoadSuccessState).binomePairMatches);
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield MatchedBinomePairMatchesInitialState();
      return;
    }

    try {
      matchedBinomePairMatchesRepository.updateBinomePairMatchStatus(
        relationStatus: RelationStatusBinomePair(
          (r) => r
            ..binomePairId = null
            ..otherBinomePairId = event.binomePairMatch.binomePairId
            ..status = event.enumRelationStatusBinomePair,
        ),
      );
    } catch (error) {
      print(error);
      yield MatchedBinomePairMatchesLoadFailureState(
          binomePairMatches: (state as MatchedBinomePairMatchesLoadSuccessState).binomePairMatches);
    }

    yield successState;
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
