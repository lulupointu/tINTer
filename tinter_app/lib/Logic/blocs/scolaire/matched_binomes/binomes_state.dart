part of 'binomes_bloc.dart';

@immutable
abstract class MatchedBinomesState extends Equatable {
  const MatchedBinomesState();

  @override
  List<Object> get props => [];
}

class MatchedBinomesInitialState extends MatchedBinomesState {}

class MatchedBinomesCheckingHasBinomePairState extends MatchedBinomesState {}

class MatchedBinomesHasBinomePairCheckedSuccessState extends MatchedBinomesState {
  final bool hasBinomePair;

  const MatchedBinomesHasBinomePairCheckedSuccessState({@required this.hasBinomePair});
}

class MatchedBinomesHasBinomePairCheckedFailedState extends MatchedBinomesState {}

class MatchedBinomesLoadingState extends MatchedBinomesHasBinomePairCheckedSuccessState {
  MatchedBinomesLoadingState({@required bool hasBinomePair})
      : super(hasBinomePair: hasBinomePair);
}

class MatchedBinomesLoadingFailedState extends MatchedBinomesHasBinomePairCheckedSuccessState {
  MatchedBinomesLoadingFailedState({@required bool hasBinomePair})
      : super(hasBinomePair: hasBinomePair);
}

class MatchedBinomesLoadSuccessState extends MatchedBinomesHasBinomePairCheckedSuccessState {
  final List<BuildBinome> binomes;

  MatchedBinomesLoadSuccessState({@required this.binomes})
      : assert(binomes != null),
        super(
          hasBinomePair: binomes.any(
            (BuildBinome binome) => binome.statusScolaire == BinomeStatus.binomeAccepted,
          ),
        );

  List<BuildBinome> withUpdatedBinome(BuildBinome oldBinome, BuildBinome updatedBinome) {
    List<BuildBinome> newBinomes = List.from(binomes);
    newBinomes.remove(oldBinome);
    newBinomes.add(updatedBinome);
    return newBinomes;
  }

  @override
  List<Object> get props => [binomes];
}

class MatchedBinomesRefreshingState extends MatchedBinomesLoadSuccessState {
  MatchedBinomesRefreshingState({@required binomes}) : super(binomes: binomes);

  List<BuildBinome> withUpdatedBinome(BuildBinome oldBinome, BuildBinome updatedBinome) {
    List<BuildBinome> newBinomes = List.from(binomes);
    newBinomes.remove(oldBinome);
    newBinomes.add(updatedBinome);
    return newBinomes;
  }

  @override
  List<Object> get props => [binomes];
}

class MatchedBinomesSavingNewStatusState extends MatchedBinomesLoadSuccessState {
  MatchedBinomesSavingNewStatusState({@required List<BuildBinome> binomes})
      : super(binomes: binomes);

  List<BuildBinome> withUpdatedBinome(BuildBinome oldBinome, BuildBinome updatedBinome) {
    throw UnimplementedError();
  }
}

class MatchedBinomesLoadFailureState extends MatchedBinomesLoadSuccessState {
  MatchedBinomesLoadFailureState({@required List<BuildBinome> binomes})
      : super(binomes: binomes);
}
