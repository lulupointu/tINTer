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
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/shared_element/slider_label.dart';
import 'package:tinterapp/UI/shared/snap_scroll_sheet_physics/snap_scroll_sheet_physics.dart';
import 'package:tinterapp/main.dart';

import 'mode_scolaire_overlay.dart';

main() => runApp(MaterialApp(
      home: Material(
        child: BinomesTab2(),
      ),
    ));

class SelectedScolaire2 extends ChangeNotifier {
  String _binomeLogin;

  String get binomeLogin => _binomeLogin;

  int _binomePairId;

  int get binomePairId => _binomePairId;

  set binomeLogin(newBinomeLogin) {
    if (binomeLogin != newBinomeLogin) {
      _binomeLogin = newBinomeLogin;
      _binomePairId = null;
      notifyListeners();
      print('REMOVING NOTIFICATION');
      notificationHandler.removeNotification(newBinomeLogin.hashCode);
      print('NOTIFICATION REMOVED');
    }
  }

  set binomePairId(newBinomePairId) {
    if (binomePairId != newBinomePairId) {
      _binomeLogin = null;
      _binomePairId = newBinomePairId;
      notifyListeners();
      notificationHandler.removeNotification(newBinomePairId.hashCode);
    }
  }
}

class BinomesTab2 extends StatefulWidget implements TinterTab {
  final Map<String, double> fractions = {
    'binomeSelectionMenu': null,
  };

  final spacing = 15.0;

  @override
  BinomesTab2State createState() => BinomesTab2State();
}

class BinomesTab2State extends State<BinomesTab2> {
  ScrollController _controller = ScrollController();
  ScrollPhysics _scrollPhysics = NeverScrollableScrollPhysics();
  double topMenuScrolledFraction = 0;

