import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/blocs/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/match.dart';
import 'package:tinterapp/Logic/models/relation_status.dart';
import 'package:tinterapp/Logic/models/searched_user.dart';
import 'package:tinterapp/Logic/repository/matched_repository.dart';
import 'package:tinterapp/Logic/repository/user_repository.dart';

part 'user_search_event.dart';

part 'user_search_state.dart';

class UserSearchBloc extends Bloc<UserSearchEvent, UserSearchState> {
  final UserRepository userRepository;
  final MatchedRepository matchedRepository;
  final AuthenticationBloc authenticationBloc;

  UserSearchBloc({@required this.userRepository, @required this.authenticationBloc, @required this.matchedRepository})
      : super(UserSearchInitialState());

  @override
  Stream<UserSearchState> mapEventToState(UserSearchEvent event) async* {
    switch (event.runtimeType) {
      case UserSearchLoadEvent:
        yield* _mapAssociationLoadEventToState();
        return;
      case UserSearchRefreshEvent:
        yield* _mapAssociationRefreshEventToState();
        return;
      case UserSearchChangeStatusEvent:
        if (state is UserSearchLoadSuccessfulState) {
          yield* _mapUserSearchChangeStatusEventEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverMatchesLoadSuccessState');
        }
        return;
      case UserSearchLikeEvent:
        if (state is UserSearchLoadSuccessfulState) {
          _mapUserSearchLikeEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverMatchesLoadSuccessState');
        }
        return;
      case UserSearchIgnoreEvent:
        if (state is UserSearchLoadSuccessfulState) {
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

  Stream<UserSearchState> _mapAssociationLoadEventToState() async* {
    yield UserSearchLoadingState();

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserSearchInitialState();
      return;
    }

    List<SearchedUser> searchedUsers;
    try {
      searchedUsers = await userRepository.getAllSearchedUsers();
    } catch (error) {
      print(error);
      yield UserSearchLoadFailedState();
    }
    yield UserSearchLoadSuccessfulState(searchedUsers: searchedUsers);
  }

  Stream<UserSearchState> _mapAssociationRefreshEventToState() async* {
    yield UserSearchRefreshingState(searchedUsers: (state as UserSearchLoadSuccessfulState).searchedUsers);

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserSearchInitialState();
      return;
    }

    List<SearchedUser> searchedUsers;
    try {
      searchedUsers = await userRepository.getAllSearchedUsers();
    } catch (error) {
      print(error);
      yield UserSearchRefreshingFailedState(searchedUsers:
          (state as UserSearchLoadSuccessfulState).searchedUsers);
    }
    yield UserSearchLoadSuccessfulState(searchedUsers: searchedUsers);
  }

  void _mapUserSearchLikeEventToState(UserSearchLikeEvent userSearchLikeEvent) {
    add(UserSearchChangeStatusEvent(
        searchedUser: userSearchLikeEvent.likedSearchedUser,
        newStatus: MatchStatus.liked,
        enumRelationStatus: EnumRelationStatus.liked));
  }

  void _mapDiscoverMatchIgnoreEventToState(UserSearchIgnoreEvent userSearchIgnoreEvent) {
    add(UserSearchChangeStatusEvent(
        searchedUser: userSearchIgnoreEvent.ignoredSearchedUser,
        newStatus: MatchStatus.ignored,
        enumRelationStatus: EnumRelationStatus.ignored));
  }

  Stream<UserSearchState> _mapUserSearchChangeStatusEventEventToState(
      UserSearchChangeStatusEvent event) async* {

    List<SearchedUser> oldSearchedUsers = (state as UserSearchLoadSuccessfulState).searchedUsers;

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserSearchInitialState();
      return;
    }

    print('Getting the new match status');

    SearchedUser newSearchedUser = SearchedUser(
      login: event.searchedUser.login,
      name: event.searchedUser.name,
      surname: event.searchedUser.surname,
      liked: event.newStatus == MatchStatus.ignored ? false : true,
    );

    print('GotIT');

    List<SearchedUser> newSearchedUsers = List<SearchedUser>.from(oldSearchedUsers);
    newSearchedUsers.remove(event.searchedUser);
    newSearchedUsers.add(newSearchedUser);

    print('Replacing the liked or ignored user');

    yield UserSearchSavingNewStatusState(searchedUsers: newSearchedUsers);

    print('Changing state to saving');

    try {
      matchedRepository.updateMatchStatus(
        relationStatus: RelationStatus(
          login: null,
          otherLogin: event.searchedUser.login,
          status: event.enumRelationStatus,
        ),
      );
      print('UPDATING');
    } catch (error) {
      print(error);
      yield UserSearchSavingNewStatusFailedState(searchedUsers: oldSearchedUsers);
    }

    print('YAHE');
    yield UserSearchLoadSuccessfulState(searchedUsers: newSearchedUsers);
  }


  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
