import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:tinterapp/Logic/blocs/scolaire/binome_pair_search/binome_pair_search_bloc.dart';
import 'package:tinterapp/Logic/models/scolaire/binome_pair.dart';
import 'package:tinterapp/Logic/models/scolaire/searched_binome_pair.dart';
import 'package:tinterapp/UI2/shared2/random_gender.dart';

main() => runApp(MaterialApp(
      home: SearchStudentBinomePairTab2(),
    ));

class SearchStudentBinomePairTab2 extends StatefulWidget {
  @override
  _SearchStudentBinomePairTab2State createState() =>
      _SearchStudentBinomePairTab2State();
}

class _SearchStudentBinomePairTab2State
    extends State<SearchStudentBinomePairTab2> {
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
    if (BlocProvider.of<BinomePairSearchBloc>(context).state
        is BinomePairSearchLoadSuccessfulState) {
      BlocProvider.of<BinomePairSearchBloc>(context)
          .add(BinomePairSearchRefreshEvent());
    } else {
      BlocProvider.of<BinomePairSearchBloc>(context)
          .add(BinomePairSearchLoadEvent());
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
          'Recherche',
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
                              labelText: randomGender == Gender.M
                                  ? "Nom ou prénom d'un étudiant"
                                  : "Nom ou prénom d'une étudiante",
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
                          child: Text('Aucune recherche effectuée.',
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
                          child: BlocBuilder<BinomePairSearchBloc,
                                  BinomePairSearchState>(
                              builder: (BuildContext context,
                                  BinomePairSearchState userSearchState) {
                            if (!(userSearchState
                                is BinomePairSearchLoadSuccessfulState))
                              return Center(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            List<SearchedBinomePair>
                                _allSearchedBinomePairsBinomePairs =
                                (userSearchState
                                        as BinomePairSearchLoadSuccessfulState)
                                    .searchedBinomePairs;
                            RegExp searchedStringRegex =
                                RegExp(searchString, caseSensitive: false);
                            List<SearchedBinomePair> _searchedBinomePairs =
                                (searchString == '')
                                    ? []
                                    : _allSearchedBinomePairsBinomePairs
                                        .where((SearchedBinomePair
                                                searchedBinomePair) =>
                                            searchedStringRegex.hasMatch(
                                                '${searchedBinomePair.name} ${searchedBinomePair.surname} ${searchedBinomePair.name} & ${searchedBinomePair.otherName} ${searchedBinomePair.otherSurname} ${searchedBinomePair.otherName}'))
                                        .toList();
                            return Column(
                              children: [
                                for (SearchedBinomePair searchedBinomePair
                                    in _searchedBinomePairs)
                                  new UserResume(searchedBinomePair),
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
  final SearchedBinomePair searchedBinomePair;

  UserResume(this.searchedBinomePair);

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
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 7.0,
            ),
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
                          height: 60,
                          width: 80,
                          child:
                              BinomePair.getProfilePictureFromBinomePairLogins(
                            loginA: searchedBinomePair.login,
                            loginB: searchedBinomePair.otherLogin,
                            width: 80,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Container(
                            height: 65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      '${searchedBinomePair.name} ${searchedBinomePair.surname}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            fontSize: 14.0,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      '${searchedBinomePair.otherName} ${searchedBinomePair.otherSurname}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            height: 1.1,
                                            fontSize: 14.0,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      BlocProvider.of<BinomePairSearchBloc>(
                                              context)
                                          .add(searchedBinomePair.liked
                                              ? BinomePairSearchIgnoreEvent(
                                                  ignoredSearchedBinomePair:
                                                      searchedBinomePair)
                                              : BinomePairSearchLikeEvent(
                                                  likedSearchedBinomePair:
                                                      searchedBinomePair)),
                                  child: Container(
                                    width: searchedBinomePair.liked ? 115 : 90,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: searchedBinomePair.liked
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
                                            searchedBinomePair.liked
                                                ? "Déjà matché"
                                                : "Matcher",
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6
                                                .copyWith(
                                                    color:
                                                        searchedBinomePair.liked
                                                            ? Colors.black87
                                                            : Colors.white),
                                          ),
                                          Icon(
                                            Icons.favorite,
                                            color: searchedBinomePair.liked
                                                ? Theme.of(context)
                                                    .indicatorColor
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
                            '44',
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
