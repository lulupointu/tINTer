import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';
import 'package:tinterapp/Logic/models/scolaire/relation_status_scolaire.dart';
import 'package:tinterapp/Logic/models/scolaire/searched_user_scolaire.dart';
import 'package:tinterapp/Logic/repository/scolaire/matched_binomes_repository.dart';
import 'package:tinterapp/Logic/repository/shared/user_repository.dart';

part 'user_scolaire_search_event.dart';

part 'user_scolaire_search_state.dart';

class UserScolaireSearchBloc extends Bloc<UserScolaireSearchEvent, UserScolaireSearchState> {
  final UserRepository userRepository;
  final MatchedBinomesRepository matchedBinomesRepository;
  final AuthenticationBloc authenticationBloc;

  UserScolaireSearchBloc(
      {@required this.userRepository,
      @required this.authenticationBloc,
      @required this.matchedBinomesRepository})
      : super(UserScolaireSearchInitialState());

  @override
  Stream<UserScolaireSearchState> mapEventToState(UserScolaireSearchEvent event) async* {
    switch (event.runtimeType) {
      case UserScolaireSearchLoadEvent:
        yield* _mapUserScolaireSearchLoadEventToState();
        return;
      case UserScolaireSearchRefreshEvent:
        yield* _mapUserScolaireRefreshEventToState();
        return;
      case UserScolaireSearchChangeStatusEvent:
        if (state is UserScolaireSearchLoadSuccessfulState) {
          yield* _mapUserScolaireSearchChangeStatusEventEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverBinomesLoadSuccessState');
        }
        return;
      case UserScolaireSearchLikeEvent:
        if (state is UserScolaireSearchLoadSuccessfulState) {
          _mapUserScolaireSearchLikeEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverBinomesLoadSuccessState');
        }
        return;
      case UserScolaireSearchIgnoreEvent:
        if (state is UserScolaireSearchLoadSuccessfulState) {
          _mapDiscoverMatchIgnoreEventToState(event);
        } else {
          _addError(
              'DiscoverMatchLikeEvent was called while state is not DiscoverBinomesLoadSuccessState');
        }
        return;
      default:
        print('event: ' + event.toString() + ' no treated');
    }
  }

  Stream<UserScolaireSearchState> _mapUserScolaireSearchLoadEventToState() async* {
    yield UserScolaireSearchLoadingState();

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserScolaireSearchInitialState();
      return;
    }

    List<SearchedUserScolaire> searchedUsers;
    print('LOADING SEARCH USERS SCOLAIRE');
    try {
      searchedUsers = await userRepository.getAllSearchedUsersScolaire();
    } catch (error) {
      print(error);
      yield UserScolaireSearchLoadFailedState();
      return;
    }
    yield UserScolaireSearchLoadSuccessfulState(searchedUsers: searchedUsers);

    searchedUsers
        .sort((SearchedUserScolaire searchedUserA, SearchedUserScolaire searchedUserB) {
      final compareNames =
      searchedUserA.name.toLowerCase().compareTo(searchedUserB.name.toLowerCase());
      return (compareNames == 0)
          ? searchedUserA.surname.toLowerCase().compareTo(searchedUserB.surname.toLowerCase())
          : compareNames;
    });
  }

  Stream<UserScolaireSearchState> _mapUserScolaireRefreshEventToState() async* {
    yield UserScolaireSearchRefreshingState(
        searchedUsers: (state as UserScolaireSearchLoadSuccessfulState).searchedUsers);

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserScolaireSearchInitialState();
      return;
    }

    List<SearchedUserScolaire> searchedUsers;
    try {
      searchedUsers = await userRepository.getAllSearchedUsersScolaire();
    } catch (error) {
      print(error);
      yield UserScolaireSearchRefreshingFailedState(
          searchedUsers: (state as UserScolaireSearchLoadSuccessfulState).searchedUsers);
    }

    searchedUsers
        .sort((SearchedUserScolaire searchedUserA, SearchedUserScolaire searchedUserB) {
      final compareNames =
      searchedUserA.name.toLowerCase().compareTo(searchedUserB.name.toLowerCase());
      return (compareNames == 0)
          ? searchedUserA.surname.toLowerCase().compareTo(searchedUserB.surname.toLowerCase())
          : compareNames;
    });

    yield UserScolaireSearchLoadSuccessfulState(searchedUsers: searchedUsers);
  }

  void _mapUserScolaireSearchLikeEventToState(
      UserScolaireSearchLikeEvent userSearchLikeEvent) {
    add(UserScolaireSearchChangeStatusEvent(
        searchedUser: userSearchLikeEvent.likedSearchedUserScolaire,
        newStatus: MatchStatus.liked,
        enumRelationStatusScolaire: EnumRelationStatusScolaire.liked));
  }

  void _mapDiscoverMatchIgnoreEventToState(
      UserScolaireSearchIgnoreEvent userSearchIgnoreEvent) {
    add(UserScolaireSearchChangeStatusEvent(
        searchedUser: userSearchIgnoreEvent.ignoredSearchedUserScolaire,
        newStatus: MatchStatus.ignored,
        enumRelationStatusScolaire: EnumRelationStatusScolaire.ignored));
  }

  Stream<UserScolaireSearchState> _mapUserScolaireSearchChangeStatusEventEventToState(
      UserScolaireSearchChangeStatusEvent event) async* {
    List<SearchedUserScolaire> oldSearchedUsersScolaires =
        (state as UserScolaireSearchLoadSuccessfulState).searchedUsers;

    if (!(authenticationBloc.state is AuthenticationSuccessfulState)) {
      authenticationBloc.add(AuthenticationLogWithTokenRequestSentEvent());
      yield UserScolaireSearchInitialState();
      return;
    }

    print('Getting the new match status');

    SearchedUserScolaire newSearchedUserScolaire = SearchedUserScolaire(
          (s) => s
        ..login = event.searchedUser.login
        ..name = event.searchedUser.name
        ..surname = event.searchedUser.surname
        ..score = event.searchedUser.score
        ..liked = event.newStatus == MatchStatus.ignored ? false : true,
    );

    print('GotIT');

    List<SearchedUserScolaire> newSearchedUsersScolaires =
        List<SearchedUserScolaire>.from(oldSearchedUsersScolaires);
    var index = newSearchedUsersScolaires.indexOf(event.searchedUser);
    newSearchedUsersScolaires.remove(event.searchedUser);
    newSearchedUsersScolaires.insert(index, newSearchedUserScolaire);

    print('Replacing the liked or ignored user');

    yield UserScolaireSearchSavingNewStatusState(searchedUsers: newSearchedUsersScolaires);

    print('Changing state to saving');

    try {
      matchedBinomesRepository.updateBinomeStatus(
        relationStatus: RelationStatusScolaire((r) => r
          ..otherLogin = event.searchedUser.login
          ..statusScolaire = event.enumRelationStatusScolaire,
        ),
      );
      print('UPDATING');
    } catch (error) {
      print(error);
      yield UserScolaireSearchSavingNewStatusFailedState(
          searchedUsers: oldSearchedUsersScolaires);
    }

    print('YAHE');
    yield UserScolaireSearchLoadSuccessfulState(searchedUsers: newSearchedUsersScolaires);
  }

  void _addError(String error) {
    addError(Exception(error), StackTrace.current);
  }
}
