import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/scolaire/discover_binome_pair_matches/discover_binome_pair_matches_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/association_logo.dart';
import 'package:tinterapp/Logic/models/scolaire/binome_pair.dart';
import 'package:tinterapp/Logic/models/scolaire/binome_pair_match.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/shared_element/custom_flare_controller.dart';
import 'package:tinterapp/UI/shared/shared_element/slider_label.dart';
import 'package:tinterapp/UI2/scolaire/discover_quadrinome/recherche_binome_pair2.dart';

import '../mode_scolaire_overlay.dart';

class DiscoverBinomePairTab2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Update to last information
    if (BlocProvider.of<DiscoverBinomePairMatchesBloc>(context).state
        is DiscoverBinomePairMatchesLoadSuccessState) {
      BlocProvider.of<DiscoverBinomePairMatchesBloc>(context)
          .add(DiscoverBinomePairMatchesRefreshEvent());
    } else {
      BlocProvider.of<DiscoverBinomePairMatchesBloc>(context)
          .add(DiscoverBinomePairMatchesRequestedEvent());
    }

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            BlocBuilder<DiscoverBinomePairMatchesBloc,
                DiscoverBinomePairMatchesState>(builder: (BuildContext
                    context,
                DiscoverBinomePairMatchesState discoverBinomePairMatchesState) {
              return LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  if (discoverBinomePairMatchesState
                          is DiscoverBinomePairMatchesInitialState ||
                      discoverBinomePairMatchesState
                          is DiscoverBinomePairMatchesLoadInProgressState)
                    return Center(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  if (discoverBinomePairMatchesState
                          is DiscoverBinomePairMatchesLoadSuccessState &&
                      discoverBinomePairMatchesState.binomePairMatches.length ==
                          0) return NoMoreDiscoveryBinomePairMatchesWidget();
                  return Stack(
                    children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                            flex: 55,
                            child: BinomePairMatchInformation(),
                          ),
                          Expanded(
                            flex: 45,
                            child: DiscoverRight(constraints.maxHeight),
                          ),
                        ],
                      ),
                      Positioned(
                        left: constraints.maxWidth * 55 / 100,
                        child: Consumer<TinterTheme>(
                            builder: (context, tinterTheme, child) {
                          return SvgPicture.asset(
                            'assets/discover/DiscoverBackground.svg',
                            color: Theme.of(context).scaffoldBackgroundColor,
                            height: constraints.maxHeight,
                          );
                        }),
                      ),
                      Positioned(
                        left: constraints.maxWidth * 55 / 100,
                        child: Consumer<TinterTheme>(
                            builder: (context, tinterTheme, child) {
                          return SvgPicture.asset(
                            'assets/discover/DiscoverTop.svg',
                            color: Theme.of(context).primaryColor,
                            height: constraints.maxHeight / 2,
                          );
                        }),
                      ),
                      Positioned(
                        left: constraints.maxWidth * 55 / 100,
                        bottom: 0,
                        child: Consumer<TinterTheme>(
                            builder: (context, tinterTheme, child) {
                          return SvgPicture.asset(
                            'assets/discover/DiscoverBottom.svg',
                            color: Theme.of(context).primaryColor,
                            height: constraints.maxHeight / 2,
                          );
                        }),
                      ),
                    ],
                  );
                },
              );
            }),
            Padding(
              padding: const EdgeInsets.only(
                top: 15.0,
                left: 20.0,
              ),
              child: ModeScolaireOverlay(),
            ),
          ],
        ),
      ),
    );
  }
}

/// All the right side of the discover tab put together
class DiscoverRight extends StatelessWidget {
  final double appHeight;

  DiscoverRight(this.appHeight);

