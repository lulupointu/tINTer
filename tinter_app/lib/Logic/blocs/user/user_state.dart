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

  UserLoadSuccessState createNewState({User user});

  UserLoadSuccessState withPrimoEntrantChanged(bool newValue) {
    return createNewState(
      user: User(
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
      ),
    );
  }

  UserLoadSuccessState withAttiranceVieAssoChanged(
    double newValue,
  ) {
    assert(0 <= newValue && newValue <= 1);
    return createNewState(
      user: User(
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
      ),
    );
  }

  UserLoadSuccessState withAideOuSortirChanged(double newValue) {
    assert(0 <= newValue && newValue <= 1);
    return createNewState(
      user: User(
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
      ),
    );
  }

  UserLoadSuccessState withFeteOuCoursChanged(double newValue) {
    assert(0 <= newValue && newValue <= 1);
    return createNewState(
      user: User(
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
      ),
    );
  }

  UserLoadSuccessState withOrganisationEvenementsChanged(double newValue) {
    assert(0 <= newValue && newValue <= 1);
    return createNewState(
      user: User(
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
      ),
    );
  }

  UserLoadSuccessState withInitAssociation() {
    return createNewState(
      user: User(
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
      ),
    );
  }


  UserLoadSuccessState withAddedAssociation(Association newAssociation) {
    final List<Association> newAssociations = List.from(user.associations);
    newAssociations.add(newAssociation);
    return createNewState(
      user: User(
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
      ),
    );
  }

  UserLoadSuccessState withRemovedAssociation(Association associationToRemove) {
    final List<Association> newAssociations = List.from(user.associations);
    newAssociations.remove(associationToRemove);
    return createNewState(
      user: User(
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
      ),
    );
  }

  UserLoadSuccessState withInitGoutsMusicaux() {
    return createNewState(
      user: User(
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
      ),
    );
  }


  UserLoadSuccessState withAddedGoutMusical(String newGoutMusical) {
    final List<String> newGoutMusicaux = List.from(user.goutsMusicaux);
    newGoutMusicaux.add(newGoutMusical);
    return createNewState(
      user: User(
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
      ),
    );
  }

  UserLoadSuccessState withRemovedGoutMusical(String goutMusicalToRemove) {
    final List<String> newGoutMusicaux = List.from(user.goutsMusicaux);
    newGoutMusicaux.remove(goutMusicalToRemove);
    return createNewState(
      user: User(
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
      ),
    );
  }
}

abstract class NewUserState extends UserLoadSuccessState {
  NewUserState({@required user}) : super(user: user);
}

class NewUserCreatingProfileState extends NewUserState {
  NewUserCreatingProfileState({@required user}) : super(user: user);

  NewUserCreatingProfileState createNewState({User user}) {
    return NewUserCreatingProfileState(user: user);
  }
}

class NewUserLoadingState extends NewUserState {
  @override
  UserLoadSuccessState createNewState({User user}) {
    throw UnimplementedError();
  }
}

class NewUserSavingState extends NewUserState {
  NewUserSavingState({@required user}) : super(user: user);

  @override
  UserLoadSuccessState createNewState({User user}) {
    throw UnimplementedError();
  }
}

abstract class KnownUserState extends UserLoadSuccessState {
  KnownUserState({@required user}) : super(user: user);
}

class KnownUserRefreshingState extends KnownUserState {
  KnownUserRefreshingState({@required user}) : super(user: user);

  @override
  KnownUserUnsavedState createNewState({User user}) {
    return KnownUserUnsavedState(user: user);
  }
}

class KnownUserSavedState extends KnownUserState {
  KnownUserSavedState({@required user}) : super(user: user);

  @override
  KnownUserUnsavedState createNewState({User user}) {
    return KnownUserUnsavedState(user: user);
  }
}

class KnownUserUnsavedState extends KnownUserState {
  KnownUserUnsavedState({@required user}) : super(user: user);

  @override
  KnownUserUnsavedState createNewState({User user}) {
    return KnownUserUnsavedState(user: user);
  }
}

class KnownUserSavingState extends KnownUserState {
  // This user is the one we are trying to save
  KnownUserSavingState({@required user}) : super(user: user);

  @override
  UserLoadSuccessState createNewState({User user}) {
    throw UnimplementedError();
  }
}

class KnownUserSavingFailedState extends KnownUserState {
  // This user is the one we are trying to save
  KnownUserSavingFailedState({@required user}) : super(user: user);

  @override
  UserLoadSuccessState createNewState({User user}) {
    throw UnimplementedError();
  }
}

class KnownUserRefreshingFailedState extends KnownUserState {
  KnownUserRefreshingFailedState({@required user}) : super(user: user);

  @override
  UserLoadSuccessState createNewState({User user}) {
    return KnownUserUnsavedState(user: user);
  }
}
