part of 'binome_pair_search_bloc.dart';

@immutable
abstract class BinomePairSearchState {}

class BinomePairSearchInitialState extends BinomePairSearchState {}

class BinomePairSearchLoadingState extends BinomePairSearchState {}

class BinomePairSearchLoadFailedState extends BinomePairSearchState {}

class BinomePairSearchLoadSuccessfulState extends BinomePairSearchState {
  final List<SearchedBinomePair> searchedBinomePairs;

  BinomePairSearchLoadSuccessfulState({@required this.searchedBinomePairs});
}

class BinomePairSearchRefreshingState extends BinomePairSearchLoadSuccessfulState {

  BinomePairSearchRefreshingState({@required List<SearchedBinomePair> searchedBinomePairs}) : super(searchedBinomePairs: searchedBinomePairs);
}

class BinomePairSearchRefreshingFailedState extends BinomePairSearchLoadSuccessfulState {

  BinomePairSearchRefreshingFailedState({@required List<SearchedBinomePair> searchedBinomePairs}) : super(searchedBinomePairs: searchedBinomePairs);
}

class BinomePairSearchSavingNewStatusState extends BinomePairSearchLoadSuccessfulState {

  BinomePairSearchSavingNewStatusState({@required List<SearchedBinomePair> searchedBinomePairs}) : super(searchedBinomePairs: searchedBinomePairs);
}

class BinomePairSearchSavingNewStatusFailedState extends BinomePairSearchLoadSuccessfulState {

  BinomePairSearchSavingNewStatusFailedState({@required List<SearchedBinomePair> searchedBinomePairs}) : super(searchedBinomePairs: searchedBinomePairs);
}