  @override
  void initState() {
    // Update to last information
    if (BlocProvider.of<MatchedBinomesBloc>(context).state
        is MatchedBinomesLoadSuccessState) {
      BlocProvider.of<MatchedBinomesBloc>(context)
          .add(MatchedBinomesRefreshingEvent());
    } else {
      BlocProvider.of<MatchedBinomesBloc>(context)
          .add(MatchedBinomesRequestedEvent());
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
    if (BlocProvider.of<BinomePairBloc>(context).state
        is BinomePairLoadSuccessfulState) {
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
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: BlocBuilder<MatchedBinomesBloc, MatchedBinomesState>(builder:
              (BuildContext context, MatchedBinomesState matchedBinomesState) {
            if (!(matchedBinomesState is MatchedBinomesLoadSuccessState)) {
              return Center(child: CircularProgressIndicator());
            }

            // Get the 2 list out of all the matched binomes
            final List<BuildBinome> allBinomes =
                (matchedBinomesState as MatchedBinomesLoadSuccessState).binomes;
            final List<BuildBinome> _binomesNotBinomes = allBinomes
                .where((binome) =>
                    binome.statusScolaire != BinomeStatus.binomeAccepted)
                .toList();
            final List<BuildBinome> _binomes = allBinomes
                .where((binome) =>
                    binome.statusScolaire == BinomeStatus.binomeAccepted)
                .toList();

            // Sort them
            _binomesNotBinomes.sort(
                (BuildBinome binomeA, BuildBinome binomeB) =>
                    binomeA.name.compareTo(binomeB.name));
            _binomes.sort((BuildBinome binomeA, BuildBinome binomeB) =>
                binomeA.name.compareTo(binomeB.name));

            return BlocBuilder<MatchedBinomePairMatchesBloc,
                MatchedBinomePairMatchesState>(builder: (BuildContext
                    context,
                MatchedBinomePairMatchesState matchedBinomePairMatchesState) {
              if (!(matchedBinomePairMatchesState
                  is MatchedBinomePairMatchesLoadSuccessState)) {
                return Center(child: CircularProgressIndicator());
              }

              // Get the 2 list out of all the matched binome pair matches
              final List<BuildBinomePairMatch> allBinomePairMatches =
                  (matchedBinomePairMatchesState
                          as MatchedBinomePairMatchesLoadSuccessState)
                      .binomePairMatches;
              final List<BuildBinomePairMatch> _binomePairMatchesNotMatched =
                  allBinomePairMatches
                      .where((binomePairMatch) =>
                          binomePairMatch.status !=
                          BinomePairMatchStatus.binomePairMatchAccepted)
                      .toList();
              final List<BuildBinomePairMatch> _binomePairMatches =
                  allBinomePairMatches
                      .where((binomePairMatch) =>
                          binomePairMatch.status ==
                          BinomePairMatchStatus.binomePairMatchAccepted)
                      .toList();

              // Sort them
              _binomePairMatchesNotMatched.sort(
                  (BuildBinomePairMatch binomePairMatchA,
                          BuildBinomePairMatch binomePairMatchB) =>
                      binomePairMatchA.name.compareTo(binomePairMatchB.name));
              _binomePairMatches.sort((BuildBinomePairMatch binomePairMatchA,
                      BuildBinomePairMatch binomePairMatchB) =>
                  binomePairMatchA.name.compareTo(binomePairMatchB.name));

              // If the user doesn't have a binome
              if (_binomes.length == 0) {
                widget.fractions['binomeSelectionMenu'] =
                    (ModeScolaireOverlay.height +
                            2 * widget.spacing +
                            BinomeSelectionMenu.height +
                            20.0) /
                        MediaQuery.of(context).size.height;
              } else {
                widget.fractions['binomeSelectionMenu'] = 0.2 +
                    ((_binomePairMatches.length != 0 ||
                            _binomePairMatchesNotMatched.length != 0)
                        ? 0.2
                        : 0);
              }

              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  // ignore: invalid_use_of_protected_member
                  if (!_controller.hasListeners) {
                    _controller.addListener(() {
                      setState(() {
                        topMenuScrolledFraction = max(
                            0,
                            min(
                                1,
                                _controller.position.pixels /
                                    (widget.fractions['binomeSelectionMenu'] *
                                        constraints.maxHeight)));
                      });
                    });
                  }

                  return NotificationListener<ScrollEndNotification>(
                    onNotification:
                        (ScrollEndNotification scrollEndNotification) {
                      _scrollPhysics = _controller.offset == 0
                          ? NeverScrollableScrollPhysics()
                          : SnapScrollSheetPhysics(
                              topChildrenHeight: [
                                widget.fractions['binomeSelectionMenu'] *
                                    constraints.maxHeight,
                              ],
                            );
                      setState(() {});
                      return true;
                    },
                    child: ListView(
                      physics: _scrollPhysics,
                      controller: _controller,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 20.0,
                            top: widget.spacing,
                          ),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: ModeScolaireOverlay(),
                          ),
                        ),
                        SizedBox(
                          height: widget.spacing,
                        ),
                        BinomeSelectionMenu(
                          binomesNotBinomes: _binomesNotBinomes,
                          binomes: _binomes,
                          binomePairMatchesNotMatched:
                              _binomePairMatchesNotMatched,
                          binomePairMatches: _binomePairMatches,
                        ),
                        (context.watch<SelectedScolaire2>().binomeLogin ==
                                    null &&
                                context
                                        .watch<SelectedScolaire2>()
                                        .binomePairId ==
                                    null)
                            ? noBinomeSelected(constraints.maxHeight)
                            : (context
                                        .watch<SelectedScolaire2>()
                                        .binomePairId ==
                                    null)
                                ? CompareViewBinome(
                                    binome: allBinomes.firstWhere(
                                      (BuildBinome binome) =>
                                          binome.login ==
                                          context
                                              .watch<SelectedScolaire2>()
                                              .binomeLogin,
                                    ),
                                    appHeight: constraints.maxHeight,
                                    topMenuScrolledFraction:
                                        topMenuScrolledFraction,
                                    onCompareTapped: onCompareTapped,
                                  )
                                : CompareViewBinomePairMatch(
                                    binomePairMatch:
                                        allBinomePairMatches.firstWhere(
                                      (BuildBinomePairMatch binomePairMatch) =>
                                          binomePairMatch.binomePairId ==
                                          context
                                              .watch<SelectedScolaire2>()
                                              .binomePairId,
                                    ),
                                    appHeight: constraints.maxHeight,
                                    topMenuScrolledFraction:
                                        topMenuScrolledFraction,
                                    onCompareTapped: onCompareTapped,
                                  ),
                      ],
                    ),
                  );
                },
              );
            });
          }),
        ),
      ),
    );
  }

  Future<void> onCompareTapped(appHeight) async {
    await _controller.animateTo(
      widget.fractions['binomeSelectionMenu'] * appHeight,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    setState(() {});
  }

  Widget noBinomeSelected(appHeight) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      SizedBox(
        height: appHeight * 0.1,
      ),
      Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
        return BlocBuilder<MatchedBinomesBloc, MatchedBinomesState>(
          buildWhen:
              (MatchedBinomesState previousState, MatchedBinomesState state) {
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
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Consumer<TinterTheme>(
                builder: (context, tinterTheme, child) {
              return ((state as MatchedBinomesLoadSuccessState)
                          .binomes
                          .length ==
                      0)
                  ? Column(
                      children: [
                        Icon(
                          Icons.sentiment_very_dissatisfied_rounded,
                          color: Colors.black87,
                          size: 70,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Il n'y a aucun binôme à afficher pour l'instant.",
                          style: Theme.of(context).textTheme.headline5,
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Icon(
                          Icons.face,
                          color: Colors.black87,
                          size: 70,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Sélectionne un binôme !",
                          style: Theme.of(context).textTheme.headline4,
                        )
                      ],
                    );
            });
          },
        );
      })
    ]);
  }
}

