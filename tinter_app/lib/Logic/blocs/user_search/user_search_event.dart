part of 'user_search_bloc.dart';

@immutable
abstract class UserSearchEvent {}

class UserSearchLoadEvent extends UserSearchEvent {}

class UserSearchRefreshEvent extends UserSearchEvent {}

class UserSearchLikeEvent extends UserSearchEvent {
  final SearchedUser likedSearchedUser;

  UserSearchLikeEvent({@required this.likedSearchedUser});
}

class UserSearchIgnoreEvent extends UserSearchEvent {
  final SearchedUser ignoredSearchedUser;

  UserSearchIgnoreEvent({@required this.ignoredSearchedUser});
}

class UserSearchChangeStatusEvent extends UserSearchEvent {
  final SearchedUser searchedUser;
  final MatchStatus newStatus;
  final EnumRelationStatus enumRelationStatus;

  UserSearchChangeStatusEvent({@required this.searchedUser, @required this.newStatus, @required this.enumRelationStatus});
}

