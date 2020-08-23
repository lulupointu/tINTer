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
  final BuildMatch match;
  final EnumRelationStatusAssociatif enumRelationStatusAssociatif;
  final MatchStatus matchStatus;

  const ChangeStatusMatchedMatchesEvent({
    @required this.match,
    @required this.enumRelationStatusAssociatif,
    @required this.matchStatus,
  });

  @override
  List<Object> get props => [match, enumRelationStatusAssociatif];
}

class AskParrainEvent extends ChangeStatusMatchedMatchesEvent {
  const AskParrainEvent({@required BuildMatch match})
      : super(
          match: match,
          enumRelationStatusAssociatif: EnumRelationStatusAssociatif.askedParrain,
          matchStatus: MatchStatus.youAskedParrain,
        );
}

class AcceptParrainEvent extends ChangeStatusMatchedMatchesEvent {
  const AcceptParrainEvent({@required BuildMatch match})
      : super(
          match: match,
          enumRelationStatusAssociatif: EnumRelationStatusAssociatif.acceptedParrain,
          matchStatus: MatchStatus.parrainAccepted,
        );
}

class RefuseParrainEvent extends ChangeStatusMatchedMatchesEvent {
  const RefuseParrainEvent({@required BuildMatch match})
      : super(
          match: match,
          enumRelationStatusAssociatif: EnumRelationStatusAssociatif.refusedParrain,
          matchStatus: MatchStatus.parrainYouRefused,
        );
}
