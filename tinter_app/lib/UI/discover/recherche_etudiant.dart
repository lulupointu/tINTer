import 'package:async/async.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:tinterapp/Logic/blocs/discover_matches/discover_matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/user_search/user_search_bloc.dart';
import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/models/searched_user.dart';
import 'package:tinterapp/Logic/models/user.dart';
import 'package:tinterapp/Logic/models/match.dart';

import '../shared_element/const.dart';

main() => runApp(MaterialApp(
      home: RechercheEtudiantTab(),
    ));

class RechercheEtudiantTab extends StatefulWidget {
  @override
  _RechercheEtudiantTabState createState() => _RechercheEtudiantTabState();
}

class _RechercheEtudiantTabState extends State<RechercheEtudiantTab> {
  final Map<String, double> fractions = {
    'top': 0.2,
    'separator': 0.05,
  };

  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  FocusNode searchBarFocusNode = FocusNode();
  String searchString = '';
  CancelableOperation changedSearchString;
  TextEditingController searchController = TextEditingController();

  @protected
  void initState() {
    if (BlocProvider.of<UserSearchBloc>(context).state is UserSearchLoadSuccessfulState) {
      BlocProvider.of<UserSearchBloc>(context).add(UserSearchRefreshEvent());
    } else {
      BlocProvider.of<UserSearchBloc>(context).add(UserSearchLoadEvent());
    }

    super.initState();

    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        if (!visible) {
          searchBarFocusNode.unfocus();
        }
      },
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: TinterColors.background,
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  height: constraints.maxHeight * fractions['top'],
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: <Widget>[
                      Positioned.fill(
                        child: SvgPicture.asset(
                          'assets/profile/topProfile.svg',
                          color: TinterColors.primaryLight,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: AutoSizeText(
                              'Rechercher \n un.e étudiant.e',
                              style: TinterTextStyle.headline1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            size: 24,
                            color: TinterColors.hint,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: fractions['separator'] * constraints.maxHeight,
                ),
                Hero(
                  tag: 'studentSearchBar',
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5.0),
                        ),
                        color: TinterColors.primaryAccent,
                      ),
                      child: TextField(
                        focusNode: searchBarFocusNode,
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 15),
                            focusedBorder: InputBorder.none,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Icon(
                                Icons.search,
                                color: TinterColors.hint,
                              ),
                            ),
                            suffixIcon: (changedSearchString?.isCompleted == false)
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
                                          color: TinterColors.background,
                                        ),
                                      )
                                    : null),
                        autofocus: true,
                        maxLines: 1,
                        onChanged: (String text) {
                          changedSearchString?.cancel();
                          setState(() {});

                          changedSearchString = CancelableOperation.fromFuture(Future.delayed(
                            Duration(milliseconds: 500),
                          )).then((_) => setState(() => searchString = text));
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: fractions['separator'] * constraints.maxHeight,
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: BlocBuilder<UserSearchBloc, UserSearchState>(
                        builder: (BuildContext context, UserSearchState userSearchState) {
                      if (!(userSearchState is UserSearchLoadSuccessfulState))
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      List<SearchedUser> _allSearchedUsers =
                          (userSearchState as UserSearchLoadSuccessfulState).searchedUsers;
                      _allSearchedUsers.sort(
                          (SearchedUser searchedUserA, SearchedUser searchedUserB) =>
                              searchedUserA.name
                                  .toLowerCase()
                                  .compareTo(searchedUserB.name.toLowerCase()));
                      RegExp searchedStringRegex = RegExp(searchString, caseSensitive: false);
                      List<SearchedUser> _searchedUsers = (searchString == '')
                          ? []
                          : _allSearchedUsers
                              .where((SearchedUser searchedUser) => searchedStringRegex.hasMatch(
                                  '${searchedUser.name} ${searchedUser.surname} ${searchedUser.name}'))
                              .toList();
                      return Column(
                        children: [
                          for (SearchedUser searchedUser in _searchedUsers)
                            userResume(searchedUser)
                        ],
                      );
                    }),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget userResume(SearchedUser searchedUser) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5.0)),
        color: TinterColors.primary,
      ),
      margin: EdgeInsets.only(bottom: 30.0, left: 20.0, right: 20.0),
      child: ListTile(
        leading: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.yellow,
          ),
          height: 45,
          width: 45,
          child: searchedUser.getProfilePicture(height: 45, width: 45),
        ),
        trailing: IconButton(
          onPressed: () => BlocProvider.of<UserSearchBloc>(context).add(searchedUser.liked
              ? UserSearchIgnoreEvent(ignoredSearchedUser: searchedUser)
              : UserSearchLikeEvent(likedSearchedUser: searchedUser)),
          icon: Icon(
            searchedUser.liked ? Icons.favorite : Icons.favorite_border,
            color: TinterColors.secondaryAccent,
          ),
        ),
        title: Text(
          searchedUser.name + ' ' + searchedUser.surname,
          style: TinterTextStyle.headline2,
        ),
      ),
    );
  }

  Widget informationRectangle({
    @required Widget child,
    double width,
    double height,
    EdgeInsets padding,
    Color color,
    EdgeInsets margin,
  }) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: color ?? TinterColors.primaryAccent,
      ),
      width: width,
      height: height,
      child: child,
    );
  }
}
