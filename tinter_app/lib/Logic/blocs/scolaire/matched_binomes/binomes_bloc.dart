import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/relation_status_associatif.dart';
import 'package:tinterapp/Logic/repository/associatif/matched_matches_repository.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';

part 'matches_event.dart';

part 'matches_state.dart';

class MatchedMatchesBloc extends Bloc<MatchedMatchesEvent, MatchedMatchesState> {
  MatchedMatchesRepository matchedMatchesRepository;
  AuthenticationBloc authenticationBloc;

  MatchedMatchesBloc(
      {@required this.matchedMatchesRepository, @required this.authenticationBloc})
      : assert(matchedMatchesRepository != null),
        super(MatchedMatchesInitialState());

  @override
  Stream<MatchedMatchesState> mapEventToState(MatchedMatchesEvent event) async* {
    if (event is MatchedMatchesRequestedEvent) {
      yield* _mapMatchedMatchesRequestedEventToState();
      return;
    } else if (event is ChangeStatusMatchedMatchesEvent) {
      if (state is MatchedMatchesLoadSuccessState) {
        yield* _mapChangeMatchStatusEventToState(event);
      } else {
        _addError(
            'ChangeStatusMatchedMatchesEvent was called while state is not MatchedMatchesLoadSuccessState');
      }
      return;
    }

    print('event: ' + event.toString() + ' no treated');
  }

  Stream<MatchedMatchesState> _mapMatchedMatchesRequestedEventToState() async* {
    yield MatchedMatchesInitializingState();
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield MatchedMatchesInitialState();
      return;
    }

    List<BuildMatch> matches;
    try {
      matches = await matchedMatchesRepository.getMatches();
    } catch (error) {
      print(error);
      yield MatchedMatchesInitializingFailedState();
      return;
    }
    yield MatchedMatchesLoadSuccessState(matches: matches);
  }

  Stream<MatchedMatchesState> _mapChangeMatchStatusEventToState(
      ChangeStatusMatchedMatchesEvent event) async* {
    BuildMatch newMatch = event.match.rebuild((b) => b..status = event.matchStatus);

    MatchedMatchesLoadSuccessState successState = MatchedMatchesLoadSuccessState(
        matches:
            (state as MatchedMatchesLoadSuccessState).withUpdatedMatch(event.match, newMatch));

    yield MatchedMatchesSavingNewStatusState(
        matches: (state as MatchedMatchesLoadSuccessState).matches);
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield MatchedMatchesInitialState();
      return;
    }

    try {
      matchedMatchesRepository.updateMatchStatus(
        relationStatus: RelationStatusAssociatif(
          (r) => r
            ..login = null
            ..otherLogin = event.match.login
            ..status = event.enumRelationStatusAssociatif,
        ),
      );
    } catch (error) {
      print(error);
      yield MatchedMatchesLoadFailureState(
          matches: (state as MatchedMatchesLoadSuccessState).matches);
    }

    yield successState;
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
