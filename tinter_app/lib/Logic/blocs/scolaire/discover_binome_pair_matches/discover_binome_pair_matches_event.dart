part of 'discover_binome_pair_matches_bloc.dart';

@immutable
abstract class DiscoverBinomePairMatchesEvent extends Equatable {
  const DiscoverBinomePairMatchesEvent();

  @override
  List<Object> get props => [];
}

class DiscoverBinomePairMatchesRequestedEvent extends DiscoverBinomePairMatchesEvent {}

abstract class DiscoverBinomePairMatchesLoadInSuccessEvent extends DiscoverBinomePairMatchesEvent {
  final BuildBinomePairMatch binomePairMatch;

  const DiscoverBinomePairMatchesLoadInSuccessEvent({@required this.binomePairMatch});

  @override
  List<Object> get props => [binomePairMatch];

}

class DiscoverBinomePairMatchesChangeStatusEvent extends DiscoverBinomePairMatchesLoadInSuccessEvent {
  final BinomePairMatchStatus newStatus;
  final EnumRelationStatusBinomePair enumRelationStatusBinomePair;

  const DiscoverBinomePairMatchesChangeStatusEvent({@required binomePairMatch, @required this.newStatus, @required this.enumRelationStatusBinomePair}):super(binomePairMatch: binomePairMatch);

  @override
  List<Object> get props => [binomePairMatch, newStatus];
}

class DiscoverBinomeLikeEvent extends DiscoverBinomePairMatchesLoadInSuccessEvent {}

class DiscoverBinomeIgnoreEvent extends DiscoverBinomePairMatchesLoadInSuccessEvent {}