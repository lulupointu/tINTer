import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';
import 'package:tinterapp/Logic/models/associatif/relation_status_associatif.dart';
import 'package:tinterapp/Logic/models/associatif/searched_user_associatif.dart';
import 'package:tinterapp/Logic/models/scolaire/searched_user_scolaire.dart';
import 'package:tinterapp/Logic/repository/associatif/matched_matches_repository.dart';
import 'package:tinterapp/Logic/repository/associatif/user_associatif_repository.dart';
import 'package:tinterapp/Logic/repository/scolaire/user_scolaire_repository.dart';

part 'user_scolaire_search_event.dart';

part 'user_scolaire_search_state.dart';

class UserScolaireSearchBloc extends Bloc<UserScolaireSearchEvent, UserScolaireSearchState> {
  final UserScolaireRepository userScolaireRepository;
  final MatchedMatchesRepository matchedMatchesRepository;
  final AuthenticationBloc authenticationBloc;

  UserScolaireSearchBloc(
      {@required this.userScolaireRepository,
      @required this.authenticationBloc,
      @required this.matchedMatchesRepository})
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
              'DiscoverMatchLikeEvent was called while state is not DiscoverMatchesLoadSuccessState');
        }
        return;
      case UserScolaireSearchLikeEvent:
        if (state is UserScolaireSearchLoadSuccessfulState) {
          _mapUserScolaireSearchLikeEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverMatchesLoadSuccessState');
        }
        return;
      case UserScolaireSearchIgnoreEvent:
        if (state is UserScolaireSearchLoadSuccessfulState) {
          _mapDiscoverMatchIgnoreEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverMatchesLoadSuccessState');
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
      searchedUsers = await userScolaireRepository.getAllSearchedUsers();
    } catch (error) {
      print(error);
      yield UserScolaireSearchLoadFailedState();
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
      searchedUsers = await userScolaireRepository.getAllSearchedUsers();
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
        enumRelationStatusAssociatif: EnumRelationStatusAssociatif.liked));
  }

  void _mapDiscoverMatchIgnoreEventToState(
      UserScolaireSearchIgnoreEvent userSearchIgnoreEvent) {
    add(UserScolaireSearchChangeStatusEvent(
        searchedUser: userSearchIgnoreEvent.ignoredSearchedUserScolaire,
        newStatus: MatchStatus.ignored,
        enumRelationStatusAssociatif: EnumRelationStatusAssociatif.ignored));
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
      matchedMatchesRepository.updateMatchStatus(
        relationStatus: RelationStatusAssociatif((r) => r
          ..otherLogin = event.searchedUser.login
          ..status = event.enumRelationStatusAssociatif,
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