  @override
  Widget build(BuildContext context) {
    return Consumer<TinterTheme>(
      builder: (context, tinterTheme, child) {
        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 15.0,
        ),
        child: Column(
          children: <Widget>[
            FractionallySizedBox(
              widthFactor: 0.9,
              child: BinomePairStudentSearch(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                height: ((this.appHeight - 15 - 60 - 15) -
                        this.appHeight * 1 / 2) /
                    (1 -
                        (1 / 2 * BinomePairMatchesFlock.fractions['bigHead'] +
                            BinomePairMatchesFlock
                                .fractions['nameAndSurname'])),
                child: BinomePairMatchesFlock(),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            LikeOrIgnore(),
          ],
        ),
      ),
    );
  }
}

class BinomePairStudentSearch extends StatelessWidget {
  const BinomePairStudentSearch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchStudentBinomePairTab2(),
          ),
        );
      },
      child: Container(
        height: 60.0,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(
              color: Colors.white, width: 4.0, style: BorderStyle.solid),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(3, 3),
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'rechercher une\npaire de binôme',
              style: Theme.of(context).textTheme.headline5.copyWith(
                    color: Colors.white,
                    height: 1.1,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class LikeOrIgnore extends StatefulWidget {
  LikeOrIgnore();

  @override
  _LikeOrIgnoreState createState() => _LikeOrIgnoreState();
}

class _LikeOrIgnoreState extends State<LikeOrIgnore>
    with TickerProviderStateMixin {
  AnimationController likeController;
  Animation<double> likeAnimation;
  AnimationController ignoreController;
  Animation<double> ignoreAnimation;

  @override
  void initState() {
    likeController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    likeAnimation = CurveTween(curve: Curves.easeOut).animate(likeController)
      ..addListener(() {
        setState(() {});
      });
    ignoreController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    ignoreAnimation =
        CurveTween(curve: Curves.easeOut).animate(ignoreController)
          ..addListener(() {
            setState(() {});
          });
    super.initState();
  }

  @override
  void dispose() {
    likeController.dispose();
    ignoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverBinomePairMatchesBloc,
            DiscoverBinomePairMatchesState>(
        builder: (context,
            DiscoverBinomePairMatchesState discoverBinomePairMatchesState) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 4,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                padding: EdgeInsets.all(0.0),
                iconSize: 35,
                color: Theme.of(context).indicatorColor,
                icon: FlareActor(
                  'assets/icons/Heart.flr',
                  color: Theme.of(context).indicatorColor,
                  fit: BoxFit.contain,
                  controller: CustomFlareController(
                      controller: likeController,
                      forwardAnimationName: 'Validate'),
                ),
                onPressed: discoverBinomePairMatchesState
                        is DiscoverBinomePairMatchesSavingNewStatusState
                    ? null
                    : () {
                        likeController.forward().whenComplete(() =>
                            likeController.animateTo(0,
                                duration: Duration(seconds: 0)));
                        BlocProvider.of<DiscoverBinomePairMatchesBloc>(context)
                            .add(DiscoverBinomePairMatchesLikeEvent());
                      },
              ),
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 4,
                  blurRadius: 4,
                  offset: Offset(1, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: IconButton(
                padding: EdgeInsets.all(0.0),
                iconSize: 35,
                color: Theme.of(context).indicatorColor,
                icon: FlareActor(
                  'assets/icons/Clear.flr',
                  color: Theme.of(context).indicatorColor,
                  fit: BoxFit.contain,
                  controller: CustomFlareController(
                    controller: ignoreController,
                    forwardAnimationName: 'Ignore',
                  ),
                ),
                onPressed: discoverBinomePairMatchesState
                        is DiscoverBinomePairMatchesSavingNewStatusState
                    ? null
                    : () {
                        ignoreController.forward().whenComplete(() =>
                            ignoreController.animateTo(0,
                                duration: Duration(seconds: 0)));
                        BlocProvider.of<DiscoverBinomePairMatchesBloc>(context)
                            .add(DiscoverBinomePairMatchesIgnoreEvent());
                      },
              ),
            ),
          ),
        ],
      );
    });
  }
}

class BinomePairMatchesFlock extends StatefulWidget {
  BinomePairMatchesFlock();

  // fraction describes the proportions
  // of each part of the widget
  static final Map<String, double> fractions = {
    'nameAndSurname': 18 / 100,
    'bigHead': 26 / 100,
    'smallHead': 15 / 100,
    'separator': 15 / 100,
  };

  @override
  _BinomePairMatchesFlockState createState() => _BinomePairMatchesFlockState();
}

