part of 'user_associatif_bloc.dart';

abstract class UserAssociatifState extends Equatable {
  const UserAssociatifState();

  @override
  List<Object> get props => [];
}

class UserInitialState extends UserAssociatifState {}

class UserInitializingState extends UserAssociatifState {}

class UserInitializingFailedState extends UserAssociatifState {}

abstract class UserLoadSuccessState extends UserAssociatifState {
  final BuildUserAssociatif user;

  UserLoadSuccessState({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];

  UserLoadSuccessState createNewState({BuildUserAssociatif newUser});

  UserLoadSuccessState withNewState({
    @required BuildUserAssociatif newState,
  }) {
    return createNewState(
        newUser: newState);
  }

}

abstract class NewUserAssociatifState extends UserLoadSuccessState {
  NewUserAssociatifState({@required user}) : super(user: user);
}

class NewUserCreatingProfileState extends NewUserAssociatifState {
  NewUserCreatingProfileState({@required user}) : super(user: user);

  NewUserCreatingProfileState createNewState({BuildUserAssociatif newUser}) {
    return NewUserCreatingProfileState(user: newUser);
  }
}

class NewUserLoadingState extends NewUserAssociatifState {
  @override
  UserLoadSuccessState createNewState({BuildUserAssociatif newUser}) {
    throw UnimplementedError();
  }
}

class NewUserSavingState extends NewUserAssociatifState {
  NewUserSavingState({@required user}) : super(user: user);

  @override
  UserLoadSuccessState createNewState({BuildUserAssociatif newUser}) {
    throw UnimplementedError();
  }
}

abstract class KnownUserAssociatifState extends UserLoadSuccessState {
  KnownUserAssociatifState({@required user}) : super(user: user);
}

class KnownUserRefreshingState extends KnownUserAssociatifState {
  KnownUserRefreshingState({@required user}) : super(user: user);

  @override
  KnownUserAssociatifState createNewState({BuildUserAssociatif newUser}) => (newUser != this.user)
      ? KnownUserUnsavedState(user: newUser, oldSavedUser: this.user)
      : KnownUserSavedState(user: this.user);
}

class KnownUserSavedState extends KnownUserAssociatifState {
  KnownUserSavedState({@required user}) : super(user: user);

  @override
  KnownUserAssociatifState createNewState({BuildUserAssociatif newUser}) => (newUser != this.user)
      ? KnownUserUnsavedState(user: newUser, oldSavedUser: this.user)
      : KnownUserSavedState(user: this.user);
}

class KnownUserUnsavedState extends KnownUserAssociatifState {
  final BuildUserAssociatif oldSavedUser;

  KnownUserUnsavedState({@required user, @required this.oldSavedUser}) : super(user: user);

  @override
  KnownUserAssociatifState createNewState({BuildUserAssociatif newUser}) => (newUser != this.oldSavedUser)
      ? KnownUserUnsavedState(user: newUser, oldSavedUser: this.oldSavedUser)
      : KnownUserSavedState(user: this.oldSavedUser);
}

class KnownUserSavingState extends KnownUserUnsavedState {
  // This user is the one we are trying to save
  KnownUserSavingState({@required user, @required oldSavedUser})
      : super(user: user, oldSavedUser: oldSavedUser);

  @override
  KnownUserAssociatifState createNewState({BuildUserAssociatif newUser}) {
    throw UnimplementedError();
  }
}

class KnownUserSavingFailedState extends KnownUserUnsavedState {
  // This user is the one we are trying to save
  KnownUserSavingFailedState({@required user, @required oldSavedUser})
      : super(user: user, oldSavedUser: oldSavedUser);
}

class KnownUserRefreshingFailedState extends KnownUserAssociatifState {
  KnownUserRefreshingFailedState({@required user}) : super(user: user);

  @override
  KnownUserAssociatifState createNewState({BuildUserAssociatif newUser}) => (newUser != this.user)
      ? KnownUserUnsavedState(user: newUser, oldSavedUser: this.user)
      : KnownUserSavedState(user: this.user);
}
