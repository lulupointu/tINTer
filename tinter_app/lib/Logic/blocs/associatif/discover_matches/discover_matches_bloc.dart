import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/relation_status.dart';
import 'package:tinterapp/Logic/repository/associatif/discover_repository.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';

part 'discover_matches_event.dart';

part 'discover_matches_state.dart';

class DiscoverMatchesBloc extends Bloc<DiscoverMatchesEvent, DiscoverMatchesState> {
  final DiscoverRepository discoverRepository;
  final AuthenticationBloc authenticationBloc;

  DiscoverMatchesBloc({@required this.discoverRepository, @required this.authenticationBloc})
      : assert(discoverRepository != null),
        super(DiscoverMatchesInitialState());

  @override
  Stream<DiscoverMatchesState> mapEventToState(DiscoverMatchesEvent event) async* {
    switch (event.runtimeType) {
      case DiscoverMatchesRequestedEvent:
        yield* _mapDiscoverMatchesRequestedEventToState();
        return;
      case ChangeStatusDiscoverMatchesEvent:
        if (state is DiscoverMatchesWaitingStatusChangeState) {
          yield* _mapChangeStatusDiscoverMatchesEventToState(event);
        } else {
          _addError(
              'ChangeStatusDiscoverMatchesEvent was called while state is not DiscoverMatchesLoadSuccessState');
        }
        return;
      case DiscoverMatchLikeEvent:
        if (state is DiscoverMatchesWaitingStatusChangeState) {
          _mapDiscoverMatchLikeEventToState();
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverMatchesLoadSuccessState');
        }
        return;
      case DiscoverMatchIgnoreEvent:
        if (state is DiscoverMatchesWaitingStatusChangeState) {
          _mapDiscoverMatchIgnoreEventToState();
        } else {
          _addError(
              'DiscoverMatchIgnoreEvent was called while state is not DiscoverMatchesLoadSuccessState');
        }
        return;
    }

    print('event: ' + event.toString() + ' no treated');
  }

  Stream<DiscoverMatchesState> _mapDiscoverMatchesRequestedEventToState() async* {
    yield DiscoverMatchesLoadInProgressState();
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield DiscoverMatchesInitialState();
      return;
    }

    List<Match> matches;
    try {
      matches = await discoverRepository.getMatches(limit: 5, offset: 0);
    } catch (error) {
      print(error);
      yield DiscoverMatchesLoadFailureState();
      return;
    }

    yield DiscoverMatchesWaitingStatusChangeState(matches: matches);
  }

  Stream<DiscoverMatchesState> _mapChangeStatusDiscoverMatchesEventToState(
      ChangeStatusDiscoverMatchesEvent event) async* {
    List<Match> oldMatches = (state as DiscoverMatchesWaitingStatusChangeState).matches;
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield DiscoverMatchesInitialState();
      return;
    }

    List<Match> newMatches = List<Match>.from(oldMatches);
    newMatches.remove(event.match);


    yield DiscoverMatchesSavingNewStatusState(matches: newMatches);

    // Update database
    try {
      await discoverRepository.updateMatchStatus(
        relationStatus: RelationStatusAssociatif(
          login: null,
          otherLogin: event.match.login,
          status: event.enumRelationStatusAssociatif,
        ),
      );
    } catch (error) {
      print(error);
      yield DiscoverMatchesWaitingStatusChangeState(matches: oldMatches);
    }

    // Get next discovery user
    Match newMatch;
    try {
      newMatch = (await discoverRepository.getMatches(
        offset: newMatches.length,
        limit: 1,
      ))[0];
    } catch (error) {
      print(error);
      yield DiscoverMatchesWaitingStatusChangeState(matches: oldMatches);
    }

    if (newMatch != null) {
      newMatches.add(newMatch);
    }

    yield DiscoverMatchesWaitingStatusChangeState(matches: newMatches);
  }

  void _mapDiscoverMatchLikeEventToState() {
    /// Grab the current displayed match, we know it's the first in the list
    final Match displayedMatch = (state as DiscoverMatchesWaitingStatusChangeState).matches[0];
    add(ChangeStatusDiscoverMatchesEvent(
        match: displayedMatch,
        newStatus: MatchStatus.liked,
        enumRelationStatusAssociatif: EnumRelationStatusAssociatif.liked));
  }

  void _mapDiscoverMatchIgnoreEventToState() {
    /// Grab the current displayed match, we know it's the first in the list
    final Match displayedMatch = (state as DiscoverMatchesWaitingStatusChangeState).matches[0];
    add(ChangeStatusDiscoverMatchesEvent(
        match: displayedMatch,
        newStatus: MatchStatus.ignored,
        enumRelationStatusAssociatif: EnumRelationStatusAssociatif.ignored));
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
