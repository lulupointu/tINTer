part of 'user_bloc.dart';

abstract class UserEvent{
  const UserEvent();
}

class UserRequestEvent extends UserEvent {}

enum AssociationEventStatus {
  add,
  remove
}

class AssociationEvent extends UserEvent {
  final Association association;
  final AssociationEventStatus status;

  const AssociationEvent({@required this.association, @required this.status});
}

enum GoutMusicauxEventStatus {
  add,
  remove
}

class GoutMusicauxEvent extends UserEvent {
  final String goutMusical;
  final GoutMusicauxEventStatus status;

  const GoutMusicauxEvent({@required this.goutMusical, @required this.status});
}

class AttiranceVieAssoChanged extends UserEvent {
  final double newValue;

  const AttiranceVieAssoChanged({@required this.newValue})
      : assert(0 <= newValue && newValue <= 1);
}

class FeteOuCoursChanged extends UserEvent {
  final double newValue;

  const FeteOuCoursChanged({@required this.newValue})
      : assert(0 <= newValue && newValue <= 1);
}

class AideOuSortirChanged extends UserEvent {
  final double newValue;

  const AideOuSortirChanged({@required this.newValue})
      : assert(0 <= newValue && newValue <= 1);
}

class OrganisationEvenementsChanged extends UserEvent {
  final double newValue;

  const OrganisationEvenementsChanged({@required this.newValue})
      : assert(0 <= newValue && newValue <= 1),
  super();
}

class UserSaveEvent extends UserEvent {}



