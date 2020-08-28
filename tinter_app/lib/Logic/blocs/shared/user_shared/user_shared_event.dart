part of 'user_shared_bloc.dart';

abstract class UserEvent {
  const UserEvent();
}

class UserInitEvent extends UserEvent {}

class UserRequestEvent extends UserEvent {}

class UserStateChangedEvent extends UserEvent {
  final BuildUser newState;

  UserStateChangedEvent({
    @required this.newState,
  });
}

class UserSaveEvent extends UserEvent {}

class UserRefreshEvent extends UserEvent {}

class UserUndoUnsavedChangesEvent extends UserEvent {}

class DeleteUserAccountEvent extends UserEvent {}
