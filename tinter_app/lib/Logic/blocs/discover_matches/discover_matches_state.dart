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

  List<Match> getUpdatedMatches(Match oldMatch, Match updatedMatch) {
    List<Match> newMatches = List.from(matches);
    newMatches.remove(oldMatch);
    newMatches.add(updatedMatch);
    return newMatches;
  }

  @override
  List<Object> get props => [matches];
}

class DiscoverMatchesWaitingStatusChangeState extends DiscoverMatchesLoadSuccessState {
  const DiscoverMatchesWaitingStatusChangeState({@required List<Match> matches})
      : super(matches: matches);
}

class DiscoverMatchesSavingNewStatusState extends DiscoverMatchesLoadSuccessState {
  const DiscoverMatchesSavingNewStatusState({@required List<Match> matches})
      : super(matches: matches);
}

class DiscoverMatchesLoadFailureState extends DiscoverMatchesState {}
