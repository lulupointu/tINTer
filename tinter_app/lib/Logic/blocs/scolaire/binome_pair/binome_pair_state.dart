part of 'binome_pair_bloc.dart';

@immutable
abstract class BinomePairState {}

class BinomePairInitialState extends BinomePairState {}

class BinomePairLoadingState extends BinomePairState {}

class BinomePairLoadFailedState extends BinomePairState {}

class BinomePairLoadSuccessfulState extends BinomePairState {
  final BuildBinomePair binomePair;

  BinomePairLoadSuccessfulState({@required this.binomePair});
}

class BinomePairRefreshingState extends BinomePairLoadSuccessfulState {

  BinomePairRefreshingState(BuildBinomePair binomePair) : super(binomePair: binomePair);
}

class BinomePairRefreshingFailedState extends BinomePairLoadSuccessfulState {

  BinomePairRefreshingFailedState(BuildBinomePair binomePair) : super(binomePair: binomePair);
}