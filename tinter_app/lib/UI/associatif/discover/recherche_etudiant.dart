import 'package:async/async.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/associatif/user_associatif_search/user_associatif_search_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/searched_user_associatif.dart';
import 'package:tinterapp/Logic/models/shared/user_profile_picture.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';


main() => runApp(MaterialApp(
      home: SearchStudentAssociatifTab(),
    ));

class SearchStudentAssociatifTab extends StatefulWidget {
  @override
  _SearchStudentAssociatifTabState createState() => _SearchStudentAssociatifTabState();
}

class _SearchStudentAssociatifTabState extends State<SearchStudentAssociatifTab> {
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
    if (BlocProvider.of<UserAssociatifSearchBloc>(context).state
        is UserAssociatifSearchLoadSuccessfulState) {
      BlocProvider.of<UserAssociatifSearchBloc>(context)
          .add(UserAssociatifSearchRefreshEvent());
    } else {
      BlocProvider.of<UserAssociatifSearchBloc>(context).add(UserAssociatifSearchLoadEvent());
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
    return Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: tinterTheme.colors.background,
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
                              color: tinterTheme.colors.primary,
                              fit: BoxFit.fill,
                            ),
                          ),
                          Positioned.fill(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: AutoSizeText(
                                  'Rechercher \n un.e étudiant.e',
                                  style: tinterTheme.textStyle.headline1,
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
                                color: tinterTheme.colors.primaryAccent,
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
                            color: tinterTheme.colors.primaryAccent,
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
                                    color: Colors.black,
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
                                              color: Colors.black,
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
                        child: BlocBuilder<UserAssociatifSearchBloc, UserAssociatifSearchState>(
                            builder:
                                (BuildContext context, UserAssociatifSearchState userSearchState) {
                          if (!(userSearchState is UserAssociatifSearchLoadSuccessfulState))
                            return Center(
                              child: Center(child: CircularProgressIndicator(),),
                            );
                          List<SearchedUserAssociatif> _allSearchedUsersAssociatifs =
                              (userSearchState as UserAssociatifSearchLoadSuccessfulState)
                                  .searchedUsers;
                          _allSearchedUsersAssociatifs.sort((SearchedUserAssociatif searchedUserA,
                                  SearchedUserAssociatif searchedUserB) =>
                              searchedUserA.name
                                  .toLowerCase()
                                  .compareTo(searchedUserB.name.toLowerCase()));
                          RegExp searchedStringRegex = RegExp(searchString, caseSensitive: false);
                          List<SearchedUserAssociatif> _searchedUsers = (searchString == '')
                              ? []
                              : _allSearchedUsersAssociatifs
                                  .where((SearchedUserAssociatif searchedUser) =>
                                      searchedStringRegex.hasMatch(
                                          '${searchedUser.name} ${searchedUser.surname} ${searchedUser.name}'))
                                  .toList();
                          return Column(
                            children: [
                              for (SearchedUserAssociatif searchedUser in _searchedUsers)
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
    );
  }

  Widget userResume(SearchedUserAssociatif searchedUser) {
    return Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: tinterTheme.colors.primary,
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
              child: getProfilePictureFromLogin(
                  login: searchedUser.login,
                  height: 45, width: 45),
            ),
            trailing: IconButton(
              onPressed: () => BlocProvider.of<UserAssociatifSearchBloc>(context).add(searchedUser
                      .liked
                  ? UserAssociatifSearchIgnoreEvent(ignoredSearchedUserAssociatif: searchedUser)
                  : UserAssociatifSearchLikeEvent(likedSearchedUserAssociatif: searchedUser)),
              icon: Icon(
                searchedUser.liked ? Icons.favorite : Icons.favorite_border,
                color: tinterTheme.colors.secondary,
              ),
            ),
            title: Text(
              searchedUser.name + ' ' + searchedUser.surname,
              style: tinterTheme.textStyle.headline2,
            ),
          ),
        );
      }
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
    return Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return Container(
          padding: padding,
          margin: margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: color ?? tinterTheme.colors.primaryAccent,
          ),
          width: width,
          height: height,
          child: child,
        );
      }
    );
  }
}
