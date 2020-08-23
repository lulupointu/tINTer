import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/user_associatif.dart';
import 'package:tinterapp/Logic/repository/shared/authentication_repository.dart';
import 'package:tinterapp/Logic/repository/associatif/user_associatif_repository.dart';

part 'user_associatif_state.dart';

part 'user_associatif_event.dart';

class UserAssociatifBloc extends Bloc<UserAssociatifEvent, UserAssociatifState> {
  final UserAssociatifRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  UserAssociatifBloc({@required this.userRepository, @required this.authenticationBloc})
      : super(UserInitialState());

  @override
  Stream<UserAssociatifState> mapEventToState(UserAssociatifEvent event) async* {
    switch (event.runtimeType) {
      case UserInitEvent:
        yield* _mapUserInitEventToState();
        return;
//      case UserNewProfileEvent:
//        yield* _mapUserNewProfileEventToState(event);
//        return;
      case UserRequestEvent:
        yield* _mapUserRequestEventToState();
        return;
      case UserRefreshEvent:
        yield* _mapUserRefreshEventToState();
        return;
      case UserSaveEvent:
        if (state is KnownUserUnsavedState) {
          yield* _mapUserSaveEventToState((state as KnownUserUnsavedState).user);
        } else if (state is NewUserCreatingProfileState) {
          yield* _mapNewUserSaveEventToState((state as NewUserCreatingProfileState).user);
        } else {
          _addError(
              'Saved was call while state was ${state.runtimeType}. Whereas it should be either KnownUserUnsavedState or NewUserCreatingProfileState');
        }
        return;
      case UserUndoUnsavedChangesEvent:
        if (state is KnownUserUnsavedState) {
          yield* _mapUserUndoUnsavedChangesEventToState();
        } else {
          _addError(
              'Saved was call while state was ${state.runtimeType}. Whereas it should be KnownUserUnsavedState');
        }

        return;
      case UserAssociatifStateChangedEvent:
        if (state is UserLoadSuccessState) {
          yield* _mapUserAssociatifStateChangedEventToState(event);
        } else {
          _addError(
              'UserSharedPartMutableAttributeChangedEvent received while state is not UserSharedPartLoadSuccessState');
        }
        return;
//      case PrimoEntrantChanged:
//        if (state is UserLoadSuccessState) {
//          yield (state as UserLoadSuccessState)
//              .withPrimoEntrantChanged((event as PrimoEntrantChanged).newValue);
//        } else {
//          _addError('PrimoEntrantChanged received while state is not UserLoadSuccessState');
//        }
//        return;
//      case AssociationEvent:
//        if (state is UserLoadSuccessState) {
//          yield* _mapAssociationEventToState(event);
//        } else {
//          _addError('AssociationEvent received while state is not UserLoadSuccessState');
//        }
//        return;
//      case AttiranceVieAssoChanged:
//        if (state is UserLoadSuccessState) {
//          yield (state as UserLoadSuccessState)
//              .withAttiranceVieAssoChanged((event as AttiranceVieAssoChanged).newValue);
//        } else {
//          _addError(
//              'AttiranceVieAssoChanged received while state is not UserLoadSuccessState');
//        }
//        return;
//      case AideOuSortirChanged:
//        if (state is UserLoadSuccessState) {
//          yield (state as UserLoadSuccessState)
//              .withAideOuSortirChanged((event as AideOuSortirChanged).newValue);
//        } else {
//          _addError('AideOuSortirChanged received while state is not UserLoadSuccessState');
//        }
//        return;
//      case FeteOuCoursChanged:
//        if (state is UserLoadSuccessState) {
//          yield (state as UserLoadSuccessState)
//              .withFeteOuCoursChanged((event as FeteOuCoursChanged).newValue);
//        } else {
//          _addError('FeteOuCoursChanged received while state is not UserLoadSuccessState');
//        }
//        return;
//      case OrganisationEvenementsChanged:
//        if (state is UserLoadSuccessState) {
//          yield (state as UserLoadSuccessState).withOrganisationEvenementsChanged(
//              (event as OrganisationEvenementsChanged).newValue);
//        } else {
//          _addError(
//              'OrganisationEvenementsChanged received while state is not UserLoadSuccessState');
//        }
//        return;
//      case GoutMusicauxEvent:
//        if (state is UserLoadSuccessState) {
//          yield* _mapGoutMusicauxEventToState(event);
//        } else {
//          _addError('GoutMusicauxEvent received while state is not UserLoadSuccessState');
//        }
//        return;
//      case ProfilePicturePathChangedEvent:
//        if (state is UserLoadSuccessState) {
//          yield (state as UserLoadSuccessState)
//              .withPictureProfileChanged((event as ProfilePicturePathChangedEvent).newPath);
//        } else {
//          _addError(
//              'ProfilePicturePathChangedEvent received while state is not UserLoadSuccessState');
//        }
//        return;
      case DeleteUserAccountEvent:
        if (state is UserLoadSuccessState) {
          yield* _mapDeleteUserAccountEventToState();
        } else {
          _addError(
              'ProfilePicturePathChangedEvent received while state is not UserLoadSuccessState');
        }
        return;
    }

    print('event: ' + event.toString() + ' no treated');
  }

