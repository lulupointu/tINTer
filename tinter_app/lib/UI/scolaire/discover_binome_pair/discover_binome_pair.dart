import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/scolaire/discover_binome_pair_matches/discover_binome_pair_matches_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/association_logo.dart';
import 'package:tinterapp/Logic/models/scolaire/binome_pair.dart';
import 'package:tinterapp/Logic/models/scolaire/binome_pair_match.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/Logic/models/shared/user_profile_picture.dart';
import 'package:tinterapp/UI/associatif/discover/recherche_etudiant.dart';
import 'package:tinterapp/UI/scolaire/discover_binome_pair/recherche_binome_pair.dart';
import 'package:tinterapp/UI/shared/score_popup_helper/score_popup_helper.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/shared_element/custom_flare_controller.dart';
import 'package:tinterapp/UI/shared/shared_element/slider_label.dart';

class DiscoverBinomePairTab extends StatelessWidget {
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

    return BlocBuilder<DiscoverBinomePairMatchesBloc, DiscoverBinomePairMatchesState>(builder:
        (BuildContext context, DiscoverBinomePairMatchesState discoverBinomePairMatchesState) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (discoverBinomePairMatchesState is DiscoverBinomePairMatchesInitialState ||
              discoverBinomePairMatchesState is DiscoverBinomePairMatchesLoadInProgressState)
            return Center(
              child: Center(child: CircularProgressIndicator(),),
            );
          if (discoverBinomePairMatchesState is DiscoverBinomePairMatchesLoadSuccessState &&
              discoverBinomePairMatchesState.binomePairMatches.length == 0)
            return NoMoreDiscoveryBinomePairMatchesWidget();
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
                child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                  return SvgPicture.asset(
                    'assets/discover/DiscoverBackground.svg',
                    color: tinterTheme.colors.background,
                    height: constraints.maxHeight,
                  );
                }),
              ),
              Positioned(
                left: constraints.maxWidth * 55 / 100,
                child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                  return SvgPicture.asset(
                    'assets/discover/DiscoverTop.svg',
                    color: tinterTheme.colors.primaryAccent,
                    height: constraints.maxHeight / 2,
                  );
                }),
              ),
              Positioned(
                left: constraints.maxWidth * 55 / 100,
                bottom: 0,
                child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                  return SvgPicture.asset(
                    'assets/discover/DiscoverBottom.svg',
                    color: tinterTheme.colors.primaryAccent,
                    height: constraints.maxHeight / 2,
                  );
                }),
              ),
            ],
          );
        },
      );
    });
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
          color: tinterTheme.colors.background,
          child: child,
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            StudentSearch(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                height: ((this.appHeight - 8 * 2 - 50 - 15) - this.appHeight * 1 / 2) /
                    (1 -
                        (1 / 2 * BinomePairMatchesFlock.fractions['bigHead'] +
                            BinomePairMatchesFlock.fractions['nameAndSurname'])),
                child: BinomePairMatchesFlock(),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            LikeOrIgnore(),
          ],
        ),
      ),
    );
  }
}

class StudentSearch extends StatelessWidget {
  final double height;

  const StudentSearch({Key key, @required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
              color: tinterTheme.colors.secondary,
            ),
            child: child,
          );
        },
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RechercheEtudiantAssociatifTab()),
            );
          },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  child: Hero(
                    tag: 'studentSearchBar',
                    child: Material(
                      color: Colors.transparent,
                      child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            color: tinterTheme.colors.secondary,
                          ),
                          child: TextField(
                            enabled: false,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              icon: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Icon(
                                  Icons.search,
                                  color: tinterTheme.colors.primaryAccent,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Flexible(
                  child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return AutoSizeText(
                      'Rechercher une\n paire de binome',
                      style: tinterTheme.textStyle.hint,
                      maxLines: 2,
                    );
                  }),
                ),
              ],
            ),
          ),
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

class _LikeOrIgnoreState extends State<LikeOrIgnore> with TickerProviderStateMixin {
  AnimationController likeController;
  Animation<double> likeAnimation;
  AnimationController ignoreController;
  Animation<double> ignoreAnimation;

