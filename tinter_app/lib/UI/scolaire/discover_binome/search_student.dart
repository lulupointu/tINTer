import 'package:async/async.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/scolaire/user_scolaire_search/user_scolaire_search_bloc.dart';
import 'package:tinterapp/Logic/models/scolaire/searched_user_scolaire.dart';
import 'package:tinterapp/Logic/models/shared/user_profile_picture.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';


main() => runApp(MaterialApp(
      home: SearchStudentScolaireTab(),
    ));

class SearchStudentScolaireTab extends StatefulWidget {
  @override
  _SearchStudentScolaireTabState createState() => _SearchStudentScolaireTabState();
}

class _SearchStudentScolaireTabState extends State<SearchStudentScolaireTab> {
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
    if (BlocProvider.of<UserScolaireSearchBloc>(context).state
        is UserScolaireSearchLoadSuccessfulState) {
      BlocProvider.of<UserScolaireSearchBloc>(context)
          .add(UserScolaireSearchRefreshEvent());
    } else {
      BlocProvider.of<UserScolaireSearchBloc>(context).add(UserScolaireSearchLoadEvent());
    }

    super.initState();

    KeyboardVisibilityController().onChange.listen((bool visible) {
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
    return SafeArea(
      child: Consumer<TinterTheme>(
          builder: (context, tinterTheme, child) {
            return Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: tinterTheme.colors.background,
            body: child,
          );
        },
        child: LayoutBuilder(
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
                        child: Consumer<TinterTheme>(
                            builder: (context, tinterTheme, child) {
                              return SvgPicture.asset(
                              'assets/profile/topProfile.svg',
                              color: tinterTheme.colors.primary,
                              fit: BoxFit.fill,
                            );
                          }
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Consumer<TinterTheme>(
                                builder: (context, tinterTheme, child) {
                                  return AutoSizeText(
                                  'Rechercher \n un.e étudiant.e',
                                  style: tinterTheme.textStyle.headline1,
                                  textAlign: TextAlign.center,
                                );
                              }
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
                          icon: Consumer<TinterTheme>(
                              builder: (context, tinterTheme, child) {
                                return Icon(
                                Icons.arrow_back,
                                size: 24,
                                color: tinterTheme.colors.primaryAccent,
                              );
                            }
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
                    child: Consumer<TinterTheme>(
                        builder: (context, tinterTheme, child) {
                          return Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            color: tinterTheme.colors.primaryAccent,
                          ),
                          child: child,
                        );
                      },
                      child: TextField(
                        focusNode: searchBarFocusNode,
                        controller: searchController,
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(top: 15),
                            focusedBorder: InputBorder.none,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                    return Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  );
                                }
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
                              icon: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                    return Icon(
                                    Icons.close,
                                    color: Colors.black,
                                  );
                                }
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
                    child: BlocBuilder<UserScolaireSearchBloc, UserScolaireSearchState>(
                        builder:
                            (BuildContext context, UserScolaireSearchState userSearchState) {
                          if (!(userSearchState is UserScolaireSearchLoadSuccessfulState))
                            return Center(
                              child: Center(child: CircularProgressIndicator(),),
                            );
                          List<SearchedUserScolaire> _allSearchedUsersScolaires =
                              (userSearchState as UserScolaireSearchLoadSuccessfulState)
                                  .searchedUsers;
                          _allSearchedUsersScolaires.sort((SearchedUserScolaire searchedUserA,
                              SearchedUserScolaire searchedUserB) =>
                              searchedUserA.name
                                  .toLowerCase()
                                  .compareTo(searchedUserB.name.toLowerCase()));
                          RegExp searchedStringRegex = RegExp(searchString, caseSensitive: false);
                          List<SearchedUserScolaire> _searchedUsers = (searchString == '')
                              ? []
                              : _allSearchedUsersScolaires
                              .where((SearchedUserScolaire searchedUser) =>
                              searchedStringRegex.hasMatch(
                                  '${searchedUser.name} ${searchedUser.surname} ${searchedUser.name}'))
                              .toList();
                          return Column(
                            children: [
                              for (SearchedUserScolaire searchedUser in _searchedUsers)
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

  Widget userResume(SearchedUserScolaire searchedUser) {
    return Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            color: tinterTheme.colors.primary,
          ),
          margin: EdgeInsets.only(bottom: 30.0, left: 20.0, right: 20.0),
          child: child,
        );
      },
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
          onPressed: () => BlocProvider.of<UserScolaireSearchBloc>(context).add(searchedUser
              .liked
              ? UserScolaireSearchIgnoreEvent(ignoredSearchedUserScolaire: searchedUser)
              : UserScolaireSearchLikeEvent(likedSearchedUserScolaire: searchedUser)),
          icon: Consumer<TinterTheme>(
              builder: (context, tinterTheme, child) {
                return Icon(
                searchedUser.liked ? Icons.favorite : Icons.favorite_border,
                color: tinterTheme.colors.secondary,
              );
            }
          ),
        ),
        title: Consumer<TinterTheme>(
            builder: (context, tinterTheme, child) {
              return Text(
              searchedUser.name + ' ' + searchedUser.surname,
              style: tinterTheme.textStyle.headline2,
            );
          }
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
      },
      child: child,
    );
  }
}
