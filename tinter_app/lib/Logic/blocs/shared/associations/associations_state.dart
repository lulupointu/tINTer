part of 'associations_bloc.dart';

@immutable
abstract class AssociationsState {}

class AssociationsInitialState extends AssociationsState {}

class AssociationsLoadingState extends AssociationsState {}

class AssociationsLoadFailedState extends AssociationsState {}

class AssociationsLoadSuccessfulState extends AssociationsState {
  final List<Association> associations;

  AssociationsLoadSuccessfulState({@required this.associations});
}

class AssociationsRefreshingState extends AssociationsLoadSuccessfulState {

  AssociationsRefreshingState(List<Association> associations) : super(associations: associations);
}

class AssociationsRefreshingFailedState extends AssociationsLoadSuccessfulState {

  AssociationsRefreshingFailedState(List<Association> associations) : super(associations: associations);
}