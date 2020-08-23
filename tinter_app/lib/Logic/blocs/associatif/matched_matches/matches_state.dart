part of 'matches_bloc.dart';

@immutable
abstract class MatchedMatchesState extends Equatable {
  const MatchedMatchesState();

  @override
  List<Object> get props => [];
}

class MatchedMatchesInitialState extends MatchedMatchesState {}

class MatchedMatchesInitializingState extends MatchedMatchesState {}

class MatchedMatchesInitializingFailedState extends MatchedMatchesState {}

class MatchedMatchesLoadSuccessState extends MatchedMatchesState {
  final List<BuildMatch> matches;

  const MatchedMatchesLoadSuccessState({@required this.matches}):assert(matches != null);

  List<BuildMatch> withUpdatedMatch(BuildMatch oldMatch, BuildMatch updatedMatch) {
    List<BuildMatch> newMatches = List.from(matches);
    newMatches.remove(oldMatch);
    newMatches.add(updatedMatch);
    return newMatches;
  }

  @override
  List<Object> get props => [matches];
}

class MatchedMatchesSavingNewStatusState extends MatchedMatchesLoadSuccessState {

  MatchedMatchesSavingNewStatusState({@required List<BuildMatch> matches}) : super(matches: matches);

  List<BuildMatch> withUpdatedMatch(BuildMatch oldMatch, BuildMatch updatedMatch) {
    throw UnimplementedError();
  }
}

class MatchedMatchesLoadFailureState extends MatchedMatchesLoadSuccessState {

  MatchedMatchesLoadFailureState({@required List<BuildMatch> matches}) : super(matches: matches);
}