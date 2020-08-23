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
  final List<Binome> binomes;

  const DiscoverBinomesLoadSuccessState({@required this.binomes});

  List<Binome> getUpdatedBinomes(Binome oldBinome, Binome updatedBinome) {
    List<Binome> newBinomes = List.from(binomes);
    newBinomes.remove(oldBinome);
    newBinomes.add(updatedBinome);
    return newBinomes;
  }

  @override
  List<Object> get props => [binomes];
}

class DiscoverBinomesWaitingStatusChangeState extends DiscoverBinomesLoadSuccessState {
  const DiscoverBinomesWaitingStatusChangeState({@required List<Binome> binomes})
      : super(binomes: binomes);
}

class DiscoverBinomesSavingNewStatusState extends DiscoverBinomesLoadSuccessState {
  const DiscoverBinomesSavingNewStatusState({@required List<Binome> binomes})
      : super(binomes: binomes);
}

class DiscoverBinomesLoadFailureState extends DiscoverBinomesState {}
