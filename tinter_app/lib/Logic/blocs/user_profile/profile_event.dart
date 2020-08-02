part of 'profile_bloc.dart';

abstract class ProfileEvent{
  const ProfileEvent();
}

class ProfileRequestEvent extends ProfileEvent {}

enum AssociationEventStatus {
  add,
  remove
}

class AssociationEvent extends ProfileEvent {
  final Association association;
  final AssociationEventStatus status;

  const AssociationEvent({@required this.association, @required this.status});
}

enum GoutMusicauxEventStatus {
  add,
  remove
}

class GoutMusicauxEvent extends ProfileEvent {
  final String goutMusical;
  final GoutMusicauxEventStatus status;

  const GoutMusicauxEvent({@required this.goutMusical, @required this.status});
}

class AttiranceVieAssoChanged extends ProfileEvent {
  final double newValue;

  const AttiranceVieAssoChanged({@required this.newValue})
      : assert(0 <= newValue && newValue <= 1);
}

class FeteOuCoursChanged extends ProfileEvent {
  final double newValue;

  const FeteOuCoursChanged({@required this.newValue})
      : assert(0 <= newValue && newValue <= 1);
}

class AideOuSortirChanged extends ProfileEvent {
  final double newValue;

  const AideOuSortirChanged({@required this.newValue})
      : assert(0 <= newValue && newValue <= 1);
}

class OrganisationEvenementsChanged extends ProfileEvent {
  final double newValue;

  const OrganisationEvenementsChanged({@required this.newValue})
      : assert(0 <= newValue && newValue <= 1),
  super();
}

class ProfileSaveEvent extends ProfileEvent {}