  @override
  void initState() {
    likeController =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    likeAnimation = CurveTween(curve: Curves.easeOut).animate(likeController)
      ..addListener(() {
        setState(() {});
      });
    ignoreController =
        AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    ignoreAnimation = CurveTween(curve: Curves.easeOut).animate(ignoreController)
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Flexible(
          child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
            return IconButton(
              padding: EdgeInsets.all(0.0),
              iconSize: 60,
              color: tinterTheme.colors.secondary,
              icon: FlareActor(
                'assets/icons/Heart.flr',
                color: tinterTheme.colors.secondary,
                fit: BoxFit.contain,
                controller: CustomFlareController(
                    controller: likeController, forwardAnimationName: 'Validate'),
              ),
              onPressed: () {
                likeController.forward().whenComplete(
                    () => likeController.animateTo(0, duration: Duration(seconds: 0)));
                BlocProvider.of<DiscoverBinomePairMatchesBloc>(context)
                    .add(DiscoverBinomePairMatchesLikeEvent());
              },
            );
          }),
        ),
        Flexible(
          child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
            return IconButton(
              padding: EdgeInsets.all(0.0),
              iconSize: 60,
              color: tinterTheme.colors.secondary,
              icon: FlareActor(
                'assets/icons/Clear.flr',
                color: tinterTheme.colors.secondary,
                fit: BoxFit.contain,
                controller: CustomFlareController(
                  controller: ignoreController,
                  forwardAnimationName: 'Ignore',
                ),
              ),
              onPressed: () {
                ignoreController.forward().whenComplete(
                    () => ignoreController.animateTo(0, duration: Duration(seconds: 0)));
                BlocProvider.of<DiscoverBinomePairMatchesBloc>(context)
                    .add(DiscoverBinomePairMatchesIgnoreEvent());
              },
            );
          }),
        ),
      ],
    );
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
        return BlocBuilder<DiscoverBinomePairMatchesBloc, DiscoverBinomePairMatchesState>(
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
        }, builder: (BuildContext context, DiscoverBinomePairMatchesState state) {
          if (!(state is DiscoverBinomePairMatchesLoadSuccessState)) {
            return Center(child: CircularProgressIndicator(),);
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
                              loginA: (state as DiscoverBinomePairMatchesLoadSuccessState)
                                  .binomePairMatches[2]
                                  .login,
                              loginB: (state as DiscoverBinomePairMatchesLoadSuccessState)
                                  .binomePairMatches[2]
                                  .otherLogin,
                              height: constraints.maxHeight *
                                      BinomePairMatchesFlock.fractions['smallHead'] -
                                  10,
                              width: constraints.maxHeight *
                                  BinomePairMatchesFlock.fractions['smallHead']),
                        ),
                      ),
                    ),
                  ),

                  // First separator
                  Positioned(
                    top:
                        constraints.maxHeight * BinomePairMatchesFlock.fractions['smallHead'] +
                            10 -
                            50 * (1 - animationController.value),
                    child: Opacity(
                      opacity: animationController.value,
                      child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                        return Container(
                          height: constraints.maxHeight *
                                  BinomePairMatchesFlock.fractions['separator'] -
                              20,
                          width: 1.5,
                          color: tinterTheme.colors.primaryAccent,
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
                            loginA: (state as DiscoverBinomePairMatchesLoadSuccessState)
                                .binomePairMatches[1]
                                .login,
                            loginB: (state as DiscoverBinomePairMatchesLoadSuccessState)
                                .binomePairMatches[1]
                                .otherLogin,
                            height: constraints.maxHeight *
                                    BinomePairMatchesFlock.fractions['smallHead'] -
                                10,
                            width: constraints.maxHeight *
                                BinomePairMatchesFlock.fractions['smallHead']),
                      ),
                    ),
                  ),

                  // Second separator
                  Positioned(
                    top:
                        constraints.maxHeight * BinomePairMatchesFlock.fractions['smallHead'] +
                            10 +
                            constraints.maxHeight *
                                (BinomePairMatchesFlock.fractions['smallHead'] +
                                    BinomePairMatchesFlock.fractions['separator']) *
                                animationController.value,
                    child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                      return Container(
                        height: constraints.maxHeight *
                                BinomePairMatchesFlock.fractions['separator'] -
                            20,
                        width: 1.5,
                        color: tinterTheme.colors.primaryAccent,
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
                        constraints.maxHeight * BinomePairMatchesFlock.fractions['separator'] +
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
                                  BinomePairMatchesFlock.fractions['smallHead'] +
                              constraints.maxHeight *
                                  (BinomePairMatchesFlock.fractions['bigHead'] -
                                      BinomePairMatchesFlock.fractions['smallHead']) *
                                  animationController.value,
                          width: constraints.maxHeight *
                                  BinomePairMatchesFlock.fractions['smallHead'] +
                              constraints.maxHeight *
                                  (BinomePairMatchesFlock.fractions['bigHead'] -
                                      BinomePairMatchesFlock.fractions['smallHead']) *
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
                                    BinomePairMatchesFlock.fractions['smallHead'] +
                                constraints.maxHeight *
                                    (BinomePairMatchesFlock.fractions['bigHead'] -
                                        BinomePairMatchesFlock.fractions['smallHead']) *
                                    animationController.value -
                                20,
                            width: constraints.maxHeight *
                                    BinomePairMatchesFlock.fractions['smallHead'] +
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
                        constraints.maxHeight * BinomePairMatchesFlock.fractions['separator'] +
                        constraints.maxHeight * BinomePairMatchesFlock.fractions['smallHead'] +
                        10 +
                        50 * animationController.value,
                    child: Opacity(
                      opacity: 1 - animationController.value,
                      child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                        return Container(
                          height: constraints.maxHeight *
                                  BinomePairMatchesFlock.fractions['separator'] -
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
                        constraints.maxHeight * BinomePairMatchesFlock.fractions['separator'] +
                        constraints.maxHeight * BinomePairMatchesFlock.fractions['bigHead'] +
                        animationController.value *
                            (constraints.maxHeight *
                                    BinomePairMatchesFlock.fractions['smallHead'] +
                                constraints.maxHeight *
                                    BinomePairMatchesFlock.fractions['separator']),
                    child: Opacity(
                      opacity: animationController.value,
                      child: Container(
                        height: constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['nameAndSurname'],
                        child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                          return Column(
                            children: <Widget>[
                              Expanded(
                                child: AutoSizeText(
                                  (state as DiscoverBinomePairMatchesLoadSuccessState)
                                          .binomePairMatches[0]
                                          .name +
                                      ' ' +
                                      (state as DiscoverBinomePairMatchesLoadSuccessState)
                                          .binomePairMatches[0]
                                          .surname,
                                  group: nameAndSurnameAutoSizeGroup,
                                  style: tinterTheme.textStyle.headline2,
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  '&',
                                  group: nameAndSurnameAutoSizeGroup,
                                  style: tinterTheme.textStyle.headline2,
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  (state as DiscoverBinomePairMatchesLoadSuccessState)
                                          .binomePairMatches[0]
                                          .otherName +
                                      ' ' +
                                      (state as DiscoverBinomePairMatchesLoadSuccessState)
                                          .binomePairMatches[0]
                                          .otherSurname,
                                  group: nameAndSurnameAutoSizeGroup,
                                  style: tinterTheme.textStyle.headline2,
                                ),
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
                        constraints.maxHeight * BinomePairMatchesFlock.fractions['separator'] +
                        constraints.maxHeight * BinomePairMatchesFlock.fractions['smallHead'] +
                        constraints.maxHeight * BinomePairMatchesFlock.fractions['separator'] +
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
                          child: BinomePair.getProfilePictureFromBinomePairLogins(
                            loginA: previousFirstBinomePairMatch.login,
                            loginB: previousFirstBinomePairMatch.otherLogin,
                            height: constraints.maxHeight *
                                    BinomePairMatchesFlock.fractions['bigHead'] -
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
                        constraints.maxHeight * BinomePairMatchesFlock.fractions['separator'] +
                        constraints.maxHeight * BinomePairMatchesFlock.fractions['smallHead'] +
                        constraints.maxHeight * BinomePairMatchesFlock.fractions['separator'] +
                        constraints.maxHeight * BinomePairMatchesFlock.fractions['bigHead'] +
                        50 * animationController.value,
                    child: Opacity(
                      opacity: 1 - animationController.value,
                      child: Container(
                        height: constraints.maxHeight *
                            BinomePairMatchesFlock.fractions['nameAndSurname'],
                        child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
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
    height: 50,
  );

  BinomePairMatchInformation();

  @override
  _BinomePairMatchInformationState createState() => _BinomePairMatchInformationState();
}

class _BinomePairMatchInformationState extends State<BinomePairMatchInformation> {
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: BlocListener<DiscoverBinomePairMatchesBloc, DiscoverBinomePairMatchesState>(
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
                  padding: const EdgeInsets.only(top: 15.0),
                  child: informationRectangle(
                    context: context,
                    height: 150,
                    width: 150,
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
                                BlocBuilder<DiscoverBinomePairMatchesBloc,
                                        DiscoverBinomePairMatchesState>(
                                    builder: (BuildContext context,
                                        DiscoverBinomePairMatchesState state) {
                                  if (!(state is DiscoverBinomePairMatchesLoadSuccessState)) {
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                                  return AnimatedSwitcher(
                                    duration: Duration(milliseconds: 300),
                                    transitionBuilder:
                                        (Widget child, Animation<double> animation) {
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
                                        key: GlobalKey(),
                                        style: TextStyle(
                                          fontSize: 50,
                                          fontWeight: FontWeight.bold,
                                          color: tinterTheme.textStyle.headline1.color,
                                        ),
                                      );
                                    }),
                                  );
                                }),
                              ],
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: InkWell(
                              onTap: () => showWhatIsScore(context),
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                return Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: tinterTheme.colors.defaultTextColor, width: 2),
                                  ),
                                  height: 20,
                                  width: 20,
                                  child: Center(
                                    child: Text(
                                      '?',
                                      style: TextStyle(
                                        color: tinterTheme.colors.defaultTextColor,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                widget.separator,
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
                          width: double.infinity,
                          child: Container(
                            height: 60,
                            child: BlocBuilder<DiscoverBinomePairMatchesBloc,
                                DiscoverBinomePairMatchesState>(
                              builder: (BuildContext context,
                                  DiscoverBinomePairMatchesState state) {
                                if (!(state is DiscoverBinomePairMatchesLoadSuccessState)) {
                                  return Center(child: CircularProgressIndicator(),);
                                }
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Row(
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
                                        opacity:
                                            (state as DiscoverBinomePairMatchesLoadSuccessState)
                                                        .binomePairMatches[0]
                                                        .lieuDeVie !=
                                                    LieuDeVie.other
                                                ? 0.5
                                                : 1,
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
                          child: BlocBuilder<DiscoverBinomePairMatchesBloc,
                              DiscoverBinomePairMatchesState>(
                            builder:
                                (BuildContext context, DiscoverBinomePairMatchesState state) {
                              if (!(state is DiscoverBinomePairMatchesLoadSuccessState)) {
                                return Center(child: CircularProgressIndicator(),);
                              }
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10.0),
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    Opacity(
                                      opacity:
                                          (state as DiscoverBinomePairMatchesLoadSuccessState)
                                                  .binomePairMatches[0]
                                                  .horairesDeTravail
                                                  .contains(HoraireDeTravail.morning)
                                              ? 1
                                              : 0.5,
                                      child: Consumer<TinterTheme>(
                                          builder: (context, tinterTheme, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            color: tinterTheme.colors.primaryAccent,
                                          ),
                                          width: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0, vertical: 10.0),
                                            child: Center(
                                              child: AutoSizeText(
                                                'Matin',
                                                maxLines: 1,
                                                minFontSize: 10,
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
                                                  .contains(HoraireDeTravail.afternoon)
                                              ? 1
                                              : 0.5,
                                      child: Consumer<TinterTheme>(
                                          builder: (context, tinterTheme, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            color: tinterTheme.colors.primaryAccent,
                                          ),
                                          width: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0, vertical: 10.0),
                                            child: Center(
                                              child: AutoSizeText(
                                                'Aprem',
                                                maxLines: 1,
                                                minFontSize: 10,
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
                                                  .contains(HoraireDeTravail.evening)
                                              ? 1
                                              : 0.5,
                                      child: Consumer<TinterTheme>(
                                          builder: (context, tinterTheme, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            color: tinterTheme.colors.primaryAccent,
                                          ),
                                          width: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0, vertical: 10.0),
                                            child: Center(
                                              child: AutoSizeText(
                                                'Soir',
                                                maxLines: 1,
                                                minFontSize: 10,
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
                                                  .contains(HoraireDeTravail.night)
                                              ? 1
                                              : 0.5,
                                      child: Consumer<TinterTheme>(
                                          builder: (context, tinterTheme, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(5.0),
                                            ),
                                            color: tinterTheme.colors.primaryAccent,
                                          ),
                                          width: 60,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 4.0, vertical: 10.0),
                                            child: Center(
                                              child: AutoSizeText(
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
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.separator,
                informationRectangle(
                  context: context,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
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
                          child: Stack(
                            alignment: AlignmentDirectional.centerStart,
                            children: <Widget>[
                              Container(
                                height: 60,
                                child: BlocBuilder<DiscoverBinomePairMatchesBloc,
                                    DiscoverBinomePairMatchesState>(
                                  builder: (BuildContext context,
                                      DiscoverBinomePairMatchesState state) {
                                    if (!(state
                                        is DiscoverBinomePairMatchesLoadSuccessState)) {
                                      return Center(child: CircularProgressIndicator(),);
                                    }
                                    return AnimatedSwitcher(
                                      duration: Duration(milliseconds: 300),
                                      child: Center(
                                        child: ListView.separated(
                                          key: GlobalKey(),
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemCount: (state
                                                  as DiscoverBinomePairMatchesLoadSuccessState)
                                              .binomePairMatches[0]
                                              .associations
                                              .length,
                                          separatorBuilder: (BuildContext context, int index) {
                                            return SizedBox(
                                              width: 5,
                                            );
                                          },
                                          itemBuilder: (BuildContext context, int index) {
                                            return associationBubble(
                                                context,
                                                (state as DiscoverBinomePairMatchesLoadSuccessState)
                                                    .binomePairMatches[0]
                                                    .associations[index]);
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.separator,
                informationRectangle(
                  context: context,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                          return AutoSizeText(
                            'Seul.e ou en groupe?',
                            style: tinterTheme.textStyle.headline2,
                            maxLines: 1,
                          );
                        }),
                        SizedBox(
                          height: 15,
                        ),
                        discoverSlider(
                            context,
                            Consumer<TinterTheme>(
                              builder: (context, tinterTheme, child) {
                                return SliderTheme(
                                  data: tinterTheme.slider.disabled,
                                  child: child,
                                );
                              },
                              child: BlocBuilder<DiscoverBinomePairMatchesBloc,
                                  DiscoverBinomePairMatchesState>(
                                builder: (BuildContext context,
                                    DiscoverBinomePairMatchesState state) {
                                  if (!(state is DiscoverBinomePairMatchesLoadSuccessState)) {
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                                  return TweenAnimationBuilder(
                                    tween: Tween<double>(
                                        begin: 0.5,
                                        end: (state
                                                as DiscoverBinomePairMatchesLoadSuccessState)
                                            .binomePairMatches[0]
                                            .groupeOuSeul),
                                    duration: Duration(milliseconds: 300),
                                    builder: (BuildContext context, value, Widget child) {
                                      return Slider(
                                        value: value,
                                        onChanged: null,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            leftLabel: 'Seul',
                            rightLabel: 'Groupe'),
                      ],
                    ),
                  ),
                ),
                widget.separator,
                informationRectangle(
                  context: context,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                          return AutoSizeText(
                            'En ligne ou à l\'école?',
                            style: tinterTheme.textStyle.headline2,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                          );
                        }),
                        SizedBox(
                          height: 15,
                        ),
                        discoverSlider(
                            context,
                            Consumer<TinterTheme>(
                              builder: (context, tinterTheme, child) {
                                return SliderTheme(
                                  data: tinterTheme.slider.disabled,
                                  child: child,
                                );
                              },
                              child: BlocBuilder<DiscoverBinomePairMatchesBloc,
                                  DiscoverBinomePairMatchesState>(
                                builder: (BuildContext context,
                                    DiscoverBinomePairMatchesState state) {
                                  if (!(state is DiscoverBinomePairMatchesLoadSuccessState)) {
                                    return Center(child: CircularProgressIndicator(),);
                                  }
                                  return TweenAnimationBuilder(
                                    tween: Tween<double>(
                                        begin: 0.5,
                                        end: (state
                                                as DiscoverBinomePairMatchesLoadSuccessState)
                                            .binomePairMatches[0]
                                            .enligneOuNon),
                                    duration: Duration(milliseconds: 300),
                                    builder: (BuildContext context, value, Widget child) {
                                      return Slider(
                                        value: value,
                                        onChanged: null,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                            leftLabel: 'En ligne',
                            rightLabel: 'A l\'école'),
                      ],
                    ),
                  ),
                ),
                widget.separator,
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: informationRectangle(
                    context: context,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        children: <Widget>[
                          Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                            return Text(
                              'Matières préférées',
                              style: tinterTheme.textStyle.headline2,
                            );
                          }),
                          SizedBox(height: 8.0),
                          BlocBuilder<DiscoverBinomePairMatchesBloc,
                              DiscoverBinomePairMatchesState>(
                            builder:
                                (BuildContext context, DiscoverBinomePairMatchesState state) {
                              if (!(state is DiscoverBinomePairMatchesLoadSuccessState)) {
                                return Center(child: CircularProgressIndicator(),);
                              }
                              return AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                child: Wrap(
                                  key: GlobalKey(),
                                  spacing: 15,
                                  alignment: WrapAlignment.center,
                                  children: <Widget>[
                                    for (String matierePreferee
                                        in (state as DiscoverBinomePairMatchesLoadSuccessState)
                                            .binomePairMatches[0]
                                            .matieresPreferees)
                                      Consumer<TinterTheme>(
                                          builder: (context, tinterTheme, child) {
                                        return Chip(
                                          label: Text(matierePreferee),
                                          labelStyle: tinterTheme.textStyle.chipLiked,
                                          backgroundColor: tinterTheme.colors.primaryAccent,
                                        );
                                      })
                                  ],
                                ),
                              );
                            },
                          )
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

  Widget informationRectangle(
      {@required BuildContext context, @required Widget child, double width, double height}) {
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
            border: Border.all(color: tinterTheme.textStyle.headline1.color, width: 3),
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
                  padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
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
                  padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
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
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
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
          WideStudentSearch(
            height: 40,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return AutoSizeText(
                      "Il n'y a plus de paire de binome à découvrir pour l'instant.\nDemande à d'autres étudiants de s'inscrire!",
                      style: tinterTheme.textStyle.headline2.copyWith(height: 2),
                      textAlign: TextAlign.center,
                      maxLines: 2,
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

class WideStudentSearch extends StatelessWidget {
  final double height;

  const WideStudentSearch({Key key, @required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return Container(
            height: height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
              color: tinterTheme.colors.primaryAccent,
            ),
            child: child,
          );
        },
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RechercheEtudiantBinomePairTab()),
            );
          },
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30,
                  child: Hero(
                    tag: 'studentSearchBar',
                    child: Material(
                      color: Colors.transparent,
                      child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            color: tinterTheme.colors.primaryAccent,
                          ),
                          child: TextField(
                            enabled: false,
                            textInputAction: TextInputAction.search,
                            decoration: InputDecoration(
                              focusedBorder: InputBorder.none,
                              icon: Padding(
                                padding: const EdgeInsets.only(left: 0),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                Flexible(
                  child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return AutoSizeText(
                      'Rechercher une paire de binome',
                      style: tinterTheme.textStyle.hintLarge,
                      maxLines: 1,
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
