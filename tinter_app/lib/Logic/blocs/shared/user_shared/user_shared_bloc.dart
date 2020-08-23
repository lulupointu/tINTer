import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/shared/user_shared_part.dart';
import 'package:tinterapp/Logic/repository/shared/user_shared_repository.dart';

part 'user_shared_state.dart';

part 'user_shared_event.dart';

class UserSharedPartBloc extends Bloc<UserSharedPartEvent, UserSharedPartState> {
  final UserSharedPartRepository userSharedPartRepository;
  final AuthenticationBloc authenticationBloc;

  UserSharedPartBloc(
      {@required this.userSharedPartRepository, @required this.authenticationBloc})
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
              (state as KnownUserSharedPartUnsavedState).user);
        } else if (state is NewUserSharedPartCreatingProfileState) {
          yield* _mapNewUserSharedPartSaveEventToState(
              (state as NewUserSharedPartCreatingProfileState).user);
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
      case UserStateChangedEvent:
        if (state is UserSharedPartLoadSuccessState) {
          yield* _mapUserStateChangedEventToState(event);
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

    BuildUserSharedPart userSharedPart;
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

    BuildUserSharedPart userSharedPart;
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
        userSharedPart: (state as KnownUserSharedPartState).user);

    BuildUserSharedPart userSharedPart;
    try {
      userSharedPart = await userSharedPartRepository.getUser();
    } catch (error) {
      yield KnownUserSharedPartRefreshingFailedState(
          userSharedPart: (state as KnownUserSharedPartState).user);
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
          (state as KnownUserSharedPartUnsavedState).user.rebuild((_) {}),
    );
  }

  Stream<UserSharedPartState> _mapUserSharedPartSaveEventToState(
      BuildUserSharedPart userSharedPart) async* {
    yield KnownUserSharedPartSavingState(
        userSharedPart: userSharedPart,
        oldSavedUserSharedPart:
            (state as KnownUserSharedPartUnsavedState).oldSavedUserSharedPart);

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
          oldSavedUserSharedPart:
              (state as KnownUserSharedPartUnsavedState).oldSavedUserSharedPart);
      return;
    }

    imageCache.clear();

    // We create a new userSharedPart manually in order to put the profilePicturePath to null
    yield KnownUserSharedPartSavedState(
      userSharedPart: (state as KnownUserSharedPartUnsavedState)
          .user
          .rebuild((u) => u..profilePictureLocalPath = null),
    );
  }

  Stream<UserSharedPartState> _mapUserSharedPartUndoUnsavedChangesEventToState() async* {
    yield KnownUserSharedPartSavedState(
        userSharedPart: (state as KnownUserSharedPartUnsavedState).oldSavedUserSharedPart);
  }

  Stream<UserSharedPartState> _mapUserStateChangedEventToState(
      UserStateChangedEvent event) async* {
    yield (state as UserSharedPartLoadSuccessState).withNewState(newState: event.newState);
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