class _BinomePairMatchesFlockState extends State<BinomePairMatchesFlock>
    with SingleTickerProviderStateMixin {
  final AutoSizeGroup nameAndSurnameAutoSizeGroup = AutoSizeGroup();
  AnimationController animationController;
  BuildBinomePairMatch previousFirstBinomePairMatch;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      lowerBound: 0,
      upperBound: 1,
    );
    animationController.animateTo(1, duration: Duration.zero);
    animationController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return BlocBuilder<DiscoverBinomePairMatchesBloc,
                DiscoverBinomePairMatchesState>(
            buildWhen: (DiscoverBinomePairMatchesState previousState,
                DiscoverBinomePairMatchesState state) {
          if (state is DiscoverBinomePairMatchesSavingNewStatusState) {
            previousFirstBinomePairMatch =
                (previousState as DiscoverBinomePairMatchesLoadSuccessState)
                    .binomePairMatches
                    .first;
            animationController
                .animateTo(0, duration: Duration(milliseconds: 0))
                .whenComplete(() => animationController.forward());
          }
          return true;
        }, builder:
                (BuildContext context, DiscoverBinomePairMatchesState state) {
          if (!(state is DiscoverBinomePairMatchesLoadSuccessState)) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Container(
            height: constraints.maxHeight,
            child: Stack(
              overflow: Overflow.visible,
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                if ((state as DiscoverBinomePairMatchesLoadSuccessState)
                        .binomePairMatches
                        .length >=
                    3) ...[
                  // First head
                  Positioned(
                    top: -50 * (1 - animationController.value),
                    child: Opacity(
                      opacity: animationController.value,
                      child: Consumer<TinterTheme>(
                        builder: (context, tinterTheme, child) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
//                              border: Border.all(
//                                width: 2,
//                                color: tinterTheme.colors.primaryAccent,
//                              ),
                            ),
                            height: constraints.maxHeight *
                                BinomePairMatchesFlock.fractions['smallHead'],
                            width: constraints.maxHeight *
                                BinomePairMatchesFlock.fractions['smallHead'],
                            child: child,
                          );
                        },
                        child: Center(
                          child: BinomePair.getProfilePictureFromBinomePairLogins(
                              loginA: (state
                                      as DiscoverBinomePairMatchesLoadSuccessState)
                                  .binomePairMatches[2]
                                  .login,
                              loginB: (state
                                      as DiscoverBinomePairMatchesLoadSuccessState)
                                  .binomePairMatches[2]
                                  .otherLogin,
                              height: constraints.maxHeight *
                                      BinomePairMatchesFlock
                                          .fractions['smallHead'] -
                                  10,
                              width: constraints.maxHeight *
                                  BinomePairMatchesFlock
                                      .fractions['smallHead']),
                        ),
                      ),
                    ),
                  ),

                  // First separator
                  Positioned(
                    top: constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['smallHead'] +
                        10 -
                        50 * (1 - animationController.value),
                    child: Opacity(
                      opacity: animationController.value,
                      child: Consumer<TinterTheme>(
                          builder: (context, tinterTheme, child) {
                        return Container(
                          height: constraints.maxHeight *
                                  BinomePairMatchesFlock
                                      .fractions['separator'] -
                              20,
                          width: 2.0,
                          color: Theme.of(context).indicatorColor,
                        );
                      }),
                    ),
                  ),
                ],
                if ((state as DiscoverBinomePairMatchesLoadSuccessState)
                        .binomePairMatches
                        .length >=
                    2) ...[
                  // Second head
                  Positioned(
                    top: 0 +
                        constraints.maxHeight *
                            (BinomePairMatchesFlock.fractions['smallHead'] +
                                BinomePairMatchesFlock.fractions['separator']) *
                            animationController.value,
                    child: Consumer<TinterTheme>(
                      builder: (context, tinterTheme, child) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
//                            border: Border.all(
//                              width: 2,
//                              color: tinterTheme.colors.primaryAccent,
//                            ),
                          ),
                          height: constraints.maxHeight *
                              BinomePairMatchesFlock.fractions['smallHead'],
                          width: constraints.maxHeight *
                              BinomePairMatchesFlock.fractions['smallHead'],
                          child: child,
                        );
                      },
                      child: Center(
                        child: BinomePair.getProfilePictureFromBinomePairLogins(
                            loginA: (state
                                    as DiscoverBinomePairMatchesLoadSuccessState)
                                .binomePairMatches[1]
                                .login,
                            loginB: (state
                                    as DiscoverBinomePairMatchesLoadSuccessState)
                                .binomePairMatches[1]
                                .otherLogin,
                            height: constraints.maxHeight *
                                    BinomePairMatchesFlock
                                        .fractions['smallHead'] -
                                10,
                            width: constraints.maxHeight *
                                BinomePairMatchesFlock.fractions['smallHead']),
                      ),
                    ),
                  ),

                  // Second separator
                  Positioned(
                    top: constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['smallHead'] +
                        10 +
                        constraints.maxHeight *
                            (BinomePairMatchesFlock.fractions['smallHead'] +
                                BinomePairMatchesFlock.fractions['separator']) *
                            animationController.value,
                    child: Consumer<TinterTheme>(
                        builder: (context, tinterTheme, child) {
                      return Container(
                        height: constraints.maxHeight *
                                BinomePairMatchesFlock.fractions['separator'] -
                            20,
                        width: 2.0,
                        color: Theme.of(context).indicatorColor,
                      );
                    }),
                  ),
                ],
                if ((state as DiscoverBinomePairMatchesLoadSuccessState)
                        .binomePairMatches
                        .length >=
                    1) ...[
                  // Third head
                  Positioned(
                    top: constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['smallHead'] +
                        constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['separator'] +
                        constraints.maxHeight *
                            (BinomePairMatchesFlock.fractions['smallHead'] +
                                BinomePairMatchesFlock.fractions['separator']) *
                            animationController.value,
                    child: Consumer<TinterTheme>(
                      builder: (context, tinterTheme, child) {
                        return Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
//                            border: Border.all(
//                              width: 2 + 2 * animationController.value,
//                              color: tinterTheme.colors.primaryAccent,
//                            ),
                          ),
                          height: constraints.maxHeight *
                                  BinomePairMatchesFlock
                                      .fractions['smallHead'] +
                              constraints.maxHeight *
                                  (BinomePairMatchesFlock.fractions['bigHead'] -
                                      BinomePairMatchesFlock
                                          .fractions['smallHead']) *
                                  animationController.value,
                          width: constraints.maxHeight *
                                  BinomePairMatchesFlock
                                      .fractions['smallHead'] +
                              constraints.maxHeight *
                                  (BinomePairMatchesFlock.fractions['bigHead'] -
                                      BinomePairMatchesFlock
                                          .fractions['smallHead']) *
                                  animationController.value,
                          child: child,
                        );
                      },
                      child: Center(
                        child: BinomePair.getProfilePictureFromBinomePairLogins(
                            loginA: (state as DiscoverBinomePairMatchesLoadSuccessState)
                                .binomePairMatches[0]
                                .login,
                            loginB: (state as DiscoverBinomePairMatchesLoadSuccessState)
                                .binomePairMatches[0]
                                .otherLogin,
                            height: constraints.maxHeight *
                                    BinomePairMatchesFlock
                                        .fractions['smallHead'] +
                                constraints.maxHeight *
                                    (BinomePairMatchesFlock.fractions['bigHead'] -
                                        BinomePairMatchesFlock
                                            .fractions['smallHead']) *
                                    animationController.value -
                                20,
                            width: constraints.maxHeight *
                                    BinomePairMatchesFlock
                                        .fractions['smallHead'] +
                                constraints.maxHeight *
                                    (BinomePairMatchesFlock.fractions['bigHead'] -
                                        BinomePairMatchesFlock.fractions['smallHead']) *
                                    animationController.value),
                      ),
                    ),
                  ),

                  // Third separator
                  Positioned(
                    top: constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['smallHead'] +
                        constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['separator'] +
                        constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['smallHead'] +
                        10 +
                        50 * animationController.value,
                    child: Opacity(
                      opacity: 1 - animationController.value,
                      child: Consumer<TinterTheme>(
                          builder: (context, tinterTheme, child) {
                        return Container(
                          height: constraints.maxHeight *
                                  BinomePairMatchesFlock
                                      .fractions['separator'] -
                              20,
                          width: 1.5,
                          color: tinterTheme.colors.primaryAccent,
                        );
                      }),
                    ),
                  ),

                  // Name and surname
                  Positioned(
                    top: constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['smallHead'] +
                        constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['separator'] +
                        constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['bigHead'] +
                        animationController.value *
                            (constraints.maxHeight *
                                    BinomePairMatchesFlock
                                        .fractions['smallHead'] +
                                constraints.maxHeight *
                                    BinomePairMatchesFlock
                                        .fractions['separator']) +
                        10.0,
                    child: Opacity(
                      opacity: animationController.value,
                      child: Container(
                        height: constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['nameAndSurname'],
                        child: Consumer<TinterTheme>(
                            builder: (context, tinterTheme, child) {
                          return Column(
                            children: [
                              AutoSizeText(
                                (state as DiscoverBinomePairMatchesLoadSuccessState)
                                        .binomePairMatches[0]
                                        .name +
                                    ' ' +
                                    (state as DiscoverBinomePairMatchesLoadSuccessState)
                                        .binomePairMatches[0]
                                        .surname,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                              AutoSizeText(
                                (state as DiscoverBinomePairMatchesLoadSuccessState)
                                        .binomePairMatches[0]
                                        .otherName +
                                    ' ' +
                                    (state as DiscoverBinomePairMatchesLoadSuccessState)
                                        .binomePairMatches[0]
                                        .otherSurname,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                ],
                if (previousFirstBinomePairMatch != null) ...[
                  // Third head
                  Positioned(
                    top: constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['smallHead'] +
                        constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['separator'] +
                        constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['smallHead'] +
                        constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['separator'] +
                        50 * animationController.value,
                    child: Opacity(
                      opacity: 1 - animationController.value,
                      child: Consumer<TinterTheme>(
                        builder: (context, tinterTheme, child) {
                          return Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: tinterTheme.colors.primaryAccent,
                              ),
                            ),
                            height: constraints.maxHeight *
                                BinomePairMatchesFlock.fractions['bigHead'],
                            width: constraints.maxHeight *
                                BinomePairMatchesFlock.fractions['bigHead'],
                            child: child,
                          );
                        },
                        child: Center(
                          child:
                              BinomePair.getProfilePictureFromBinomePairLogins(
                            loginA: previousFirstBinomePairMatch.login,
                            loginB: previousFirstBinomePairMatch.otherLogin,
                            height: constraints.maxHeight *
                                    BinomePairMatchesFlock
                                        .fractions['bigHead'] -
                                20,
                            width: constraints.maxHeight *
                                BinomePairMatchesFlock.fractions['bigHead'],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Name and surname of the third head
                  Positioned(
                    top: constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['smallHead'] +
                        constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['separator'] +
                        constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['smallHead'] +
                        constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['separator'] +
                        constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['bigHead'] +
                        50 * animationController.value,
                    child: Opacity(
                      opacity: 1 - animationController.value,
                      child: Container(
                        height: constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['nameAndSurname'],
                        child: Consumer<TinterTheme>(
                            builder: (context, tinterTheme, child) {
                          return Column(
                            children: <Widget>[
                              Expanded(
                                child: AutoSizeText(
                                  previousFirstBinomePairMatch.name,
                                  group: nameAndSurnameAutoSizeGroup,
                                  style: tinterTheme.textStyle.headline2,
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  previousFirstBinomePairMatch.surname,
                                  group: nameAndSurnameAutoSizeGroup,
                                  style: tinterTheme.textStyle.headline2,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
                  )
                ],
              ],
            ),
          );
        });
      },
    );
  }
}

/// BinomePairMatchInformation displays a binomePairMatch information
/// in a column.
class BinomePairMatchInformation extends StatefulWidget {
  final Widget separator = SizedBox(
    height: 20,
  );

  BinomePairMatchInformation();

  @override
  _BinomePairMatchInformationState createState() =>
      _BinomePairMatchInformationState();
}

class _BinomePairMatchInformationState
    extends State<BinomePairMatchInformation> {
  ScrollController informationController;

  @override
  void initState() {
    informationController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    informationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15.0,
        ),
        child: BlocListener<DiscoverBinomePairMatchesBloc,
            DiscoverBinomePairMatchesState>(
          listener: (BuildContext context, state) {
            informationController.animateTo(0,
                duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          },
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
              return false;
            },
            child: SingleChildScrollView(
              controller: informationController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 70.0,
                    ),
                    child: Align(
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
                            child: BlocBuilder<DiscoverBinomePairMatchesBloc,
                                DiscoverBinomePairMatchesState>(
                              builder: (BuildContext context,
                                  DiscoverBinomePairMatchesState state) {
                                if (!(state
                                    is DiscoverBinomePairMatchesLoadSuccessState)) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return AnimatedSwitcher(
                                  duration: Duration(milliseconds: 300),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    return ScaleTransition(
                                      child: child,
                                      scale: animation,
                                    );
                                  },
                                  child: Consumer<TinterTheme>(
                                      builder: (context, tinterTheme, child) {
                                    return Text(
                                      (state as DiscoverBinomePairMatchesLoadSuccessState)
                                          .binomePairMatches[0]
                                          .score
                                          .toString(),
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1
                                          .copyWith(
                                            fontWeight: FontWeight.w400,
                                          ),
                                    );
                                  }),
                                );
                              },
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
                                    pageBuilder: (BuildContext context, animation, _) => Material(
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
                                                      style: Theme.of(context).textTheme.headline4,
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
                                                      style: Theme.of(context).textTheme.headline5,
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
                    ),
                  ),
                  widget.separator,
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
                              child: BlocBuilder<DiscoverBinomePairMatchesBloc,
                                  DiscoverBinomePairMatchesState>(
                                builder: (BuildContext context,
                                    DiscoverBinomePairMatchesState state) {
                                  if (!(state
                                      is DiscoverBinomePairMatchesLoadSuccessState)) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Opacity(
                                        opacity:
                                            (state as DiscoverBinomePairMatchesLoadSuccessState)
                                                        .binomePairMatches[0]
                                                        .lieuDeVie !=
                                                    LieuDeVie.maisel
                                                ? 0.5
                                                : 1,
                                        child: Consumer<TinterTheme>(builder:
                                            (context, tinterTheme, child) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                bottomLeft:
                                                    Radius.circular(5.0),
                                                topLeft: Radius.circular(5.0),
                                              ),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            width: 70,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Center(
                                                child: AutoSizeText(
                                                  'MAISEL',
                                                  maxLines: 1,
                                                  minFontSize: 10,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                      Opacity(
                                        opacity:
                                            (state as DiscoverBinomePairMatchesLoadSuccessState)
                                                        .binomePairMatches[0]
                                                        .lieuDeVie !=
                                                    LieuDeVie.other
                                                ? 0.5
                                                : 1,
                                        child: Consumer<TinterTheme>(builder:
                                            (context, tinterTheme, child) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(5.0),
                                                bottomRight:
                                                    Radius.circular(5.0),
                                              ),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            width: 70,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Center(
                                                child: AutoSizeText(
                                                  'Autre',
                                                  maxLines: 1,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .headline5,
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.separator,
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, right: 15.0, top: 10.0, bottom: 15.0),
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
                            child: BlocBuilder<DiscoverBinomePairMatchesBloc,
                                DiscoverBinomePairMatchesState>(
                              builder: (BuildContext context,
                                  DiscoverBinomePairMatchesState state) {
                                if (!(state
                                    is DiscoverBinomePairMatchesLoadSuccessState)) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    Opacity(
                                      opacity:
                                          (state as DiscoverBinomePairMatchesLoadSuccessState)
                                                  .binomePairMatches[0]
                                                  .horairesDeTravail
                                                  .contains(
                                                      HoraireDeTravail.morning)
                                              ? 1
                                              : 0.5,
                                      child: Consumer<TinterTheme>(builder:
                                          (context, tinterTheme, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          width: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0,
                                                vertical: 10.0),
                                            child: Center(
                                              child: AutoSizeText(
                                                'Matin',
                                                maxLines: 1,
                                                minFontSize: 10,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    Opacity(
                                      opacity:
                                          (state as DiscoverBinomePairMatchesLoadSuccessState)
                                                  .binomePairMatches[0]
                                                  .horairesDeTravail
                                                  .contains(HoraireDeTravail
                                                      .afternoon)
                                              ? 1
                                              : 0.5,
                                      child: Consumer<TinterTheme>(builder:
                                          (context, tinterTheme, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          width: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0,
                                                vertical: 10.0),
                                            child: Center(
                                              child: AutoSizeText(
                                                'Aprem',
                                                maxLines: 1,
                                                minFontSize: 10,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    Opacity(
                                      opacity:
                                          (state as DiscoverBinomePairMatchesLoadSuccessState)
                                                  .binomePairMatches[0]
                                                  .horairesDeTravail
                                                  .contains(
                                                      HoraireDeTravail.evening)
                                              ? 1
                                              : 0.5,
                                      child: Consumer<TinterTheme>(builder:
                                          (context, tinterTheme, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          width: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0,
                                                vertical: 10.0),
                                            child: Center(
                                              child: AutoSizeText(
                                                'Soir',
                                                maxLines: 1,
                                                minFontSize: 10,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    Opacity(
                                      opacity:
                                          (state as DiscoverBinomePairMatchesLoadSuccessState)
                                                  .binomePairMatches[0]
                                                  .horairesDeTravail
                                                  .contains(
                                                      HoraireDeTravail.night)
                                              ? 1
                                              : 0.5,
                                      child: Consumer<TinterTheme>(builder:
                                          (context, tinterTheme, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                          width: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0,
                                                vertical: 10.0),
                                            child: Center(
                                              child: AutoSizeText(
                                                'Nuit',
                                                maxLines: 1,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.separator,
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, top: 10.0, bottom: 15.0),
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
                                BlocBuilder<DiscoverBinomePairMatchesBloc,
                                    DiscoverBinomePairMatchesState>(
                                  builder: (BuildContext context,
                                      DiscoverBinomePairMatchesState state) {
                                    if (!(state
                                        is DiscoverBinomePairMatchesLoadSuccessState)) {
                                      return Container(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    return (state as DiscoverBinomePairMatchesLoadSuccessState)
                                                .binomePairMatches[0]
                                                .associations
                                                .length >=
                                            1
                                        ? Container(
                                            height: 60,
                                            child: AnimatedSwitcher(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              child: ListView.separated(
                                                key: GlobalKey(),
                                                shrinkWrap: true,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: (state
                                                        as DiscoverBinomePairMatchesLoadSuccessState)
                                                    .binomePairMatches[0]
                                                    .associations
                                                    .length,
                                                separatorBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return SizedBox(
                                                    width: 5,
                                                  );
                                                },
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return associationBubble(
                                                      context,
                                                      (state as DiscoverBinomePairMatchesLoadSuccessState)
                                                          .binomePairMatches[0]
                                                          .associations[index]);
                                                },
                                              ),
                                            ),
                                          )
                                        : Text(
                                            'Aucune association sélectionnée',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline5,
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  widget.separator,
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
                              maxLines: 1,
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
                                        overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 0.0),
                                        trackHeight: 6.0,
                                        disabledInactiveTrackColor:
                                            Theme.of(context).indicatorColor,
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 8.0),
                                      ),
                                  child: BlocBuilder<
                                      DiscoverBinomePairMatchesBloc,
                                      DiscoverBinomePairMatchesState>(
                                    builder: (BuildContext context,
                                        DiscoverBinomePairMatchesState state) {
                                      if (!(state
                                          is DiscoverBinomePairMatchesLoadSuccessState)) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return TweenAnimationBuilder(
                                        tween: Tween<double>(
                                            begin: 0.5,
                                            end: (state
                                                    as DiscoverBinomePairMatchesLoadSuccessState)
                                                .binomePairMatches[0]
                                                .groupeOuSeul),
                                        duration: Duration(milliseconds: 300),
                                        builder: (BuildContext context, value,
                                            Widget child) {
                                          return Slider(
                                            value: value,
                                            onChanged: null,
                                          );
                                        },
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
                  widget.separator,
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
                              maxLines: 1,
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
                                        overlayShape: RoundSliderOverlayShape(
                                            overlayRadius: 0.0),
                                        trackHeight: 6.0,
                                        disabledInactiveTrackColor:
                                            Theme.of(context).indicatorColor,
                                        thumbShape: RoundSliderThumbShape(
                                            enabledThumbRadius: 8.0),
                                      ),
                                  child: BlocBuilder<
                                      DiscoverBinomePairMatchesBloc,
                                      DiscoverBinomePairMatchesState>(
                                    builder: (BuildContext context,
                                        DiscoverBinomePairMatchesState state) {
                                      if (!(state
                                          is DiscoverBinomePairMatchesLoadSuccessState)) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return TweenAnimationBuilder(
                                        tween: Tween<double>(
                                            begin: 0.5,
                                            end: (state
                                                    as DiscoverBinomePairMatchesLoadSuccessState)
                                                .binomePairMatches[0]
                                                .enligneOuNon),
                                        duration: Duration(milliseconds: 300),
                                        builder: (BuildContext context, value,
                                            Widget child) {
                                          return Slider(
                                            value: value,
                                            onChanged: null,
                                          );
                                        },
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
                  widget.separator,
                  Padding(
                    padding: const EdgeInsets.only(bottom: 80.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 15.0),
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
                              BlocBuilder<DiscoverBinomePairMatchesBloc,
                                  DiscoverBinomePairMatchesState>(
                                builder: (BuildContext context,
                                    DiscoverBinomePairMatchesState state) {
                                  if (!(state
                                      is DiscoverBinomePairMatchesLoadSuccessState)) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return (state as DiscoverBinomePairMatchesLoadSuccessState)
                                              .binomePairMatches[0]
                                              .matieresPreferees
                                              .length >=
                                          1
                                      ? AnimatedSwitcher(
                                          duration: Duration(milliseconds: 300),
                                          child: Wrap(
                                            alignment: WrapAlignment.center,
                                            key: GlobalKey(),
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: <Widget>[
                                              for (String matierePreferee in (state
                                                      as DiscoverBinomePairMatchesLoadSuccessState)
                                                  .binomePairMatches[0]
                                                  .matieresPreferees)
                                                Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15.0,
                                                      vertical: 6.0),
                                                  decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.2),
                                                        spreadRadius: 0.2,
                                                        blurRadius: 5,
                                                        offset: Offset(2, 2),
                                                      )
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                    border: Border.all(
                                                        color:
                                                            (Theme.of(context)
                                                                .primaryColor),
                                                        width: 3.0,
                                                        style:
                                                            BorderStyle.solid),
                                                    color: Colors.white,
                                                  ),
                                                  child: Text(matierePreferee),
                                                ),
                                            ],
                                          ),
                                        )
                                      : Text('Aucune matière sélectionnée',
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5,
                                          textAlign: TextAlign.center);
                                },
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget informationRectangle(
      {@required BuildContext context,
      @required Widget child,
      double width,
      double height}) {
    return Align(
      alignment: AlignmentDirectional.center,
      child: Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return Container(
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
        Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SliderLabel(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 3.0, vertical: 2.0),
                  child: Text(
                    leftLabel,
                    style: tinterTheme.textStyle.smallLabel,
                  ),
                ),
                side: Side.Left,
                triangleSize: 14,
              ),
              SliderLabel(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 3.0, vertical: 2.0),
                  child: Text(
                    rightLabel,
                    style: tinterTheme.textStyle.smallLabel,
                  ),
                ),
                side: Side.Right,
                triangleSize: 14,
              ),
            ],
          );
        }),
        Padding(
          padding: const EdgeInsets.only(top: 13.0, left: 4, right: 4),
          child: slider,
        ),
      ],
    );
  }
}

class NoPaddingTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop =
        offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 5;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class NoMoreDiscoveryBinomePairMatchesWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 50,
            ),
            child: BinomePairWideStudentSearch(),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return Icon(
                      Icons.sentiment_very_dissatisfied_rounded,
                      color: Colors.black87,
                      size: 70,
                    );
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        right: 20.0,
                        bottom: 60.0,
                      ),
                      child: AutoSizeText(
                        "Il n'y a plus de paires de binôme à découvrir pour l'instant. Demande à d'autres étudiant.e.s de s'inscrire !",
                        style: Theme.of(context)
                            .textTheme
                            .headline5
                            .copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BinomePairWideStudentSearch extends StatelessWidget {
  const BinomePairWideStudentSearch({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SearchStudentBinomePairTab2()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          border: Border.all(
              color: Colors.white, width: 4.0, style: BorderStyle.solid),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(3, 3),
            ),
          ],
          borderRadius: BorderRadius.all(
            Radius.circular(15.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 3.0),
                child: Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                ),
              ),
              Text(
                'rechercher une paire de binôme',
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: Colors.white, height: 1.15),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
