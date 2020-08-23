part of 'user_scolaire_bloc.dart';

abstract class UserScolaireEvent {
  const UserScolaireEvent();
}

class UserScolaireInitEvent extends UserScolaireEvent {}

class UserScolaireRequestEvent extends UserScolaireEvent {}

class UserScolaireMutableAttributeChangedEvent extends UserScolaireEvent {
  final UserScolaireMutableAttribute userScolaireMutableAttribute;
  final dynamic newState;

  UserScolaireMutableAttributeChangedEvent({
    @required this.userScolaireMutableAttribute,
    @required this.newState,
  });
}

class UserScolaireSaveEvent extends UserScolaireEvent {}

class UserScolaireRefreshEvent extends UserScolaireEvent {}

class UserScolaireUndoUnsavedChangesEvent extends UserScolaireEvent {}

//class DeleteUserScolaireAccountEvent extends UserScolaireEvent {}
