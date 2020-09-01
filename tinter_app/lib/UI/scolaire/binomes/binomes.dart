import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:separated_column/separated_column.dart';
import 'package:tinterapp/Logic/blocs/scolaire/binome_pair/binome_pair_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/matched_binome_pair_matches/matched_pair_matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/scolaire/matched_binomes/binomes_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/association_logo.dart';
import 'package:tinterapp/Logic/models/scolaire/binome.dart';
import 'package:tinterapp/Logic/models/scolaire/binome_pair.dart';
import 'package:tinterapp/Logic/models/scolaire/binome_pair_match.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/Logic/models/shared/user_profile_picture.dart';
import 'package:tinterapp/UI/shared/score_popup_helper/score_popup_helper.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/shared_element/slider_label.dart';

import '../../shared/snap_scroll_sheet_physics/snap_scroll_sheet_physics.dart';

main() => runApp(MaterialApp(
      home: Material(
        child: BinomesTab(),
      ),
    ));

class BinomesTab extends StatefulWidget {
  final Map<String, double> fractions = {
    'binomeSelectionMenu': null,
  };

  @override
  _BinomesTabState createState() => _BinomesTabState();
}

class _BinomesTabState extends State<BinomesTab> {
  String _selectedBinomeLogin;
  String _selectedBinomePairMatchLogin;
  ScrollController _controller = ScrollController();
  ScrollPhysics _scrollPhysics = NeverScrollableScrollPhysics();
  double topMenuScrolledFraction = 0;