  Stream<UserAssociatifState> _mapUserInitEventToState() async* {
    yield UserInitializingState();

    BuildUserAssociatif user;
    try {
      user = await userRepository.getUser();
    } catch (error) {
      print(error);
      yield UserInitialState();
      return;
    }

    yield KnownUserSavedState(user: user);
  }

//  // TODO: REMOVE THIS
//  Stream<UserAssociatifState> _mapUserNewProfileEventToState(UserNewProfileEvent event) async* {
//    final User user = User(
//      login: event.staticStudent.login,
//      name: event.staticStudent.name,
//      surname: event.staticStudent.surname,
//      email: event.staticStudent.email,
//      primoEntrant: event.staticStudent.primoEntrant,
//      associations: [],
//      attiranceVieAsso: 0.5,
//      feteOuCours: 0.5,
//      aideOuSortir: 0.5,
//      organisationEvenements: 0.5,
//      goutsMusicaux: [],
//    );
//    yield KnownUserUnsavedState(user: user);
//  }

  Stream<UserAssociatifState> _mapUserRequestEventToState() async* {
    yield UserInitializingState();

    BuildUserAssociatif user;
    try {
      user = await userRepository.getUser();
    } catch (error) {
      yield UserInitializingFailedState();
      return;
    }
    yield KnownUserSavedState(user: user);
  }

  Stream<UserAssociatifState> _mapUserRefreshEventToState() async* {
    if (!(state is KnownUserAssociatifState)) {
      print("Trying to refresh while the user wasn't known");
      yield UserInitialState();
      return;
    }
    yield KnownUserRefreshingState(user: (state as KnownUserAssociatifState).user);

    BuildUserAssociatif user;
    try {
      user = await userRepository.getUser();
    } catch (error) {
      yield KnownUserRefreshingFailedState(user: (state as KnownUserAssociatifState).user);
      return;
    }
    yield KnownUserSavedState(user: user);
  }

  Stream<UserAssociatifState> _mapNewUserSaveEventToState(user) async* {
    yield NewUserSavingState(user: user);
    try {
      await userRepository.createUser(user: user);
    } catch (error) {
      yield NewUserCreatingProfileState(user: user);
      return;
    }

    imageCache.clear();

    yield KnownUserSavedState(
      user: (state as NewUserAssociatifState).user,
    );
  }

  Stream<UserAssociatifState> _mapUserSaveEventToState(BuildUserAssociatif user) async* {
    yield KnownUserSavingState(
        user: user, oldSavedUser: (state as KnownUserUnsavedState).oldSavedUser);

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserInitialState();
      return;
    }

    try {
      await userRepository.updateUser(user: user);
    } catch (error) {
      yield KnownUserSavingFailedState(
          user: user, oldSavedUser: (state as KnownUserUnsavedState).oldSavedUser);
      return;
    }

    imageCache.clear();

    yield KnownUserSavedState(user: (state as KnownUserUnsavedState).user);
  }

  Stream<UserAssociatifState> _mapUserUndoUnsavedChangesEventToState() async* {
    yield KnownUserSavedState(user: (state as KnownUserUnsavedState).oldSavedUser);
  }

//  Stream<UserAssociatifState> _mapAssociationEventToState(AssociationEvent event) async* {
//    switch (event.status) {
//      case AssociationEventStatus.init:
//        yield (state as UserLoadSuccessState).withInitAssociation();
//        break;
//      case AssociationEventStatus.add:
//        yield (state as UserLoadSuccessState).withAddedAssociation(event.association);
//        break;
//      case AssociationEventStatus.remove:
//        yield (state as UserLoadSuccessState).withRemovedAssociation(event.association);
//        break;
//    }
//  }
//
//  Stream<UserAssociatifState> _mapGoutMusicauxEventToState(GoutMusicauxEvent event) async* {
//    switch (event.status) {
//      case GoutMusicauxEventStatus.init:
//        yield (state as UserLoadSuccessState).withInitGoutsMusicaux();
//        break;
//      case GoutMusicauxEventStatus.add:
//        yield (state as UserLoadSuccessState).withAddedGoutMusical(event.goutMusical);
//        break;
//      case GoutMusicauxEventStatus.remove:
//        yield (state as UserLoadSuccessState).withRemovedGoutMusical(event.goutMusical);
//        break;
//    }
//  }

  Stream<UserAssociatifState> _mapUserAssociatifStateChangedEventToState(
      UserAssociatifStateChangedEvent event) async* {
    yield (state as UserLoadSuccessState).withNewState(newState: event.newState);
  }

  Stream<UserAssociatifState> _mapDeleteUserAccountEventToState() async* {
    try {
      await userRepository.deleteUserAccount();
    } catch (error) {
      print('Removing account failed: $error');
      return;
    }

    authenticationBloc.add(AuthenticationLoggedOutEvent());

    yield UserInitialState();
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
