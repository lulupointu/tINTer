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
  final EnumRelationStatusScolaire enumRelationStatusScolaire;
  final BinomeStatus binomeStatus;

  const ChangeStatusMatchedBinomesEvent({
    @required this.binome,
    @required this.enumRelationStatusScolaire,
    @required this.binomeStatus,
  });

  @override
  List<Object> get props => [binome, enumRelationStatusScolaire];
}

class AskBinomeEvent extends ChangeStatusMatchedBinomesEvent {
  const AskBinomeEvent({@required BuildBinome binome})
      : super(
          binome: binome,
          enumRelationStatusScolaire: EnumRelationStatusScolaire.askedBinome,
          binomeStatus: BinomeStatus.youAskedBinome,
        );
}

class AcceptBinomeEvent extends ChangeStatusMatchedBinomesEvent {
  const AcceptBinomeEvent({@required BuildBinome binome})
      : super(
          binome: binome,
          enumRelationStatusScolaire: EnumRelationStatusScolaire.acceptedBinome,
          binomeStatus: BinomeStatus.binomeAccepted,
        );
}

class RefuseBinomeEvent extends ChangeStatusMatchedBinomesEvent {
  const RefuseBinomeEvent({@required BuildBinome binome})
      : super(
          binome: binome,
          enumRelationStatusScolaire: EnumRelationStatusScolaire.refusedBinome,
          binomeStatus: BinomeStatus.binomeYouRefused,
        );
}