  @override
  void initState() {
    // Update to last information
    if (BlocProvider.of<MatchedBinomesBloc>(context).state is MatchedBinomesLoadSuccessState) {
      BlocProvider.of<MatchedBinomesBloc>(context).add(MatchedBinomesRefreshingEvent());
    } else {
      BlocProvider.of<MatchedBinomesBloc>(context).add(MatchedBinomesRequestedEvent());
    }

    // Update to last information
    if (BlocProvider.of<MatchedBinomePairMatchesBloc>(context).state
        is MatchedBinomePairMatchesLoadSuccessState) {
      BlocProvider.of<MatchedBinomePairMatchesBloc>(context)
          .add(MatchedBinomePairRefreshingEvent());
    } else {
      BlocProvider.of<MatchedBinomePairMatchesBloc>(context)
          .add(MatchedBinomePairMatchesRequestedEvent());
    }

    // Update to last information
    if (BlocProvider.of<BinomePairBloc>(context).state is BinomePairLoadSuccessfulState) {
      BlocProvider.of<BinomePairBloc>(context).add(BinomePairRefreshEvent());
    } else {
      BlocProvider.of<BinomePairBloc>(context).add(BinomePairLoadEvent());
    }

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchedBinomesBloc, MatchedBinomesState>(
        builder: (BuildContext context, MatchedBinomesState matchedBinomesState) {
      if (!(matchedBinomesState is MatchedBinomesLoadSuccessState)) {
        return Center(child: CircularProgressIndicator());
      }

      // Get the 2 list out of all the matched binomes
      final List<BuildBinome> allBinomes =
          (matchedBinomesState as MatchedBinomesLoadSuccessState).binomes;
      final List<BuildBinome> _binomesNotBinomes = allBinomes
          .where((binome) => binome.statusScolaire != BinomeStatus.binomeAccepted)
          .toList();
      final List<BuildBinome> _binomes = allBinomes
          .where((binome) => binome.statusScolaire == BinomeStatus.binomeAccepted)
          .toList();

      // Sort them
      _binomesNotBinomes.sort(
          (BuildBinome binomeA, BuildBinome binomeB) => binomeA.name.compareTo(binomeB.name));
      _binomes.sort(
          (BuildBinome binomeA, BuildBinome binomeB) => binomeA.name.compareTo(binomeB.name));

      return BlocBuilder<MatchedBinomePairMatchesBloc, MatchedBinomePairMatchesState>(builder:
          (BuildContext context, MatchedBinomePairMatchesState matchedBinomePairMatchesState) {
        if (!(matchedBinomePairMatchesState is MatchedBinomePairMatchesLoadSuccessState)) {
          return Center(child: CircularProgressIndicator());
        }

        // Get the 2 list out of all the matched binome pair matches
        final List<BuildBinomePairMatch> allBinomePairMatches =
            (matchedBinomePairMatchesState as MatchedBinomePairMatchesLoadSuccessState)
                .binomePairMatches;
        final List<BuildBinomePairMatch> _binomePairMatchesNotMatched = allBinomePairMatches
            .where((binomePairMatch) =>
                binomePairMatch.status != BinomePairMatchStatus.binomePairMatchAccepted)
            .toList();
        final List<BuildBinomePairMatch> _binomePairMatches = allBinomePairMatches
            .where((binomePairMatch) =>
                binomePairMatch.status == BinomePairMatchStatus.binomePairMatchAccepted)
            .toList();

        // Sort them
        _binomePairMatchesNotMatched.sort(
            (BuildBinomePairMatch binomePairMatchA, BuildBinomePairMatch binomePairMatchB) =>
                binomePairMatchA.name.compareTo(binomePairMatchB.name));
        _binomePairMatches.sort(
            (BuildBinomePairMatch binomePairMatchA, BuildBinomePairMatch binomePairMatchB) =>
                binomePairMatchA.name.compareTo(binomePairMatchB.name));

        // If the user doesn't have a binome
        if (_binomes.length == 0) {
          widget.fractions['binomeSelectionMenu'] = 0.2;
        } else {
          widget.fractions['binomeSelectionMenu'] = 0.2 +
              ((_binomePairMatches.length != 0 || _binomePairMatchesNotMatched.length != 0)
                  ? 0.2
                  : 0);
        }

        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            // ignore: invalid_use_of_protected_member
            if (!_controller.hasListeners) {
              _controller.addListener(() {
                setState(() {
                  topMenuScrolledFraction = min(
                      1,
                      _controller.position.pixels /
                          (widget.fractions['binomeSelectionMenu'] * constraints.maxHeight));
                });
              });
            }

            return NotificationListener<ScrollEndNotification>(
              onNotification: (ScrollEndNotification scrollEndNotification) {
                _scrollPhysics = _controller.offset == 0
                    ? NeverScrollableScrollPhysics()
                    : SnapScrollSheetPhysics(
                        topChildrenHeight: [
                          widget.fractions['binomeSelectionMenu'] * constraints.maxHeight,
                        ],
                      );
                setState(() {});
                return true;
              },
              child: ListView(
                physics: _scrollPhysics,
                controller: _controller,
                children: [
                  BinomeSelectionMenu(
                    onTapBinome: binomeSelected,
                    onTapBinomePair: binomePairSelected,
                    height: constraints.maxHeight * widget.fractions['binomeSelectionMenu'],
                    binomesNotBinomes: _binomesNotBinomes,
                    binomes: _binomes,
                    binomePairMatchesNotMatched: _binomePairMatchesNotMatched,
                    binomePairMatches: _binomePairMatches,
                  ),
                  (_selectedBinomeLogin == null && _selectedBinomePairMatchLogin == null)
                      ? noBinomeSelected(constraints.maxHeight)
                      : (_selectedBinomePairMatchLogin == null)
                          ? CompareViewBinome(
                              binome: allBinomes.firstWhere(
                                (BuildBinome binome) => binome.login == _selectedBinomeLogin,
                              ),
                              appHeight: constraints.maxHeight,
                              topMenuScrolledFraction: topMenuScrolledFraction,
                              onCompareTapped: onCompareTapped,
                            )
                          : CompareViewBinomePairMatch(
                              binomePairMatch: allBinomePairMatches.firstWhere(
                                (BuildBinomePairMatch binomePairMatch) =>
                                    binomePairMatch.login == _selectedBinomePairMatchLogin,
                              ),
                              appHeight: constraints.maxHeight,
                              topMenuScrolledFraction: topMenuScrolledFraction,
                              onCompareTapped: onCompareTapped,
                            ),
                ],
              ),
            );
          },
        );
      });
    });
  }

  void onCompareTapped(appHeight) {
    setState(() {
      _controller.animateTo(
        widget.fractions['binomeSelectionMenu'] * appHeight,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  Widget noBinomeSelected(appHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: appHeight * 0.1,
        ),
        Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
          return Icon(
            Icons.face,
            color: tinterTheme.colors.defaultTextColor,
            size: 70,
          );
        }),
        SizedBox(
          height: 10,
        ),
        BlocBuilder<MatchedBinomesBloc, MatchedBinomesState>(
          buildWhen: (MatchedBinomesState previousState, MatchedBinomesState state) {
            if (previousState.runtimeType != state.runtimeType) {
              return true;
            }
            if (previousState is MatchedBinomesLoadSuccessState &&
                state is MatchedBinomesLoadSuccessState) {
              if (previousState.binomes.length != state.binomes.length) {
                return true;
              }
            }
            return false;
          },
          builder: (BuildContext context, MatchedBinomesState state) {
            if (!(state is MatchedBinomesLoadSuccessState)) {
              return Center(child: CircularProgressIndicator(),);
            }
            return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
              return ((state as MatchedBinomesLoadSuccessState).binomes.length == 0)
                  ? Text(
                      "Aucun binome pour l'instant",
                      style: tinterTheme.textStyle.headline2,
                    )
                  : Text(
                      'Selectionnez un binome.',
                      style: tinterTheme.textStyle.headline2,
                    );
            });
          },
        ),
      ],
    );
  }

  void binomeSelected(BuildBinome binome) {
    setState(() {
      _selectedBinomeLogin = binome.login;
      _selectedBinomePairMatchLogin = null;
    });
  }

  void binomePairSelected(BuildBinomePairMatch binomePairMatch) {
    setState(() {
      _selectedBinomeLogin = null;
      _selectedBinomePairMatchLogin = binomePairMatch.login;
    });
  }
}

