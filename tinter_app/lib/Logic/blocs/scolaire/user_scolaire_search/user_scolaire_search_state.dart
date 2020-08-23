part of 'user_scolaire_search_bloc.dart';

@immutable
abstract class UserScolaireSearchState {}

class UserScolaireSearchInitialState extends UserScolaireSearchState {}

class UserScolaireSearchLoadingState extends UserScolaireSearchState {}

class UserScolaireSearchLoadFailedState extends UserScolaireSearchState {}

class UserScolaireSearchLoadSuccessfulState extends UserScolaireSearchState {
  final List<SearchedUserScolaire> searchedUsers;

  UserScolaireSearchLoadSuccessfulState({@required this.searchedUsers});
}

class UserScolaireSearchRefreshingState extends UserScolaireSearchLoadSuccessfulState {

  UserScolaireSearchRefreshingState({@required List<SearchedUserScolaire> searchedUsers}) : super(searchedUsers: searchedUsers);
}

class UserScolaireSearchRefreshingFailedState extends UserScolaireSearchLoadSuccessfulState {

  UserScolaireSearchRefreshingFailedState({@required List<SearchedUserScolaire> searchedUsers}) : super(searchedUsers: searchedUsers);
}

class UserScolaireSearchSavingNewStatusState extends UserScolaireSearchLoadSuccessfulState {

  UserScolaireSearchSavingNewStatusState({@required List<SearchedUserScolaire> searchedUsers}) : super(searchedUsers: searchedUsers);
}

class UserScolaireSearchSavingNewStatusFailedState extends UserScolaireSearchLoadSuccessfulState {

  UserScolaireSearchSavingNewStatusFailedState({@required List<SearchedUserScolaire> searchedUsers}) : super(searchedUsers: searchedUsers);
}