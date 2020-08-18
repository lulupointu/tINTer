part of 'matches_bloc.dart';

@immutable
abstract class MatchedMatchesEvent extends Equatable {
  const MatchedMatchesEvent();

  @override
  List<Object> get props => [];
}

class MatchedMatchesRequestedEvent extends MatchedMatchesEvent {}

//abstract class MatchedMatchesLoadInSuccessEvent extends MatchedMatchesEvent {
//
//  const MatchedMatchesLoadInSuccessEvent({@required this.match});
//
//  @override
//  List<Object> get props => [match];
//}

abstract class ChangeStatusMatchedMatchesEvent extends MatchedMatchesEvent {
  final Match match;
  final EnumRelationStatus enumRelationStatus;
  final MatchStatus matchStatus;

  const ChangeStatusMatchedMatchesEvent({
    @required this.match,
    @required this.enumRelationStatus,
    @required this.matchStatus,
  });

  @override
  List<Object> get props => [match, enumRelationStatus];
}

class AskParrainEvent extends ChangeStatusMatchedMatchesEvent {
  const AskParrainEvent({@required Match match})
      : super(
          match: match,
          enumRelationStatus: EnumRelationStatus.askedParrain,
          matchStatus: MatchStatus.youAskedParrain,
        );
}

class AcceptParrainEvent extends ChangeStatusMatchedMatchesEvent {
  const AcceptParrainEvent({@required Match match})
      : super(
          match: match,
          enumRelationStatus: EnumRelationStatus.acceptedParrain,
          matchStatus: MatchStatus.parrainAccepted,
        );
}

class RefuseParrainEvent extends ChangeStatusMatchedMatchesEvent {
  const RefuseParrainEvent({@required Match match})
      : super(
          match: match,
          enumRelationStatus: EnumRelationStatus.refusedParrain,
          matchStatus: MatchStatus.parrainYouRefused,
        );
}