class CompareViewBinome extends StatelessWidget {
  final BuildBinome _binome;
  final double appHeight;
  final double topMenuScrolledFraction;
  final onCompareTapped;

  CompareViewBinome({
    BuildBinome binome,
    @required this.appHeight,
    @required this.topMenuScrolledFraction,
    @required this.onCompareTapped,
  }) : _binome = binome;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        facesAroundScore(context),
        SizedBox(height: appHeight*0.05),
        statusRectangle(context),
        SizedBox(height: appHeight*0.05),
        Opacity(
          opacity: topMenuScrolledFraction,
          child: informationComparison(),
        ),
      ],
    );
  }

  Widget facesAroundScore(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      height: appHeight * 0.25,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<UserBloc, UserState>(
                    builder: (BuildContext context, UserState userState) {
                  if (!(userState is UserLoadSuccessState)) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return userPicture(
                      getProfilePicture: ({@required height, @required width}) =>
                          getProfilePictureFromLocalPathOrLogin(
                              login: (userState as UserLoadSuccessState).user.login,
                              localPath: (userState as UserLoadSuccessState)
                                  .user
                                  .profilePictureLocalPath,
                              height: height,
                              width: width));
                }),
                userPictureText(title: 'You'),
              ],
            ),
          ),
          Expanded(
            flex: 20,
            child: score(context),
          ),
          Expanded(
            flex: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                userPicture(
                    getProfilePicture: ({@required height, @required width}) =>
                        getProfilePictureFromLogin(
                            login: _binome.login, height: height, width: width)),
                userPictureText(title: _binome.name + '\n' + _binome.surname),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Displays either your face text or your binome face text
  Widget userPictureText({String title}) {
    return Container(
      height: appHeight * 0.1,
      child: Center(
        child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
          return AutoSizeText(
            title,
            textAlign: TextAlign.center,
            style: tinterTheme.textStyle.headline2,
            maxFontSize: 18,
          );
        }),
      ),
    );
  }

  /// Displays either your face or your binome face
  Widget userPicture(
      {Widget Function({@required double height, @required double width}) getProfilePicture}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      height: appHeight * 0.09,
      width: appHeight * 0.09,
      child: getProfilePicture(
        height: appHeight * 0.09,
        width: appHeight * 0.09,
      ),
    );
  }

  Widget score(BuildContext context) {
    return informationRectangle(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return Text(
                      'Score',
                      style: tinterTheme.textStyle.headline1,
                    );
                  }),
                  Stack(
                    children: <Widget>[
                      Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                        return Text(
                          _binome.score.toString(),
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: tinterTheme.textStyle.headline1.color,
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: InkWell(
                onTap: () => showWhatIsScore(context),
                child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: tinterTheme.colors.defaultTextColor),
                    ),
                    height: 20,
                    width: 20,
                    child: Center(
                      child: Text(
                        '?',
                        style: TextStyle(color: tinterTheme.colors.defaultTextColor),
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget statusRectangle(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.75,
      child: informationRectangle(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        height: appHeight * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1000,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return AutoSizeText(
                      (_binome.statusScolaire == BinomeStatus.liked ||
                              _binome.statusScolaire == BinomeStatus.heIgnoredYou)
                          ? "Cette personne ne t'a pas encore liker"
                          : (_binome.statusScolaire == BinomeStatus.matched)
                              ? "Propose lui d'être son binome"
                              : (_binome.statusScolaire == BinomeStatus.youAskedBinome)
                                  ? "Demande envoyée"
                                  : (_binome.statusScolaire == BinomeStatus.heAskedBinome)
                                      ? "Cette personne veut être ton/ta binome"
                                      : (_binome.statusScolaire == BinomeStatus.binomeAccepted)
                                          ? "Tu es en binome avec cette personne!"
                                          : (_binome.statusScolaire ==
                                                  BinomeStatus.binomeHeRefused)
                                              ? 'Cette personne à refusée ta demande'
                                              : (_binome.statusScolaire ==
                                                      BinomeStatus.binomeYouRefused)
                                                  ? "Tu as refusé d'être le/la binome de cette personne."
                                                  : 'ERROR: the status should not be ${_binome.statusScolaire}',
                      style: tinterTheme.textStyle.headline2,
                      maxLines: 1,
                    );
                  }),
                ),
              ),
            ),
            if ([BinomeStatus.matched, BinomeStatus.heAskedBinome]
                .contains(_binome.statusScolaire)) ...[
              Container(
                constraints: BoxConstraints(
                  minHeight: 10,
                ),
              ),
              Expanded(
                flex: 1000,
                child: (_binome.statusScolaire == BinomeStatus.matched)
                    ? Center(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            BlocProvider.of<MatchedBinomesBloc>(context)
                                .add(AskBinomeEvent(binome: _binome));
                          },
                          child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                            return Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                color: tinterTheme.colors.secondary,
                              ),
                              child: AutoSizeText(
                                "Envoyer une demande",
                                style: tinterTheme.textStyle.headline2,
                              ),
                            );
                          }),
                        ),
                      )
                    : (_binome.statusScolaire == BinomeStatus.heAskedBinome)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  BlocProvider.of<MatchedBinomesBloc>(context)
                                      .add(AcceptBinomeEvent(binome: _binome));
                                },
                                child: Consumer<TinterTheme>(
                                    builder: (context, tinterTheme, child) {
                                  return Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                      color: tinterTheme.colors.secondary,
                                    ),
                                    child: AutoSizeText(
                                      "Accepter",
                                      style: tinterTheme.textStyle.headline2,
                                    ),
                                  );
                                }),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  BlocProvider.of<MatchedBinomesBloc>(context)
                                      .add(RefuseBinomeEvent(binome: _binome));
                                },
                                child: Consumer<TinterTheme>(
                                    builder: (context, tinterTheme, child) {
                                  return Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                      color: tinterTheme.colors.secondary,
                                    ),
                                    child: AutoSizeText(
                                      "Refuser",
                                      style: tinterTheme.textStyle.headline2,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          )
                        : AutoSizeText(
                            'ERROR: the state should not be ' +
                                _binome.statusScolaire.toString(),
                          ),
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: 10,
                ),
              ),
            ],
            if (topMenuScrolledFraction != 1)
              Expanded(
                flex: (1000 * (1 - topMenuScrolledFraction)).floor(),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      onCompareTapped(appHeight);
                    },
                    child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                      return Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          color: tinterTheme.colors.button,
                        ),
                        child: AutoSizeText(
                          'Compare vos profils',
                          style:
                              tinterTheme.textStyle.chipNotLiked.copyWith(color: Colors.black),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          maxFontSize: 15,
                        ),
                      );
                    }),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget informationRectangle(
      {@required Widget child, double width, double height, EdgeInsetsGeometry padding}) {
    return Align(
      alignment: AlignmentDirectional.center,
      child: Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: tinterTheme.colors.primary,
            ),
            width: width != null ? width : Size.infinite.width,
            height: height,
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  Widget verticalSeparator() {
    return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
      return Container(
        width: 1.0,
        color: tinterTheme.colors.primaryAccent,
      );
    });
  }

  Widget informationComparison() {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
                builder: (BuildContext context, UserState state) {
              if (!(state is KnownUserState)) {
                BlocProvider.of<UserBloc>(context).add(UserRequestEvent());
                return Center(child: CircularProgressIndicator(),);
              }
              return ProfileInformation(user: (state as KnownUserState).user);
            }),
          ),
          verticalSeparator(),
          Expanded(
            child: ProfileInformation(user: _binome),
          ),
        ],
      ),
    );
  }
}

