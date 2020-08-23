part of 'user_shared_bloc.dart';

abstract class UserSharedPartEvent {
  const UserSharedPartEvent();
}

class UserSharedPartInitEvent extends UserSharedPartEvent {}

class UserSharedPartRequestEvent extends UserSharedPartEvent {}

class UserStateChangedEvent extends UserSharedPartEvent {
  final BuildUserSharedPart newState;

  UserStateChangedEvent({
    @required this.newState,
  });
}

class UserSharedPartSaveEvent extends UserSharedPartEvent {}

class UserSharedPartRefreshEvent extends UserSharedPartEvent {}

class UserSharedPartUndoUnsavedChangesEvent extends UserSharedPartEvent {}

class DeleteUserSharedPartAccountEvent extends UserSharedPartEvent {}
