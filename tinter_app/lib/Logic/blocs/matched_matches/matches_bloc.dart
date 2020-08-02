import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/repository/matched_repository.dart';
import 'package:tinterapp/Logic/models/match.dart';

part 'matches_event.dart';

part 'matches_state.dart';

class MatchedMatchesBloc extends Bloc<MatchedMatchesEvent, MatchedMatchesState> {
  MatchedRepository matchedRepository;

  MatchedMatchesBloc({@required this.matchedRepository})
      :
        assert(matchedRepository != null),
        super(MatchedMatchesInitialState());

  @override
  Stream<MatchedMatchesState> mapEventToState(MatchedMatchesEvent event) async* {
    switch (event.runtimeType) {
      case MatchedMatchesRequestedEvent:
        yield* _mapMatchedMatchesRequestedEventToState();
        return;
      case ChangeStatusMatchedMatchesEvent:
        if (state is MatchedMatchesLoadSuccessState) {
          yield* _mapChangeStatusMatchedMatchesEventToState(event);
        } else {
          _addError('ChangeStatusMatchedMatchesEvent was called while state is not MatchedMatchesLoadSuccessState');
        }
    }

    print('event: ' + event.toString() + ' no treated');
    }

  Stream<MatchedMatchesState> _mapMatchedMatchesRequestedEventToState() async* {
    yield MatchedMatchesLoadInProgressState();
    List<Match> matches = await matchedRepository.getMatches();
    yield MatchedMatchesLoadSuccessState(matches: matches);
  }

  Stream<MatchedMatchesState> _mapChangeStatusMatchedMatchesEventToState(ChangeStatusMatchedMatchesEvent event) async* {
    Match newMatch = Match(
        event.match.name,
        event.match.surname,
        event.newStatus,
        event.match.associations,
        event.match.attiranceVieAsso,
        event.match.feteOuCours,
        event.match.aideOuSortir,
        event.match.organisationEvenements,
        event.match.goutsMusicaux);
    matchedRepository.updateMatchStatus(newMatch);
    yield MatchedMatchesLoadSuccessState(
        matches: (state as MatchedMatchesLoadSuccessState).withUpdatedMatch(event.match, newMatch));
  }


  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