class CompareViewBinomePairMatch extends StatelessWidget {
  final BuildBinomePairMatch _binomePairMatch;
  final double appHeight;
  final double topMenuScrolledFraction;
  final onCompareTapped;

  CompareViewBinomePairMatch({
    BuildBinomePairMatch binomePairMatch,
    @required this.appHeight,
    @required this.topMenuScrolledFraction,
    @required this.onCompareTapped,
  }) : _binomePairMatch = binomePairMatch;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        facesAroundScore(context),
        SizedBox(height: appHeight*0.05),
        statusRectangle(context),
        SizedBox(height: appHeight*0.05),
        Opacity(
          opacity: topMenuScrolledFraction,
          child: informationComparison(),
        ),
      ],
    );
  }

  Widget facesAroundScore(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      height: appHeight * 0.25,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<BinomePairBloc, BinomePairState>(
                    builder: (BuildContext context, BinomePairState binomePairState) {
                  if (!(binomePairState is BinomePairLoadSuccessfulState)) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return userPicture(
                      getProfilePicture: ({@required height, @required width}) =>
                          BinomePair.getProfilePictureFromBinomePairLogins(
                            loginA: (binomePairState as BinomePairLoadSuccessfulState)
                                .binomePair
                                .login,
                            loginB: (binomePairState as BinomePairLoadSuccessfulState)
                                .binomePair
                                .otherLogin,
                            height: height,
                            width: width,
                          ));
                }),
                userPictureText(title: 'Ton\nbinome'),
              ],
            ),
          ),
          Expanded(
            flex: 20,
            child: score(context),
          ),
          Expanded(
            flex: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                userPicture(
                  getProfilePicture: ({@required height, @required width}) =>
                      BinomePair.getProfilePictureFromBinomePairLogins(
                    loginA: _binomePairMatch.login,
                    loginB: _binomePairMatch.otherLogin,
                    height: height - 30,
                    width: width,
                  ),
                ),
                userPictureText(
                    title: '${_binomePairMatch.name} ${_binomePairMatch.surname} '
                        '\n & \n'
                        '${_binomePairMatch.otherName} ${_binomePairMatch.otherSurname} '),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Displays either your face text or your binome face text
  Widget userPictureText({String title}) {
    return Container(
      height: appHeight * 0.1,
      child: Center(
        child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
          return AutoSizeText(
            title,
            textAlign: TextAlign.center,
            style: tinterTheme.textStyle.headline2,
            maxFontSize: 18,
          );
        }),
      ),
    );
  }

  /// Displays either your face or your binome face
  Widget userPicture(
      {Widget Function({@required double height, @required double width}) getProfilePicture}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      height: appHeight * 0.09,
      width: appHeight * 0.11,
      child: getProfilePicture(
        height: appHeight * 0.09,
        width: appHeight * 0.11,
      ),
    );
  }

  Widget score(BuildContext context) {
    return informationRectangle(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return Text(
                      'Score',
                      style: tinterTheme.textStyle.headline1,
                    );
                  }),
                  Stack(
                    children: <Widget>[
                      Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                        return Text(
                          _binomePairMatch.score.toString(),
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: tinterTheme.textStyle.headline1.color,
                          ),
                        );
                      }),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: InkWell(
                onTap: () => showWhatIsScore(context),
                child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(width: 2, color: tinterTheme.colors.defaultTextColor),
                    ),
                    height: 20,
                    width: 20,
                    child: Center(
                      child: Text(
                        '?',
                        style: TextStyle(color: tinterTheme.colors.defaultTextColor),
                      ),
                    ),
                  );
                }),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget statusRectangle(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.75,
      child: informationRectangle(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        height: appHeight * 0.2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1000,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return AutoSizeText(
                      (_binomePairMatch.status == BinomePairMatchStatus.liked ||
                              _binomePairMatch.status == BinomePairMatchStatus.heIgnoredYou)
                          ? "Ce binome ne vous a pas encore liker"
                          : (_binomePairMatch.status == BinomePairMatchStatus.matched)
                              ? "Propose lui d'être votre binome de binome"
                              : (_binomePairMatch.status ==
                                      BinomePairMatchStatus.youAskedBinomePairMatch)
                                  ? "Demande envoyée"
                                  : (_binomePairMatch.status ==
                                          BinomePairMatchStatus.heAskedBinomePairMatch)
                                      ? "Cette personne veut être ton binome de binome"
                                      : (_binomePairMatch.status ==
                                              BinomePairMatchStatus.binomePairMatchAccepted)
                                          ? "Tu es en binome de binome avec eux!"
                                          : (_binomePairMatch.status ==
                                                  BinomePairMatchStatus
                                                      .binomePairMatchHeRefused)
                                              ? 'Ce binome à refusé votre demande'
                                              : (_binomePairMatch.status ==
                                                      BinomePairMatchStatus
                                                          .binomePairMatchYouRefused)
                                                  ? "Vous avez refusé d'être leurs binome de binome."
                                                  : 'ERROR: the status should not be ${_binomePairMatch.status}',
                      style: tinterTheme.textStyle.headline2,
                      maxLines: 1,
                    );
                  }),
                ),
              ),
            ),
            if ([BinomePairMatchStatus.matched, BinomePairMatchStatus.heAskedBinomePairMatch]
                .contains(_binomePairMatch.status)) ...[
              Container(
                constraints: BoxConstraints(
                  minHeight: 10,
                ),
              ),
              Expanded(
                flex: 1000,
                child: (_binomePairMatch.status == BinomePairMatchStatus.matched)
                    ? Center(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            BlocProvider.of<MatchedBinomePairMatchesBloc>(context).add(
                                AskBinomePairMatchEvent(binomePairMatch: _binomePairMatch));
                          },
                          child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                            return Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                color: tinterTheme.colors.secondary,
                              ),
                              child: AutoSizeText(
                                "Envoyer une demande",
                                style: tinterTheme.textStyle.headline2,
                              ),
                            );
                          }),
                        ),
                      )
                    : (_binomePairMatch.status == BinomePairMatchStatus.heAskedBinomePairMatch)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  BlocProvider.of<MatchedBinomePairMatchesBloc>(context).add(
                                      AcceptBinomePairMatchEvent(
                                          binomePairMatch: _binomePairMatch));
                                },
                                child: Consumer<TinterTheme>(
                                    builder: (context, tinterTheme, child) {
                                  return Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                      color: tinterTheme.colors.secondary,
                                    ),
                                    child: AutoSizeText(
                                      "Accepter",
                                      style: tinterTheme.textStyle.headline2,
                                    ),
                                  );
                                }),
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  BlocProvider.of<MatchedBinomePairMatchesBloc>(context).add(
                                      RefuseBinomePairMatchEvent(
                                          binomePairMatch: _binomePairMatch));
                                },
                                child: Consumer<TinterTheme>(
                                    builder: (context, tinterTheme, child) {
                                  return Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                      color: tinterTheme.colors.secondary,
                                    ),
                                    child: AutoSizeText(
                                      "Refuser",
                                      style: tinterTheme.textStyle.headline2,
                                    ),
                                  );
                                }),
                              ),
                            ],
                          )
                        : AutoSizeText(
                            'ERROR: the state should not be ' +
                                _binomePairMatch.status.toString(),
                          ),
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: 10,
                ),
              ),
            ],
            if (topMenuScrolledFraction != 1)
              Expanded(
                flex: (1000 * (1 - topMenuScrolledFraction)).floor(),
                child: Center(
                  child: InkWell(
                    onTap: () {
                      onCompareTapped(appHeight);
                    },
                    child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                      return Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          color: tinterTheme.colors.button,
                        ),
                        child: AutoSizeText(
                          'Compare vos profils',
                          style:
                              tinterTheme.textStyle.chipNotLiked.copyWith(color: Colors.black),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          maxFontSize: 15,
                        ),
                      );
                    }),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget informationRectangle(
      {@required Widget child, double width, double height, EdgeInsetsGeometry padding}) {
    return Align(
      alignment: AlignmentDirectional.center,
      child: Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: tinterTheme.colors.primary,
            ),
            width: width != null ? width : Size.infinite.width,
            height: height,
            child: child,
          );
        },
        child: child,
      ),
    );
  }

  Widget verticalSeparator() {
    return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
      return Container(
        width: 1.0,
        color: tinterTheme.colors.primaryAccent,
      );
    });
  }

  Widget informationComparison() {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: BlocBuilder<UserBloc, UserState>(
                builder: (BuildContext context, UserState state) {
              if (!(state is KnownUserState)) {
                BlocProvider.of<UserBloc>(context).add(UserRequestEvent());
                return Center(child: CircularProgressIndicator(),);
              }
              return ProfileInformation(user: (state as KnownUserState).user);
            }),
          ),
          verticalSeparator(),
          Expanded(
            child: ProfileInformation(user: _binomePairMatch),
          ),
        ],
      ),
    );
  }
}

