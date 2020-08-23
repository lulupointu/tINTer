part of 'user_associatif_search_bloc.dart';

@immutable
abstract class UserAssociatifSearchState {}

class UserAssociatifSearchInitialState extends UserAssociatifSearchState {}

class UserAssociatifSearchLoadingState extends UserAssociatifSearchState {}

class UserAssociatifSearchLoadFailedState extends UserAssociatifSearchState {}

class UserAssociatifSearchLoadSuccessfulState extends UserAssociatifSearchState {
  final List<SearchedUserAssociatif> searchedUsers;

  UserAssociatifSearchLoadSuccessfulState({@required this.searchedUsers});
}

class UserAssociatifSearchRefreshingState extends UserAssociatifSearchLoadSuccessfulState {

  UserAssociatifSearchRefreshingState({@required List<SearchedUserAssociatif> searchedUsers}) : super(searchedUsers: searchedUsers);
}

class UserAssociatifSearchRefreshingFailedState extends UserAssociatifSearchLoadSuccessfulState {

  UserAssociatifSearchRefreshingFailedState({@required List<SearchedUserAssociatif> searchedUsers}) : super(searchedUsers: searchedUsers);
}

class UserAssociatifSearchSavingNewStatusState extends UserAssociatifSearchLoadSuccessfulState {

  UserAssociatifSearchSavingNewStatusState({@required List<SearchedUserAssociatif> searchedUsers}) : super(searchedUsers: searchedUsers);
}

class UserAssociatifSearchSavingNewStatusFailedState extends UserAssociatifSearchLoadSuccessfulState {

  UserAssociatifSearchSavingNewStatusFailedState({@required List<SearchedUserAssociatif> searchedUsers}) : super(searchedUsers: searchedUsers);
}