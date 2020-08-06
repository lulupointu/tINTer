import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/repository/discover_repository.dart';
import 'package:tinterapp/Logic/models/match.dart';

part 'discover_matches_event.dart';

part 'discover_matches_state.dart';

class DiscoverMatchesBloc extends Bloc<DiscoverMatchesEvent, DiscoverMatchesState> {
  final DiscoverRepository discoverRepository;

  DiscoverMatchesBloc({@required this.discoverRepository}) :
        assert(discoverRepository!=null),
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
          _addError('ChangeStatusDiscoverMatchesEvent was called while state is not DiscoverMatchesLoadSuccessState');
        }
        return;
      case DiscoverMatchLikeEvent:
        if (state is DiscoverMatchesLoadSuccessState) {
          _mapDiscoverMatchLikeEventToState();
        } else {
          _addError('DiscoverMatchLikeEvent was called while state is not DiscoverMatchesLoadSuccessState');
        }
        return;
      case DiscoverMatchIgnoreEvent:
        if (state is DiscoverMatchesLoadSuccessState) {
          _mapDiscoverMatchIgnoreEventToState();
        } else {
          _addError('DiscoverMatchIgnoreEvent was called while state is not DiscoverMatchesLoadSuccessState');
        }
        return;
    }

    print('event: ' + event.toString() + ' no treated');
  }

  Stream<DiscoverMatchesState> _mapDiscoverMatchesRequestedEventToState() async* {
    yield DiscoverMatchesLoadInProgressState();
    List<Match> matches = await discoverRepository.getMatches();
    yield DiscoverMatchesLoadSuccessState(matches: matches);
  }

  Stream<DiscoverMatchesState> _mapChangeStatusDiscoverMatchesEventToState(ChangeStatusDiscoverMatchesEvent event) async* {
    Match newMatch = Match(
        event.match.name,
        event.match.surname,
        event.match.email,
        event.newStatus,
        event.match.score,
        event.match.primoEntrant,
        event.match.associations,
        event.match.attiranceVieAsso,
        event.match.feteOuCours,
        event.match.aideOuSortir,
        event.match.organisationEvenements,
        event.match.goutsMusicaux);
    discoverRepository.updateMatchStatus(newMatch);
    yield DiscoverMatchesLoadSuccessState(
        matches: (state as DiscoverMatchesLoadSuccessState).withUpdatedMatch(event.match, newMatch));
  }

  void _mapDiscoverMatchLikeEventToState() {
    /// Grab the current displayed match, we know it's the first in the list
    final Match displayedMatch = (state as DiscoverMatchesLoadSuccessState).matches[0];
    add(ChangeStatusDiscoverMatchesEvent(match: displayedMatch, newStatus: MatchStatus.liked));
  }

  void _mapDiscoverMatchIgnoreEventToState() {
    /// Grab the current displayed match, we know it's the first in the list
    final Match displayedMatch = (state as DiscoverMatchesLoadSuccessState).matches[0];
    add(ChangeStatusDiscoverMatchesEvent(match: displayedMatch, newStatus: MatchStatus.ignored));
  }


  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
