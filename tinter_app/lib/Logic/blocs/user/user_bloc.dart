import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/models/user.dart';
import 'package:tinterapp/Logic/repository/user_repository.dart';

part 'user_state.dart';
part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({@required this.userRepository}) : super(UserInitialState());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    switch (event.runtimeType) {
      case UserRequestEvent:
        yield* _mapUserRequestEventToState();
        return;
      case UserSaveEvent:
        if (state is UnsavedUserState) {
          yield* _mapUserSaveEventToState((state as UnsavedUserState).user);
        } else {
          _addError('Saved was call while state is not UnsavedUserState');
        }
        return;
      case AssociationEvent:
        if (state is UserLoadSuccessState) {
          yield* _mapAssociationEventToState(event);
        } else {
          _addError('AssociationEvent received while state is not UserLoadSuccessState');
        }
        return;
      case AttiranceVieAssoChanged:
        if (state is UserLoadSuccessState) {
          yield (state as UserLoadSuccessState).withAttiranceVieAssoChanged((event as AttiranceVieAssoChanged).newValue);
        } else {
          _addError('AttiranceVieAssoChanged received while state is not UserLoadSuccessState');
        }
        return;
      case AideOuSortirChanged:
        if (state is UserLoadSuccessState) {
          yield (state as UserLoadSuccessState).withAideOuSortirChanged((event as AideOuSortirChanged).newValue);
        } else {
          _addError('AideOuSortirChanged received while state is not UserLoadSuccessState');
        }
        return;
      case FeteOuCoursChanged:
        if (state is UserLoadSuccessState) {
          yield (state as UserLoadSuccessState).withFeteOuCoursChanged((event as FeteOuCoursChanged).newValue);
        } else {
          _addError('FeteOuCoursChanged received while state is not UserLoadSuccessState');
        }
        return;
      case OrganisationEvenementsChanged:
        if (state is UserLoadSuccessState) {
          yield (state as UserLoadSuccessState).withOrganisationEvenementsChanged((event as OrganisationEvenementsChanged).newValue);
        } else {
          _addError('OrganisationEvenementsChanged received while state is not UserLoadSuccessState');
        }
        return;
      case GoutMusicauxEvent:
        if (state is UserLoadSuccessState) {
          yield* _mapGoutMusicauxEventToState(event);
        } else {
          _addError('GoutMusicauxEvent received while state is not UserLoadSuccessState');
        }
        return;
    }

    print('event: ' + event.toString() + ' no treated');
  }

  Stream<UserState> _mapUserRequestEventToState() async* {
    yield UserLoadInProgressState();
    final User user = await userRepository.getUser();
    yield SavedUserState(user: user);
  }

  Stream<UserState> _mapUserSaveEventToState(user) async* {
    userRepository.updateUser(user);
  }

  Stream<UserState> _mapAssociationEventToState(AssociationEvent event) async* {
    if (event.status == AssociationEventStatus.add) {
      yield (state as UserLoadSuccessState).withAddedAssociation(event.association);
    } else {
      assert(event.status == AssociationEventStatus.remove);
      yield (state as UserLoadSuccessState).withRemovedAssociation(event.association);
    }
  }

  Stream<UserState> _mapGoutMusicauxEventToState(GoutMusicauxEvent event) async* {
    if (event.status == GoutMusicauxEventStatus.add) {
      yield (state as UserLoadSuccessState).withAddedGoutMusical(event.goutMusical);
    } else {
      assert(event.status == GoutMusicauxEventStatus.remove);
      yield (state as UserLoadSuccessState).withRemovedGoutMusical(event.goutMusical);
    }
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }


}
