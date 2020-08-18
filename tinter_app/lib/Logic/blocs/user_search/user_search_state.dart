part of 'user_search_bloc.dart';

@immutable
abstract class UserSearchState {}

class UserSearchInitialState extends UserSearchState {}

class UserSearchLoadingState extends UserSearchState {}

class UserSearchLoadFailedState extends UserSearchState {}

class UserSearchLoadSuccessfulState extends UserSearchState {
  final List<SearchedUser> searchedUsers;

  UserSearchLoadSuccessfulState({@required this.searchedUsers});
}

class UserSearchRefreshingState extends UserSearchLoadSuccessfulState {

  UserSearchRefreshingState({@required List<SearchedUser> searchedUsers}) : super(searchedUsers: searchedUsers);
}

class UserSearchRefreshingFailedState extends UserSearchLoadSuccessfulState {

  UserSearchRefreshingFailedState({@required List<SearchedUser> searchedUsers}) : super(searchedUsers: searchedUsers);
}

class UserSearchSavingNewStatusState extends UserSearchLoadSuccessfulState {

  UserSearchSavingNewStatusState({@required List<SearchedUser> searchedUsers}) : super(searchedUsers: searchedUsers);
}

class UserSearchSavingNewStatusFailedState extends UserSearchLoadSuccessfulState {

  UserSearchSavingNewStatusFailedState({@required List<SearchedUser> searchedUsers}) : super(searchedUsers: searchedUsers);
}