part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitialState extends UserState {}

class UserInitializingState extends UserState {}

class UserInitializingFailedState extends UserState {}

abstract class UserLoadSuccessState extends UserState {
  final User user;

  UserLoadSuccessState({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];

  UserLoadSuccessState createNewState({User newUser});

  UserLoadSuccessState withPrimoEntrantChanged(bool newValue) {
    return createNewState(
      newUser: User(
        login: user.login,
        name: user.name,
        surname: user.surname,
        email: user.email,
        primoEntrant: newValue,
        associations: user.associations,
        attiranceVieAsso: user.attiranceVieAsso,
        feteOuCours: user.feteOuCours,
        aideOuSortir: user.aideOuSortir,
        organisationEvenements: user.organisationEvenements,
        goutsMusicaux: user.goutsMusicaux,
        profilePicturePath: user.profilePictureLocalPath,
      ),
    );
  }

  UserLoadSuccessState withAttiranceVieAssoChanged(
    double newValue,
  ) {
    assert(0 <= newValue && newValue <= 1);
    return createNewState(
      newUser: User(
        login: user.login,
        name: user.name,
        surname: user.surname,
        email: user.email,
        primoEntrant: user.primoEntrant,
        associations: user.associations,
        attiranceVieAsso: newValue,
        feteOuCours: user.feteOuCours,
        aideOuSortir: user.aideOuSortir,
        organisationEvenements: user.organisationEvenements,
        goutsMusicaux: user.goutsMusicaux,
        profilePicturePath: user.profilePictureLocalPath,
      ),
    );
  }

  UserLoadSuccessState withAideOuSortirChanged(double newValue) {
    assert(0 <= newValue && newValue <= 1);
    return createNewState(
      newUser: User(
        login: user.login,
        name: user.name,
        surname: user.surname,
        email: user.email,
        primoEntrant: user.primoEntrant,
        associations: user.associations,
        attiranceVieAsso: user.attiranceVieAsso,
        feteOuCours: user.feteOuCours,
        aideOuSortir: newValue,
        organisationEvenements: user.organisationEvenements,
        goutsMusicaux: user.goutsMusicaux,
        profilePicturePath: user.profilePictureLocalPath,
      ),
    );
  }

  UserLoadSuccessState withFeteOuCoursChanged(double newValue) {
    assert(0 <= newValue && newValue <= 1);
    return createNewState(
      newUser: User(
        login: user.login,
        name: user.name,
        surname: user.surname,
        email: user.email,
        primoEntrant: user.primoEntrant,
        associations: user.associations,
        attiranceVieAsso: user.attiranceVieAsso,
        feteOuCours: newValue,
        aideOuSortir: user.aideOuSortir,
        organisationEvenements: user.organisationEvenements,
        goutsMusicaux: user.goutsMusicaux,
        profilePicturePath: user.profilePictureLocalPath,
      ),
    );
  }

  UserLoadSuccessState withOrganisationEvenementsChanged(double newValue) {
    assert(0 <= newValue && newValue <= 1);
    return createNewState(
      newUser: User(
        login: user.login,
        name: user.name,
        surname: user.surname,
        email: user.email,
        primoEntrant: user.primoEntrant,
        associations: user.associations,
        attiranceVieAsso: user.attiranceVieAsso,
        feteOuCours: user.feteOuCours,
        aideOuSortir: user.aideOuSortir,
        organisationEvenements: newValue,
        goutsMusicaux: user.goutsMusicaux,
        profilePicturePath: user.profilePictureLocalPath,
      ),
    );
  }

  UserLoadSuccessState withInitAssociation() {
    return createNewState(
      newUser: User(
        login: user.login,
        name: user.name,
        surname: user.surname,
        email: user.email,
        primoEntrant: user.primoEntrant,
        associations: List<Association>(),
        attiranceVieAsso: user.attiranceVieAsso,
        feteOuCours: user.feteOuCours,
        aideOuSortir: user.aideOuSortir,
        organisationEvenements: user.organisationEvenements,
        goutsMusicaux: user.goutsMusicaux,
        profilePicturePath: user.profilePictureLocalPath,
      ),
    );
  }

  UserLoadSuccessState withAddedAssociation(Association newAssociation) {
    final List<Association> newAssociations = List.from(user.associations);
    newAssociations.add(newAssociation);
    return createNewState(
      newUser: User(
        login: user.login,
        name: user.name,
        surname: user.surname,
        email: user.email,
        primoEntrant: user.primoEntrant,
        associations: newAssociations,
        attiranceVieAsso: user.attiranceVieAsso,
        feteOuCours: user.feteOuCours,
        aideOuSortir: user.aideOuSortir,
        organisationEvenements: user.organisationEvenements,
        goutsMusicaux: user.goutsMusicaux,
        profilePicturePath: user.profilePictureLocalPath,
      ),
    );
  }

  UserLoadSuccessState withRemovedAssociation(Association associationToRemove) {
    final List<Association> newAssociations = List.from(user.associations);
    newAssociations.remove(associationToRemove);
    return createNewState(
      newUser: User(
        login: user.login,
        name: user.name,
        surname: user.surname,
        email: user.email,
        primoEntrant: user.primoEntrant,
        associations: newAssociations,
        attiranceVieAsso: user.attiranceVieAsso,
        feteOuCours: user.feteOuCours,
        aideOuSortir: user.aideOuSortir,
        organisationEvenements: user.organisationEvenements,
        goutsMusicaux: user.goutsMusicaux,
        profilePicturePath: user.profilePictureLocalPath,
      ),
    );
  }

  UserLoadSuccessState withInitGoutsMusicaux() {
    return createNewState(
      newUser: User(
        login: user.login,
        name: user.name,
        surname: user.surname,
        email: user.email,
        primoEntrant: user.primoEntrant,
        associations: user.associations,
        attiranceVieAsso: user.attiranceVieAsso,
        feteOuCours: user.feteOuCours,
        aideOuSortir: user.aideOuSortir,
        organisationEvenements: user.organisationEvenements,
        goutsMusicaux: List<String>(),
        profilePicturePath: user.profilePictureLocalPath,
      ),
    );
  }

  UserLoadSuccessState withAddedGoutMusical(String newGoutMusical) {
    final List<String> newGoutMusicaux = List.from(user.goutsMusicaux);
    newGoutMusicaux.add(newGoutMusical);
    return createNewState(
      newUser: User(
        login: user.login,
        name: user.name,
        surname: user.surname,
        email: user.email,
        primoEntrant: user.primoEntrant,
        associations: user.associations,
        attiranceVieAsso: user.attiranceVieAsso,
        feteOuCours: user.feteOuCours,
        aideOuSortir: user.aideOuSortir,
        organisationEvenements: user.organisationEvenements,
        goutsMusicaux: newGoutMusicaux,
        profilePicturePath: user.profilePictureLocalPath,
      ),
    );
  }

  UserLoadSuccessState withRemovedGoutMusical(String goutMusicalToRemove) {
    final List<String> newGoutMusicaux = List.from(user.goutsMusicaux);
    newGoutMusicaux.remove(goutMusicalToRemove);
    return createNewState(
      newUser: User(
        login: user.login,
        name: user.name,
        surname: user.surname,
        email: user.email,
        primoEntrant: user.primoEntrant,
        associations: user.associations,
        attiranceVieAsso: user.attiranceVieAsso,
        feteOuCours: user.feteOuCours,
        aideOuSortir: user.aideOuSortir,
        organisationEvenements: user.organisationEvenements,
        goutsMusicaux: newGoutMusicaux,
        profilePicturePath: user.profilePictureLocalPath,
      ),
    );
  }

  UserLoadSuccessState withPictureProfileChanged(String pictureProfilePath) {
    return createNewState(
      newUser: User(
        login: user.login,
        name: user.name,
        surname: user.surname,
        email: user.email,
        primoEntrant: user.primoEntrant,
        associations: user.associations,
        attiranceVieAsso: user.attiranceVieAsso,
        feteOuCours: user.feteOuCours,
        aideOuSortir: user.aideOuSortir,
        organisationEvenements: user.organisationEvenements,
        goutsMusicaux: user.goutsMusicaux,
        profilePicturePath: pictureProfilePath,
      ),
    );
  }
}

abstract class NewUserState extends UserLoadSuccessState {
  NewUserState({@required user}) : super(user: user);
}

class NewUserCreatingProfileState extends NewUserState {
  NewUserCreatingProfileState({@required user}) : super(user: user);

