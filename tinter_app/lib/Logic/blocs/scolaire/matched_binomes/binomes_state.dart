part of 'binomes_bloc.dart';

@immutable
abstract class MatchedBinomesState extends Equatable {
  const MatchedBinomesState();

  @override
  List<Object> get props => [];
}

class MatchedBinomesInitialState extends MatchedBinomesState {}

class MatchedBinomesInitializingState extends MatchedBinomesState {}

class MatchedBinomesInitializingFailedState extends MatchedBinomesState {}

class MatchedBinomesLoadSuccessState extends MatchedBinomesState {
  final List<BuildBinome> binomes;

  const MatchedBinomesLoadSuccessState({@required this.binomes}):assert(binomes != null);

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

  MatchedBinomesSavingNewStatusState({@required List<BuildBinome> binomes}) : super(binomes: binomes);

  List<BuildBinome> withUpdatedBinome(BuildBinome oldBinome, BuildBinome updatedBinome) {
    throw UnimplementedError();
  }
}

class MatchedBinomesLoadFailureState extends MatchedBinomesLoadSuccessState {

  MatchedBinomesLoadFailureState({@required List<BuildBinome> binomes}) : super(binomes: binomes);
}