import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/blocs/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/relation_status.dart';
import 'package:tinterapp/Logic/repository/matched_repository.dart';
import 'package:tinterapp/Logic/models/match.dart';

part 'matches_event.dart';

part 'matches_state.dart';

class MatchedMatchesBloc extends Bloc<MatchedMatchesEvent, MatchedMatchesState> {
  MatchedRepository matchedRepository;
  AuthenticationBloc authenticationBloc;

  MatchedMatchesBloc({@required this.matchedRepository, @required this.authenticationBloc})
      : assert(matchedRepository != null),
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

    List<Match> matches;
    try {
      matches = await matchedRepository.getMatches();
    } catch (error) {
      print(error);
      yield MatchedMatchesInitializingFailedState();
      return;
    }
    yield MatchedMatchesLoadSuccessState(matches: matches);
  }

  Stream<MatchedMatchesState> _mapChangeMatchStatusEventToState(
      ChangeStatusMatchedMatchesEvent event) async* {

    Match newMatch = Match(
      login: event.match.login,
      name: event.match.name,
      surname: event.match.surname,
      email: event.match.email,
      score: event.match.score,
      status: event.matchStatus,
      primoEntrant: event.match.primoEntrant,
      associations: event.match.associations,
      attiranceVieAsso: event.match.attiranceVieAsso,
      feteOuCours: event.match.feteOuCours,
      aideOuSortir: event.match.aideOuSortir,
      organisationEvenements: event.match.organisationEvenements,
      goutsMusicaux: event.match.goutsMusicaux,
    );

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
      matchedRepository.updateMatchStatus(
        relationStatus: RelationStatus(
          login: null,
          otherLogin: event.match.login,
          status: event.enumRelationStatus,
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
