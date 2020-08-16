import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/blocs/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/models/static_student.dart';
import 'package:tinterapp/Logic/models/user.dart';
import 'package:tinterapp/Logic/repository/authentication_repository.dart';
import 'package:tinterapp/Logic/repository/user_repository.dart';

part 'user_state.dart';

part 'user_event.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  UserBloc({@required this.userRepository, @required this.authenticationBloc})
      : super(UserInitialState());

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    switch (event.runtimeType) {
      case UserInitEvent:
        yield* _mapUserInitEventToState();
        return;
      case UserNewProfileEvent:
        yield* _mapUserNewProfileEventToState(event);
        return;
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
        }else
        {
          _addError('Saved was call while state is not UnsavedUserState');
        }
        return;
      case PrimoEntrantChanged:
        if (state is UserLoadSuccessState) {
          yield (state as UserLoadSuccessState)
              .withPrimoEntrantChanged((event as PrimoEntrantChanged).newValue);
        } else {
          _addError('PrimoEntrantChanged received while state is not UserLoadSuccessState');
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
          yield (state as UserLoadSuccessState)
              .withAttiranceVieAssoChanged((event as AttiranceVieAssoChanged).newValue);
        } else {
          _addError(
              'AttiranceVieAssoChanged received while state is not UserLoadSuccessState');
        }
        return;
      case AideOuSortirChanged:
        if (state is UserLoadSuccessState) {
          yield (state as UserLoadSuccessState)
              .withAideOuSortirChanged((event as AideOuSortirChanged).newValue);
        } else {
          _addError('AideOuSortirChanged received while state is not UserLoadSuccessState');
        }
        return;
      case FeteOuCoursChanged:
        if (state is UserLoadSuccessState) {
          yield (state as UserLoadSuccessState)
              .withFeteOuCoursChanged((event as FeteOuCoursChanged).newValue);
        } else {
          _addError('FeteOuCoursChanged received while state is not UserLoadSuccessState');
        }
        return;
      case OrganisationEvenementsChanged:
        if (state is UserLoadSuccessState) {
          yield (state as UserLoadSuccessState).withOrganisationEvenementsChanged(
              (event as OrganisationEvenementsChanged).newValue);
        } else {
          _addError(
              'OrganisationEvenementsChanged received while state is not UserLoadSuccessState');
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

  Stream<UserState> _mapUserInitEventToState() async* {
    yield UserInitializingState();

    User user;
    try {
      user = await userRepository.getUser();
    } on UnknownUserError catch (error) {
      try {
        StaticStudent staticUser = await userRepository.getBasicUserInfo();
        yield NewUserCreatingProfileState(
          user: User(
            login: staticUser.login,
            name: staticUser.name,
            surname: staticUser.surname,
            email: staticUser.email,
          ),
        );
      } catch (error) {
        print(error);
      }
      return;
    }

    yield KnownUserSavedState(user: user);
  }

  // TODO: REMOVE THIS
  Stream<UserState> _mapUserNewProfileEventToState(UserNewProfileEvent event) async* {
    final User user = User(
      login: event.staticStudent.login,
      name: event.staticStudent.name,
      surname: event.staticStudent.surname,
      email: event.staticStudent.email,
      primoEntrant: event.staticStudent.primoEntrant,
      associations: [],
      attiranceVieAsso: 0.5,
      feteOuCours: 0.5,
      aideOuSortir: 0.5,
      organisationEvenements: 0.5,
      goutsMusicaux: [],
    );
    yield KnownUserUnsavedState(user: user);
  }

  Stream<UserState> _mapUserRequestEventToState() async* {
    yield UserInitializingState();

    User user;
    try {
      user = await userRepository.getUser();
    } catch (error) {
      yield UserInitializingFailedState();
    }
    yield KnownUserSavedState(user: user);
  }

  Stream<UserState> _mapUserRefreshEventToState() async* {
    if (!(state is KnownUserState)) {
      print("Trying to refresh while the user wasn't known");
      yield UserInitialState();
      return;
    }
    yield KnownUserRefreshingState(user: (state as KnownUserState).user);

    User user;
    try {
      user = await userRepository.getUser();
    } catch (error) {
      yield KnownUserRefreshingFailedState(user: (state as KnownUserState).user);
    }
    yield KnownUserSavedState(user: user);
  }


  Stream<UserState> _mapNewUserSaveEventToState(user) async* {
    yield NewUserSavingState(user: user);
    try {
      await userRepository.createUser(user: user);
    } catch (error) {
      yield NewUserCreatingProfileState(user: user);
      return;
    }

    yield KnownUserSavedState(user: user);
  }

  Stream<UserState> _mapUserSaveEventToState(user) async* {
    yield KnownUserSavingState(user: user);
    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserInitialState();
      return;
    }
    try {
      userRepository.updateUser(user: user);
    } catch (error) {
      yield KnownUserSavingFailedState(user: user);
      return;
    }

    yield KnownUserSavedState(user: user);
  }

  Stream<UserState> _mapAssociationEventToState(AssociationEvent event) async* {
    switch (event.status) {
      case AssociationEventStatus.init:
        yield (state as UserLoadSuccessState).withInitAssociation();
        break;
      case AssociationEventStatus.add:
        yield (state as UserLoadSuccessState).withAddedAssociation(event.association);
        break;
      case AssociationEventStatus.remove:
        yield (state as UserLoadSuccessState).withRemovedAssociation(event.association);
        break;
    }
  }

  Stream<UserState> _mapGoutMusicauxEventToState(GoutMusicauxEvent event) async* {
    switch (event.status) {
      case GoutMusicauxEventStatus.init:
        yield (state as UserLoadSuccessState).withInitGoutsMusicaux();
        break;
      case GoutMusicauxEventStatus.add:
        yield (state as UserLoadSuccessState).withAddedGoutMusical(event.goutMusical);
        break;
      case GoutMusicauxEventStatus.remove:
        yield (state as UserLoadSuccessState).withRemovedGoutMusical(event.goutMusical);
        break;
    }
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
