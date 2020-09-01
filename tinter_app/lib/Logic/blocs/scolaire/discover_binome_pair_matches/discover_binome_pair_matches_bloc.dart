import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/scolaire/binome_pair_match.dart';
import 'package:tinterapp/Logic/models/scolaire/relation_status_binome_pair.dart';
import 'package:tinterapp/Logic/repository/scolaire/discover_binome_pair_matches_repository.dart';

part 'discover_binome_pair_matches_event.dart';

part 'discover_binome_pair_matches_state.dart';

class DiscoverBinomePairMatchesBloc
    extends Bloc<DiscoverBinomePairMatchesEvent, DiscoverBinomePairMatchesState> {
  final DiscoverBinomePairMatchesRepository discoverBinomePairMatchesRepository;
  final AuthenticationBloc authenticationBloc;

  DiscoverBinomePairMatchesBloc(
      {@required this.discoverBinomePairMatchesRepository, @required this.authenticationBloc})
      : assert(discoverBinomePairMatchesRepository != null),
        super(DiscoverBinomePairMatchesInitialState());

  @override
  Stream<DiscoverBinomePairMatchesState> mapEventToState(
      DiscoverBinomePairMatchesEvent event) async* {
    switch (event.runtimeType) {
      case DiscoverBinomePairMatchesRequestedEvent:
        yield* _mapDiscoverBinomePairMatchesRequestedEventToState();
        return;
      case DiscoverBinomePairMatchesRefreshEvent:
        if (state is DiscoverBinomePairMatchesLoadSuccessState) {
          yield* _mapDiscoverBinomePairMatchesRefreshEventToState();
        } else {
          _addError(
              'DiscoverBinomePairMatchesRefreshEvent was called while state is not DiscoverBinomePairMatchesLoadSuccessState');
        }
        return;
      case DiscoverBinomePairMatchesChangeStatusEvent:
        if (state is DiscoverBinomePairMatchesWaitingStatusChangeState) {
          yield* _mapChangeStatusDiscoverBinomePairMatchesEventToState(event);
        } else {
          _addError(
              'ChangeStatusDiscoverBinomePairMatchesEvent was called while state is not DiscoverBinomePairMatchesLoadSuccessState');
        }
        return;
      case DiscoverBinomePairMatchesLikeEvent:
        if (state is DiscoverBinomePairMatchesWaitingStatusChangeState) {
          _mapDiscoverBinomeLikeEventToState();
        } else {
          _addError(
              'DiscoverBinomeLikeEvent was called while state is not DiscoverBinomePairMatchesLoadSuccessState');
        }
        return;
      case DiscoverBinomePairMatchesIgnoreEvent:
        if (state is DiscoverBinomePairMatchesWaitingStatusChangeState) {
          _mapDiscoverBinomeIgnoreEventToState();
        } else {
          _addError(
              'DiscoverBinomeIgnoreEvent was called while state is not DiscoverBinomePairMatchesLoadSuccessState');
        }
        return;
    }

    print('event: ' + event.toString() + ' no treated');
  }

  Stream<DiscoverBinomePairMatchesState>
      _mapDiscoverBinomePairMatchesRequestedEventToState() async* {
    yield DiscoverBinomePairMatchesLoadInProgressState();
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield DiscoverBinomePairMatchesInitialState();
      return;
    }

    List<BuildBinomePairMatch> binomePairMatchPairMatches;
    try {
      binomePairMatchPairMatches =
          await discoverBinomePairMatchesRepository.getBinomePairMatches(limit: 5, offset: 0);
    } catch (error) {
      print(error);
      yield DiscoverBinomePairMatchesLoadFailureState();
      return;
    }

    yield DiscoverBinomePairMatchesWaitingStatusChangeState(
        binomePairMatches: binomePairMatchPairMatches);
  }

  Stream<DiscoverBinomePairMatchesState>
      _mapDiscoverBinomePairMatchesRefreshEventToState() async* {
    yield DiscoverBinomePairMatchesRefreshingState(
        binomePairMatches:
            (state as DiscoverBinomePairMatchesLoadSuccessState).binomePairMatches);
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield DiscoverBinomePairMatchesInitialState();
      return;
    }

    List<BuildBinomePairMatch> binomePairMatchPairMatches;
    try {
      binomePairMatchPairMatches =
          await discoverBinomePairMatchesRepository.getBinomePairMatches(limit: 5, offset: 0);
    } catch (error) {
      print(error);
      yield DiscoverBinomePairMatchesLoadFailureState();
      return;
    }

    // If state did not change while loading
    if (state is DiscoverBinomePairMatchesRefreshingState) {
      yield DiscoverBinomePairMatchesWaitingStatusChangeState(
          binomePairMatches: binomePairMatchPairMatches);
    }
  }

  Stream<DiscoverBinomePairMatchesState> _mapChangeStatusDiscoverBinomePairMatchesEventToState(
      DiscoverBinomePairMatchesChangeStatusEvent event) async* {
    List<BuildBinomePairMatch> oldBinomePairMatches =
        (state as DiscoverBinomePairMatchesWaitingStatusChangeState).binomePairMatches;
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield DiscoverBinomePairMatchesInitialState();
      return;
    }

    List<BuildBinomePairMatch> newBinomePairMatches =
        List<BuildBinomePairMatch>.from(oldBinomePairMatches);
    newBinomePairMatches.remove(event.binomePairMatch);

    yield DiscoverBinomePairMatchesSavingNewStatusState(
        binomePairMatches: newBinomePairMatches);

    // Update database
    try {
      await discoverBinomePairMatchesRepository.updateBinomePairMatchStatus(
        relationStatus: RelationStatusBinomePair(
          (r) => r
            ..binomePairId = null
            ..otherBinomePairId = event.binomePairMatch.binomePairId
            ..status = event.enumRelationStatusBinomePair,
        ),
      );
    } catch (error) {
      print(error);
      yield DiscoverBinomePairMatchesWaitingStatusChangeState(
          binomePairMatches: oldBinomePairMatches);
    }

    // Get next discovery user
    BuildBinomePairMatch newBinome;
    try {
      newBinome = (await discoverBinomePairMatchesRepository.getBinomePairMatches(
        offset: newBinomePairMatches.length,
        limit: 1,
      ))[0];
    } catch (error) {
      print(error);
      yield DiscoverBinomePairMatchesWaitingStatusChangeState(
          binomePairMatches: oldBinomePairMatches);
    }

    if (newBinome != null) {
      newBinomePairMatches.add(newBinome);
    }

    yield DiscoverBinomePairMatchesWaitingStatusChangeState(
        binomePairMatches: newBinomePairMatches);
  }

  void _mapDiscoverBinomeLikeEventToState() {
    /// Grab the current displayed binomePairMatch, we know it's the first in the list
    final BuildBinomePairMatch displayedBinome =
        (state as DiscoverBinomePairMatchesWaitingStatusChangeState).binomePairMatches[0];
    add(DiscoverBinomePairMatchesChangeStatusEvent(
        binomePairMatch: displayedBinome,
        newStatus: BinomePairMatchStatus.liked,
        enumRelationStatusBinomePair: EnumRelationStatusBinomePair.liked));
  }

  void _mapDiscoverBinomeIgnoreEventToState() {
    /// Grab the current displayed binomePairMatch, we know it's the first in the list
    final BuildBinomePairMatch displayedBinome =
        (state as DiscoverBinomePairMatchesWaitingStatusChangeState).binomePairMatches[0];
    add(DiscoverBinomePairMatchesChangeStatusEvent(
        binomePairMatch: displayedBinome,
        newStatus: BinomePairMatchStatus.ignored,
        enumRelationStatusBinomePair: EnumRelationStatusBinomePair.ignored));
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
