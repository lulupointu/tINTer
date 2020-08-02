import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/models/profile.dart';
import 'package:tinterapp/Logic/repository/profile_repository.dart';

part 'profile_state.dart';
part 'profile_event.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRepository profileRepository;

  ProfileBloc({@required this.profileRepository}) : super(ProfileInitialState());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    switch (event.runtimeType) {
      case ProfileRequestEvent:
        yield* _mapProfileRequestEventToState();
        return;
      case ProfileSaveEvent:
        if (state is UnsavedProfileState) {
          yield* _mapProfileSaveEventToState((state as UnsavedProfileState).profile);
        } else {
          _addError('Saved was call while state is not UnsavedProfileState');
        }
        return;
      case AssociationEvent:
        if (state is ProfileLoadSuccessState) {
          yield* _mapAssociationEventToState(event);
        } else {
          _addError('AssociationEvent received while state is not ProfileLoadSuccessState');
        }
        return;
      case AttiranceVieAssoChanged:
        if (state is ProfileLoadSuccessState) {
          yield (state as ProfileLoadSuccessState).withAttiranceVieAssoChanged((event as AttiranceVieAssoChanged).newValue);
        } else {
          _addError('AttiranceVieAssoChanged received while state is not ProfileLoadSuccessState');
        }
        return;
      case AideOuSortirChanged:
        if (state is ProfileLoadSuccessState) {
          yield (state as ProfileLoadSuccessState).withAideOuSortirChanged((event as AideOuSortirChanged).newValue);
        } else {
          _addError('AideOuSortirChanged received while state is not ProfileLoadSuccessState');
        }
        return;
      case FeteOuCoursChanged:
        if (state is ProfileLoadSuccessState) {
          yield (state as ProfileLoadSuccessState).withFeteOuCoursChanged((event as FeteOuCoursChanged).newValue);
        } else {
          _addError('FeteOuCoursChanged received while state is not ProfileLoadSuccessState');
        }
        return;
      case OrganisationEvenementsChanged:
        if (state is ProfileLoadSuccessState) {
          yield (state as ProfileLoadSuccessState).withOrganisationEvenementsChanged((event as OrganisationEvenementsChanged).newValue);
        } else {
          _addError('OrganisationEvenementsChanged received while state is not ProfileLoadSuccessState');
        }
        return;
      case GoutMusicauxEvent:
        if (state is ProfileLoadSuccessState) {
          yield* _mapGoutMusicauxEventToState(event);
        } else {
          _addError('GoutMusicauxEvent received while state is not ProfileLoadSuccessState');
        }
        return;
    }

    print('event: ' + event.toString() + ' no treated');
  }

  Stream<ProfileState> _mapProfileRequestEventToState() async* {
    yield ProfileLoadInProgressState();
    final Profile profile = await profileRepository.getProfile();
    yield SavedProfileState(profile: profile);
  }

  Stream<ProfileState> _mapProfileSaveEventToState(profile) async* {
    profileRepository.updateProfile(profile);
  }

  Stream<ProfileState> _mapAssociationEventToState(AssociationEvent event) async* {
    if (event.status == AssociationEventStatus.add) {
      yield (state as ProfileLoadSuccessState).withAddedAssociation(event.association);
    } else {
      assert(event.status == AssociationEventStatus.remove);
      yield (state as ProfileLoadSuccessState).withRemovedAssociation(event.association);
    }
  }

  Stream<ProfileState> _mapGoutMusicauxEventToState(GoutMusicauxEvent event) async* {
    if (event.status == GoutMusicauxEventStatus.add) {
      yield (state as ProfileLoadSuccessState).withAddedGoutMusical(event.goutMusical);
    } else {
      assert(event.status == GoutMusicauxEventStatus.remove);
      yield (state as ProfileLoadSuccessState).withRemovedGoutMusical(event.goutMusical);
    }
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }


}
