part of 'matched_pair_matches_bloc.dart';

@immutable
abstract class MatchedBinomePairMatchesState extends Equatable {
  const MatchedBinomePairMatchesState();

  @override
  List<Object> get props => [];
}

class MatchedBinomePairMatchesInitialState extends MatchedBinomePairMatchesState {}

class MatchedBinomePairMatchesInitializingState extends MatchedBinomePairMatchesState {}

class MatchedBinomePairMatchesInitializingFailedState extends MatchedBinomePairMatchesState {}

class MatchedBinomePairMatchesLoadSuccessState extends MatchedBinomePairMatchesState {
  final List<BuildBinomePairMatch> binomePairMatches;

  const MatchedBinomePairMatchesLoadSuccessState({@required this.binomePairMatches}):assert(binomePairMatches != null);

  List<BuildBinomePairMatch> withUpdatedBinomePairMatch(BuildBinomePairMatch oldBinomePairMatch, BuildBinomePairMatch updatedBinomePairMatch) {
    List<BuildBinomePairMatch> newBinomePairMatches = List.from(binomePairMatches);
    newBinomePairMatches.remove(oldBinomePairMatch);
    newBinomePairMatches.add(updatedBinomePairMatch);
    return newBinomePairMatches;
  }

  @override
  List<Object> get props => [binomePairMatches];
}

class MatchedBinomePairMatchesSavingNewStatusState extends MatchedBinomePairMatchesLoadSuccessState {

  MatchedBinomePairMatchesSavingNewStatusState({@required List<BuildBinomePairMatch> binomePairMatches}) : super(binomePairMatches: binomePairMatches);

  List<BuildBinomePairMatch> withUpdatedBinomePairMatch(BuildBinomePairMatch oldBinomePairMatch, BuildBinomePairMatch updatedBinomePairMatch) {
    throw UnimplementedError();
  }
}

class MatchedBinomePairMatchesLoadFailureState extends MatchedBinomePairMatchesLoadSuccessState {

  MatchedBinomePairMatchesLoadFailureState({@required List<BuildBinomePairMatch> binomePairMatches}) : super(binomePairMatches: binomePairMatches);
}