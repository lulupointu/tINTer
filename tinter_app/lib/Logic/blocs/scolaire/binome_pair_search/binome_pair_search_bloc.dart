import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';
import 'package:tinterapp/Logic/models/scolaire/relation_status_binome_pair.dart';
import 'package:tinterapp/Logic/models/scolaire/searched_binome_pair.dart';
import 'package:tinterapp/Logic/repository/scolaire/binome_pair_repository.dart';
import 'package:tinterapp/Logic/repository/scolaire/matched_binome_pair_matches_repository.dart';

part 'binome_pair_search_event.dart';

part 'binome_pair_search_state.dart';

class BinomePairSearchBloc extends Bloc<BinomePairSearchEvent, BinomePairSearchState> {
  final BinomePairRepository binomePairRepository;
  final MatchedBinomePairMatchesRepository matchedBinomePairMatchesRepository;
  final AuthenticationBloc authenticationBloc;

  BinomePairSearchBloc(
      {@required this.binomePairRepository,
      @required this.authenticationBloc,
      @required this.matchedBinomePairMatchesRepository})
      : super(BinomePairSearchInitialState());

  @override
  Stream<BinomePairSearchState> mapEventToState(BinomePairSearchEvent event) async* {
    switch (event.runtimeType) {
      case BinomePairSearchLoadEvent:
        yield* _mapAssociationLoadEventToState();
        return;
      case BinomePairSearchRefreshEvent:
        yield* _mapAssociationRefreshEventToState();
        return;
      case BinomePairSearchChangeStatusEvent:
        if (state is BinomePairSearchLoadSuccessfulState) {
          yield* _mapBinomePairSearchChangeStatusEventEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverBinomePairsLoadSuccessState');
        }
        return;
      case BinomePairSearchLikeEvent:
        if (state is BinomePairSearchLoadSuccessfulState) {
          _mapBinomePairSearchLikeEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverBinomePairsLoadSuccessState');
        }
        return;
      case BinomePairSearchIgnoreEvent:
        if (state is BinomePairSearchLoadSuccessfulState) {
          _mapDiscoverMatchIgnoreEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverBinomePairsLoadSuccessState');
        }
        return;
      default:
        print('event: ' + event.toString() + ' no treated');
    }
  }

  Stream<BinomePairSearchState> _mapAssociationLoadEventToState() async* {
    yield BinomePairSearchLoadingState();

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield BinomePairSearchInitialState();
      return;
    }

    List<SearchedBinomePair> searchedBinomePairss;
    try {
      searchedBinomePairss = await binomePairRepository.getAllSearchedBinomePairsScolaire();
    } catch (error) {
      print(error);
      yield BinomePairSearchLoadFailedState();
      return;
    }
    yield BinomePairSearchLoadSuccessfulState(searchedBinomePairs: searchedBinomePairss);
  }

  Stream<BinomePairSearchState> _mapAssociationRefreshEventToState() async* {
    yield BinomePairSearchRefreshingState(
        searchedBinomePairs:
            (state as BinomePairSearchLoadSuccessfulState).searchedBinomePairs);

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield BinomePairSearchInitialState();
      return;
    }

    List<SearchedBinomePair> searchedBinomePairss;
    try {
      searchedBinomePairss = await binomePairRepository.getAllSearchedBinomePairsScolaire();
    } catch (error) {
      print(error);
      yield BinomePairSearchRefreshingFailedState(
          searchedBinomePairs:
              (state as BinomePairSearchLoadSuccessfulState).searchedBinomePairs);
    }
    yield BinomePairSearchLoadSuccessfulState(searchedBinomePairs: searchedBinomePairss);
  }

  void _mapBinomePairSearchLikeEventToState(BinomePairSearchLikeEvent userSearchLikeEvent) {
    add(BinomePairSearchChangeStatusEvent(
        searchedBinomePairs: userSearchLikeEvent.likedSearchedBinomePair,
        newStatus: MatchStatus.liked,
        enumRelationStatusBinomePair: EnumRelationStatusBinomePair.liked));
  }

  void _mapDiscoverMatchIgnoreEventToState(BinomePairSearchIgnoreEvent userSearchIgnoreEvent) {
    add(BinomePairSearchChangeStatusEvent(
        searchedBinomePairs: userSearchIgnoreEvent.ignoredSearchedBinomePair,
        newStatus: MatchStatus.ignored,
        enumRelationStatusBinomePair: EnumRelationStatusBinomePair.ignored));
  }

  Stream<BinomePairSearchState> _mapBinomePairSearchChangeStatusEventEventToState(
      BinomePairSearchChangeStatusEvent event) async* {
    List<SearchedBinomePair> oldSearchedBinomePairsScolaire =
        (state as BinomePairSearchLoadSuccessfulState).searchedBinomePairs;

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield BinomePairSearchInitialState();
      return;
    }

    print('Getting the new match status');

    SearchedBinomePair newSearchedBinomePair = event.searchedBinomePairs.rebuild(
      (s) => s..liked = event.newStatus == MatchStatus.ignored ? false : true,
    );

    print('GotIT');

    List<SearchedBinomePair> newSearchedBinomePairsScolaire =
        List<SearchedBinomePair>.from(oldSearchedBinomePairsScolaire);
    var index = newSearchedBinomePairsScolaire.indexOf(event.searchedBinomePairs);
    newSearchedBinomePairsScolaire.remove(event.searchedBinomePairs);
    newSearchedBinomePairsScolaire.insert(index, newSearchedBinomePair);

    print('Replacing the liked or ignored user');

    yield BinomePairSearchSavingNewStatusState(
        searchedBinomePairs: newSearchedBinomePairsScolaire);

    print('Changing state to saving');

    try {
      matchedBinomePairMatchesRepository.updateBinomePairMatchStatus(
        relationStatus: RelationStatusBinomePair(
          (r) => r
            ..otherBinomePairId = event.searchedBinomePairs.binomePairId
            ..status = event.enumRelationStatusBinomePair,
        ),
      );
      print('UPDATING');
    } catch (error) {
      print(error);
      yield BinomePairSearchSavingNewStatusFailedState(
          searchedBinomePairs: oldSearchedBinomePairsScolaire);
    }

    print('YAHE');
    yield BinomePairSearchLoadSuccessfulState(
        searchedBinomePairs: newSearchedBinomePairsScolaire);
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