  NewUserCreatingProfileState createNewState({User newUser}) {
    return NewUserCreatingProfileState(user: newUser);
  }
}

class NewUserLoadingState extends NewUserState {
  @override
  UserLoadSuccessState createNewState({User newUser}) {
    throw UnimplementedError();
  }
}

class NewUserSavingState extends NewUserState {
  NewUserSavingState({@required user}) : super(user: user);

  @override
  UserLoadSuccessState createNewState({User newUser}) {
    throw UnimplementedError();
  }
}

abstract class KnownUserState extends UserLoadSuccessState {
  KnownUserState({@required user}) : super(user: user);
}

class KnownUserRefreshingState extends KnownUserState {
  KnownUserRefreshingState({@required user}) : super(user: user);

  @override
  KnownUserState createNewState({User newUser}) => (newUser != this.user)
      ? KnownUserUnsavedState(user: newUser, oldSavedUser: this.user)
      : KnownUserSavedState(user: this.user);
}

class KnownUserSavedState extends KnownUserState {
  KnownUserSavedState({@required user}) : super(user: user);

  @override
  KnownUserState createNewState({User newUser}) => (newUser != this.user)
      ? KnownUserUnsavedState(user: newUser, oldSavedUser: this.user)
      : KnownUserSavedState(user: this.user);
}

class KnownUserUnsavedState extends KnownUserState {
  final User oldSavedUser;

  KnownUserUnsavedState({@required user, @required this.oldSavedUser}) : super(user: user);

  @override
  KnownUserState createNewState({User newUser}) => (newUser != this.oldSavedUser)
      ? KnownUserUnsavedState(user: newUser, oldSavedUser: this.oldSavedUser)
      : KnownUserSavedState(user: this.oldSavedUser);
}

class KnownUserSavingState extends KnownUserUnsavedState {
  // This user is the one we are trying to save
  KnownUserSavingState({@required user, @required oldSavedUser})
      : super(user: user, oldSavedUser: oldSavedUser);

  @override
  KnownUserState createNewState({User newUser}) {
    throw UnimplementedError();
  }
}

class KnownUserSavingFailedState extends KnownUserUnsavedState {
  // This user is the one we are trying to save
  KnownUserSavingFailedState({@required user, @required oldSavedUser})
      : super(user: user, oldSavedUser: oldSavedUser);
}

class KnownUserRefreshingFailedState extends KnownUserState {
  KnownUserRefreshingFailedState({@required user}) : super(user: user);

  @override
  KnownUserState createNewState({User newUser}) => (newUser != this.user)
      ? KnownUserUnsavedState(user: newUser, oldSavedUser: this.user)
      : KnownUserSavedState(user: this.user);
}
