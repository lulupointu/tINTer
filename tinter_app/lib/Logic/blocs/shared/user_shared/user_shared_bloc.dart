import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';

part 'user_shared_state.dart';

part 'user_shared_event.dart';

class UserSharedPartBloc extends Bloc<UserSharedPartEvent, UserSharedPartState> {
  final UserSharedPartRepository userSharedPartRepository;
  final AuthenticationBloc authenticationBloc;

  UserSharedPartBloc({@required this.userSharedPartRepository, @required this.authenticationBloc})
      : super(UserSharedPartInitialState());

  @override
  Stream<UserSharedPartState> mapEventToState(UserSharedPartEvent event) async* {
    switch (event.runtimeType) {
      case UserSharedPartInitEvent:
        yield* _mapUserSharedPartInitEventToState();
        return;
//      case UserSharedPartNewProfileEvent:
//        yield* _mapUserSharedPartNewProfileEventToState(event);
//        return;
      case UserSharedPartRequestEvent:
        yield* _mapUserSharedPartRequestEventToState();
        return;
      case UserSharedPartRefreshEvent:
        yield* _mapUserSharedPartRefreshEventToState();
        return;
      case UserSharedPartSaveEvent:
        if (state is KnownUserSharedPartUnsavedState) {
          yield* _mapUserSharedPartSaveEventToState(
              (state as KnownUserSharedPartUnsavedState).userSharedPart);
        } else if (state is NewUserSharedPartCreatingProfileState) {
          yield* _mapNewUserSharedPartSaveEventToState(
              (state as NewUserSharedPartCreatingProfileState).userSharedPart);
        } else {
          _addError(
              'Saved was call while state was ${state.runtimeType}. Whereas it should be either KnownUserSharedPartUnsavedState or NewUserSharedPartCreatingProfileState');
        }
        return;
      case UserSharedPartUndoUnsavedChangesEvent:
        if (state is KnownUserSharedPartUnsavedState) {
          yield* _mapUserSharedPartUndoUnsavedChangesEventToState();
        } else {
          _addError(
              'Saved was call while state was ${state.runtimeType}. Whereas it should be KnownUserSharedPartUnsavedState');
        }

        return;
      case UserSharedPartMutableAttributeChangedEvent:
        if (state is UserSharedPartLoadSuccessState) {
          yield* _mapUserSharedPartMutableAttributeChangedEventToState(event);
        } else {
          _addError(
              'UserSharedPartMutableAttributeChangedEvent received while state is not UserSharedPartLoadSuccessState');
        }
        return;
      case DeleteUserSharedPartAccountEvent:
        if (state is UserSharedPartLoadSuccessState) {
          yield* _mapDeleteUserSharedPartAccountEventToState();
        } else {
          _addError(
              'ProfilePicturePathChangedEvent received while state is not UserSharedPartLoadSuccessState');
        }
        return;
    }

    print('event: ' + event.toString() + ' no treated');
  }

  Stream<UserSharedPartState> _mapUserSharedPartInitEventToState() async* {
    yield UserSharedPartInitializingState();

    UserSharedPart userSharedPart;
    try {
      userSharedPart = await userSharedPartRepository.getUser();
    } catch (error) {
      print(error);
      yield UserSharedPartInitialState();
      return;
    }

    yield KnownUserSharedPartSavedState(userSharedPart: userSharedPart);
  }

  Stream<UserSharedPartState> _mapUserSharedPartRequestEventToState() async* {
    yield UserSharedPartInitializingState();

    UserSharedPart userSharedPart;
    try {
      userSharedPart = await userSharedPartRepository.getUser();
    } catch (error) {
      yield UserSharedPartInitializingFailedState();
      return;
    }
    yield KnownUserSharedPartSavedState(userSharedPart: userSharedPart);
  }

