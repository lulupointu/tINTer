part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitialState extends UserState {}

class UserLoadInProgressState extends UserState {}

abstract class UserLoadSuccessState extends UserState {
  final User user;

  UserLoadSuccessState({@required this.user}) : assert(user != null);

  @override
  List<Object> get props => [user];

  UnsavedUserState withAttiranceVieAssoChanged(double newValue) {
    assert(0 <= newValue && newValue <= 1);
    return UnsavedUserState(user: User(user.name, user.surname, user.email, user.primoEntrant, user.associations, newValue,
        user.feteOuCours, user.aideOuSortir, user.organisationEvenements, user.goutsMusicaux));
  }

  UnsavedUserState withAideOuSortirChanged(double newValue) {
    assert(0 <= newValue && newValue <= 1);
    return UnsavedUserState(user: User(user.name, user.surname, user.email, user.primoEntrant, user.associations, user.attiranceVieAsso,
        user.feteOuCours, newValue, user.organisationEvenements, user.goutsMusicaux));
  }

  UnsavedUserState withFeteOuCoursChanged(double newValue) {
    assert(0 <= newValue && newValue <= 1);
    return UnsavedUserState(user: User(user.name, user.surname, user.email, user.primoEntrant, user.associations, user.attiranceVieAsso,
        newValue, user.aideOuSortir, user.organisationEvenements, user.goutsMusicaux));
  }

  UnsavedUserState withOrganisationEvenementsChanged(double newValue) {
    assert(0 <= newValue && newValue <= 1);
    return UnsavedUserState(user: User(user.name, user.surname, user.email, user.primoEntrant, user.associations, user.attiranceVieAsso,
        user.feteOuCours, user.aideOuSortir, newValue, user.goutsMusicaux));
  }

  UnsavedUserState withAddedAssociation(Association newAssociation) {
    final List<Association> newAssociations = List.from(user.associations);
    newAssociations.add(newAssociation);
    return UnsavedUserState(user: User(user.name, user.surname, user.email, user.primoEntrant, newAssociations, user.attiranceVieAsso,
        user.feteOuCours, user.aideOuSortir, user.organisationEvenements, user.goutsMusicaux));
  }

  UnsavedUserState withRemovedAssociation(Association associationToRemove) {
    final List<Association> newAssociations = List.from(user.associations);
    newAssociations.remove(associationToRemove);
    return UnsavedUserState(user: User(user.name, user.surname, user.email, user.primoEntrant, newAssociations, user.attiranceVieAsso,
        user.feteOuCours, user.aideOuSortir, user.organisationEvenements, user.goutsMusicaux));
  }

  UnsavedUserState withAddedGoutMusical(String newGoutMusical) {
    final List<String> newGoutMusicaux = List.from(user.goutsMusicaux);
    newGoutMusicaux.add(newGoutMusical);
    return UnsavedUserState(user: User(user.name, user.surname, user.email, user.primoEntrant, user.associations, user.attiranceVieAsso,
        user.feteOuCours, user.aideOuSortir, user.organisationEvenements, newGoutMusicaux));
  }

  UnsavedUserState withRemovedGoutMusical(String goutMusicalToRemove) {
    final List<String> newGoutMusicaux = List.from(user.goutsMusicaux);
    newGoutMusicaux.remove(goutMusicalToRemove);
    return UnsavedUserState(user: User(user.name, user.surname, user.email, user.primoEntrant, user.associations, user.attiranceVieAsso,
        user.feteOuCours, user.aideOuSortir, user.organisationEvenements, newGoutMusicaux));
  }
}

class SavedUserState extends UserLoadSuccessState {
  SavedUserState({@required user}) : super(user: user);
}

class UnsavedUserState extends UserLoadSuccessState {
  UnsavedUserState({@required user}) : super(user: user);
}
