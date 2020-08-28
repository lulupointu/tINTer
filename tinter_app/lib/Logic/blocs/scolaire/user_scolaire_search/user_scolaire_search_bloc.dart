import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';
import 'package:tinterapp/Logic/models/scolaire/relation_status_scolaire.dart';
import 'package:tinterapp/Logic/models/scolaire/searched_user_scolaire.dart';
import 'package:tinterapp/Logic/repository/scolaire/matched_binomes_repository.dart';
import 'package:tinterapp/Logic/repository/shared/user_repository.dart';

part 'user_scolaire_search_event.dart';

part 'user_scolaire_search_state.dart';

class UserScolaireSearchBloc extends Bloc<UserScolaireSearchEvent, UserScolaireSearchState> {
  final UserRepository userRepository;
  final MatchedBinomesRepository matchedBinomesRepository;
  final AuthenticationBloc authenticationBloc;

  UserScolaireSearchBloc(
      {@required this.userRepository,
      @required this.authenticationBloc,
      @required this.matchedBinomesRepository})
      : super(UserScolaireSearchInitialState());

  @override
  Stream<UserScolaireSearchState> mapEventToState(UserScolaireSearchEvent event) async* {
    switch (event.runtimeType) {
      case UserScolaireSearchLoadEvent:
        yield* _mapAssociationLoadEventToState();
        return;
      case UserScolaireSearchRefreshEvent:
        yield* _mapAssociationRefreshEventToState();
        return;
      case UserScolaireSearchChangeStatusEvent:
        if (state is UserScolaireSearchLoadSuccessfulState) {
          yield* _mapUserScolaireSearchChangeStatusEventEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverBinomesLoadSuccessState');
        }
        return;
      case UserScolaireSearchLikeEvent:
        if (state is UserScolaireSearchLoadSuccessfulState) {
          _mapUserScolaireSearchLikeEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverBinomesLoadSuccessState');
        }
        return;
      case UserScolaireSearchIgnoreEvent:
        if (state is UserScolaireSearchLoadSuccessfulState) {
          _mapDiscoverMatchIgnoreEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverBinomesLoadSuccessState');
        }
        return;
      default:
        print('event: ' + event.toString() + ' no treated');
    }
  }

  Stream<UserScolaireSearchState> _mapAssociationLoadEventToState() async* {
    yield UserScolaireSearchLoadingState();

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserScolaireSearchInitialState();
      return;
    }

    List<SearchedUserScolaire> searchedUsers;
    try {
      searchedUsers = await userRepository.getAllSearchedUsersScolaire();
    } catch (error) {
      print(error);
      yield UserScolaireSearchLoadFailedState();
      return;
    }
    yield UserScolaireSearchLoadSuccessfulState(searchedUsers: searchedUsers);
  }

  Stream<UserScolaireSearchState> _mapAssociationRefreshEventToState() async* {
    yield UserScolaireSearchRefreshingState(
        searchedUsers: (state as UserScolaireSearchLoadSuccessfulState).searchedUsers);

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserScolaireSearchInitialState();
      return;
    }

    List<SearchedUserScolaire> searchedUsers;
    try {
      searchedUsers = await userRepository.getAllSearchedUsersScolaire();
    } catch (error) {
      print(error);
      yield UserScolaireSearchRefreshingFailedState(
          searchedUsers: (state as UserScolaireSearchLoadSuccessfulState).searchedUsers);
    }
    yield UserScolaireSearchLoadSuccessfulState(searchedUsers: searchedUsers);
  }

  void _mapUserScolaireSearchLikeEventToState(
      UserScolaireSearchLikeEvent userSearchLikeEvent) {
    add(UserScolaireSearchChangeStatusEvent(
        searchedUser: userSearchLikeEvent.likedSearchedUserScolaire,
        newStatus: MatchStatus.liked,
        enumRelationStatusScolaire: EnumRelationStatusScolaire.liked));
  }

  void _mapDiscoverMatchIgnoreEventToState(
      UserScolaireSearchIgnoreEvent userSearchIgnoreEvent) {
    add(UserScolaireSearchChangeStatusEvent(
        searchedUser: userSearchIgnoreEvent.ignoredSearchedUserScolaire,
        newStatus: MatchStatus.ignored,
        enumRelationStatusScolaire: EnumRelationStatusScolaire.ignored));
  }

  Stream<UserScolaireSearchState> _mapUserScolaireSearchChangeStatusEventEventToState(
      UserScolaireSearchChangeStatusEvent event) async* {
    List<SearchedUserScolaire> oldSearchedUsersScolaire =
        (state as UserScolaireSearchLoadSuccessfulState).searchedUsers;

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserScolaireSearchInitialState();
      return;
    }

    print('Getting the new match status');

    SearchedUserScolaire newSearchedUserScolaire = event.searchedUser
        .rebuild((s) => s..liked = event.newStatus == MatchStatus.ignored ? false : true);

    print('GotIT');

    List<SearchedUserScolaire> newSearchedUsersScolaire =
        List<SearchedUserScolaire>.from(oldSearchedUsersScolaire);
    newSearchedUsersScolaire.remove(event.searchedUser);
    newSearchedUsersScolaire.add(newSearchedUserScolaire);

    print('Replacing the liked or ignored user');

    yield UserScolaireSearchSavingNewStatusState(searchedUsers: newSearchedUsersScolaire);

    print('Changing state to saving');

    try {
      matchedBinomesRepository.updateBinomeStatus(
        relationStatus: RelationStatusScolaire((r) => r
          ..otherLogin = event.searchedUser.login
          ..statusScolaire = event.enumRelationStatusScolaire,
        ),
      );
      print('UPDATING');
    } catch (error) {
      print(error);
      yield UserScolaireSearchSavingNewStatusFailedState(
          searchedUsers: oldSearchedUsersScolaire);
    }

    print('YAHE');
    yield UserScolaireSearchLoadSuccessfulState(searchedUsers: newSearchedUsersScolaire);
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
