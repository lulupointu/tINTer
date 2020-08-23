part of 'discover_binomes_bloc.dart';

@immutable
abstract class DiscoverBinomesState extends Equatable {
  const DiscoverBinomesState();

  @override
  List<Object> get props => [];
}

class DiscoverBinomesInitialState extends DiscoverBinomesState {}

class DiscoverBinomesLoadInProgressState extends DiscoverBinomesState {}

class DiscoverBinomesLoadSuccessState extends DiscoverBinomesState {
  final List<BuildBinome> binomes;

  const DiscoverBinomesLoadSuccessState({@required this.binomes});

  List<BuildBinome> getUpdatedBinomes(BuildBinome oldBinome, BuildBinome updatedBinome) {
    List<BuildBinome> newBinomes = List.from(binomes);
    newBinomes.remove(oldBinome);
    newBinomes.add(updatedBinome);
    return newBinomes;
  }

  @override
  List<Object> get props => [binomes];
}

class DiscoverBinomesWaitingStatusChangeState extends DiscoverBinomesLoadSuccessState {
  const DiscoverBinomesWaitingStatusChangeState({@required List<BuildBinome> binomes})
      : super(binomes: binomes);
}

class DiscoverBinomesSavingNewStatusState extends DiscoverBinomesLoadSuccessState {
  const DiscoverBinomesSavingNewStatusState({@required List<BuildBinome> binomes})
      : super(binomes: binomes);
}

class DiscoverBinomesLoadFailureState extends DiscoverBinomesState {}
