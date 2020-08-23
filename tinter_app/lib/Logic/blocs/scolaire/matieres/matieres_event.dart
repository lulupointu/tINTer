part of 'matieres_bloc.dart';

@immutable
abstract class MatieresEvent {}

class MatieresLoadEvent extends MatieresEvent {}

class MatieresRefreshEvent extends MatieresEvent {}
