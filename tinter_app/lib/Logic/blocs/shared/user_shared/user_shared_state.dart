part of 'user_shared_bloc.dart';

abstract class UserSharedPartState extends Equatable {
  const UserSharedPartState();

  @override
  List<Object> get props => [];
}

class UserSharedPartInitialState extends UserSharedPartState {}

class UserSharedPartInitializingState extends UserSharedPartState {}

class UserSharedPartInitializingFailedState extends UserSharedPartState {}

abstract class UserSharedPartLoadSuccessState extends UserSharedPartState {
  final BuildUserSharedPart user;

  UserSharedPartLoadSuccessState({@required this.user})
      : assert(user != null);

  @override
  List<Object> get props => [user];

  UserSharedPartLoadSuccessState createNewState({BuildUserSharedPart newUserSharedPart});

  UserSharedPartLoadSuccessState withNewState({
    @required BuildUserSharedPart newState,
  }) {
    return createNewState(
        newUserSharedPart: newState);
  }
}

abstract class NewUserSharedPartState extends UserSharedPartLoadSuccessState {
  NewUserSharedPartState({@required userSharedPart}) : super(user: userSharedPart);
}

class NewUserSharedPartCreatingProfileState extends NewUserSharedPartState {
  NewUserSharedPartCreatingProfileState({@required userSharedPart})
      : super(userSharedPart: userSharedPart);

  NewUserSharedPartCreatingProfileState createNewState({BuildUserSharedPart newUserSharedPart}) {
    return NewUserSharedPartCreatingProfileState(userSharedPart: newUserSharedPart);
  }
}

class NewUserSharedPartLoadingState extends NewUserSharedPartState {
  @override
  UserSharedPartLoadSuccessState createNewState({BuildUserSharedPart newUserSharedPart}) {
    throw UnimplementedError();
  }
}

class NewUserSharedPartSavingState extends NewUserSharedPartState {
  NewUserSharedPartSavingState({@required userSharedPart})
      : super(userSharedPart: userSharedPart);

  @override
  UserSharedPartLoadSuccessState createNewState({BuildUserSharedPart newUserSharedPart}) {
    throw UnimplementedError();
  }
}

abstract class KnownUserSharedPartState extends UserSharedPartLoadSuccessState {
  KnownUserSharedPartState({@required userSharedPart}) : super(user: userSharedPart);
}

class KnownUserSharedPartRefreshingState extends KnownUserSharedPartState {
  KnownUserSharedPartRefreshingState({@required userSharedPart})
      : super(userSharedPart: userSharedPart);

  @override
  KnownUserSharedPartState createNewState({BuildUserSharedPart newUserSharedPart}) =>
      (newUserSharedPart != this.user)
          ? KnownUserSharedPartUnsavedState(
              userSharedPart: newUserSharedPart, oldSavedUserSharedPart: this.user)
          : KnownUserSharedPartSavedState(userSharedPart: this.user);
}

class KnownUserSharedPartSavedState extends KnownUserSharedPartState {
  KnownUserSharedPartSavedState({@required userSharedPart})
      : super(userSharedPart: userSharedPart);

  @override
  KnownUserSharedPartState createNewState({BuildUserSharedPart newUserSharedPart}) =>
      (newUserSharedPart != this.user)
          ? KnownUserSharedPartUnsavedState(
              userSharedPart: newUserSharedPart, oldSavedUserSharedPart: this.user)
          : KnownUserSharedPartSavedState(userSharedPart: this.user);
}

class KnownUserSharedPartUnsavedState extends KnownUserSharedPartState {
  final BuildUserSharedPart oldSavedUserSharedPart;

  KnownUserSharedPartUnsavedState(
      {@required userSharedPart, @required this.oldSavedUserSharedPart})
      : super(userSharedPart: userSharedPart);

  @override
  KnownUserSharedPartState createNewState({BuildUserSharedPart newUserSharedPart}) =>
      (newUserSharedPart != this.oldSavedUserSharedPart)
          ? KnownUserSharedPartUnsavedState(
              userSharedPart: newUserSharedPart,
              oldSavedUserSharedPart: this.oldSavedUserSharedPart)
          : KnownUserSharedPartSavedState(userSharedPart: this.oldSavedUserSharedPart);
}

class KnownUserSharedPartSavingState extends KnownUserSharedPartUnsavedState {
  // This userSharedPart is the one we are trying to save
  KnownUserSharedPartSavingState({@required userSharedPart, @required oldSavedUserSharedPart})
      : super(userSharedPart: userSharedPart, oldSavedUserSharedPart: oldSavedUserSharedPart);

  @override
  KnownUserSharedPartState createNewState({BuildUserSharedPart newUserSharedPart}) {
    throw UnimplementedError();
  }
}

class KnownUserSharedPartSavingFailedState extends KnownUserSharedPartUnsavedState {
  // This userSharedPart is the one we are trying to save
  KnownUserSharedPartSavingFailedState(
      {@required userSharedPart, @required oldSavedUserSharedPart})
      : super(userSharedPart: userSharedPart, oldSavedUserSharedPart: oldSavedUserSharedPart);
}

class KnownUserSharedPartRefreshingFailedState extends KnownUserSharedPartState {
  KnownUserSharedPartRefreshingFailedState({@required userSharedPart})
      : super(userSharedPart: userSharedPart);

  @override
  KnownUserSharedPartState createNewState({BuildUserSharedPart newUserSharedPart}) =>
      (newUserSharedPart != this.user)
          ? KnownUserSharedPartUnsavedState(
              userSharedPart: newUserSharedPart, oldSavedUserSharedPart: this.user)
          : KnownUserSharedPartSavedState(userSharedPart: this.user);
}
