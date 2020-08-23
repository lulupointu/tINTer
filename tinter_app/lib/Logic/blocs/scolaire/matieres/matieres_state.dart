part of 'matieres_bloc.dart';

@immutable
abstract class MatieresState {}

class MatieresInitialState extends MatieresState {}

class MatieresLoadingState extends MatieresState {}

class MatieresLoadFailedState extends MatieresState {}

class MatieresLoadSuccessfulState extends MatieresState {
  final List<String> matieres;

  MatieresLoadSuccessfulState({@required this.matieres});
}

class MatieresRefreshingState extends MatieresLoadSuccessfulState {

  MatieresRefreshingState(List<String> matieres) : super(matieres: matieres);
}

class MatieresRefreshingFailedState extends MatieresLoadSuccessfulState {

  MatieresRefreshingFailedState(List<String> matieres) : super(matieres: matieres);
}