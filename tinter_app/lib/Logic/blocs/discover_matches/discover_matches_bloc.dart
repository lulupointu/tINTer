import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/blocs/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/relation_status.dart';
import 'package:tinterapp/Logic/repository/discover_repository.dart';
import 'package:tinterapp/Logic/models/match.dart';

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
        if (state is DiscoverMatchesLoadSuccessState) {
          yield* _mapChangeStatusDiscoverMatchesEventToState(event);
        } else {
          _addError(
              'ChangeStatusDiscoverMatchesEvent was called while state is not DiscoverMatchesLoadSuccessState');
        }
        return;
      case DiscoverMatchLikeEvent:
        if (state is DiscoverMatchesLoadSuccessState) {
          _mapDiscoverMatchLikeEventToState();
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverMatchesLoadSuccessState');
        }
        return;
      case DiscoverMatchIgnoreEvent:
        if (state is DiscoverMatchesLoadSuccessState) {
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
      matches = await discoverRepository.getMatches();
    } catch (error) {
      print(error);
      yield DiscoverMatchesLoadFailureState();
    }
    yield DiscoverMatchesLoadSuccessState(matches: matches);
  }

  Stream<DiscoverMatchesState> _mapChangeStatusDiscoverMatchesEventToState(
      ChangeStatusDiscoverMatchesEvent event) async* {
    List<Match> oldMatches = (state as DiscoverMatchesLoadSuccessState).matches;
    yield DiscoverMatchesSavingNewStatusState();
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield DiscoverMatchesInitialState();
      return;
    }

    Match newMatch = Match(
      login: event.match.login,
      name: event.match.name,
      surname: event.match.surname,
      email: event.match.email,
      score: event.match.score,
      status: event.newStatus,
      primoEntrant: event.match.primoEntrant,
      associations: event.match.associations,
      attiranceVieAsso: event.match.attiranceVieAsso,
      feteOuCours: event.match.feteOuCours,
      aideOuSortir: event.match.aideOuSortir,
      organisationEvenements: event.match.organisationEvenements,
      goutsMusicaux: event.match.goutsMusicaux,
    );

    try {
      discoverRepository.updateMatchStatus(
        relationStatus: RelationStatus(
          login: null,
          otherLogin: event.match.login,
          status: event.enumRelationStatus,
        ),
      );
    } catch (error) {
      print(error);
      yield DiscoverMatchesLoadSuccessState(matches: oldMatches);
    }
    yield DiscoverMatchesLoadSuccessState(
        matches: (state as DiscoverMatchesLoadSuccessState)
            .withUpdatedMatch(event.match, newMatch));
  }

  void _mapDiscoverMatchLikeEventToState() {
    /// Grab the current displayed match, we know it's the first in the list
    final Match displayedMatch = (state as DiscoverMatchesLoadSuccessState).matches[0];
    add(ChangeStatusDiscoverMatchesEvent(
        match: displayedMatch,
        newStatus: MatchStatus.liked,
        enumRelationStatus: EnumRelationStatus.liked));
  }

  void _mapDiscoverMatchIgnoreEventToState() {
    /// Grab the current displayed match, we know it's the first in the list
    final Match displayedMatch = (state as DiscoverMatchesLoadSuccessState).matches[0];
    add(ChangeStatusDiscoverMatchesEvent(
        match: displayedMatch,
        newStatus: MatchStatus.ignored,
        enumRelationStatus: EnumRelationStatus.ignored));
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
