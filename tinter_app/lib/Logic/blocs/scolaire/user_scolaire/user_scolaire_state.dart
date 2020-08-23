part of 'user_scolaire_bloc.dart';

abstract class UserScolaireState extends Equatable {
  const UserScolaireState();

  @override
  List<Object> get props => [];
}

class UserScolaireInitialState extends UserScolaireState {}

class UserScolaireInitializingState extends UserScolaireState {}

class UserScolaireInitializingFailedState extends UserScolaireState {}

abstract class UserScolaireLoadSuccessState extends UserScolaireState {
  final UserScolaire userScolaire;

  UserScolaireLoadSuccessState({@required this.userScolaire}) : assert(userScolaire != null);

  @override
  List<Object> get props => [userScolaire];

  UserScolaireLoadSuccessState createNewState({UserScolaire newUserScolaire});

  UserScolaireLoadSuccessState withAttributeChanged({
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
        newUserScolaire: UserScolaire(
            login: userScolaire.login,
            name: userScolaire.name,
            surname: userScolaire.surname,
            email: userScolaire.email,
            year: year ?? userScolaire.year,
            associations: associations ?? userScolaire.associations,
            groupeOuSeul: groupeOuSeul ?? userScolaire.groupeOuSeul,
            lieuDeVie: lieuDeVie ?? userScolaire.lieuDeVie,
            horairesDeTravail: horairesDeTravail ?? userScolaire.horairesDeTravail,
            enligneOuNon: enligneOuNon ?? userScolaire.enligneOuNon,
            matieresPreferees: matieresPreferees ?? userScolaire.matieresPreferees)
    );
  }
}

abstract class NewUserScolaireState extends UserScolaireLoadSuccessState {
  NewUserScolaireState({@required userScolaire}) : super(userScolaire: userScolaire);
}

class NewUserScolaireCreatingProfileState extends NewUserScolaireState {
  NewUserScolaireCreatingProfileState({@required userScolaire})
      : super(userScolaire: userScolaire);

  NewUserScolaireCreatingProfileState createNewState({UserScolaire newUserScolaire}) {
    return NewUserScolaireCreatingProfileState(userScolaire: newUserScolaire);
  }
}

class NewUserScolaireLoadingState extends NewUserScolaireState {
  @override
  UserScolaireLoadSuccessState createNewState({UserScolaire newUserScolaire}) {
    throw UnimplementedError();
  }
}

class NewUserScolaireSavingState extends NewUserScolaireState {
  NewUserScolaireSavingState({@required userScolaire}) : super(userScolaire: userScolaire);

  @override
  UserScolaireLoadSuccessState createNewState({UserScolaire newUserScolaire}) {
    throw UnimplementedError();
  }
}

abstract class KnownUserScolaireState extends UserScolaireLoadSuccessState {
  KnownUserScolaireState({@required userScolaire}) : super(userScolaire: userScolaire);
}

class KnownUserScolaireRefreshingState extends KnownUserScolaireState {
  KnownUserScolaireRefreshingState({@required userScolaire})
      : super(userScolaire: userScolaire);

  @override
  KnownUserScolaireState createNewState({UserScolaire newUserScolaire}) =>
      (newUserScolaire != this.userScolaire)
          ? KnownUserScolaireUnsavedState(
          userScolaire: newUserScolaire, oldSavedUserScolaire: this.userScolaire)
          : KnownUserScolaireSavedState(userScolaire: this.userScolaire);
}

class KnownUserScolaireSavedState extends KnownUserScolaireState {
  KnownUserScolaireSavedState({@required userScolaire}) : super(userScolaire: userScolaire);

  @override
  KnownUserScolaireState createNewState({UserScolaire newUserScolaire}) =>
      (newUserScolaire != this.userScolaire)
          ? KnownUserScolaireUnsavedState(
          userScolaire: newUserScolaire, oldSavedUserScolaire: this.userScolaire)
          : KnownUserScolaireSavedState(userScolaire: this.userScolaire);
}

class KnownUserScolaireUnsavedState extends KnownUserScolaireState {
  final UserScolaire oldSavedUserScolaire;

  KnownUserScolaireUnsavedState({@required userScolaire, @required this.oldSavedUserScolaire})
      : super(userScolaire: userScolaire);

  @override
  KnownUserScolaireState createNewState({UserScolaire newUserScolaire}) =>
      (newUserScolaire != this.oldSavedUserScolaire)
          ? KnownUserScolaireUnsavedState(
          userScolaire: newUserScolaire, oldSavedUserScolaire: this.oldSavedUserScolaire)
          : KnownUserScolaireSavedState(userScolaire: this.oldSavedUserScolaire);
}

class KnownUserScolaireSavingState extends KnownUserScolaireUnsavedState {
  // This userScolaire is the one we are trying to save
  KnownUserScolaireSavingState({@required userScolaire, @required oldSavedUserScolaire})
      : super(userScolaire: userScolaire, oldSavedUserScolaire: oldSavedUserScolaire);

  @override
  KnownUserScolaireState createNewState({UserScolaire newUserScolaire}) {
    throw UnimplementedError();
  }
}

class KnownUserScolaireSavingFailedState extends KnownUserScolaireUnsavedState {
  // This userScolaire is the one we are trying to save
  KnownUserScolaireSavingFailedState({@required userScolaire, @required oldSavedUserScolaire})
      : super(userScolaire: userScolaire, oldSavedUserScolaire: oldSavedUserScolaire);
}

class KnownUserScolaireRefreshingFailedState extends KnownUserScolaireState {
  KnownUserScolaireRefreshingFailedState({@required userScolaire})
      : super(userScolaire: userScolaire);

  @override
  KnownUserScolaireState createNewState({UserScolaire newUserScolaire}) =>
      (newUserScolaire != this.userScolaire)
          ? KnownUserScolaireUnsavedState(
          userScolaire: newUserScolaire, oldSavedUserScolaire: this.userScolaire)
          : KnownUserScolaireSavedState(userScolaire: this.userScolaire);
}
