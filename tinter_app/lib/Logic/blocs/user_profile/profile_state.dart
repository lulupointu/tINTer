part of 'profile_bloc.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object> get props => [];
}

class ProfileInitialState extends ProfileState {}

class ProfileLoadInProgressState extends ProfileState {}

abstract class ProfileLoadSuccessState extends ProfileState {
  final Profile profile;

  ProfileLoadSuccessState({@required this.profile}) : assert(profile != null);

  @override
  List<Object> get props => [profile];

  UnsavedProfileState withAttiranceVieAssoChanged(double newValue) {
    assert(0 <= newValue && newValue <= 1);
    return UnsavedProfileState(profile: Profile(profile.name, profile.surname, profile.email, profile.primoEntrant, profile.associations, newValue,
        profile.feteOuCours, profile.aideOuSortir, profile.organisationEvenements, profile.goutsMusicaux));
  }

  UnsavedProfileState withAideOuSortirChanged(double newValue) {
    assert(0 <= newValue && newValue <= 1);
    return UnsavedProfileState(profile: Profile(profile.name, profile.surname, profile.email, profile.primoEntrant, profile.associations, profile.attiranceVieAsso,
        profile.feteOuCours, newValue, profile.organisationEvenements, profile.goutsMusicaux));
  }

  UnsavedProfileState withFeteOuCoursChanged(double newValue) {
    assert(0 <= newValue && newValue <= 1);
    return UnsavedProfileState(profile: Profile(profile.name, profile.surname, profile.email, profile.primoEntrant, profile.associations, profile.attiranceVieAsso,
        newValue, profile.aideOuSortir, profile.organisationEvenements, profile.goutsMusicaux));
  }

  UnsavedProfileState withOrganisationEvenementsChanged(double newValue) {
    assert(0 <= newValue && newValue <= 1);
    return UnsavedProfileState(profile: Profile(profile.name, profile.surname, profile.email, profile.primoEntrant, profile.associations, profile.attiranceVieAsso,
        profile.feteOuCours, profile.aideOuSortir, newValue, profile.goutsMusicaux));
  }

  UnsavedProfileState withAddedAssociation(Association newAssociation) {
    final List<Association> newAssociations = List.from(profile.associations);
    newAssociations.add(newAssociation);
    return UnsavedProfileState(profile: Profile(profile.name, profile.surname, profile.email, profile.primoEntrant, newAssociations, profile.attiranceVieAsso,
        profile.feteOuCours, profile.aideOuSortir, profile.organisationEvenements, profile.goutsMusicaux));
  }

  UnsavedProfileState withRemovedAssociation(Association associationToRemove) {
    final List<Association> newAssociations = List.from(profile.associations);
    newAssociations.remove(associationToRemove);
    return UnsavedProfileState(profile: Profile(profile.name, profile.surname, profile.email, profile.primoEntrant, newAssociations, profile.attiranceVieAsso,
        profile.feteOuCours, profile.aideOuSortir, profile.organisationEvenements, profile.goutsMusicaux));
  }

  UnsavedProfileState withAddedGoutMusical(String newGoutMusical) {
    final List<String> newGoutMusicaux = List.from(profile.goutsMusicaux);
    newGoutMusicaux.add(newGoutMusical);
    return UnsavedProfileState(profile: Profile(profile.name, profile.surname, profile.email, profile.primoEntrant, profile.associations, profile.attiranceVieAsso,
        profile.feteOuCours, profile.aideOuSortir, profile.organisationEvenements, newGoutMusicaux));
  }

  UnsavedProfileState withRemovedGoutMusical(String goutMusicalToRemove) {
    final List<String> newGoutMusicaux = List.from(profile.goutsMusicaux);
    newGoutMusicaux.remove(goutMusicalToRemove);
    return UnsavedProfileState(profile: Profile(profile.name, profile.surname, profile.email, profile.primoEntrant, profile.associations, profile.attiranceVieAsso,
        profile.feteOuCours, profile.aideOuSortir, profile.organisationEvenements, newGoutMusicaux));
  }
}

class SavedProfileState extends ProfileLoadSuccessState {
  SavedProfileState({@required profile}) : super(profile: profile);
}

class UnsavedProfileState extends ProfileLoadSuccessState {
  UnsavedProfileState({@required profile}) : super(profile: profile);
}
