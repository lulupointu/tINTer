part of 'user_scolaire_search_bloc.dart';

@immutable
abstract class UserScolaireSearchEvent {}

class UserScolaireSearchLoadEvent extends UserScolaireSearchEvent {}

class UserScolaireSearchRefreshEvent extends UserScolaireSearchEvent {}

class UserScolaireSearchLikeEvent extends UserScolaireSearchEvent {
  final SearchedUserScolaire likedSearchedUserScolaire;

  UserScolaireSearchLikeEvent({@required this.likedSearchedUserScolaire});
}

class UserScolaireSearchIgnoreEvent extends UserScolaireSearchEvent {
  final SearchedUserScolaire ignoredSearchedUserScolaire;

  UserScolaireSearchIgnoreEvent({@required this.ignoredSearchedUserScolaire});
}

class UserScolaireSearchChangeStatusEvent extends UserScolaireSearchEvent {
  final SearchedUserScolaire searchedUser;
  final MatchStatus newStatus;
  final EnumRelationStatusAssociatif enumRelationStatusAssociatif;

  UserScolaireSearchChangeStatusEvent({@required this.searchedUser, @required this.newStatus, @required this.enumRelationStatusAssociatif});
}

