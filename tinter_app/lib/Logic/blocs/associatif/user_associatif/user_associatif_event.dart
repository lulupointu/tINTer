part of 'user_associatif_bloc.dart';

abstract class UserAssociatifEvent {
  const UserAssociatifEvent();
}

class UserInitEvent extends UserAssociatifEvent {}

//class UserNewProfileEvent extends UserAssociatifEvent {
//  final StaticStudent staticStudent;
//
//  const UserNewProfileEvent({
//    @required this.staticStudent,
//  });
//}

class PrimoEntrantChanged extends UserAssociatifEvent {
  final bool newValue;

  const PrimoEntrantChanged({@required this.newValue})
      : assert(newValue != null);
}

class UserRequestEvent extends UserAssociatifEvent {}

enum AssociationEventStatus { init, add, remove }

class AssociationEvent extends UserAssociatifEvent {
  final Association association;
  final AssociationEventStatus status;

  const AssociationEvent({@required this.association, @required this.status});
}

enum GoutMusicauxEventStatus { init, add, remove }

class GoutMusicauxEvent extends UserAssociatifEvent {
  final String goutMusical;
  final GoutMusicauxEventStatus status;

  const GoutMusicauxEvent({@required this.goutMusical, @required this.status});
}

class AttiranceVieAssoChanged extends UserAssociatifEvent {
  final double newValue;

  const AttiranceVieAssoChanged({@required this.newValue})
      : assert(0 <= newValue && newValue <= 1);
}

class FeteOuCoursChanged extends UserAssociatifEvent {
  final double newValue;

  const FeteOuCoursChanged({@required this.newValue}) : assert(0 <= newValue && newValue <= 1);
}

class AideOuSortirChanged extends UserAssociatifEvent {
  final double newValue;

  const AideOuSortirChanged({@required this.newValue})
      : assert(0 <= newValue && newValue <= 1);
}

class OrganisationEvenementsChanged extends UserAssociatifEvent {
  final double newValue;

  const OrganisationEvenementsChanged({@required this.newValue})
      : assert(0 <= newValue && newValue <= 1),
        super();
}

class ProfilePicturePathChangedEvent extends UserAssociatifEvent {
  final String newPath;

  const ProfilePicturePathChangedEvent({@required this.newPath})
      : assert(newPath != null),
        super();
}

class UserSaveEvent extends UserAssociatifEvent {}

class UserRefreshEvent extends UserAssociatifEvent {}

class UserUndoUnsavedChangesEvent extends UserAssociatifEvent {}

class DeleteUserAccountEvent extends UserAssociatifEvent {}
