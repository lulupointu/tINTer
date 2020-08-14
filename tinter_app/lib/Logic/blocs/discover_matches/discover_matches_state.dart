part of 'discover_matches_bloc.dart';

@immutable
abstract class DiscoverMatchesState extends Equatable {
  const DiscoverMatchesState();

  @override
  List<Object> get props => [];
}

class DiscoverMatchesInitialState extends DiscoverMatchesState {}

class DiscoverMatchesLoadInProgressState extends DiscoverMatchesState {}

class DiscoverMatchesLoadSuccessState extends DiscoverMatchesState {
  final List<Match> matches;


  const DiscoverMatchesLoadSuccessState({@required this.matches});

  List<Match> withUpdatedMatch(Match oldMatch, Match updatedMatch) {
    List<Match> newMatches = List.from(matches);
    newMatches.remove(oldMatch);
    newMatches.add(updatedMatch);
    return newMatches;
  }

  @override
  List<Object> get props => [matches];
}

class DiscoverMatchesSavingNewStatusState extends DiscoverMatchesState {}

class DiscoverMatchesLoadFailureState extends DiscoverMatchesState {}