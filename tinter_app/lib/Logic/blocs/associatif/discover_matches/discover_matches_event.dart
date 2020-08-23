part of 'discover_matches_bloc.dart';

@immutable
abstract class DiscoverMatchesEvent extends Equatable {
  const DiscoverMatchesEvent();

  @override
  List<Object> get props => [];
}

class DiscoverMatchesRequestedEvent extends DiscoverMatchesEvent {}

abstract class DiscoverMatchesLoadInSuccessEvent extends DiscoverMatchesEvent {
  final Match match;

  const DiscoverMatchesLoadInSuccessEvent({@required this.match});

  @override
  List<Object> get props => [match];

}

class ChangeStatusDiscoverMatchesEvent extends DiscoverMatchesLoadInSuccessEvent {
  final MatchStatus newStatus;
  final EnumRelationStatusAssociatif enumRelationStatusAssociatif;

  const ChangeStatusDiscoverMatchesEvent({@required match, @required this.newStatus, @required this.enumRelationStatusAssociatif}):super(match: match);

  @override
  List<Object> get props => [match, newStatus];
}

class DiscoverMatchLikeEvent extends DiscoverMatchesLoadInSuccessEvent {}

class DiscoverMatchIgnoreEvent extends DiscoverMatchesLoadInSuccessEvent {}