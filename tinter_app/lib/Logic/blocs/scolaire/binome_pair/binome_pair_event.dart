part of 'binome_pair_bloc.dart';

@immutable
abstract class BinomePairEvent {}

class BinomePairLoadEvent extends BinomePairEvent {}

class BinomePairRefreshEvent extends BinomePairEvent {}
