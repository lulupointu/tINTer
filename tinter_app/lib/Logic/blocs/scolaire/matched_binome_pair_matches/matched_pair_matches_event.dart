part of 'matched_pair_matches_bloc.dart';

@immutable
abstract class MatchedBinomePairMatchesEvent extends Equatable {
  const MatchedBinomePairMatchesEvent();

  @override
  List<Object> get props => [];
}

class MatchedBinomePairMatchesRequestedEvent extends MatchedBinomePairMatchesEvent {}

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

class AskBinomePairMatchEvent extends ChangeStatusMatchedBinomePairMatchesEvent {
  const AskBinomePairMatchEvent({@required BuildBinomePairMatch binomePairMatch})
      : super(
          binomePairMatch: binomePairMatch,
          enumRelationStatusBinomePair: EnumRelationStatusBinomePair.askedBinomePair,
          binomePairMatchStatus: BinomePairMatchStatus.youAskedBinomePair,
        );
}

class AcceptBinomePairMatchEvent extends ChangeStatusMatchedBinomePairMatchesEvent {
  const AcceptBinomePairMatchEvent({@required BuildBinomePairMatch binomePairMatch})
      : super(
          binomePairMatch: binomePairMatch,
          enumRelationStatusBinomePair: EnumRelationStatusBinomePair.acceptedBinomePair,
          binomePairMatchStatus: BinomePairMatchStatus.binomePairAccepted,
        );
}

class RefuseBinomePairMatchEvent extends ChangeStatusMatchedBinomePairMatchesEvent {
  const RefuseBinomePairMatchEvent({@required BuildBinomePairMatch binomePairMatch})
      : super(
          binomePairMatch: binomePairMatch,
          enumRelationStatusBinomePair: EnumRelationStatusBinomePair.refusedBinomePair,
          binomePairMatchStatus: BinomePairMatchStatus.binomePairYouRefused,
        );
}
