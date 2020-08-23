part of 'user_associatif_search_bloc.dart';

@immutable
abstract class UserAssociatifSearchEvent {}

class UserAssociatifSearchLoadEvent extends UserAssociatifSearchEvent {}

class UserAssociatifSearchRefreshEvent extends UserAssociatifSearchEvent {}

class UserAssociatifSearchLikeEvent extends UserAssociatifSearchEvent {
  final SearchedUserAssociatif likedSearchedUserAssociatif;

  UserAssociatifSearchLikeEvent({@required this.likedSearchedUserAssociatif});
}

class UserAssociatifSearchIgnoreEvent extends UserAssociatifSearchEvent {
  final SearchedUserAssociatif ignoredSearchedUserAssociatif;

  UserAssociatifSearchIgnoreEvent({@required this.ignoredSearchedUserAssociatif});
}

class UserAssociatifSearchChangeStatusEvent extends UserAssociatifSearchEvent {
  final SearchedUserAssociatif searchedUser;
  final MatchStatus newStatus;
  final EnumRelationStatusAssociatif enumRelationStatusAssociatif;

  UserAssociatifSearchChangeStatusEvent({@required this.searchedUser, @required this.newStatus, @required this.enumRelationStatusAssociatif});
}

