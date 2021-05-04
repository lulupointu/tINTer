import 'package:async/async.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/scolaire/binome_pair_search/binome_pair_search_bloc.dart';
import 'package:tinterapp/Logic/models/scolaire/binome_pair.dart';
import 'package:tinterapp/Logic/models/scolaire/searched_binome_pair.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';


main() => runApp(MaterialApp(
      home: SearchStudentBinomePairTab(),
    ));


// TODO: implement binome pair
class SearchStudentBinomePairTab extends StatefulWidget {
  @override
  _SearchStudentBinomePairTabState createState() => _SearchStudentBinomePairTabState();
}

class _SearchStudentBinomePairTabState extends State<SearchStudentBinomePairTab> {
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
    if (BlocProvider.of<BinomePairSearchBloc>(context).state
        is BinomePairSearchLoadSuccessfulState) {
      BlocProvider.of<BinomePairSearchBloc>(context)
          .add(BinomePairSearchRefreshEvent());
    } else {
      BlocProvider.of<BinomePairSearchBloc>(context).add(BinomePairSearchLoadEvent());
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
                                  'Rechercher une \n paire de binome',
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
                    child: BlocBuilder<BinomePairSearchBloc, BinomePairSearchState>(
                        builder:
                            (BuildContext context, BinomePairSearchState userSearchState) {
                          if (!(userSearchState is BinomePairSearchLoadSuccessfulState))
                            return Center(
                              child: Center(child: CircularProgressIndicator(),),
                            );
                          List<SearchedBinomePair> _allSearchedBinomePairsBinomePairs =
                              (userSearchState as BinomePairSearchLoadSuccessfulState)
                                  .searchedBinomePairs;
                          _allSearchedBinomePairsBinomePairs.sort((SearchedBinomePair searchedBinomePairA,
                              SearchedBinomePair searchedBinomePairB) =>
                              searchedBinomePairA.name
                                  .toLowerCase()
                                  .compareTo(searchedBinomePairB.name.toLowerCase()));
                          RegExp searchedStringRegex = RegExp(searchString, caseSensitive: false);
                          List<SearchedBinomePair> _searchedBinomePairs = (searchString == '')
                              ? []
                              : _allSearchedBinomePairsBinomePairs
                              .where((SearchedBinomePair searchedBinomePair) =>
                              searchedStringRegex.hasMatch(
                                  '${searchedBinomePair.name} ${searchedBinomePair.surname} ${searchedBinomePair.name} & ${searchedBinomePair.otherName} ${searchedBinomePair.otherSurname} ${searchedBinomePair.otherName}'))
                              .toList();
                          return Column(
                            children: [
                              for (SearchedBinomePair searchedBinomePair in _searchedBinomePairs)
                                userResume(searchedBinomePair)
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

  Widget userResume(SearchedBinomePair searchedBinomePair) {
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
            color: Colors.transparent,
          ),
          height: 45,
          width: 60,
          child: BinomePair.getProfilePictureFromBinomePairLogins(loginA: searchedBinomePair.login, loginB: searchedBinomePair.otherLogin, width: 45),
        ),
        trailing: IconButton(
          onPressed: () => BlocProvider.of<BinomePairSearchBloc>(context).add(searchedBinomePair
              .liked
              ? BinomePairSearchIgnoreEvent(ignoredSearchedBinomePair: searchedBinomePair)
              : BinomePairSearchLikeEvent(likedSearchedBinomePair: searchedBinomePair)),
          icon: Consumer<TinterTheme>(
              builder: (context, tinterTheme, child) {
                return Icon(
                searchedBinomePair.liked ? Icons.favorite : Icons.favorite_border,
                color: tinterTheme.colors.secondary,
              );
            }
          ),
        ),
        title: Consumer<TinterTheme>(
            builder: (context, tinterTheme, child) {
              return AutoSizeText(
              '${searchedBinomePair.name} ${searchedBinomePair.surname} \n${searchedBinomePair.otherName} ${searchedBinomePair.otherSurname}',
              style: tinterTheme.textStyle.headline2,
                maxLines: 2,
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
