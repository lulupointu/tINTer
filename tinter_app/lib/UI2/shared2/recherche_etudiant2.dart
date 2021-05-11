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

  int _keyboardVisibilitySubscriberId;
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
                      child: TextField(
                        obscureText: false,
                        focusNode: searchBarFocusNode,
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        style: TextStyle(textBaseline: TextBaseline.alphabetic),
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            labelText: "Nom ou prénom d'un.e étudiant.e",
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            floatingLabelBehavior: FloatingLabelBehavior.never,
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
                                          color: Theme.of(context).primaryColor,
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
              Flexible(
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
                    List<SearchedUserAssociatif> _allSearchedUsersAssociatifs =
                        (userSearchState
                                as UserAssociatifSearchLoadSuccessfulState)
                            .searchedUsers;
                    _allSearchedUsersAssociatifs.sort(
                        (SearchedUserAssociatif searchedUserA,
                                SearchedUserAssociatif searchedUserB) =>
                            searchedUserA.name
                                .toLowerCase()
                                .compareTo(searchedUserB.name.toLowerCase()));
                    RegExp searchedStringRegex =
                        RegExp(searchString, caseSensitive: false);
                    List<
                        SearchedUserAssociatif> _searchedUsers = (searchString ==
                            '')
                        ? []
                        : _allSearchedUsersAssociatifs
                            .where((SearchedUserAssociatif searchedUser) =>
                                searchedStringRegex.hasMatch(
                                    '${searchedUser.name} ${searchedUser.surname} ${searchedUser.name}'))
                            .toList();
                    return Column(
                      children: [
                        for (SearchedUserAssociatif searchedUser
                            in _searchedUsers)
                          userResume(searchedUser, context)
                      ],
                    );
                  }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget userResume(SearchedUserAssociatif searchedUser, BuildContext context) {
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
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, top: 5.0, bottom: 5.0),
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
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Container(
                  height: 55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        searchedUser.surname + ' ' + searchedUser.name,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      // Text(
                      //   "Année : 1A",
                      //   style: Theme.of(context).textTheme.headline6,
                      // ),
                      Container(
                        width: searchedUser.liked ? 115 : 90,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: searchedUser.liked
                              ? Colors.white
                              : Theme.of(context).accentColor,
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 1,
                              blurRadius: 2,
                              offset: Offset(3, 3),
                            ),
                          ],
                        ),
                        child: searchedUser.liked
                            ? Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Déjà matché",
                                      style:
                                          Theme.of(context).textTheme.headline6,
                                    ),
                                    Icon(
                                      Icons.favorite,
                                      color: Theme.of(context).accentColor,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Matcher",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          .copyWith(color: Colors.white),
                                    ),
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.white,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
