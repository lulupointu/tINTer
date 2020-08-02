part of 'matches_bloc.dart';

@immutable
abstract class MatchedMatchesState extends Equatable {
  const MatchedMatchesState();

  @override
  List<Object> get props => [];
}

class MatchedMatchesInitialState extends MatchedMatchesState {}

class MatchedMatchesLoadInProgressState extends MatchedMatchesState {}

class MatchedMatchesLoadSuccessState extends MatchedMatchesState {
  final List<Match> matches;


  const MatchedMatchesLoadSuccessState({@required this.matches});

  List<Match> withUpdatedMatch(Match oldMatch, Match updatedMatch) {
    List<Match> newMatches = List.from(matches);
    newMatches.remove(oldMatch);
    newMatches.add(updatedMatch);
    return newMatches;
  }

  @override
  List<Object> get props => [matches];
}

class MatchedMatchesLoadFailureState extends MatchedMatchesState {}