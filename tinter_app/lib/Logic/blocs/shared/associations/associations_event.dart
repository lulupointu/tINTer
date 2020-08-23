part of 'associations_bloc.dart';

@immutable
abstract class AssociationsEvent {}

class AssociationsLoadEvent extends AssociationsEvent {}

class AssociationsRefreshEvent extends AssociationsEvent {}