  Stream<UserSharedPartState> _mapUserSharedPartRefreshEventToState() async* {
    if (!(state is KnownUserSharedPartState)) {
      print("Trying to refresh while the userSharedPart wasn't known");
      yield UserSharedPartInitialState();
      return;
    }
    yield KnownUserSharedPartRefreshingState(
        userSharedPart: (state as KnownUserSharedPartState).userSharedPart);

    UserSharedPart userSharedPart;
    try {
      userSharedPart = await userSharedPartRepository.getUser();
    } catch (error) {
      yield KnownUserSharedPartRefreshingFailedState(
          userSharedPart: (state as KnownUserSharedPartState).userSharedPart);
      return;
    }
    yield KnownUserSharedPartSavedState(userSharedPart: userSharedPart);
  }

  Stream<UserSharedPartState> _mapNewUserSharedPartSaveEventToState(userSharedPart) async* {
    yield NewUserSharedPartSavingState(userSharedPart: userSharedPart);
    try {
      await userSharedPartRepository.createUser(user: userSharedPart);
    } catch (error) {
      yield NewUserSharedPartCreatingProfileState(userSharedPart: userSharedPart);
      return;
    }

    imageCache.clear();

    // We create a new userSharedPart manually in order to put the profilePicturePath to null
    yield KnownUserSharedPartSavedState(
      userSharedPart:
      (state as KnownUserSharedPartUnsavedState).withAttributeChanged().userSharedPart,
    );
  }

  Stream<UserSharedPartState> _mapUserSharedPartSaveEventToState(
      UserSharedPart userSharedPart) async* {
    yield KnownUserSharedPartSavingState(
        userSharedPart: userSharedPart,
        oldSavedUserSharedPart: (state as KnownUserSharedPartUnsavedState).oldSavedUserSharedPart);

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserSharedPartInitialState();
      return;
    }

    try {
      await userSharedPartRepository.updateUser(user: userSharedPart);
    } catch (error) {
      yield KnownUserSharedPartSavingFailedState(
          userSharedPart: userSharedPart,
          oldSavedUserSharedPart: (state as KnownUserSharedPartUnsavedState).oldSavedUserSharedPart);
      return;
    }

    imageCache.clear();

    // We create a new userSharedPart manually in order to put the profilePicturePath to null
    yield KnownUserSharedPartSavedState(
      userSharedPart:
      (state as KnownUserSharedPartUnsavedState).withAttributeChanged().userSharedPart,
    );
  }

  Stream<UserSharedPartState> _mapUserSharedPartUndoUnsavedChangesEventToState() async* {
    yield KnownUserSharedPartSavedState(
        userSharedPart: (state as KnownUserSharedPartUnsavedState).oldSavedUserSharedPart);
  }

  Stream<UserSharedPartState> _mapUserSharedPartMutableAttributeChangedEventToState(
      UserSharedPartMutableAttributeChangedEvent event) async* {
    switch (event.userSharedPartMutableAttribute) {
      case UserSharedPartMutableAttribute.year:
        yield (state as UserSharedPartLoadSuccessState).withAttributeChanged(
          year: event.newValue,
        );
        break;
      case UserSharedPartMutableAttribute.groupeOuSeul:
        yield (state as UserSharedPartLoadSuccessState).withAttributeChanged(
          groupeOuSeul: event.newValue,
        );
        break;
      case UserSharedPartMutableAttribute.lieuDeVie:
        yield (state as UserSharedPartLoadSuccessState).withAttributeChanged(
          lieuDeVie: event.newValue,
        );
        break;
      case UserSharedPartMutableAttribute.horairesDeTravail:
        yield (state as UserSharedPartLoadSuccessState).withAttributeChanged(
          horairesDeTravail: event.newValue,
        );
        break;
      case UserSharedPartMutableAttribute.enligneOuNon:
        yield (state as UserSharedPartLoadSuccessState).withAttributeChanged(
          enligneOuNon: event.newValue,
        );
        break;
      case UserSharedPartMutableAttribute.matieresPreferees:
        yield (state as UserSharedPartLoadSuccessState).withAttributeChanged(
          matieresPreferees: event.newValue,
        );
        break;
    }
  }

  Stream<UserSharedPartState> _mapDeleteUserSharedPartAccountEventToState() async* {
    try {
      await userSharedPartRepository.deleteUserAccount();
    } catch (error) {
      print('Removing account failed: $error');
      return;
    }

    authenticationBloc.add(AuthenticationLoggedOutEvent());

    yield UserSharedPartInitialState();
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
