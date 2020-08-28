part of 'binomes_bloc.dart';

@immutable
abstract class MatchedBinomesEvent extends Equatable {
  const MatchedBinomesEvent();

  @override
  List<Object> get props => [];
}

class MatchedBinomesRequestedEvent extends MatchedBinomesEvent {}

//abstract class MatchedBinomesLoadInSuccessEvent extends MatchedBinomesEvent {
//
//  const MatchedBinomesLoadInSuccessEvent({@required this.binome});
//
//  @override
//  List<Object> get props => [binome];
//}

abstract class ChangeStatusMatchedBinomesEvent extends MatchedBinomesEvent {
  final BuildBinome binome;
  final EnumRelationStatusAssociatif enumRelationStatusAssociatif;
  final BinomeStatus binomeStatus;

  const ChangeStatusMatchedBinomesEvent({
    @required this.binome,
    @required this.enumRelationStatusAssociatif,
    @required this.binomeStatus,
  });

  @override
  List<Object> get props => [binome, enumRelationStatusAssociatif];
}

class AskParrainEvent extends ChangeStatusMatchedBinomesEvent {
  const AskParrainEvent({@required BuildBinome binome})
      : super(
          binome: binome,
          enumRelationStatusAssociatif: EnumRelationStatusAssociatif.askedParrain,
          binomeStatus: BinomeStatus.youAskedParrain,
        );
}

class AcceptParrainEvent extends ChangeStatusMatchedBinomesEvent {
  const AcceptParrainEvent({@required BuildBinome binome})
      : super(
          binome: binome,
          enumRelationStatusAssociatif: EnumRelationStatusAssociatif.acceptedParrain,
          binomeStatus: BinomeStatus.parrainAccepted,
        );
}

class RefuseParrainEvent extends ChangeStatusMatchedBinomesEvent {
  const RefuseParrainEvent({@required BuildBinome binome})
      : super(
          binome: binome,
          enumRelationStatusAssociatif: EnumRelationStatusAssociatif.refusedParrain,
          binomeStatus: BinomeStatus.parrainYouRefused,
        );
}
