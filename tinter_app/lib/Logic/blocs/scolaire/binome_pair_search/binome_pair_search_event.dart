part of 'binome_pair_search_bloc.dart';

@immutable
abstract class BinomePairSearchEvent {}

class BinomePairSearchLoadEvent extends BinomePairSearchEvent {}

class BinomePairSearchRefreshEvent extends BinomePairSearchEvent {}

class BinomePairSearchLikeEvent extends BinomePairSearchEvent {
  final SearchedBinomePair likedSearchedBinomePair;

  BinomePairSearchLikeEvent({@required this.likedSearchedBinomePair});
}

class BinomePairSearchIgnoreEvent extends BinomePairSearchEvent {
  final SearchedBinomePair ignoredSearchedBinomePair;

  BinomePairSearchIgnoreEvent({@required this.ignoredSearchedBinomePair});
}

class BinomePairSearchChangeStatusEvent extends BinomePairSearchEvent {
  final SearchedBinomePair searchedBinomePairs;
  final MatchStatus newStatus;
  final EnumRelationStatusBinomePair enumRelationStatusBinomePair;

  BinomePairSearchChangeStatusEvent({@required this.searchedBinomePairs, @required this.newStatus, @required this.enumRelationStatusBinomePair});
}

