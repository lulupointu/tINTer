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
  final UserSharedPart userSharedPart;

  UserSharedPartLoadSuccessState({@required this.userSharedPart}) : assert(userSharedPart != null);

  @override
  List<Object> get props => [userSharedPart];

  UserSharedPartLoadSuccessState createNewState({UserSharedPart newUserSharedPart});

  UserSharedPartLoadSuccessState withAttributeChanged({
    TSPYear year,
    List<dynamic> associations,
    double groupeOuSeul,
    LieuDeVie lieuDeVie,
    List<HoraireDeTravail> horairesDeTravail,
    OutilDeTravail enligneOuNon,
    List<String> matieresPreferees,
    String profilePicturePath,
  }) {
    return createNewState(
        newUserSharedPart: UserSharedPart(
            login: userSharedPart.login,
            year: year ?? userSharedPart.year,
            groupeOuSeul: groupeOuSeul ?? userSharedPart.groupeOuSeul,
            lieuDeVie: lieuDeVie ?? userSharedPart.lieuDeVie,
            horairesDeTravail: horairesDeTravail ?? userSharedPart.horairesDeTravail,
            enligneOuNon: enligneOuNon ?? userSharedPart.enligneOuNon,
            matieresPreferees: matieresPreferees ?? userSharedPart.matieresPreferees)
    );
  }
}

abstract class NewUserSharedPartState extends UserSharedPartLoadSuccessState {
  NewUserSharedPartState({@required userSharedPart}) : super(userSharedPart: userSharedPart);
}

class NewUserSharedPartCreatingProfileState extends NewUserSharedPartState {
  NewUserSharedPartCreatingProfileState({@required userSharedPart})
      : super(userSharedPart: userSharedPart);

  NewUserSharedPartCreatingProfileState createNewState({UserSharedPart newUserSharedPart}) {
    return NewUserSharedPartCreatingProfileState(userSharedPart: newUserSharedPart);
  }
}

class NewUserSharedPartLoadingState extends NewUserSharedPartState {
  @override
  UserSharedPartLoadSuccessState createNewState({UserSharedPart newUserSharedPart}) {
    throw UnimplementedError();
  }
}

class NewUserSharedPartSavingState extends NewUserSharedPartState {
  NewUserSharedPartSavingState({@required userSharedPart}) : super(userSharedPart: userSharedPart);

  @override
  UserSharedPartLoadSuccessState createNewState({UserSharedPart newUserSharedPart}) {
    throw UnimplementedError();
  }
}

abstract class KnownUserSharedPartState extends UserSharedPartLoadSuccessState {
  KnownUserSharedPartState({@required userSharedPart}) : super(userSharedPart: userSharedPart);
}

class KnownUserSharedPartRefreshingState extends KnownUserSharedPartState {
  KnownUserSharedPartRefreshingState({@required userSharedPart})
      : super(userSharedPart: userSharedPart);

  @override
  KnownUserSharedPartState createNewState({UserSharedPart newUserSharedPart}) =>
      (newUserSharedPart != this.userSharedPart)
          ? KnownUserSharedPartUnsavedState(
          userSharedPart: newUserSharedPart, oldSavedUserSharedPart: this.userSharedPart)
          : KnownUserSharedPartSavedState(userSharedPart: this.userSharedPart);
}

class KnownUserSharedPartSavedState extends KnownUserSharedPartState {
  KnownUserSharedPartSavedState({@required userSharedPart}) : super(userSharedPart: userSharedPart);

  @override
  KnownUserSharedPartState createNewState({UserSharedPart newUserSharedPart}) =>
      (newUserSharedPart != this.userSharedPart)
          ? KnownUserSharedPartUnsavedState(
          userSharedPart: newUserSharedPart, oldSavedUserSharedPart: this.userSharedPart)
          : KnownUserSharedPartSavedState(userSharedPart: this.userSharedPart);
}

class KnownUserSharedPartUnsavedState extends KnownUserSharedPartState {
  final UserSharedPart oldSavedUserSharedPart;

  KnownUserSharedPartUnsavedState({@required userSharedPart, @required this.oldSavedUserSharedPart})
      : super(userSharedPart: userSharedPart);

  @override
  KnownUserSharedPartState createNewState({UserSharedPart newUserSharedPart}) =>
      (newUserSharedPart != this.oldSavedUserSharedPart)
          ? KnownUserSharedPartUnsavedState(
          userSharedPart: newUserSharedPart, oldSavedUserSharedPart: this.oldSavedUserSharedPart)
          : KnownUserSharedPartSavedState(userSharedPart: this.oldSavedUserSharedPart);
}

class KnownUserSharedPartSavingState extends KnownUserSharedPartUnsavedState {
  // This userSharedPart is the one we are trying to save
  KnownUserSharedPartSavingState({@required userSharedPart, @required oldSavedUserSharedPart})
      : super(userSharedPart: userSharedPart, oldSavedUserSharedPart: oldSavedUserSharedPart);

  @override
  KnownUserSharedPartState createNewState({UserSharedPart newUserSharedPart}) {
    throw UnimplementedError();
  }
}

class KnownUserSharedPartSavingFailedState extends KnownUserSharedPartUnsavedState {
  // This userSharedPart is the one we are trying to save
  KnownUserSharedPartSavingFailedState({@required userSharedPart, @required oldSavedUserSharedPart})
      : super(userSharedPart: userSharedPart, oldSavedUserSharedPart: oldSavedUserSharedPart);
}

class KnownUserSharedPartRefreshingFailedState extends KnownUserSharedPartState {
  KnownUserSharedPartRefreshingFailedState({@required userSharedPart})
      : super(userSharedPart: userSharedPart);

  @override
  KnownUserSharedPartState createNewState({UserSharedPart newUserSharedPart}) =>
      (newUserSharedPart != this.userSharedPart)
          ? KnownUserSharedPartUnsavedState(
          userSharedPart: newUserSharedPart, oldSavedUserSharedPart: this.userSharedPart)
          : KnownUserSharedPartSavedState(userSharedPart: this.userSharedPart);
}