class ProfileInformation extends StatelessWidget {
  final dynamic user;

  ProfileInformation({this.user}) : assert(user != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SeparatedColumn(
        mainAxisSize: MainAxisSize.min,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 50,
          );
        },
        includeOuterSeparators: false,
        children: [
          informationRectangle(
            context: context,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                      return Text(
                        'Lieu de vie',
                        style: tinterTheme.textStyle.headline2,
                      );
                    }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0),
                    width: double.infinity,
                    child: Container(
                      height: 60,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Opacity(
                              opacity: user.lieuDeVie != LieuDeVie.maisel ? 0.5 : 1,
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5.0),
                                      topLeft: Radius.circular(5.0),
                                    ),
                                    color: tinterTheme.colors.primaryAccent,
                                  ),
                                  width: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Center(
                                      child: AutoSizeText(
                                        'MAISEL',
                                        maxLines: 1,
                                        minFontSize: 10,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            Opacity(
                              opacity: user.lieuDeVie != LieuDeVie.other ? 0.5 : 1,
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(5.0),
                                      bottomRight: Radius.circular(5.0),
                                    ),
                                    color: tinterTheme.colors.primaryAccent,
                                  ),
                                  width: 60,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Center(
                                      child: AutoSizeText(
                                        'Autre',
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                );
                              }),
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
          informationRectangle(
            context: context,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: AlignmentDirectional.topCenter,
                    child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                      return Text(
                        'Horaires de travail',
                        style: tinterTheme.textStyle.headline2,
                      );
                    }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          Opacity(
                            opacity: user.horairesDeTravail.contains(HoraireDeTravail.morning)
                                ? 1
                                : 0.5,
                            child:
                                Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  color: tinterTheme.colors.primaryAccent,
                                ),
                                width: 60,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Center(
                                    child: Text(
                                      'Matin',
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          Opacity(
                            opacity:
                                user.horairesDeTravail.contains(HoraireDeTravail.afternoon)
                                    ? 1
                                    : 0.5,
                            child:
                                Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  color: tinterTheme.colors.primaryAccent,
                                ),
                                width: 60,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Center(
                                    child: Text(
                                      'Aprem',
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          Opacity(
                            opacity: user.horairesDeTravail.contains(HoraireDeTravail.evening)
                                ? 1
                                : 0.5,
                            child:
                                Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  color: tinterTheme.colors.primaryAccent,
                                ),
                                width: 60,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Center(
                                    child: Text(
                                      'Soir',
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                          Opacity(
                            opacity: user.horairesDeTravail.contains(HoraireDeTravail.night)
                                ? 1
                                : 0.5,
                            child:
                                Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  color: tinterTheme.colors.primaryAccent,
                                ),
                                width: 60,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Center(
                                    child: Text(
                                      'Nuit',
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          informationRectangle(
            context: context,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: <Widget>[
                  Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return Text(
                      'Associations',
                      style: tinterTheme.textStyle.headline2,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    child: Center(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (int index = 0; index < user.associations.length; index++) ...[
                              if (index == 0)
                                SizedBox(
                                  width: 10,
                                ),
                              associationBubble(context, user.associations[index]),
                              SizedBox(
                                width: 5,
                              )
                            ]
                          ],
                        ),
                      ),
//                            child: ListView.separated(
//                              shrinkWrap: true,
//                              scrollDirection: Axis.horizontal,
//                              itemCount: user.associations.length,
//                              separatorBuilder: (BuildContext context, int index) {
//                                return SizedBox(
//                                  width: 5,
//                                );
//                              },
//                              itemBuilder: (BuildContext context, int index) {
//                                return associationBubble(context, user.associations[index]);
//                              },
//                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          informationRectangle(
            context: context,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return Text(
                      'Seul.e ou en groupe?',
                      style: tinterTheme.textStyle.headline2,
                      textAlign: TextAlign.center,
                    );
                  }),
                  SizedBox(
                    height: 15,
                  ),
                  discoverSlider(context,
                      Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return SliderTheme(
                      data: tinterTheme.slider.disabled,
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.5, end: user.groupeOuSeul),
                        duration: Duration(milliseconds: 300),
                        builder: (BuildContext context, value, Widget child) {
                          return Slider(
                            value: value,
                            onChanged: null,
                          );
                        },
                      ),
                    );
                  }), leftLabel: 'Seul', rightLabel: 'Groupe'),
                ],
              ),
            ),
          ),
          informationRectangle(
            context: context,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return Text(
                      'En ligne ou à l\'école?',
                      style: tinterTheme.textStyle.headline2,
                      textAlign: TextAlign.center,
                    );
                  }),
                  SizedBox(
                    height: 15,
                  ),
                  discoverSlider(context,
                      Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return SliderTheme(
                      data: tinterTheme.slider.disabled,
                      child: TweenAnimationBuilder(
                        tween: Tween<double>(begin: 0.5, end: user.enligneOuNon),
                        duration: Duration(milliseconds: 300),
                        builder: (BuildContext context, value, Widget child) {
                          return Slider(
                            value: value,
                            onChanged: null,
                          );
                        },
                      ),
                    );
                  }), leftLabel: 'En ligne', rightLabel: 'A l\'école'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: informationRectangle(
              context: context,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                      return Text(
                        'Matières préférées',
                        style: tinterTheme.textStyle.headline2,
                      );
                    }),
                    SizedBox(height: 8.0),
                    Wrap(
                      key: GlobalKey(),
                      spacing: 15,
                      alignment: WrapAlignment.center,
                      children: <Widget>[
                        for (String matierePreferee in user.matieresPreferees)
                          Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                            return Chip(
                              label: Text(matierePreferee),
                              labelStyle: tinterTheme.textStyle.chipLiked,
                              backgroundColor: tinterTheme.colors.primaryAccent,
                            );
                          })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget informationRectangle(
      {@required BuildContext context, @required Widget child, double width, double height}) {
    return Consumer<TinterTheme>(
      builder: (context, tinterTheme, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: tinterTheme.colors.primary,
          ),
          width: width,
          height: height,
          child: child,
        );
      },
      child: child,
    );
  }

  Widget associationBubble(BuildContext context, Association association) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        child: ClipOval(
          child: getLogoFromAssociation(associationName: association.name),
        ),
      ),
    );
  }

