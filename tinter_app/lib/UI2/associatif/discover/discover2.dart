import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/associatif/discover_matches/discover_matches_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/association_logo.dart';
import 'package:tinterapp/Logic/models/shared/user_profile_picture.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';
import 'package:tinterapp/UI/shared/score_popup_helper/score_popup_helper.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/shared_element/custom_flare_controller.dart';
import 'package:tinterapp/UI/shared/shared_element/slider_label.dart';
import 'package:tinterapp/UI2/associatif/discover/recherche_etudiant2.dart';

class DiscoverAssociatifTab2 extends StatelessWidget implements TinterTab {
  @override
  Widget build(BuildContext context) {
    // Update to last information
    if (BlocProvider.of<DiscoverMatchesBloc>(context).state
        is DiscoverMatchesLoadSuccessState) {
      BlocProvider.of<DiscoverMatchesBloc>(context)
          .add(DiscoverMatchesRefreshEvent());
    } else {
      BlocProvider.of<DiscoverMatchesBloc>(context)
          .add(DiscoverMatchesRequestedEvent());
    }

    return BlocBuilder<DiscoverMatchesBloc, DiscoverMatchesState>(builder:
        (BuildContext context, DiscoverMatchesState discoverMatchesState) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (discoverMatchesState is DiscoverMatchesInitialState ||
              discoverMatchesState is DiscoverMatchesLoadInProgressState)
            return Center(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          if (discoverMatchesState is DiscoverMatchesLoadSuccessState &&
              discoverMatchesState.matches.length == 0)
            return NoMoreDiscoveryMatchesWidget();
          return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
            return Stack(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 55,
                      child: MatchInformation(),
                    ),
                    Expanded(
                      flex: 45,
                      child: DiscoverRight(constraints.maxHeight),
                    ),
                  ],
                ),
                Positioned(
                  left: constraints.maxWidth * 55 / 100,
                  child: SvgPicture.asset(
                    'assets/discover/DiscoverBackground.svg',
                    color: Theme.of(context).scaffoldBackgroundColor,
                    height: constraints.maxHeight,
                  ),
                ),
                Positioned(
                  left: constraints.maxWidth * 55 / 100,
                  child: SvgPicture.asset(
                    'assets/discover/DiscoverTop.svg',
                    color: Theme.of(context).primaryColor,
                    height: constraints.maxHeight / 2,
                  ),
                ),
                Positioned(
                  left: constraints.maxWidth * 55 / 100,
                  bottom: 0,
                  child: SvgPicture.asset(
                    'assets/discover/DiscoverBottom.svg',
                    color: Theme.of(context).primaryColor,
                    height: constraints.maxHeight / 2,
                  ),
                ),
              ],
            );
          });
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
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
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
                height: ((this.appHeight - 8 * 2 - 50 - 15) -
                        this.appHeight * 1 / 2) /
                    (1 -
                        (1 / 2 * MatchesFlock.fractions['bigHead'] +
                            MatchesFlock.fractions['nameAndSurname'])),
                child: MatchesFlock(),
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
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchStudentAssociatifTab2()),
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
                          child: Container(
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
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: AutoSizeText(
                        'Rechercher\nun.e étudiant.e',
                        style: tinterTheme.textStyle.hint,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
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
    return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
      return BlocBuilder<DiscoverMatchesBloc, DiscoverMatchesState>(
          builder: (context, DiscoverMatchesState discoverMatchesState) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Flexible(
              child: IconButton(
                padding: EdgeInsets.all(0.0),
                iconSize: 60,
                color: tinterTheme.colors.secondary,
                icon: FlareActor(
                  'assets/icons/Heart.flr',
                  color: tinterTheme.colors.secondary,
                  fit: BoxFit.contain,
                  controller: CustomFlareController(
                      controller: likeController,
                      forwardAnimationName: 'Validate'),
                ),
                onPressed:
                    discoverMatchesState is DiscoverMatchesSavingNewStatusState
                        ? null
                        : () {
                            likeController.forward().whenComplete(() =>
                                likeController.animateTo(0,
                                    duration: Duration(seconds: 0)));
                            BlocProvider.of<DiscoverMatchesBloc>(context)
                                .add(DiscoverMatchLikeEvent());
                          },
              ),
            ),
            Flexible(
              child: IconButton(
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
                onPressed:
                    discoverMatchesState is DiscoverMatchesSavingNewStatusState
                        ? null
                        : () {
                            ignoreController.forward().whenComplete(() =>
                                ignoreController.animateTo(0,
                                    duration: Duration(seconds: 0)));
                            BlocProvider.of<DiscoverMatchesBloc>(context)
                                .add(DiscoverMatchIgnoreEvent());
                          },
              ),
            ),
          ],
        );
      });
    });
  }
}

