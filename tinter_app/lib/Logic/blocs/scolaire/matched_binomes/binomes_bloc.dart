import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/scolaire/binome.dart';
import 'package:tinterapp/Logic/models/scolaire/relation_status_scolaire.dart';
import 'package:tinterapp/Logic/repository/scolaire/matched_binomes_repository.dart';

part 'binomes_event.dart';

part 'binomes_state.dart';

class MatchedBinomesBloc extends Bloc<MatchedBinomesEvent, MatchedBinomesState> {
  MatchedBinomesRepository matchedBinomesRepository;
  AuthenticationBloc authenticationBloc;

  MatchedBinomesBloc(
      {@required this.matchedBinomesRepository, @required this.authenticationBloc})
      : assert(matchedBinomesRepository != null),
        super(MatchedBinomesInitialState());

  @override
  Stream<MatchedBinomesState> mapEventToState(MatchedBinomesEvent event) async* {
    if (event is MatchedBinomesRequestedEvent) {
      yield* _mapMatchedBinomesRequestedEventToState();
      return;
    } else if (event is ChangeStatusMatchedBinomesEvent) {
      if (state is MatchedBinomesLoadSuccessState) {
        yield* _mapChangeBinomeStatusEventToState(event);
      } else {
        _addError(
            'ChangeStatusMatchedBinomesEvent was called while state is not MatchedBinomesLoadSuccessState');
      }
      return;
    }

    print('event: ' + event.toString() + ' no treated');
  }

  Stream<MatchedBinomesState> _mapMatchedBinomesRequestedEventToState() async* {
    yield MatchedBinomesInitializingState();
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield MatchedBinomesInitialState();
      return;
    }

    List<BuildBinome> binomes;
    try {
      binomes = await matchedBinomesRepository.getBinomes();
    } catch (error) {
      print(error);
      yield MatchedBinomesInitializingFailedState();
      return;
    }
    yield MatchedBinomesLoadSuccessState(binomes: binomes);
  }

  Stream<MatchedBinomesState> _mapChangeBinomeStatusEventToState(
      ChangeStatusMatchedBinomesEvent event) async* {
    BuildBinome newBinome = event.binome.rebuild((b) => b..statusScolaire = event.binomeStatus);

    MatchedBinomesLoadSuccessState successState = MatchedBinomesLoadSuccessState(
        binomes:
            (state as MatchedBinomesLoadSuccessState).withUpdatedBinome(event.binome, newBinome));

    yield MatchedBinomesSavingNewStatusState(
        binomes: (state as MatchedBinomesLoadSuccessState).binomes);
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield MatchedBinomesInitialState();
      return;
    }

    try {
      matchedBinomesRepository.updateBinomeStatus(
        relationStatus: RelationStatusScolaire(
          (r) => r
            ..login = null
            ..otherLogin = event.binome.login
            ..statusScolaire = event.enumRelationStatusScolaire,
        ),
      );
    } catch (error) {
      print(error);
      yield MatchedBinomesLoadFailureState(
          binomes: (state as MatchedBinomesLoadSuccessState).binomes);
    }

    yield successState;
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}