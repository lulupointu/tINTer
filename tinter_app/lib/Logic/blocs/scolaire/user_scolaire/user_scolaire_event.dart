part of 'user_scolaire_bloc.dart';

abstract class UserScolaireEvent {
  const UserScolaireEvent();
}

class UserScolaireInitEvent extends UserScolaireEvent {}

class UserScolaireRequestEvent extends UserScolaireEvent {}

class UserScolaireAttributeChangedEvent extends UserScolaireEvent {
  final UserScolaireAttribute userScolaireAttribute;
  final dynamic newValue;

  UserScolaireAttributeChangedEvent({
    @required this.userScolaireAttribute,
    @required this.newValue,
  });
}

class UserScolaireSaveEvent extends UserScolaireEvent {}

class UserScolaireRefreshEvent extends UserScolaireEvent {}

class UserScolaireUndoUnsavedChangesEvent extends UserScolaireEvent {}

class DeleteUserScolaireAccountEvent extends UserScolaireEvent {}