//  Widget inactiveSlider(BuildContext context, double value, {String labelRight, String labelLeft}) {
//    return SliderTheme(
//      data: Theme.of(context).sliderTheme.copyWith(
//        trackShape: NoPaddingTrackShape()
//      ),
//      child: Slider(
//        value: value,
//        onChanged: null,
//      ),
//    );
//  }

  Widget discoverSlider(BuildContext context, Widget slider,
      {String leftLabel, String rightLabel}) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SliderLabel(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
                child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                  return Text(
                    leftLabel,
                    style: tinterTheme.textStyle.smallLabel,
                  );
                }),
              ),
              side: Side.Left,
              triangleSize: 14,
            ),
            SliderLabel(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
                child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                  return Text(
                    rightLabel,
                    style: tinterTheme.textStyle.smallLabel,
                  );
                }),
              ),
              side: Side.Right,
              triangleSize: 14,
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 13.0, left: 4, right: 4),
          child: slider,
        ),
      ],
    );
  }
}

class BinomeSelectionMenu extends StatelessWidget {
  final void Function(BuildBinome) _onTapBinome;
  final void Function(BuildBinomePairMatch) _onTapBinomePair;
  final double height;
  final List<BuildBinome> binomesNotBinomes;
  final List<BuildBinome> binomes;
  final List<BuildBinomePairMatch> binomePairMatchesNotMatched;
  final List<BuildBinomePairMatch> binomePairMatches;

