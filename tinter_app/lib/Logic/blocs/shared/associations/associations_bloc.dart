import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/repository/shared/associations_repository.dart';

part 'associations_event.dart';

part 'associations_state.dart';

class AssociationsBloc extends Bloc<AssociationsEvent, AssociationsState> {
  final AssociationsRepository associationsRepository;
  final AuthenticationBloc authenticationBloc;

  AssociationsBloc({@required this.associationsRepository, @required this.authenticationBloc})
      : super(AssociationsInitialState());

  @override
  Stream<AssociationsState> mapEventToState(AssociationsEvent event) async* {
    switch (event.runtimeType) {
      case AssociationsLoadEvent:
        yield* _mapAssociationLoadEventToState();
        return;
      case AssociationsRefreshEvent:
        yield* _mapAssociationRefreshEventToState();
        return;
    }
  }

  Stream<AssociationsState> _mapAssociationLoadEventToState() async* {
    yield AssociationsLoadingState();

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield AssociationsInitialState();
      return;
    }

    List<Association> associations;
    try {
      associations = await associationsRepository.getAllAssociations();
    } catch (error) {
      print(error);
      yield AssociationsLoadFailedState();
    }
    yield AssociationsLoadSuccessfulState(associations: associations);
  }

  Stream<AssociationsState> _mapAssociationRefreshEventToState() async* {
    yield AssociationsRefreshingState((state as AssociationsLoadSuccessfulState).associations);

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield AssociationsInitialState();
      return;
    }

    List<Association> associations;
    try {
      associations = await associationsRepository.getAllAssociations();
    } catch (error) {
      print(error);
      yield AssociationsRefreshingFailedState((state as AssociationsLoadSuccessfulState).associations);
    }
    yield AssociationsLoadSuccessfulState(associations: associations);
  }
}
