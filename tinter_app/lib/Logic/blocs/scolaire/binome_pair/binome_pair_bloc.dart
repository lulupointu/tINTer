import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/scolaire/build_binome_pair.dart';
import 'package:tinterapp/Logic/repository/scolaire/binome_pair_repository.dart';

part 'binome_pair_event.dart';

part 'binome_pair_state.dart';

class BinomePairBloc extends Bloc<BinomePairEvent, BinomePairState> {
  final BinomePairRepository binomePairRepository;
  final AuthenticationBloc authenticationBloc;

  BinomePairBloc({@required this.binomePairRepository, @required this.authenticationBloc})
      : super(BinomePairInitialState());

  @override
  Stream<BinomePairState> mapEventToState(BinomePairEvent event) async* {
    switch (event.runtimeType) {
      case BinomePairLoadEvent:
        yield* _mapMatiereLoadEventToState();
        return;
      case BinomePairRefreshEvent:
        yield* _mapMatiereRefreshEventToState();
        return;
    }
  }

  Stream<BinomePairState> _mapMatiereLoadEventToState() async* {
    yield BinomePairLoadingState();

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield BinomePairInitialState();
      return;
    }

    BuildBinomePair binomePair;
    try {
      binomePair = await binomePairRepository.getBinomePair();
    } catch (error) {
      print(error);
      yield BinomePairLoadFailedState();
      return;
    }
    yield BinomePairLoadSuccessfulState(binomePair: binomePair);
  }

  Stream<BinomePairState> _mapMatiereRefreshEventToState() async* {
    final currentState = state as BinomePairLoadSuccessfulState;
    yield BinomePairRefreshingState(currentState.binomePair);

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield BinomePairInitialState();
      return;
    }

    BuildBinomePair binomePair;
    try {
      binomePair = await binomePairRepository.getBinomePair();
    } catch (error) {
      print(error);
      yield BinomePairRefreshingFailedState(currentState.binomePair);
    }
    yield BinomePairLoadSuccessfulState(binomePair: binomePair);
  }
}
