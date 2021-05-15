import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:tinterapp/Logic/blocs/associatif/user_associatif_search/user_associatif_search_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/searched_user_associatif.dart';
import 'package:tinterapp/Logic/models/shared/user_profile_picture.dart';

main() => runApp(MaterialApp(
      home: SearchStudentAssociatifTab2(),
    ));

class SearchStudentAssociatifTab2 extends StatefulWidget {
  @override
  _SearchStudentAssociatifTab2State createState() =>
      _SearchStudentAssociatifTab2State();
}

class _SearchStudentAssociatifTab2State
    extends State<SearchStudentAssociatifTab2> {
  final Map<String, double> fractions = {
    'top': 0.2,
    'separator': 0.05,
  };

  FocusNode searchBarFocusNode = FocusNode();
  String searchString = '';
  CancelableOperation changedSearchString;
  TextEditingController searchController = TextEditingController();

  @protected
  void initState() {
    if (BlocProvider.of<UserAssociatifSearchBloc>(context).state
        is UserAssociatifSearchLoadSuccessfulState) {
      BlocProvider.of<UserAssociatifSearchBloc>(context)
          .add(UserAssociatifSearchRefreshEvent());
    } else {
      BlocProvider.of<UserAssociatifSearchBloc>(context)
          .add(UserAssociatifSearchLoadEvent());
    }

    super.initState();

    KeyboardVisibilityController().onChange.listen(
      (bool visible) {
        if (!visible) {
          searchBarFocusNode.unfocus();
        }
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Rechercher un.e étudiant.e',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Card(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor,
                        width: 2.0,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  ),
                  child: Card(
                    child: Center(
                      child: Container(
                        height: 50,
                        child: TextField(
                          obscureText: false,
                          focusNode: searchBarFocusNode,
                          controller: searchController,
                          textInputAction: TextInputAction.search,
                          style:
                              TextStyle(textBaseline: TextBaseline.alphabetic),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(
                                bottom: 20,
                              ),
                              labelText: "Nom ou prénom d'un.e étudiant.e",
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              labelStyle: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(color: Colors.black38),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Theme.of(context).primaryColor,
                              ),
                              suffixIcon: (changedSearchString?.isCompleted ==
                                      false)
                                  ? Image.asset(
                                      'assets/discover/loading.gif',
                                      scale: 4,
                                    )
                                  : (searchString != '')
                                      ? IconButton(
                                          onPressed: () {
                                            changedSearchString?.cancel();
                                            searchString = '';
                                            searchController.clear();
                                            setState(() {});
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        )
                                      : null),
                          onChanged: (String text) {
                            changedSearchString?.cancel();
                            setState(() {});
                            changedSearchString =
                                CancelableOperation.fromFuture(Future.delayed(
                              Duration(milliseconds: 500),
                            )).then((_) => setState(() => searchString = text));
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              searchString.isEmpty
                  ? Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Center(
                        child: Text(
                            'Aucune recherche effectuée.',
                            style: Theme.of(context).textTheme.headline5),
                          ),
                    ),
                    )
                  : Flexible(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onPanDown: (_) {
                          WidgetsBinding.instance.focusManager.primaryFocus
                              ?.unfocus();
                        },
                        child: SingleChildScrollView(
                          child: BlocBuilder<UserAssociatifSearchBloc,
                                  UserAssociatifSearchState>(
                              builder: (BuildContext context,
                                  UserAssociatifSearchState userSearchState) {
                            if (!(userSearchState
                                is UserAssociatifSearchLoadSuccessfulState))
                              return Center(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            List<SearchedUserAssociatif>
                                _allSearchedUsersAssociatifs = (userSearchState
                                        as UserAssociatifSearchLoadSuccessfulState)
                                    .searchedUsers;
                            RegExp searchedStringRegex =
                                RegExp(searchString, caseSensitive: false);
                            List<SearchedUserAssociatif> _searchedUsers =
                                (searchString == '')
                                    ? []
                                    : _allSearchedUsersAssociatifs
                                        .where((SearchedUserAssociatif
                                                searchedUser) =>
                                            searchedStringRegex.hasMatch(
                                                '${searchedUser.name} ${searchedUser.surname} ${searchedUser.name}'))
                                        .toList();
                            return Column(
                              children: [
                                for (SearchedUserAssociatif searchedUser
                                    in _searchedUsers)
                                  new UserResume(searchedUser),
                              ],
                            );
                          }),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserResume extends StatelessWidget {
  final SearchedUserAssociatif searchedUser;

  UserResume(this.searchedUser);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 20.0, right: 20.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 2.0,
              style: BorderStyle.solid),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 5.0, bottom: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Colors.black.withOpacity(0.6),
                                width: 3.0,
                                style: BorderStyle.solid),
                          ),
                          child: getProfilePictureFromLogin(
                            login: searchedUser.login,
                            height: 60,
                            width: 60,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Container(
                            height: 55,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      searchedUser.name +
                                          ' ' +
                                          searchedUser.surname,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      BlocProvider.of<UserAssociatifSearchBloc>(
                                              context)
                                          .add(searchedUser.liked
                                              ? UserAssociatifSearchIgnoreEvent(
                                                  ignoredSearchedUserAssociatif:
                                                      searchedUser)
                                              : UserAssociatifSearchLikeEvent(
                                                  likedSearchedUserAssociatif:
                                                      searchedUser)),
                                  child: Container(
                                    width: searchedUser.liked ? 115 : 90,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: searchedUser.liked
                                          ? Colors.white
                                          : Theme.of(context).indicatorColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: Offset(3, 3),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 3.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            searchedUser.liked
                                                ? "Déjà matché"
                                                : "Matcher",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    color: searchedUser.liked
                                                        ? Colors.black87
                                                        : Colors.white),
                                          ),
                                          Icon(
                                            Icons.favorite,
                                            color: searchedUser.liked
                                                ? Theme.of(context).indicatorColor
                                                : Colors.white,
                                            size: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0, left: 5.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).indicatorColor,
                          width: 2.0,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    height: 60,
                    width: 60,
                    child: Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Text('Score',
                                style: Theme.of(context).textTheme.headline6),
                          ),
                          Text(
                            '95',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(fontSize: 25.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
