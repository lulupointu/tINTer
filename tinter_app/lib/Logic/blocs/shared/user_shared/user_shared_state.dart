part of 'user_shared_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitialState extends UserState {}

class UserInitializingState extends UserState {}

class UserInitializingFailedState extends UserState {}

abstract class UserLoadSuccessState extends UserState {
  final BuildUser user;

  UserLoadSuccessState({@required this.user})
      : assert(user != null);

  @override
  List<Object> get props => [user];

  UserLoadSuccessState createNewState({BuildUser newUser});

  UserLoadSuccessState withNewState({
    @required BuildUser newState,
  }) {
    return createNewState(
        newUser: newState);
  }
}

abstract class NewUserState extends UserLoadSuccessState {
  NewUserState({@required user}) : super(user: user);
}

class NewUserCreatingProfileState extends NewUserState {
  NewUserCreatingProfileState({@required user})
      : super(user: user);

  NewUserCreatingProfileState createNewState({BuildUser newUser}) {
    return NewUserCreatingProfileState(user: newUser);
  }
}

class NewUserLoadingState extends NewUserState {
  @override
  UserLoadSuccessState createNewState({BuildUser newUser}) {
    throw UnimplementedError();
  }
}

class NewUserSavingState extends NewUserState {
  NewUserSavingState({@required user})
      : super(user: user);

  @override
  UserLoadSuccessState createNewState({BuildUser newUser}) {
    throw UnimplementedError();
  }
}

abstract class KnownUserState extends UserLoadSuccessState {
  KnownUserState({@required user}) : super(user: user);
}

class KnownUserRefreshingState extends KnownUserState {
  KnownUserRefreshingState({@required user})
      : super(user: user);

  @override
  KnownUserState createNewState({BuildUser newUser}) =>
      (newUser != this.user)
          ? KnownUserUnsavedState(
              user: newUser, oldSavedUser: this.user)
          : KnownUserSavedState(user: this.user);
}

class KnownUserSavedState extends KnownUserState {
  KnownUserSavedState({@required user})
      : super(user: user);

  @override
  KnownUserState createNewState({BuildUser newUser}) =>
      (newUser != this.user)
          ? KnownUserUnsavedState(
              user: newUser, oldSavedUser: this.user)
          : KnownUserSavedState(user: this.user);
}

class KnownUserUnsavedState extends KnownUserState {
  final BuildUser oldSavedUser;

  KnownUserUnsavedState(
      {@required user, @required this.oldSavedUser})
      : super(user: user);

  @override
  KnownUserState createNewState({BuildUser newUser}) =>
      (newUser != this.oldSavedUser)
          ? KnownUserUnsavedState(
              user: newUser,
              oldSavedUser: this.oldSavedUser)
          : KnownUserSavedState(user: this.oldSavedUser);
}

class KnownUserSavingState extends KnownUserUnsavedState {
  // This user is the one we are trying to save
  KnownUserSavingState({@required user, @required oldSavedUser})
      : super(user: user, oldSavedUser: oldSavedUser);

  @override
  KnownUserState createNewState({BuildUser newUser}) {
    throw UnimplementedError();
  }
}

class KnownUserSavingFailedState extends KnownUserUnsavedState {
  // This user is the one we are trying to save
  KnownUserSavingFailedState(
      {@required user, @required oldSavedUser})
      : super(user: user, oldSavedUser: oldSavedUser);
}

class KnownUserRefreshingFailedState extends KnownUserState {
  KnownUserRefreshingFailedState({@required user})
      : super(user: user);

  @override
  KnownUserState createNewState({BuildUser newUser}) =>
      (newUser != this.user)
          ? KnownUserUnsavedState(
              user: newUser, oldSavedUser: this.user)
          : KnownUserSavedState(user: this.user);
}
