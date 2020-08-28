import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/repository/scolaire/matieres_repository.dart';

part 'matieres_event.dart';

part 'matieres_state.dart';

class MatieresBloc extends Bloc<MatieresEvent, MatieresState> {
  final MatieresRepository matieresRepository;
  final AuthenticationBloc authenticationBloc;

  MatieresBloc({@required this.matieresRepository, @required this.authenticationBloc})
      : super(MatieresInitialState());

  @override
  Stream<MatieresState> mapEventToState(MatieresEvent event) async* {
    switch (event.runtimeType) {
      case MatieresLoadEvent:
        yield* _mapMatiereLoadEventToState();
        return;
      case MatieresRefreshEvent:
        yield* _mapMatiereRefreshEventToState();
        return;
    }
  }

  Stream<MatieresState> _mapMatiereLoadEventToState() async* {
    yield MatieresLoadingState();

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield MatieresInitialState();
      return;
    }

    List<String> matieres;
    try {
      matieres = await matieresRepository.getAllMatieres();
    } catch (error) {
      print(error);
      yield MatieresLoadFailedState();
      return;
    }
    yield MatieresLoadSuccessfulState(matieres: matieres);
  }

  Stream<MatieresState> _mapMatiereRefreshEventToState() async* {
    yield MatieresRefreshingState((state as MatieresLoadSuccessfulState).matieres);

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield MatieresInitialState();
      return;
    }

    List<String> matieres;
    try {
      matieres = await matieresRepository.getAllMatieres();
    } catch (error) {
      print(error);
      yield MatieresRefreshingFailedState((state as MatieresLoadSuccessfulState).matieres);
    }
    yield MatieresLoadSuccessfulState(matieres: matieres);
  }
}
