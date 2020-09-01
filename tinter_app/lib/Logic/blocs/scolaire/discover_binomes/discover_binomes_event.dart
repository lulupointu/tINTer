part of 'discover_binomes_bloc.dart';

@immutable
abstract class DiscoverBinomesEvent extends Equatable {
  const DiscoverBinomesEvent();

  @override
  List<Object> get props => [];
}

class DiscoverBinomesRequestedEvent extends DiscoverBinomesEvent {}

class DiscoverBinomesRefreshEvent extends DiscoverBinomesEvent {}

abstract class DiscoverBinomesLoadInSuccessEvent extends DiscoverBinomesEvent {
  final BuildBinome binome;

  const DiscoverBinomesLoadInSuccessEvent({@required this.binome});

  @override
  List<Object> get props => [binome];

}

class DiscoverBinomesChangeStatusEvent extends DiscoverBinomesLoadInSuccessEvent {
  final BinomeStatus newStatus;
  final EnumRelationStatusScolaire enumRelationStatusScolaire;

  const DiscoverBinomesChangeStatusEvent({@required binome, @required this.newStatus, @required this.enumRelationStatusScolaire}):super(binome: binome);

  @override
  List<Object> get props => [binome, newStatus];
}

class DiscoverBinomeLikeEvent extends DiscoverBinomesLoadInSuccessEvent {}

class DiscoverBinomeIgnoreEvent extends DiscoverBinomesLoadInSuccessEvent {}