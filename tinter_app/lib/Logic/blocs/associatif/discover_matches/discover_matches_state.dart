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
  final List<BuildMatch> matches;

  const DiscoverMatchesLoadSuccessState({@required this.matches});

  List<BuildMatch> getUpdatedMatches(BuildMatch oldMatch, BuildMatch updatedMatch) {
    List<BuildMatch> newMatches = List.from(matches);
    newMatches.remove(oldMatch);
    newMatches.add(updatedMatch);
    return newMatches;
  }

  @override
  List<Object> get props => [matches];
}

class DiscoverMatchesRefreshingState extends DiscoverMatchesLoadSuccessState {

  const DiscoverMatchesRefreshingState({@required matches}):super(matches: matches);

  List<BuildMatch> getUpdatedMatches(BuildMatch oldMatch, BuildMatch updatedMatch) {
    List<BuildMatch> newMatches = List.from(matches);
    newMatches.remove(oldMatch);
    newMatches.add(updatedMatch);
    return newMatches;
  }

  @override
  List<Object> get props => [matches];
}

class DiscoverMatchesWaitingStatusChangeState extends DiscoverMatchesLoadSuccessState {
  const DiscoverMatchesWaitingStatusChangeState({@required List<BuildMatch> matches})
      : super(matches: matches);
}

class DiscoverMatchesSavingNewStatusState extends DiscoverMatchesLoadSuccessState {
  const DiscoverMatchesSavingNewStatusState({@required List<BuildMatch> matches})
      : super(matches: matches);
}

class DiscoverMatchesLoadFailureState extends DiscoverMatchesState {}
