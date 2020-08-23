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
  final UserAssociatif user;

  UserLoadSuccessState({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];

  UserLoadSuccessState createNewState({UserAssociatif newUser});

  UserLoadSuccessState withPrimoEntrantChanged(bool newValue) {
    return createNewState(
      newUser: UserAssociatif(
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
      newUser: UserAssociatif(
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
      newUser: UserAssociatif(
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
      newUser: UserAssociatif(
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
      newUser: UserAssociatif(
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
      newUser: UserAssociatif(
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
      newUser: UserAssociatif(
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
      newUser: UserAssociatif(
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
      newUser: UserAssociatif(
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
      newUser: UserAssociatif(
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
      newUser: UserAssociatif(
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
      newUser: UserAssociatif(
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

abstract class NewUserAssociatifState extends UserLoadSuccessState {
  NewUserAssociatifState({@required user}) : super(user: user);
}

class NewUserCreatingProfileState extends NewUserAssociatifState {
  NewUserCreatingProfileState({@required user}) : super(user: user);

  NewUserCreatingProfileState createNewState({UserAssociatif newUser}) {
    return NewUserCreatingProfileState(user: newUser);
  }
}

class NewUserLoadingState extends NewUserAssociatifState {
  @override
  UserLoadSuccessState createNewState({UserAssociatif newUser}) {
    throw UnimplementedError();
  }
}

class NewUserSavingState extends NewUserAssociatifState {
  NewUserSavingState({@required user}) : super(user: user);

  @override
  UserLoadSuccessState createNewState({UserAssociatif newUser}) {
    throw UnimplementedError();
  }
}

abstract class KnownUserAssociatifState extends UserLoadSuccessState {
  KnownUserAssociatifState({@required user}) : super(user: user);
}

class KnownUserRefreshingState extends KnownUserAssociatifState {
  KnownUserRefreshingState({@required user}) : super(user: user);

  @override
  KnownUserAssociatifState createNewState({UserAssociatif newUser}) => (newUser != this.user)
      ? KnownUserUnsavedState(user: newUser, oldSavedUser: this.user)
      : KnownUserSavedState(user: this.user);
}

class KnownUserSavedState extends KnownUserAssociatifState {
  KnownUserSavedState({@required user}) : super(user: user);

  @override
  KnownUserAssociatifState createNewState({UserAssociatif newUser}) => (newUser != this.user)
      ? KnownUserUnsavedState(user: newUser, oldSavedUser: this.user)
      : KnownUserSavedState(user: this.user);
}

class KnownUserUnsavedState extends KnownUserAssociatifState {
  final UserAssociatif oldSavedUser;

  KnownUserUnsavedState({@required user, @required this.oldSavedUser}) : super(user: user);

  @override
  KnownUserAssociatifState createNewState({UserAssociatif newUser}) => (newUser != this.oldSavedUser)
      ? KnownUserUnsavedState(user: newUser, oldSavedUser: this.oldSavedUser)
      : KnownUserSavedState(user: this.oldSavedUser);
}

class KnownUserSavingState extends KnownUserUnsavedState {
  // This user is the one we are trying to save
  KnownUserSavingState({@required user, @required oldSavedUser})
      : super(user: user, oldSavedUser: oldSavedUser);

  @override
  KnownUserAssociatifState createNewState({UserAssociatif newUser}) {
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
  KnownUserAssociatifState createNewState({UserAssociatif newUser}) => (newUser != this.user)
      ? KnownUserUnsavedState(user: newUser, oldSavedUser: this.user)
      : KnownUserSavedState(user: this.user);
}
