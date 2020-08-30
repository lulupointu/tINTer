part of 'discover_binome_pair_matches_bloc.dart';

@immutable
abstract class DiscoverBinomePairMatchesState extends Equatable {
  const DiscoverBinomePairMatchesState();

  @override
  List<Object> get props => [];
}

class DiscoverBinomePairMatchesInitialState extends DiscoverBinomePairMatchesState {}

class DiscoverBinomePairMatchesLoadInProgressState extends DiscoverBinomePairMatchesState {}

class DiscoverBinomePairMatchesLoadSuccessState extends DiscoverBinomePairMatchesState {
  final List<BuildBinomePairMatch> binomePairMatches;

  const DiscoverBinomePairMatchesLoadSuccessState({@required this.binomePairMatches});

  List<BuildBinomePairMatch> getUpdatedBinomePairMatches(BuildBinomePairMatch oldBinome, BuildBinomePairMatch updatedBinome) {
    List<BuildBinomePairMatch> newBinomePairMatches = List.from(binomePairMatches);
    newBinomePairMatches.remove(oldBinome);
    newBinomePairMatches.add(updatedBinome);
    return newBinomePairMatches;
  }

  @override
  List<Object> get props => [binomePairMatches];
}

class DiscoverBinomePairMatchesWaitingStatusChangeState extends DiscoverBinomePairMatchesLoadSuccessState {
  const DiscoverBinomePairMatchesWaitingStatusChangeState({@required List<BuildBinomePairMatch> binomePairMatches})
      : super(binomePairMatches: binomePairMatches);
}

class DiscoverBinomePairMatchesSavingNewStatusState extends DiscoverBinomePairMatchesLoadSuccessState {
  const DiscoverBinomePairMatchesSavingNewStatusState({@required List<BuildBinomePairMatch> binomePairMatches})
      : super(binomePairMatches: binomePairMatches);
}

class DiscoverBinomePairMatchesLoadFailureState extends DiscoverBinomePairMatchesState {}