  BinomeSelectionMenu({
    @required onTapBinome,
    @required onTapBinomePair,
    @required this.height,
    @required this.binomesNotBinomes,
    @required this.binomes,
    @required this.binomePairMatchesNotMatched,
    @required this.binomePairMatches,
  })  : _onTapBinome = onTapBinome,
        _onTapBinomePair = onTapBinomePair;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
        children: [
          (binomesNotBinomes.length != 0 && binomes.length == 0)
              ? Expanded(
                  child: topMenuBinome(
                      binomes: binomesNotBinomes, title: 'Mes binomes potentiels'))
              : Container(),
          (binomes.length != 0)
              ? Expanded(child: topMenuBinome(binomes: binomes, title: 'Mon/Ma Binome'))
              : Container(),
          (binomePairMatchesNotMatched.length != 0 && binomePairMatches.length == 0)
              ? Expanded(
                  child: topMenuBinomePair(
                      binomePairMatches: binomePairMatchesNotMatched,
                      title: 'Mes binomes de binome potentiels'))
              : Container(),
          (binomePairMatches.length != 0)
              ? Expanded(
                  child: topMenuBinomePair(
                      binomePairMatches: binomePairMatches, title: 'Mon Binome de binome'))
              : Container(),
        ],
      ),
    );
  }

  /// Either displays the binome top menu or the binome top menu
  Widget topMenuBinome({@required List<BuildBinome> binomes, @required String title}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
            return Text(
              title,
              style: tinterTheme.textStyle.headline2,
            );
          }),
        ),
        Flexible(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (BuildBinome binome in binomes)
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () => _onTapBinome(binome),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: 20.0,
                      left: binome == binomes[0] ? 20.0 : 0.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
//                    height: 50,
                    width: 50,
                    child: getProfilePictureFromLocalPathOrLogin(
                      login: binome.login,
                      localPath: binome.profilePictureLocalPath,
//                      height: 50,
                      width: 50,
                    ),
                  ),
                ),
            ],
          ),
        ),
        separator(),
      ],
    );
  }

  /// Either displays the binome pair matched top menu or the binome pair not matched top menu
  Widget topMenuBinomePair(
      {@required List<BuildBinomePairMatch> binomePairMatches, @required String title}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
            return Text(
              title,
              style: tinterTheme.textStyle.headline2,
            );
          }),
        ),
        Flexible(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (BuildBinomePairMatch binomePairMatch in binomePairMatches)
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () => _onTapBinomePair(binomePairMatch),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: 20.0,
                      left: binomePairMatch == binomePairMatches[0] ? 20.0 : 0.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
//                    height: 50,
                    width: 70,
                    child: BinomePair.getProfilePictureFromBinomePairLogins(
                      loginA: binomePairMatch.login,
                      loginB: binomePairMatch.otherLogin,
//                      height: 50,
                      width: 70,
                    ),
                  ),
                ),
            ],
          ),
        ),
        separator(),
      ],
    );
  }

  Widget separator() {
    return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
      return Container(
        margin: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
        height: 0.5,
        color: Colors.black,
      );
    });
  }
}
