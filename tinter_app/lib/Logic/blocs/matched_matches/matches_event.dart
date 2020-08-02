part of 'matches_bloc.dart';

@immutable
abstract class MatchedMatchesEvent extends Equatable {
  const MatchedMatchesEvent();

  @override
  List<Object> get props => [];
}

class MatchedMatchesRequestedEvent extends MatchedMatchesEvent {}

abstract class MatchedMatchesLoadInSuccessEvent extends MatchedMatchesEvent {
  final Match match;

  const MatchedMatchesLoadInSuccessEvent({@required this.match});

  @override
  List<Object> get props => [match];

}

class ChangeStatusMatchedMatchesEvent extends MatchedMatchesLoadInSuccessEvent {
  final MatchStatus newStatus;

  const ChangeStatusMatchedMatchesEvent({@required match, @required this.newStatus}):super(match: match);

  @override
  List<Object> get props => [match, newStatus];
}