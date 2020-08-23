part of 'discover_binomes_bloc.dart';

@immutable
abstract class DiscoverBinomesEvent extends Equatable {
  const DiscoverBinomesEvent();

  @override
  List<Object> get props => [];
}

class DiscoverBinomesRequestedEvent extends DiscoverBinomesEvent {}

abstract class DiscoverBinomesLoadInSuccessEvent extends DiscoverBinomesEvent {
  final Binome binome;

  const DiscoverBinomesLoadInSuccessEvent({@required this.binome});

  @override
  List<Object> get props => [binome];

}

class ChangeStatusDiscoverBinomesEvent extends DiscoverBinomesLoadInSuccessEvent {
  final BinomeStatus newStatus;
  final EnumRelationStatusAssociatif enumRelationStatusAssociatif;

  const ChangeStatusDiscoverBinomesEvent({@required binome, @required this.newStatus, @required this.enumRelationStatusAssociatif}):super(binome: binome);

  @override
  List<Object> get props => [binome, newStatus];
}

class DiscoverBinomeLikeEvent extends DiscoverBinomesLoadInSuccessEvent {}

class DiscoverBinomeIgnoreEvent extends DiscoverBinomesLoadInSuccessEvent {}