import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/relation_status_associatif.dart';
import 'package:tinterapp/Logic/models/scolaire/binome.dart';
import 'package:tinterapp/Logic/repository/associatif/discover_matches_repository.dart';
import 'package:tinterapp/Logic/repository/scolaire/discover_binomes_repository.dart';

part 'discover_binomes_event.dart';

part 'discover_binomes_state.dart';

class DiscoverBinomesBloc extends Bloc<DiscoverBinomesEvent, DiscoverBinomesState> {
  final DiscoverBinomesRepository discoverBinomesRepository;
  final AuthenticationBloc authenticationBloc;

  DiscoverBinomesBloc({@required this.discoverBinomesRepository, @required this.authenticationBloc})
      : assert(discoverBinomesRepository != null),
        super(DiscoverBinomesInitialState());

  @override
  Stream<DiscoverBinomesState> mapEventToState(DiscoverBinomesEvent event) async* {
    switch (event.runtimeType) {
      case DiscoverBinomesRequestedEvent:
        yield* _mapDiscoverBinomesRequestedEventToState();
        return;
      case DiscoverBinomesChangeStatusEvent:
        if (state is DiscoverBinomesWaitingStatusChangeState) {
          yield* _mapChangeStatusDiscoverBinomesEventToState(event);
        } else {
          _addError(
              'ChangeStatusDiscoverBinomesEvent was called while state is not DiscoverBinomesLoadSuccessState');
        }
        return;
      case DiscoverBinomeLikeEvent:
        if (state is DiscoverBinomesWaitingStatusChangeState) {
          _mapDiscoverBinomeLikeEventToState();
        } else {
          _addError(
              'DiscoverBinomeLikeEvent was called while state is not DiscoverBinomesLoadSuccessState');
        }
        return;
      case DiscoverBinomeIgnoreEvent:
        if (state is DiscoverBinomesWaitingStatusChangeState) {
          _mapDiscoverBinomeIgnoreEventToState();
        } else {
          _addError(
              'DiscoverBinomeIgnoreEvent was called while state is not DiscoverBinomesLoadSuccessState');
        }
        return;
    }

    print('event: ' + event.toString() + ' no treated');
  }

  Stream<DiscoverBinomesState> _mapDiscoverBinomesRequestedEventToState() async* {
    yield DiscoverBinomesLoadInProgressState();
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield DiscoverBinomesInitialState();
      return;
    }

    List<BuildBinome> binomes;
    try {
      binomes = await discoverBinomesRepository.getBinomes(limit: 5, offset: 0);
    } catch (error) {
      print(error);
      yield DiscoverBinomesLoadFailureState();
      return;
    }

    yield DiscoverBinomesWaitingStatusChangeState(binomes: binomes);
  }

  Stream<DiscoverBinomesState> _mapChangeStatusDiscoverBinomesEventToState(
      DiscoverBinomesChangeStatusEvent event) async* {
    List<BuildBinome> oldBinomes = (state as DiscoverBinomesWaitingStatusChangeState).binomes;
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield DiscoverBinomesInitialState();
      return;
    }

    List<BuildBinome> newBinomes = List<BuildBinome>.from(oldBinomes);
    newBinomes.remove(event.binome);


    yield DiscoverBinomesSavingNewStatusState(binomes: newBinomes);

    // Update database
    try {
      await discoverBinomesRepository.updateBinomeStatus(
        relationStatus: RelationStatusAssociatif((r) => r
          ..login = null
          ..otherLogin = event.binome.userScolaire.user.login
          ..status = event.enumRelationStatusAssociatif,
        ),
      );
    } catch (error) {
      print(error);
      yield DiscoverBinomesWaitingStatusChangeState(binomes: oldBinomes);
    }

    // Get next discovery user
    BuildBinome newBinome;
    try {
      newBinome = (await discoverBinomesRepository.getBinomes(
        offset: newBinomes.length,
        limit: 1,
      ))[0];
    } catch (error) {
      print(error);
      yield DiscoverBinomesWaitingStatusChangeState(binomes: oldBinomes);
    }

    if (newBinome != null) {
      newBinomes.add(newBinome);
    }

    yield DiscoverBinomesWaitingStatusChangeState(binomes: newBinomes);
  }

  void _mapDiscoverBinomeLikeEventToState() {
    /// Grab the current displayed binome, we know it's the first in the list
    final BuildBinome displayedBinome = (state as DiscoverBinomesWaitingStatusChangeState).binomes[0];
    add(DiscoverBinomesChangeStatusEvent(
        binome: displayedBinome,
        newStatus: BinomeStatus.liked,
        enumRelationStatusAssociatif: EnumRelationStatusAssociatif.liked));
  }

  void _mapDiscoverBinomeIgnoreEventToState() {
    /// Grab the current displayed binome, we know it's the first in the list
    final BuildBinome displayedBinome = (state as DiscoverBinomesWaitingStatusChangeState).binomes[0];
    add(DiscoverBinomesChangeStatusEvent(
        binome: displayedBinome,
        newStatus: BinomeStatus.ignored,
        enumRelationStatusAssociatif: EnumRelationStatusAssociatif.ignored));
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
