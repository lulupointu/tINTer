import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';
import 'package:tinterapp/Logic/models/associatif/relation_status_associatif.dart';
import 'package:tinterapp/Logic/models/associatif/searched_user_associatif.dart';
import 'package:tinterapp/Logic/repository/associatif/matched_matches_repository.dart';
import 'package:tinterapp/Logic/repository/shared/user_repository.dart';

part 'user_associatif_search_event.dart';

part 'user_associatif_search_state.dart';

class UserAssociatifSearchBloc
    extends Bloc<UserAssociatifSearchEvent, UserAssociatifSearchState> {
  final UserRepository userRepository;
  final MatchedMatchesRepository matchedMatchesRepository;
  final AuthenticationBloc authenticationBloc;

  UserAssociatifSearchBloc(
      {@required this.userRepository,
      @required this.authenticationBloc,
      @required this.matchedMatchesRepository})
      : super(UserAssociatifSearchInitialState());

  @override
  Stream<UserAssociatifSearchState> mapEventToState(UserAssociatifSearchEvent event) async* {
    switch (event.runtimeType) {
      case UserAssociatifSearchLoadEvent:
        yield* _mapAssociationLoadEventToState();
        return;
      case UserAssociatifSearchRefreshEvent:
        yield* _mapAssociationRefreshEventToState();
        return;
      case UserAssociatifSearchChangeStatusEvent:
        if (state is UserAssociatifSearchLoadSuccessfulState) {
          yield* _mapUserAssociatifSearchChangeStatusEventEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverMatchesLoadSuccessState');
        }
        return;
      case UserAssociatifSearchLikeEvent:
        if (state is UserAssociatifSearchLoadSuccessfulState) {
          _mapUserAssociatifSearchLikeEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverMatchesLoadSuccessState');
        }
        return;
      case UserAssociatifSearchIgnoreEvent:
        if (state is UserAssociatifSearchLoadSuccessfulState) {
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

  Stream<UserAssociatifSearchState> _mapAssociationLoadEventToState() async* {
    yield UserAssociatifSearchLoadingState();

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserAssociatifSearchInitialState();
      return;
    }

    List<SearchedUserAssociatif> searchedUsers;
    try {
      searchedUsers = await userRepository.getAllSearchedUsersAssociatifs();
    } catch (error) {
      print(error);
      yield UserAssociatifSearchLoadFailedState();
    }

    searchedUsers
        .sort((SearchedUserAssociatif searchedUserA, SearchedUserAssociatif searchedUserB) {
      final compareNames =
          searchedUserA.name.toLowerCase().compareTo(searchedUserB.name.toLowerCase());
      return (compareNames == 0)
          ? searchedUserA.surname.toLowerCase().compareTo(searchedUserB.surname.toLowerCase())
          : compareNames;
    });

    yield UserAssociatifSearchLoadSuccessfulState(searchedUsers: searchedUsers);
  }

  Stream<UserAssociatifSearchState> _mapAssociationRefreshEventToState() async* {
    yield UserAssociatifSearchRefreshingState(
        searchedUsers: (state as UserAssociatifSearchLoadSuccessfulState).searchedUsers);

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserAssociatifSearchInitialState();
      return;
    }

    List<SearchedUserAssociatif> searchedUsers;
    try {
      searchedUsers = await userRepository.getAllSearchedUsersAssociatifs();
    } catch (error) {
      print(error);
      yield UserAssociatifSearchRefreshingFailedState(
          searchedUsers: (state as UserAssociatifSearchLoadSuccessfulState).searchedUsers);
    }

    searchedUsers
        .sort((SearchedUserAssociatif searchedUserA, SearchedUserAssociatif searchedUserB) {
      final compareNames =
      searchedUserA.name.toLowerCase().compareTo(searchedUserB.name.toLowerCase());
      return (compareNames == 0)
          ? searchedUserA.surname.toLowerCase().compareTo(searchedUserB.surname.toLowerCase())
          : compareNames;
    });

    yield UserAssociatifSearchLoadSuccessfulState(searchedUsers: searchedUsers);
  }

  void _mapUserAssociatifSearchLikeEventToState(
      UserAssociatifSearchLikeEvent userSearchLikeEvent) {
    add(UserAssociatifSearchChangeStatusEvent(
        searchedUser: userSearchLikeEvent.likedSearchedUserAssociatif,
        newStatus: MatchStatus.liked,
        enumRelationStatusAssociatif: EnumRelationStatusAssociatif.liked));
  }

  void _mapDiscoverMatchIgnoreEventToState(
      UserAssociatifSearchIgnoreEvent userSearchIgnoreEvent) {
    add(UserAssociatifSearchChangeStatusEvent(
        searchedUser: userSearchIgnoreEvent.ignoredSearchedUserAssociatif,
        newStatus: MatchStatus.ignored,
        enumRelationStatusAssociatif: EnumRelationStatusAssociatif.ignored));
  }

  Stream<UserAssociatifSearchState> _mapUserAssociatifSearchChangeStatusEventEventToState(
      UserAssociatifSearchChangeStatusEvent event) async* {
    List<SearchedUserAssociatif> oldSearchedUsersAssociatifs =
        (state as UserAssociatifSearchLoadSuccessfulState).searchedUsers;

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserAssociatifSearchInitialState();
      return;
    }

    print('Getting the new match status');

    SearchedUserAssociatif newSearchedUserAssociatif = SearchedUserAssociatif(
      (s) => s
        ..login = event.searchedUser.login
        ..name = event.searchedUser.name
        ..surname = event.searchedUser.surname
        ..liked = event.newStatus == MatchStatus.ignored ? false : true,
    );

    print('GotIT');

    List<SearchedUserAssociatif> newSearchedUsersAssociatifs =
        List<SearchedUserAssociatif>.from(oldSearchedUsersAssociatifs);
    var index = newSearchedUsersAssociatifs.indexOf(event.searchedUser);
    newSearchedUsersAssociatifs.remove(event.searchedUser);
    newSearchedUsersAssociatifs.insert(index, newSearchedUserAssociatif);

    print('Replacing the liked or ignored user');

    yield UserAssociatifSearchSavingNewStatusState(searchedUsers: newSearchedUsersAssociatifs);

    print('Changing state to saving');

    try {
      matchedMatchesRepository.updateMatchStatus(
        relationStatus: RelationStatusAssociatif((r) => r
          ..login = null
          ..otherLogin = event.searchedUser.login
          ..status = event.enumRelationStatusAssociatif),
      );
      print('UPDATING');
    } catch (error) {
      print(error);
      yield UserAssociatifSearchSavingNewStatusFailedState(
          searchedUsers: oldSearchedUsersAssociatifs);
    }

    print('YAHE');
    yield UserAssociatifSearchLoadSuccessfulState(searchedUsers: newSearchedUsersAssociatifs);
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