class CompareViewBinome extends StatelessWidget {
  final BuildBinome _binome;
  final double appHeight;
  final double topMenuScrolledFraction;
  final Future<void> Function(double) onCompareTapped;

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
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 20.0,
          ),
          child: facesAroundScore(context),
        ),
        statusRectangle(context),
        SizedBox(
          height: 30,
        ),
        Opacity(
          opacity: topMenuScrolledFraction,
          child: informationComparison(),
        ),
      ],
    );
  }

  Widget facesAroundScore(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<UserBloc, UserState>(
                    builder: (BuildContext context, UserState userState) {
                  if (!(userState is UserLoadSuccessState)) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return userPicture(
                      getProfilePicture: (
                              {@required height, @required width}) =>
                          getProfilePictureFromLocalPathOrLogin(
                              login: (userState as UserLoadSuccessState)
                                  .user
                                  .login,
                              localPath: (userState as UserLoadSuccessState)
                                  .user
                                  .profilePictureLocalPath,
                              height: height,
                              width: width));
                }),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Moi\n',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ),
          InBetweenScore2(context),
          Container(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                userPicture(
                  getProfilePicture: ({@required height, @required width}) =>
                      getProfilePictureFromLogin(
                    login: _binome.login,
                    height: height,
                    width: width,
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  _binome.name + '\n' + _binome.surname,
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Displays either your face or your binome face
  Widget userPicture(
      {Widget Function({@required double height, @required double width})
          getProfilePicture}) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: Color(0xff79BFC9), width: 4.0, style: BorderStyle.solid),
      ),
      height: 80,
      width: 80,
      child: getProfilePicture(
        height: 80,
        width: 80,
      ),
    );
  }

  Widget InBetweenScore2(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 125,
            width: 125,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5.0,
              ),
              child: Text(
                'Score',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5.0,
            ),
            child: Text(
              _binome.score.toString(),
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 5.0,
                bottom: 5.0,
              ),
              child: GestureDetector(
                onTap: () {
                  showGeneralDialog(
                    transitionDuration: Duration(milliseconds: 300),
                    context: context,
                    pageBuilder: (BuildContext context, animation, _) =>
                        Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: SimpleDialog(
                          elevation: 5.0,
                          children: [
                            InkWell(
                              onTap: () {},
                              splashColor: Colors.transparent,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                    ),
                                    child: Text(
                                      "Aide",
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 10.0,
                                    ),
                                    child: Text(
                                      "Le score est un indicateur sur 100 de l'affinité supposée entre deux étudiants."
                                      " Il est basé sur les critères renseignés dans le profil.",
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                    ),
                                    child: Container(
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text(
                                          "Continuer",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.help_outline_outlined,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget statusRectangle(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.75,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 15.0,
              ),
              child: AutoSizeText(
                (_binome.statusScolaire == BinomeStatus.liked ||
                        _binome.statusScolaire == BinomeStatus.heIgnoredYou)
                    ? "Cette personne ne t'a pas encore liké.e."
                    : (_binome.statusScolaire == BinomeStatus.matched)
                        ? "Propose lui d'être son binôme !"
                        : (_binome.statusScolaire ==
                                BinomeStatus.youAskedBinome)
                            ? "Demande de binôme envoyée !"
                            : (_binome.statusScolaire ==
                                    BinomeStatus.heAskedBinome)
                                ? "Cette personne veut être ton ou ta binôme !"
                                : (_binome.statusScolaire ==
                                        BinomeStatus.binomeAccepted)
                                    ? "Tu es en binôme avec cette personne !"
                                    : (_binome.statusScolaire ==
                                            BinomeStatus.binomeHeRefused)
                                        ? 'Cette personne a refusé ta demande de binôme.'
                                        : (_binome.statusScolaire ==
                                                BinomeStatus.binomeYouRefused)
                                            ? "Tu as refusé d'être le ou la binôme de cette personne."
                                            : 'ERROR: the status should not be ${_binome.statusScolaire}',
                style: Theme.of(context).textTheme.headline5,
                maxLines: 2,
              ),
            ),
            if (topMenuScrolledFraction != 1)
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 15.0,
                ),
                child: FractionallySizedBox(
                  widthFactor: 0.8,
                  child: Container(
                    height: 50.0 * (1.0 - topMenuScrolledFraction),
                    child: ElevatedButton(
                      onPressed: () {
                        onCompareTapped(appHeight);
                      },
                      child: Text(
                        'Comparer vos profils',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            if ([BinomeStatus.matched, BinomeStatus.heAskedBinome]
                .contains(_binome.statusScolaire)) ...[
              (_binome.statusScolaire == BinomeStatus.matched)
                  ? Padding(
                      padding: const EdgeInsets.only(
                        bottom: 15.0,
                      ),
                      child: FractionallySizedBox(
                        widthFactor: 0.8,
                        child: Container(
                          height: 50,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).indicatorColor),
                            ),
                            onPressed: () {
                              BlocProvider.of<MatchedBinomesBloc>(context)
                                  .add(AskBinomeEvent(binome: _binome));
                            },
                            child: Text(
                              'Envoyer une demande',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                    color: Colors.white,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : (_binome.statusScolaire == BinomeStatus.heAskedBinome)
                      ? Padding(
                          padding: const EdgeInsets.only(
                            bottom: 15.0,
                          ),
                          child: FractionallySizedBox(
                            widthFactor: 0.8,
                            child: Container(
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        BlocProvider.of<MatchedBinomesBloc>(
                                                context)
                                            .add(AcceptBinomeEvent(
                                                binome: _binome));
                                      },
                                      child: Text(
                                        'Accepter',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15.0,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Theme.of(context)
                                                    .indicatorColor),
                                      ),
                                      onPressed: () {
                                        BlocProvider.of<MatchedBinomesBloc>(
                                                context)
                                            .add(RefuseBinomeEvent(
                                                binome: _binome));
                                      },
                                      child: Text(
                                        'Refuser',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : AutoSizeText(
                          'ERROR: the state should not be ' +
                              _binome.statusScolaire.toString(),
                        ),
            ],
            Padding(
              padding: const EdgeInsets.only(
                bottom: 15.0,
              ),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: Container(
                  height: 50,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).errorColor),
                    ),
                    onPressed: () async {
                      await onCompareTapped(0);
                      context.read<SelectedScolaire2>().binomeLogin = null;
                      BlocProvider.of<MatchedBinomesBloc>(context).add(
                        IgnoreBinomeEvent(binome: _binome),
                      );
                    },
                    child: Text(
                      'Supprimer ce binôme',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget informationRectangle(
      {@required Widget child,
      double width,
      double height,
      EdgeInsetsGeometry padding}) {
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
        width: 2.5,
        color: Theme.of(context).disabledColor.withOpacity(0.6),
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
                return Center(
                  child: CircularProgressIndicator(),
                );
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
  final Future<void> Function(double) onCompareTapped;

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
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 20.0,
          ),
          child: facesAroundScore(context),
        ),
        statusRectangle(context),
        Opacity(
          opacity: topMenuScrolledFraction,
          child: informationComparison(),
        ),
      ],
    );
  }

  Widget facesAroundScore(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<BinomePairBloc, BinomePairState>(builder:
                    (BuildContext context, BinomePairState binomePairState) {
                  if (!(binomePairState is BinomePairLoadSuccessfulState)) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return userPicture(
                      getProfilePicture: (
                              {@required height, @required width}) =>
                          BinomePair.getProfilePictureFromBinomePairLogins(
                            loginA: (binomePairState
                                    as BinomePairLoadSuccessfulState)
                                .binomePair
                                .login,
                            loginB: (binomePairState
                                    as BinomePairLoadSuccessfulState)
                                .binomePair
                                .otherLogin,
                            height: height,
                            width: width,
                          ));
                }),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  'Ton' + '\n' + 'binôme',
                  style: Theme.of(context).textTheme.headline5,
                ),
              ],
            ),
          ),
          InBetweenScore2(context),
          Container(
            width: 100,
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
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  '${_binomePairMatch.name} ${_binomePairMatch.surname} '
                  '\n & \n'
                  '${_binomePairMatch.otherName} ${_binomePairMatch.otherSurname} ',
                  style: Theme.of(context).textTheme.headline5,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Displays either your face or your binome face
  Widget userPicture(
      {Widget Function({@required double height, @required double width})
          getProfilePicture}) {
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

  Widget InBetweenScore2(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 125,
            width: 125,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  15.0,
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                top: 5.0,
              ),
              child: Text(
                'Score',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 5.0,
            ),
            child: Text(
              _binomePairMatch.score.toString(),
              style: Theme.of(context).textTheme.headline1.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.only(
                right: 5.0,
                bottom: 5.0,
              ),
              child: GestureDetector(
                onTap: () {
                  showGeneralDialog(
                    transitionDuration: Duration(milliseconds: 300),
                    context: context,
                    pageBuilder: (BuildContext context, animation, _) =>
                        Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        child: SimpleDialog(
                          elevation: 5.0,
                          children: [
                            InkWell(
                              onTap: () {},
                              splashColor: Colors.transparent,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                    ),
                                    child: Text(
                                      "Aide",
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0,
                                      vertical: 10.0,
                                    ),
                                    child: Text(
                                      "Le score est un indicateur sur 100 de l'affinité supposée entre deux étudiants."
                                      " Il est basé sur les critères renseignés dans le profil.",
                                      textAlign: TextAlign.center,
                                      style:
                                          Theme.of(context).textTheme.headline5,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5.0,
                                    ),
                                    child: Container(
                                      width: 200,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text(
                                          "Continuer",
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Icon(
                  Icons.help_outline_outlined,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
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
                  child: Consumer<TinterTheme>(
                      builder: (context, tinterTheme, child) {
                    return AutoSizeText(
                      (_binomePairMatch.status == BinomePairMatchStatus.liked ||
                              _binomePairMatch.status ==
                                  BinomePairMatchStatus.heIgnoredYou)
                          ? "Ce binome ne vous a pas encore liker"
                          : (_binomePairMatch.status ==
                                  BinomePairMatchStatus.matched)
                              ? "Propose lui d'être votre binome de binome"
                              : (_binomePairMatch.status ==
                                      BinomePairMatchStatus
                                          .youAskedBinomePairMatch)
                                  ? "Demande envoyée"
                                  : (_binomePairMatch.status ==
                                          BinomePairMatchStatus
                                              .heAskedBinomePairMatch)
                                      ? "Cette personne veut être ton binome de binome"
                                      : (_binomePairMatch.status ==
                                              BinomePairMatchStatus
                                                  .binomePairMatchAccepted)
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
            if ([
              BinomePairMatchStatus.matched,
              BinomePairMatchStatus.heAskedBinomePairMatch
            ].contains(_binomePairMatch.status)) ...[
              Container(
                constraints: BoxConstraints(
                  minHeight: 10,
                ),
              ),
              Expanded(
                flex: 1000,
                child: (_binomePairMatch.status ==
                        BinomePairMatchStatus.matched)
                    ? Center(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            BlocProvider.of<MatchedBinomePairMatchesBloc>(
                                    context)
                                .add(AskBinomePairMatchEvent(
                                    binomePairMatch: _binomePairMatch));
                          },
                          child: Consumer<TinterTheme>(
                              builder: (context, tinterTheme, child) {
                            return Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3.0)),
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
                    : (_binomePairMatch.status ==
                            BinomePairMatchStatus.heAskedBinomePairMatch)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  BlocProvider.of<MatchedBinomePairMatchesBloc>(
                                          context)
                                      .add(AcceptBinomePairMatchEvent(
                                          binomePairMatch: _binomePairMatch));
                                },
                                child: Consumer<TinterTheme>(
                                    builder: (context, tinterTheme, child) {
                                  return Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.0)),
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
                                  BlocProvider.of<MatchedBinomePairMatchesBloc>(
                                          context)
                                      .add(RefuseBinomePairMatchEvent(
                                          binomePairMatch: _binomePairMatch));
                                },
                                child: Consumer<TinterTheme>(
                                    builder: (context, tinterTheme, child) {
                                  return Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(3.0)),
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
                    child: Consumer<TinterTheme>(
                        builder: (context, tinterTheme, child) {
                      return Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                          color: tinterTheme.colors.button,
                        ),
                        child: AutoSizeText(
                          'Compare vos profils',
                          style: tinterTheme.textStyle.chipNotLiked
                              .copyWith(color: Colors.black),
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
      {@required Widget child,
      double width,
      double height,
      EdgeInsetsGeometry padding}) {
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
        width: 2.5,
        color: Theme.of(context).disabledColor.withOpacity(0.6),
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
                return Center(
                  child: CircularProgressIndicator(),
                );
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
            height: 20,
          );
        },
        includeOuterSeparators: false,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0, bottom: 15.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Lieu de vie',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: Container(
                      height: 35,
                      width: 90,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Opacity(
                            opacity:
                                user.lieuDeVie != LieuDeVie.maisel ? 0.5 : 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5.0),
                                  topLeft: Radius.circular(5.0),
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              width: 70,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                  child: AutoSizeText(
                                    'MAISEL',
                                    maxLines: 1,
                                    minFontSize: 10,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Opacity(
                            opacity:
                                user.lieuDeVie != LieuDeVie.other ? 0.5 : 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(5.0),
                                  bottomRight: Radius.circular(5.0),
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              width: 70,
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Center(
                                  child: AutoSizeText(
                                    'Autre',
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 15.0,
                right: 15.0,
                top: 10.0,
                bottom: 15.0,
              ),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Horaires de travail',
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        Opacity(
                          opacity: user.horairesDeTravail
                                  .contains(HoraireDeTravail.morning)
                              ? 1
                              : 0.5,
                          child: Consumer<TinterTheme>(
                              builder: (context, tinterTheme, child) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    5.0,
                                  ),
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              width: 60,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                  vertical: 10.0,
                                ),
                                child: Center(
                                  child: Text(
                                    'Matin',
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        Opacity(
                          opacity: user.horairesDeTravail
                                  .contains(HoraireDeTravail.afternoon)
                              ? 1
                              : 0.5,
                          child: Consumer<TinterTheme>(
                              builder: (context, tinterTheme, child) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    5.0,
                                  ),
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              width: 60,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                  vertical: 10.0,
                                ),
                                child: Center(
                                  child: Text(
                                    'Aprem',
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        Opacity(
                          opacity: user.horairesDeTravail
                                  .contains(HoraireDeTravail.evening)
                              ? 1
                              : 0.5,
                          child: Consumer<TinterTheme>(
                              builder: (context, tinterTheme, child) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    5.0,
                                  ),
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              width: 60,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                  vertical: 10.0,
                                ),
                                child: Center(
                                  child: Text(
                                    'Soir',
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        Opacity(
                          opacity: user.horairesDeTravail
                                  .contains(HoraireDeTravail.night)
                              ? 1
                              : 0.5,
                          child: Consumer<TinterTheme>(
                              builder: (context, tinterTheme, child) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(
                                    5.0,
                                  ),
                                ),
                                color: Theme.of(context).primaryColor,
                              ),
                              width: 60,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                  vertical: 10.0,
                                ),
                                child: Center(
                                  child: Text(
                                    'Nuit',
                                    maxLines: 1,
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Associations',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: double.infinity,
                    child: Stack(
                      alignment: AlignmentDirectional.centerStart,
                      children: <Widget>[
                        user.associations.length >= 1
                            ? Container(
                                width: double.infinity,
                                height: 60,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (int index = 0;
                                          index < user.associations.length;
                                          index++) ...[
                                        associationBubble(
                                            context, user.associations[index]),
                                        SizedBox(
                                          width: 5,
                                        )
                                      ]
                                    ],
                                  ),
                                ),
                              )
                            : Text(
                                'Aucune association sélectionnée',
                                style: Theme.of(context).textTheme.headline5,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0, bottom: 15.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'A plusieurs ou seul.e ?',
                      style: Theme.of(context).textTheme.headline5,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.group_rounded,
                          size: 22.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: Theme.of(context).sliderTheme.copyWith(
                                disabledActiveTrackColor:
                                    Theme.of(context).primaryColor,
                                disabledThumbColor: Color(0xffCECECE),
                                overlayShape:
                                    RoundSliderOverlayShape(overlayRadius: 0.0),
                                trackHeight: 6.0,
                                disabledInactiveTrackColor:
                                    Theme.of(context).indicatorColor,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8.0),
                              ),
                          child: TweenAnimationBuilder(
                            tween: Tween<double>(
                                begin: 0.5, end: user.groupeOuSeul),
                            duration: Duration(milliseconds: 300),
                            builder:
                                (BuildContext context, value, Widget child) {
                              return Slider(
                                value: value,
                                onChanged: null,
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.person_rounded,
                          size: 22.0,
                          color: Theme.of(context).indicatorColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 10.0, bottom: 15.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'En ligne ou à l\'école ?',
                      style: Theme.of(context).textTheme.headline5,
                      maxLines: 2,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Icon(
                          Icons.school_rounded,
                          size: 22.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: Theme.of(context).sliderTheme.copyWith(
                                disabledActiveTrackColor:
                                    Theme.of(context).primaryColor,
                                disabledThumbColor: Color(0xffCECECE),
                                overlayShape:
                                    RoundSliderOverlayShape(overlayRadius: 0.0),
                                trackHeight: 6.0,
                                disabledInactiveTrackColor:
                                    Theme.of(context).indicatorColor,
                                thumbShape: RoundSliderThumbShape(
                                    enabledThumbRadius: 8.0),
                              ),
                          child: TweenAnimationBuilder(
                            tween: Tween<double>(
                                begin: 0.5, end: user.enligneOuNon),
                            duration: Duration(milliseconds: 300),
                            builder:
                                (BuildContext context, value, Widget child) {
                              return Slider(
                                value: value,
                                onChanged: null,
                              );
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.wifi,
                          size: 22.0,
                          color: Theme.of(context).indicatorColor,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 10.0,
                    bottom: 15.0,
                    left: 5.0,
                    right: 5.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Matières préférées',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      user.matieresPreferees.length >= 1
                          ? Wrap(
                              alignment: WrapAlignment.center,
                              key: GlobalKey(),
                              spacing: 8,
                              runSpacing: 8,
                              children: <Widget>[
                                for (String matierePreferee
                                    in user.matieresPreferees)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 6.0,
                                    ),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(
                                            0.2,
                                          ),
                                          spreadRadius: 0.2,
                                          blurRadius: 3,
                                          offset: Offset(
                                            1,
                                            1,
                                          ),
                                        )
                                      ],
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          10.0,
                                        ),
                                      ),
                                      border: Border.all(
                                        color: (Theme.of(context).primaryColor),
                                        width: 3.0,
                                        style: BorderStyle.solid,
                                      ),
                                      color: Colors.white,
                                    ),
                                    child: Text(matierePreferee),
                                  ),
                              ],
                            )
                          : Text(
                              'Aucune matière sélectionnée',
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget associationBubble(BuildContext context, Association association) {
    return Consumer<TinterTheme>(
      builder: (context, tinterTheme, child) {
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 2.5,
            ),
          ),
          height: 60,
          width: 60,
          child: child,
        );
      },
      child: ClipOval(
        child: Container(
          alignment: AlignmentDirectional.centerStart,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: getLogoFromAssociation(associationName: association.name),
        ),
      ),
    );
  }

  Widget discoverSlider(BuildContext context, Widget slider,
      {String leftLabel, String rightLabel}) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SliderLabel(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
                child: Consumer<TinterTheme>(
                    builder: (context, tinterTheme, child) {
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
                child: Consumer<TinterTheme>(
                    builder: (context, tinterTheme, child) {
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
  static final double height = 100;
  final List<BuildBinome> binomesNotBinomes;
  final List<BuildBinome> binomes;
  final List<BuildBinomePairMatch> binomePairMatchesNotMatched;
  final List<BuildBinomePairMatch> binomePairMatches;

  BinomeSelectionMenu({
    @required this.binomesNotBinomes,
    @required this.binomes,
    @required this.binomePairMatchesNotMatched,
    @required this.binomePairMatches,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ((binomesNotBinomes.length != 0) && (binomes.length == 0)) ||
              ((binomes.length != 0) &&
                  (binomePairMatchesNotMatched.length == 0))
          ? height
          : 2 * height + 15.0,
      child: Column(
        children: [
          (binomesNotBinomes.length != 0 && binomes.length == 0)
              ? Expanded(
                  child: topMenuBinome(
                    context: context,
                    binomes: binomesNotBinomes,
                    title: 'Mes binômes potentiels',
                  ),
                )
              : Container(),
          (binomes.length != 0)
              ? Expanded(
                  child: topMenuBinome(
                    context: context,
                    binomes: binomes,
                    title: 'Mon ou ma binôme',
                  ),
                )
              : Container(),
          (binomePairMatchesNotMatched.length != 0 &&
                  binomePairMatches.length == 0)
              ? Expanded(
                  child: topMenuBinomePair(
                    context: context,
                    binomePairMatches: binomePairMatchesNotMatched,
                    title: 'Mes binômes de binôme potentiels',
                  ),
                )
              : Container(),
          (binomePairMatches.length != 0)
              ? Expanded(
                  child: topMenuBinomePair(
                    context: context,
                    binomePairMatches: binomePairMatches,
                    title: 'Mon binôme de binôme',
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  /// Either displays the binome top menu or the binome top menu
  Widget topMenuBinome({
    @required BuildContext context,
    @required List<BuildBinome> binomes,
    @required String title,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15.0,
            top: 10.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                return Text(
                  title,
                  style: Theme.of(context).textTheme.headline5,
                );
              }),
              SizedBox(
                height: 7.5,
              ),
              Container(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (BuildBinome binome in binomes)
                      GestureDetector(
                        onTap: () => context
                            .read<SelectedScolaire2>()
                            .binomeLogin = binome.login,
                        child: Padding(
                          padding: const EdgeInsets.only(
                            right: 7.5,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 3.0,
                                  style: BorderStyle.solid),
                            ),
                            child: getProfilePictureFromLocalPathOrLogin(
                              login: binome.login,
                              localPath: binome.profilePictureLocalPath,
                              height: 44,
                              width: 44,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Either displays the binome pair matched top menu or the binome pair not matched top menu
  Widget topMenuBinomePair(
      {@required BuildContext context,
      @required List<BuildBinomePairMatch> binomePairMatches,
      @required String title}) {
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
                  onTap: () => context.read<SelectedScolaire2>().binomePairId =
                      binomePairMatch.binomePairId,
                  child: Container(
                    margin: EdgeInsets.only(
                      right: 20.0,
                      left:
                          binomePairMatch == binomePairMatches[0] ? 20.0 : 0.0,
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
