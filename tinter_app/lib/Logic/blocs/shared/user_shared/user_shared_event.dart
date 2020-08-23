part of 'user_shared_bloc.dart';

abstract class UserSharedPartEvent {
  const UserSharedPartEvent();
}

class UserSharedPartInitEvent extends UserSharedPartEvent {}

class UserSharedPartRequestEvent extends UserSharedPartEvent {}

class UserSharedPartMutableAttributeChangedEvent extends UserSharedPartEvent {
  final UserSharedPartMutableAttribute userSharedPartMutableAttribute;
  final dynamic newValue;

  UserSharedPartMutableAttributeChangedEvent({
    @required this.userSharedPartMutableAttribute,
    @required this.newValue,
  });
}

class UserSharedPartSaveEvent extends UserSharedPartEvent {}

class UserSharedPartRefreshEvent extends UserSharedPartEvent {}

class UserSharedPartUndoUnsavedChangesEvent extends UserSharedPartEvent {}

class DeleteUserSharedPartAccountEvent extends UserSharedPartEvent {}
