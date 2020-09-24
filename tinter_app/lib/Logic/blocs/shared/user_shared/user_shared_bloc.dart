import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/Logic/repository/shared/user_repository.dart';
import 'package:tinterapp/notifications_handler.dart';

part 'user_shared_state.dart';

part 'user_shared_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;
  StreamSubscription authenticationSubscription;

  UserBloc({@required this.userRepository, @required this.authenticationBloc})
      : super(UserInitialState()) {
    authenticationSubscription = authenticationBloc.listen((AuthenticationState authenticationState) {
      if (!(authenticationState is AuthenticationSuccessfulState)) {
        this.add(UserResetEvent());
      }
    });
  }

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    switch (event.runtimeType) {
      case UserResetEvent:
        yield UserInitialState();
        return;
      case UserInitEvent:
        yield* _mapUserInitEventToState();
        return;
//      case UserNewProfileEvent:
//        yield* _mapUserNewProfileEventToState(event);
//        return;
      case UserRequestEvent:
        yield* _mapUserRequestEventToState();
        return;
      case UserRefreshEvent:
        yield* _mapUserRefreshEventToState();
        return;
      case UserSaveEvent:
        if (state is KnownUserUnsavedState) {
          yield* _mapUserSaveEventToState((state as KnownUserUnsavedState).user);
        } else if (state is NewUserCreatingProfileState) {
          yield* _mapNewUserSaveEventToState((state as NewUserCreatingProfileState).user);
        } else {
          _addError(
              'Saved was call while state was ${state.runtimeType}. Whereas it should be either KnownUserUnsavedState or NewUserCreatingProfileState');
        }
        return;
      case UserUndoUnsavedChangesEvent:
        if (state is KnownUserUnsavedState) {
          yield* _mapUserUndoUnsavedChangesEventToState();
        } else {
          _addError(
              'Saved was call while state was ${state.runtimeType}. Whereas it should be KnownUserUnsavedState');
        }

        return;
      case UserStateChangedEvent:
        if (state is UserLoadSuccessState) {
          yield* _mapUserStateChangedEventToState(event);
        } else {
          _addError(
              'UserMutableAttributeChangedEvent received while state is not UserLoadSuccessState');
        }
        return;
      case DeleteUserAccountEvent:
        if (state is UserLoadSuccessState) {
          yield* _mapDeleteUserAccountEventToState();
        } else {
          _addError(
              'ProfilePicturePathChangedEvent received while state is not UserLoadSuccessState');
        }
        return;
    }

    print('event: ' + event.toString() + ' no treated');
  }

  Stream<UserState> _mapUserInitEventToState() async* {
    yield UserInitializingState();

    bool isKnown;
    try {
      isKnown = await userRepository.isKnown();
    } catch (error) {
      print(error);
      yield UserInitialState();
      return;
    }

    BuildUser user;
    try {
      user = await userRepository.getUser();
    } catch (error) {
      print(error);
      yield UserInitialState();
      return;
    }

    if (isKnown) {
      yield KnownUserSavedState(user: user);
    } else {
      yield NewUserCreatingProfileState(user: user);
    }
  }

  Stream<UserState> _mapUserRequestEventToState() async* {
    yield UserInitializingState();

    BuildUser user;
    try {
      user = await userRepository.getUser();
    } catch (error) {
      yield UserInitializingFailedState();
      return;
    }
    yield KnownUserSavedState(user: user);
  }

  Stream<UserState> _mapUserRefreshEventToState() async* {
    if (!(state is KnownUserState)) {
      print("Trying to refresh while the user wasn't known");
      yield UserInitialState();
      return;
    }
    yield KnownUserRefreshingState(user: (state as KnownUserState).user);

    BuildUser user;
    try {
      user = await userRepository.getUser();
    } catch (error) {
      yield KnownUserRefreshingFailedState(user: (state as KnownUserState).user);
      return;
    }
    yield KnownUserSavedState(user: user);
  }

  Stream<UserState> _mapNewUserSaveEventToState(user) async* {
    yield NewUserSavingState(user: user);
    try {
      await userRepository.createUser(user: user);
    } catch (error) {
      print(error);
      yield NewUserCreatingProfileState(user: user);
      return;
    }

    imageCache.clear();

    // We create a new user manually in order to put the profilePicturePath to null
    yield KnownUserSavedState(
      user: (state as NewUserSavingState)
          .user
          .rebuild((b) => b..profilePictureLocalPath = null),
    );
  }

  Stream<UserState> _mapUserSaveEventToState(BuildUser user) async* {
    yield KnownUserSavingState(
        user: user, oldSavedUser: (state as KnownUserUnsavedState).oldSavedUser);

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserInitialState();
      return;
    }

    try {
      await userRepository.updateUser(user: user);
    } catch (error) {
      yield KnownUserSavingFailedState(
          user: user, oldSavedUser: (state as KnownUserUnsavedState).oldSavedUser);
      return;
    }

    imageCache.clear();

    // We create a new user manually in order to put the profilePicturePath to null
    yield KnownUserSavedState(
      user: (state as KnownUserUnsavedState)
          .user
          .rebuild((u) => u..profilePictureLocalPath = null),
    );
  }

  Stream<UserState> _mapUserUndoUnsavedChangesEventToState() async* {
    yield KnownUserSavedState(user: (state as KnownUserUnsavedState).oldSavedUser);
  }

  Stream<UserState> _mapUserStateChangedEventToState(UserStateChangedEvent event) async* {
    yield (state as UserLoadSuccessState).withNewState(newState: event.newState);
  }

  Stream<UserState> _mapDeleteUserAccountEventToState() async* {
    try {
      await userRepository.deleteUserAccount();
    } catch (error) {
      print('Removing account failed: $error');
      return;
    }

    authenticationBloc.add(AuthenticationLoggedOutEvent());

    await (await SharedPreferences.getInstance()).setBool('hasEverHadBinome', false);
    await NotificationHandler.deleteNotificationToken();

    yield UserInitialState();
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }

  @override
  Future<void> close() {
    authenticationSubscription.cancel();
    return super.close();
  }
}