class MatchesFlock extends StatefulWidget {
  MatchesFlock();

  // fraction describes the proportions
  // of each part of the widget
  static final Map<String, double> fractions = {
    'nameAndSurname': 14 / 100,
    'bigHead': 26 / 100,
    'smallHead': 15 / 100,
    'separator': 15 / 100,
  };

  @override
  _MatchesFlockState createState() => _MatchesFlockState();
}

class _MatchesFlockState extends State<MatchesFlock>
    with SingleTickerProviderStateMixin {
  final AutoSizeGroup nameAndSurnameAutoSizeGroup = AutoSizeGroup();
  AnimationController animationController;
  BuildMatch previousFirstMatch;

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
        return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
          return BlocBuilder<DiscoverMatchesBloc, DiscoverMatchesState>(
              buildWhen: (DiscoverMatchesState previousState,
                  DiscoverMatchesState state) {
            if (state is DiscoverMatchesSavingNewStatusState) {
              previousFirstMatch =
                  (previousState as DiscoverMatchesLoadSuccessState)
                      .matches
                      .first;
              animationController
                  .animateTo(0, duration: Duration(milliseconds: 0))
                  .whenComplete(() => animationController.forward());
            }
            if (previousState is DiscoverMatchesSavingNewStatusState) {
              return false;
            }
            return true;
          }, builder: (BuildContext context, DiscoverMatchesState state) {
            if (!(state is DiscoverMatchesLoadSuccessState)) {
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
                  if ((state as DiscoverMatchesLoadSuccessState)
                          .matches
                          .length >=
                      3) ...[
                    // First head
                    Positioned(
                      top: -50 * (1 - animationController.value),
                      child: Opacity(
                        opacity: animationController.value,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 2,
                              color: tinterTheme.colors.secondary,
                            ),
                          ),
                          height: constraints.maxHeight *
                              MatchesFlock.fractions['smallHead'],
                          width: constraints.maxHeight *
                              MatchesFlock.fractions['smallHead'],
                          child: Center(
                            child: getProfilePictureFromLocalPathOrLogin(
                                login:
                                    (state as DiscoverMatchesLoadSuccessState)
                                        .matches[2]
                                        .login,
                                localPath:
                                    (state as DiscoverMatchesLoadSuccessState)
                                        .matches[2]
                                        .profilePictureLocalPath,
                                height: constraints.maxHeight *
                                    MatchesFlock.fractions['smallHead'],
                                width: constraints.maxHeight *
                                    MatchesFlock.fractions['smallHead']),
                          ),
                        ),
                      ),
                    ),

                    // First separator
                    Positioned(
                      top: constraints.maxHeight *
                              MatchesFlock.fractions['smallHead'] +
                          10 -
                          50 * (1 - animationController.value),
                      child: Opacity(
                        opacity: animationController.value,
                        child: Container(
                          height: constraints.maxHeight *
                                  MatchesFlock.fractions['separator'] -
                              20,
                          width: 1.5,
                          color: tinterTheme.colors.primaryAccent,
                        ),
                      ),
                    ),
                  ],
                  if ((state as DiscoverMatchesLoadSuccessState)
                          .matches
                          .length >=
                      2) ...[
                    // Second head
                    Positioned(
                      top: 0 +
                          constraints.maxHeight *
                              (MatchesFlock.fractions['smallHead'] +
                                  MatchesFlock.fractions['separator']) *
                              animationController.value,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2,
                            color: tinterTheme.colors.secondary,
                          ),
                        ),
                        height: constraints.maxHeight *
                            MatchesFlock.fractions['smallHead'],
                        width: constraints.maxHeight *
                            MatchesFlock.fractions['smallHead'],
                        child: Center(
                          child: getProfilePictureFromLocalPathOrLogin(
                              login: (state as DiscoverMatchesLoadSuccessState)
                                  .matches[1]
                                  .login,
                              localPath:
                                  (state as DiscoverMatchesLoadSuccessState)
                                      .matches[1]
                                      .profilePictureLocalPath,
                              height: constraints.maxHeight *
                                  MatchesFlock.fractions['smallHead'],
                              width: constraints.maxHeight *
                                  MatchesFlock.fractions['smallHead']),
                        ),
                      ),
                    ),

                    // Second separator
                    Positioned(
                      top: constraints.maxHeight *
                              MatchesFlock.fractions['smallHead'] +
                          10 +
                          constraints.maxHeight *
                              (MatchesFlock.fractions['smallHead'] +
                                  MatchesFlock.fractions['separator']) *
                              animationController.value,
                      child: Container(
                        height: constraints.maxHeight *
                                MatchesFlock.fractions['separator'] -
                            20,
                        width: 1.5,
                        color: tinterTheme.colors.primaryAccent,
                      ),
                    ),
                  ],
                  if ((state as DiscoverMatchesLoadSuccessState)
                          .matches
                          .length >=
                      1) ...[
                    // Third head
                    Positioned(
                      top: constraints.maxHeight *
                              MatchesFlock.fractions['smallHead'] +
                          constraints.maxHeight *
                              MatchesFlock.fractions['separator'] +
                          constraints.maxHeight *
                              (MatchesFlock.fractions['smallHead'] +
                                  MatchesFlock.fractions['separator']) *
                              animationController.value,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            width: 2 + 2 * animationController.value,
                            color: tinterTheme.colors.secondary,
                          ),
                        ),
                        height: constraints.maxHeight *
                                MatchesFlock.fractions['smallHead'] +
                            constraints.maxHeight *
                                (MatchesFlock.fractions['bigHead'] -
                                    MatchesFlock.fractions['smallHead']) *
                                animationController.value,
                        width: constraints.maxHeight *
                                MatchesFlock.fractions['smallHead'] +
                            constraints.maxHeight *
                                (MatchesFlock.fractions['bigHead'] -
                                    MatchesFlock.fractions['smallHead']) *
                                animationController.value,
                        child: Center(
                          child: getProfilePictureFromLocalPathOrLogin(
                              login: (state as DiscoverMatchesLoadSuccessState)
                                  .matches[0]
                                  .login,
                              localPath:
                                  (state as DiscoverMatchesLoadSuccessState)
                                      .matches[0]
                                      .profilePictureLocalPath,
                              height: constraints.maxHeight *
                                      MatchesFlock.fractions['smallHead'] +
                                  constraints.maxHeight *
                                      (MatchesFlock.fractions['bigHead'] -
                                          MatchesFlock.fractions['smallHead']) *
                                      animationController.value,
                              width: constraints.maxHeight *
                                      MatchesFlock.fractions['smallHead'] +
                                  constraints.maxHeight *
                                      (MatchesFlock.fractions['bigHead'] -
                                          MatchesFlock.fractions['smallHead']) *
                                      animationController.value),
                        ),
                      ),
                    ),

                    // Third separator
                    Positioned(
                      top: constraints.maxHeight *
                              MatchesFlock.fractions['smallHead'] +
                          constraints.maxHeight *
                              MatchesFlock.fractions['separator'] +
                          constraints.maxHeight *
                              MatchesFlock.fractions['smallHead'] +
                          10 +
                          50 * animationController.value,
                      child: Opacity(
                        opacity: 1 - animationController.value,
                        child: Container(
                          height: constraints.maxHeight *
                                  MatchesFlock.fractions['separator'] -
                              20,
                          width: 1.5,
                          color: tinterTheme.colors.primaryAccent,
                        ),
                      ),
                    ),

                    // Name and surname
                    Positioned(
                      top: constraints.maxHeight *
                              MatchesFlock.fractions['smallHead'] +
                          constraints.maxHeight *
                              MatchesFlock.fractions['separator'] +
                          constraints.maxHeight *
                              MatchesFlock.fractions['bigHead'] +
                          animationController.value *
                              (constraints.maxHeight *
                                      MatchesFlock.fractions['smallHead'] +
                                  constraints.maxHeight *
                                      MatchesFlock.fractions['separator']),
                      child: Opacity(
                        opacity: animationController.value,
                        child: Container(
                          height: constraints.maxHeight *
                              MatchesFlock.fractions['nameAndSurname'],
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: AutoSizeText(
                                  (state as DiscoverMatchesLoadSuccessState)
                                      .matches[0]
                                      .name,
                                  group: nameAndSurnameAutoSizeGroup,
                                  style: tinterTheme.textStyle.headline2,
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  (state as DiscoverMatchesLoadSuccessState)
                                      .matches[0]
                                      .surname,
                                  group: nameAndSurnameAutoSizeGroup,
                                  style: tinterTheme.textStyle.headline2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (previousFirstMatch != null) ...[
                    // Third head
                    Positioned(
                      top: constraints.maxHeight *
                              MatchesFlock.fractions['smallHead'] +
                          constraints.maxHeight *
                              MatchesFlock.fractions['separator'] +
                          constraints.maxHeight *
                              MatchesFlock.fractions['smallHead'] +
                          constraints.maxHeight *
                              MatchesFlock.fractions['separator'] +
                          50 * animationController.value,
                      child: Opacity(
                        opacity: 1 - animationController.value,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: tinterTheme.colors.secondary,
                            ),
                          ),
                          height: constraints.maxHeight *
                              MatchesFlock.fractions['bigHead'],
                          width: constraints.maxHeight *
                              MatchesFlock.fractions['bigHead'],
                          child: Center(
                            child: getProfilePictureFromLocalPathOrLogin(
                              login: previousFirstMatch.login,
                              localPath:
                                  previousFirstMatch.profilePictureLocalPath,
                              height: constraints.maxHeight *
                                  MatchesFlock.fractions['bigHead'],
                              width: constraints.maxHeight *
                                  MatchesFlock.fractions['bigHead'],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Name and surname of the third head
                    Positioned(
                      top: constraints.maxHeight *
                              MatchesFlock.fractions['smallHead'] +
                          constraints.maxHeight *
                              MatchesFlock.fractions['separator'] +
                          constraints.maxHeight *
                              MatchesFlock.fractions['smallHead'] +
                          constraints.maxHeight *
                              MatchesFlock.fractions['separator'] +
                          constraints.maxHeight *
                              MatchesFlock.fractions['bigHead'] +
                          50 * animationController.value,
                      child: Opacity(
                        opacity: 1 - animationController.value,
                        child: Container(
                          height: constraints.maxHeight *
                              MatchesFlock.fractions['nameAndSurname'],
                          child: Column(
                            children: <Widget>[
                              Expanded(
                                child: AutoSizeText(
                                  previousFirstMatch.name,
                                  group: nameAndSurnameAutoSizeGroup,
                                  style: tinterTheme.textStyle.headline2,
                                ),
                              ),
                              Expanded(
                                child: AutoSizeText(
                                  previousFirstMatch.surname,
                                  group: nameAndSurnameAutoSizeGroup,
                                  style: tinterTheme.textStyle.headline2,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ],
              ),
            );
          });
        });
      },
    );
  }
}

/// MatchInformation displays a match information
/// in a column.
class MatchInformation extends StatefulWidget {
  MatchInformation();

  @override
  _MatchInformationState createState() => _MatchInformationState();
}

class _MatchInformationState extends State<MatchInformation> {
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
        child: BlocListener<DiscoverMatchesBloc, DiscoverMatchesState>(
          listener: (BuildContext context, state) {
            informationController.animateTo(0,
                duration: Duration(milliseconds: 300), curve: Curves.easeIn);
          },
          child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
            return ListView.separated(
              controller: informationController,
              itemCount: 7,
              separatorBuilder: (BuildContext context, int index) {
                return Container(
                  height: 20,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 125,
                        width: 125,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Text(
                                  'Score',
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                              Text(
                                '95',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    .copyWith(fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (index == 1) {
                  return Card(
                    child: informationRectangle(
                      context: context,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 10.0, bottom: 10.0),
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
                                  Container(
                                    height: 60,
                                    child: BlocBuilder<DiscoverMatchesBloc,
                                        DiscoverMatchesState>(
                                      builder: (BuildContext context,
                                          DiscoverMatchesState state) {
                                        if (!(state
                                            is DiscoverMatchesLoadSuccessState)) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return AnimatedSwitcher(
                                          duration: Duration(milliseconds: 300),
                                          child: ListView.separated(
                                            key: GlobalKey(),
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: (state
                                                    as DiscoverMatchesLoadSuccessState)
                                                .matches[0]
                                                .associations
                                                .length,
                                            separatorBuilder:
                                                (BuildContext context,
                                                    int index) {
                                              return SizedBox(
                                                width: 5,
                                              );
                                            },
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              return associationBubble(
                                                  context,
                                                  (state as DiscoverMatchesLoadSuccessState)
                                                      .matches[0]
                                                      .associations[index]);
                                            },
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
                  );
                } else if (index == 2) {
                  return Card(
                    child: informationRectangle(
                      context: context,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15.0, top: 10.0, bottom: 15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Attirance pour la vie associative',
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: Icon(
                                    Icons.celebration,
                                    color: Theme.of(context).primaryColor,
                                    size: 22.0,
                                  ),
                                ),
                                Expanded(
                                  child: SliderTheme(
                                    data: Theme.of(context)
                                        .sliderTheme
                                        .copyWith(
                                          disabledActiveTrackColor:
                                              Theme.of(context).primaryColor,
                                          disabledThumbColor: Color(0xffCECECE),
                                          overlayShape: RoundSliderOverlayShape(
                                              overlayRadius: 0.0),
                                          trackHeight: 6.0,
                                        ),
                                    child: BlocBuilder<DiscoverMatchesBloc,
                                        DiscoverMatchesState>(
                                      builder: (BuildContext context,
                                          DiscoverMatchesState state) {
                                        if (!(state
                                            is DiscoverMatchesLoadSuccessState)) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return TweenAnimationBuilder(
                                          tween: Tween<double>(
                                              begin: 0.5,
                                              end: (state
                                                      as DiscoverMatchesLoadSuccessState)
                                                  .matches[0]
                                                  .attiranceVieAsso),
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (index == 3) {
                  return informationRectangle(
                    context: context,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 5),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Cours ou soirée?',
                            style: tinterTheme.textStyle.headline2,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          discoverSlider(
                              context,
                              SliderTheme(
                                data: tinterTheme.slider.disabled,
                                child: BlocBuilder<DiscoverMatchesBloc,
                                    DiscoverMatchesState>(
                                  builder: (BuildContext context,
                                      DiscoverMatchesState state) {
                                    if (!(state
                                        is DiscoverMatchesLoadSuccessState)) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return TweenAnimationBuilder(
                                      tween: Tween<double>(
                                          begin: 0.5,
                                          end: (state
                                                  as DiscoverMatchesLoadSuccessState)
                                              .matches[0]
                                              .feteOuCours),
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
                              leftLabel: 'Cours',
                              rightLabel: 'Soirée'),
                        ],
                      ),
                    ),
                  );
                } else if (index == 4) {
                  return informationRectangle(
                    context: context,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 5),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Parrain qui aide ou avec qui sortir?',
                            style: tinterTheme.textStyle.headline2,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          discoverSlider(
                              context,
                              SliderTheme(
                                data: tinterTheme.slider.disabled,
                                child: BlocBuilder<DiscoverMatchesBloc,
                                    DiscoverMatchesState>(
                                  builder: (BuildContext context,
                                      DiscoverMatchesState state) {
                                    if (!(state
                                        is DiscoverMatchesLoadSuccessState)) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return TweenAnimationBuilder(
                                      tween: Tween<double>(
                                          begin: 0.5,
                                          end: (state
                                                  as DiscoverMatchesLoadSuccessState)
                                              .matches[0]
                                              .aideOuSortir),
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
                              leftLabel: 'Aide',
                              rightLabel: 'Sortir'),
                        ],
                      ),
                    ),
                  );
                } else if (index == 5) {
                  return informationRectangle(
                    context: context,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Aime organiser les événements?',
                            style: tinterTheme.textStyle.headline2,
                            textAlign: TextAlign.center,
                          ),
                          SliderTheme(
                            data: tinterTheme.slider.disabled,
                            child: BlocBuilder<DiscoverMatchesBloc,
                                DiscoverMatchesState>(
                              builder: (BuildContext context,
                                  DiscoverMatchesState state) {
                                if (!(state
                                    is DiscoverMatchesLoadSuccessState)) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return TweenAnimationBuilder(
                                  tween: Tween<double>(
                                      begin: 0.5,
                                      end: (state
                                              as DiscoverMatchesLoadSuccessState)
                                          .matches[0]
                                          .organisationEvenements),
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
                        ],
                      ),
                    ),
                  );
                } else if (index == 6) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: informationRectangle(
                      context: context,
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Goûts musicaux',
                            style: tinterTheme.textStyle.headline2,
                          ),
                          BlocBuilder<DiscoverMatchesBloc,
                              DiscoverMatchesState>(
                            builder: (BuildContext context,
                                DiscoverMatchesState state) {
                              if (!(state is DiscoverMatchesLoadSuccessState)) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                child: Wrap(
                                  key: GlobalKey(),
                                  spacing: 15,
                                  children: <Widget>[
                                    for (String musicStyle in (state
                                            as DiscoverMatchesLoadSuccessState)
                                        .matches[0]
                                        .goutsMusicaux)
                                      Chip(
                                        label: Text(musicStyle),
                                        labelStyle:
                                            tinterTheme.textStyle.chipLiked,
                                        backgroundColor:
                                            tinterTheme.colors.primaryAccent,
                                      )
                                  ],
                                ),
                              );
                            },
                          )
                        ],
                      ),
                    ),
                  );
                }
                return ErrorWidget(
                    'This list should not contain more than 7 items.');
              },
            );
          }),
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
              //borderRadius: BorderRadius.all(Radius.circular(8.0)),
              color: Colors.transparent,
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
            border:
                Border.all(color: Theme.of(context).primaryColor, width: 2.5),
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

class NoMoreDiscoveryMatchesWidget extends StatelessWidget {
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
              child:
                  Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.face,
                      color: tinterTheme.colors.defaultTextColor,
                      size: 70,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    AutoSizeText(
                      "Il n'y a plus de match à découvrir pour l'instant.\nDemande à d'autres étudiant.e.s de s'inscrire!",
                      style:
                          tinterTheme.textStyle.headline2.copyWith(height: 2),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                    ),
                  ],
                );
              }),
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
      child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
        return Container(
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            color: tinterTheme.colors.primaryAccent,
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SearchStudentAssociatifTab2()),
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
                        child: Container(
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
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: AutoSizeText(
                      'Rechercher un.e étudiant.e',
                      style: tinterTheme.textStyle.hintLarge,
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
