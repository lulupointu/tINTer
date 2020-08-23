import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/scolaire/user_scolaire.dart';
import 'package:tinterapp/Logic/repository/scolaire/user_scolaire_repository.dart';

part 'user_scolaire_state.dart';

part 'user_scolaire_event.dart';

class UserScolaireBloc extends Bloc<UserScolaireEvent, UserScolaireState> {
  final UserScolaireRepository userScolaireRepository;
  final AuthenticationBloc authenticationBloc;

  UserScolaireBloc({@required this.userScolaireRepository, @required this.authenticationBloc})
      : super(UserScolaireInitialState());

  @override
  Stream<UserScolaireState> mapEventToState(UserScolaireEvent event) async* {
    switch (event.runtimeType) {
      case UserScolaireInitEvent:
        yield* _mapUserScolaireInitEventToState();
        return;
//      case UserScolaireNewProfileEvent:
//        yield* _mapUserScolaireNewProfileEventToState(event);
//        return;
      case UserScolaireRequestEvent:
        yield* _mapUserScolaireRequestEventToState();
        return;
      case UserScolaireRefreshEvent:
        yield* _mapUserScolaireRefreshEventToState();
        return;
      case UserScolaireSaveEvent:
        if (state is KnownUserScolaireUnsavedState) {
          yield* _mapUserScolaireSaveEventToState(
              (state as KnownUserScolaireUnsavedState).userScolaire);
        } else if (state is NewUserScolaireCreatingProfileState) {
          yield* _mapNewUserScolaireSaveEventToState(
              (state as NewUserScolaireCreatingProfileState).userScolaire);
        } else {
          _addError(
              'Saved was call while state was ${state.runtimeType}. Whereas it should be either KnownUserScolaireUnsavedState or NewUserScolaireCreatingProfileState');
        }
        return;
      case UserScolaireUndoUnsavedChangesEvent:
        if (state is KnownUserScolaireUnsavedState) {
          yield* _mapUserScolaireUndoUnsavedChangesEventToState();
        } else {
          _addError(
              'Saved was call while state was ${state.runtimeType}. Whereas it should be KnownUserScolaireUnsavedState');
        }

        return;
      case UserScolaireMutableAttributeChangedEvent:
        if (state is UserScolaireLoadSuccessState) {
          yield* _mapUserScolaireMutableAttributeChangedEventToState(event);
        } else {
          _addError(
              'UserScolaireMutableAttributeChangedEvent received while state is not UserScolaireLoadSuccessState');
        }
        return;
//      case DeleteUserScolaireAccountEvent:
//        if (state is UserScolaireLoadSuccessState) {
//          yield* _mapDeleteUserScolaireAccountEventToState();
//        } else {
//          _addError(
//              'ProfilePicturePathChangedEvent received while state is not UserScolaireLoadSuccessState');
//        }
//        return;
    }

    print('event: ' + event.toString() + ' no treated');
  }

  Stream<UserScolaireState> _mapUserScolaireInitEventToState() async* {
    yield UserScolaireInitializingState();

    UserScolaire userScolaire;
    try {
      userScolaire = await userScolaireRepository.getUser();
    } catch (error) {
      print(error);
      yield UserScolaireInitialState();
      return;
    }

    yield KnownUserScolaireSavedState(userScolaire: userScolaire);
  }

  Stream<UserScolaireState> _mapUserScolaireRequestEventToState() async* {
    yield UserScolaireInitializingState();

    UserScolaire userScolaire;
    try {
      userScolaire = await userScolaireRepository.getUser();
    } catch (error) {
      yield UserScolaireInitializingFailedState();
      return;
    }
    yield KnownUserScolaireSavedState(userScolaire: userScolaire);
  }

  Stream<UserScolaireState> _mapUserScolaireRefreshEventToState() async* {
    if (!(state is KnownUserScolaireState)) {
      print("Trying to refresh while the userScolaire wasn't known");
      yield UserScolaireInitialState();
      return;
    }
    yield KnownUserScolaireRefreshingState(
        userScolaire: (state as KnownUserScolaireState).userScolaire);

    UserScolaire userScolaire;
    try {
      userScolaire = await userScolaireRepository.getUser();
    } catch (error) {
      yield KnownUserScolaireRefreshingFailedState(
          userScolaire: (state as KnownUserScolaireState).userScolaire);
      return;
    }
    yield KnownUserScolaireSavedState(userScolaire: userScolaire);
  }

  Stream<UserScolaireState> _mapNewUserScolaireSaveEventToState(
      UserScolaire userScolaire) async* {
    yield NewUserScolaireSavingState(userScolaire: userScolaire);
    try {
      await userScolaireRepository.createUser(user: userScolaire);
    } catch (error) {
      yield NewUserScolaireCreatingProfileState(userScolaire: userScolaire);
      return;
    }

    imageCache.clear();

    // We create a new userScolaire manually in order to put the profilePicturePath to null
    yield KnownUserScolaireSavedState(
        userScolaire: (state as KnownUserScolaireUnsavedState).userScolaire);
  }

  Stream<UserScolaireState> _mapUserScolaireSaveEventToState(
      UserScolaire userScolaire) async* {
    yield KnownUserScolaireSavingState(
        userScolaire: userScolaire,
        oldSavedUserScolaire: (state as KnownUserScolaireUnsavedState).oldSavedUserScolaire);

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserScolaireInitialState();
      return;
    }

    try {
      await userScolaireRepository.updateUser(user: userScolaire);
    } catch (error) {
      yield KnownUserScolaireSavingFailedState(
          userScolaire: userScolaire,
          oldSavedUserScolaire: (state as KnownUserScolaireUnsavedState).oldSavedUserScolaire);
      return;
    }

    imageCache.clear();

    // We create a new userScolaire manually in order to put the profilePicturePath to null
    yield KnownUserScolaireSavedState(
        userScolaire: (state as KnownUserScolaireUnsavedState).userScolaire);
  }

  Stream<UserScolaireState> _mapUserScolaireUndoUnsavedChangesEventToState() async* {
    yield KnownUserScolaireSavedState(
        userScolaire: (state as KnownUserScolaireUnsavedState).oldSavedUserScolaire);
  }

  Stream<UserScolaireState> _mapUserScolaireMutableAttributeChangedEventToState(
      UserScolaireMutableAttributeChangedEvent event) async* {
    yield (state as UserScolaireLoadSuccessState).withNewState(
      newState: event.newState,
    );
  }

//  Stream<UserScolaireState> _mapDeleteUserScolaireAccountEventToState() async* {
//    try {
//      await userScolaireRepository.deleteUserAccount();
//    } catch (error) {
//      print('Removing account failed: $error');
//      return;
//    }
//
//    authenticationBloc.add(AuthenticationLoggedOutEvent());
//
//    yield UserScolaireInitialState();
//  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
