part of 'matched_pair_matches_bloc.dart';

@immutable
abstract class MatchedBinomePairMatchesEvent extends Equatable {
  const MatchedBinomePairMatchesEvent();

  @override
  List<Object> get props => [];
}

class MatchedBinomePairMatchesRequestedEvent extends MatchedBinomePairMatchesEvent {}

class MatchedBinomePairRefreshingEvent extends MatchedBinomePairMatchesEvent {}

//abstract class MatchedBinomePairMatchesLoadInSuccessEvent extends MatchedBinomePairMatchesEvent {
//
//  const MatchedBinomePairMatchesLoadInSuccessEvent({@required this.binomePairMatch});
//
//  @override
//  List<Object> get props => [binomePairMatch];
//}

abstract class ChangeStatusMatchedBinomePairMatchesEvent extends MatchedBinomePairMatchesEvent {
  final BuildBinomePairMatch binomePairMatch;
  final EnumRelationStatusBinomePair enumRelationStatusBinomePair;
  final BinomePairMatchStatus binomePairMatchStatus;

  const ChangeStatusMatchedBinomePairMatchesEvent({
    @required this.binomePairMatch,
    @required this.enumRelationStatusBinomePair,
    @required this.binomePairMatchStatus,
  });

  @override
  List<Object> get props => [binomePairMatch, enumRelationStatusBinomePair];
}

class IgnoreBinomePairMatchEvent extends ChangeStatusMatchedBinomePairMatchesEvent {
  const IgnoreBinomePairMatchEvent({@required BuildBinomePairMatch binomePairMatch})
      : super(
    binomePairMatch: binomePairMatch,
    enumRelationStatusBinomePair: EnumRelationStatusBinomePair.ignored,
    binomePairMatchStatus: BinomePairMatchStatus.ignored,
  );
}

class AskBinomePairMatchEvent extends ChangeStatusMatchedBinomePairMatchesEvent {
  const AskBinomePairMatchEvent({@required BuildBinomePairMatch binomePairMatch})
      : super(
          binomePairMatch: binomePairMatch,
          enumRelationStatusBinomePair: EnumRelationStatusBinomePair.askedBinomePairMatch,
          binomePairMatchStatus: BinomePairMatchStatus.youAskedBinomePairMatch,
        );
}

class AcceptBinomePairMatchEvent extends ChangeStatusMatchedBinomePairMatchesEvent {
  const AcceptBinomePairMatchEvent({@required BuildBinomePairMatch binomePairMatch})
      : super(
          binomePairMatch: binomePairMatch,
          enumRelationStatusBinomePair: EnumRelationStatusBinomePair.acceptedBinomePairMatch,
          binomePairMatchStatus: BinomePairMatchStatus.binomePairMatchAccepted,
        );
}

class RefuseBinomePairMatchEvent extends ChangeStatusMatchedBinomePairMatchesEvent {
  const RefuseBinomePairMatchEvent({@required BuildBinomePairMatch binomePairMatch})
      : super(
          binomePairMatch: binomePairMatch,
          enumRelationStatusBinomePair: EnumRelationStatusBinomePair.refusedBinomePairMatch,
          binomePairMatchStatus: BinomePairMatchStatus.binomePairMatchYouRefused,
        );
}
