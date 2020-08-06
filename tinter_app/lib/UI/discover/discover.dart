import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tinterapp/Logic/blocs/discover_matches/discover_matches_bloc.dart';
import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/repository/discover_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';
import 'package:tinterapp/UI/shared_element/custom_flare_controller.dart';
import 'package:tinterapp/UI/discover/recherche_etudiant.dart';
import 'package:tinterapp/UI/shared_element/slider_label.dart';
import 'package:tinterapp/UI/shared_element/const.dart';
import 'package:http/http.dart' as http;
import 'package:tinterapp/Logic/models/match.dart';

main() {
  final http.Client httpClient = http.Client();
  TinterApiClient tinterApiClient = TinterApiClient(
    httpClient: httpClient,
  );

  final DiscoverRepository discoverRepository =
      DiscoverRepository(tinterApiClient: tinterApiClient);

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(
    BlocProvider(
      create: (BuildContext context) =>
          DiscoverMatchesBloc(discoverRepository: discoverRepository),
      child: MaterialApp(
        home: SafeArea(
          child: Scaffold(
            backgroundColor: TinterColors.background,
            body: DiscoverTab(),
          ),
        ),
      ),
    ),
  );
}

class DiscoverTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Update to last information
    BlocProvider.of<DiscoverMatchesBloc>(context).add(DiscoverMatchesRequestedEvent());

    return BlocBuilder<DiscoverMatchesBloc, DiscoverMatchesState>(
      buildWhen: (DiscoverMatchesState previousState, DiscoverMatchesState state) {
        return previousState.runtimeType != state.runtimeType;
      },
      builder: (BuildContext context, DiscoverMatchesState state) {
        if (!(state is DiscoverMatchesLoadSuccessState)) {
          return CircularProgressIndicator();
        }
        return LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
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
                    'assets/Discover/DiscoverBackground.svg',
                    color: TinterColors.background,
                    height: constraints.maxHeight,
                  ),
                ),
                Positioned(
                  left: constraints.maxWidth * 55 / 100,
                  child: SvgPicture.asset(
                    'assets/Discover/DiscoverTop.svg',
                    color: TinterColors.primaryAccent,
                    height: constraints.maxHeight / 2,
                  ),
                ),
                Positioned(
                  left: constraints.maxWidth * 55 / 100,
                  bottom: 0,
                  child: SvgPicture.asset(
                    'assets/Discover/DiscoverBottom.svg',
                    color: TinterColors.primaryAccent,
                    height: constraints.maxHeight / 2,
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

/// All the right side of the discover tab put together
class DiscoverRight extends StatelessWidget {
  final double appHeight;

  DiscoverRight(this.appHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [TinterColors.discoverGradientGrey, TinterColors.background])),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            studentSearch(
              context,
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Container(
                height: ((this.appHeight - 8 * 2 - 50 - 15) - this.appHeight * 1 / 2) /
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

  Widget studentSearch(BuildContext context, {@required double height}) {
    return Container(
      height: height,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RechercheEtudiantTab()),
          );
        },
        child: Stack(
          children: [
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
                    enabled: false,
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      focusedBorder: InputBorder.none,
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.search,
                          color: TinterColors.hint,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment(0.4, 0),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 500),
                child: AutoSizeText(
                  'Rechercher\nun.e étudiant.e',
                  style: TinterTextStyle.hint,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

//  Widget likeOrIgnore(BuildContext context) {
//    return Row(
//      mainAxisAlignment: MainAxisAlignment.center,
//      children: <Widget>[
//        Flexible(
//          child: IconButton(
//            padding: EdgeInsets.only(left: 6.0),
//            iconSize: 60,
//            color: TinterColors.secondaryAccent,
//            icon: FlareActor(
//              'assets/Icons/Heart.flr',
//              color: TinterColors.secondaryAccent,
//              animation: animation.value == 0 ? 'None' : 'Validate',
//              fit: BoxFit.fill,
//            ),
//            onPressed: () {
//              BlocProvider.of<DiscoverMatchesBloc>(context).add(DiscoverMatchLikeEvent());
//            },
//          ),
//        ),
//        Flexible(
//          child: IconButton(
//            padding: EdgeInsets.all(0.0),
//            iconSize: 70,
//            color: TinterColors.secondaryAccent,
//            icon: FlareActor(
//              'assets/Icons/Clear.flr',
//              color: TinterColors.secondaryAccent,
//              animation: animation.value == 0 ? 'None' : 'Validate',
//              fit: BoxFit.fill,
//            ),
//            onPressed: () {
//              animateNextMatch(); // TODO: say it's ignored
//            },
//          ),
//        ),
//      ],
//    );
//  }
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
          child: IconButton(
            padding: EdgeInsets.all(0.0),
            iconSize: 60,
            color: TinterColors.secondaryAccent,
            icon: FlareActor(
              'assets/Icons/Heart.flr',
              color: TinterColors.secondaryAccent,
              fit: BoxFit.contain,
              controller: CustomFlareController(
                  controller: likeController, forwardAnimationName: 'Validate'),
            ),
            onPressed: () {
              likeController.forward().whenComplete(
                  () => likeController.animateTo(0, duration: Duration(seconds: 0)));
              BlocProvider.of<DiscoverMatchesBloc>(context).add(DiscoverMatchLikeEvent());
            },
          ),
        ),
        Flexible(
          child: IconButton(
            padding: EdgeInsets.all(0.0),
            iconSize: 60,
            color: TinterColors.secondaryAccent,
            icon: FlareActor(
              'assets/Icons/Clear.flr',
              color: TinterColors.secondaryAccent,
              fit: BoxFit.contain,
              controller: CustomFlareController(
                controller: ignoreController,
                forwardAnimationName: 'Ignore',
              ),
            ),
            onPressed: () {
              ignoreController.forward().whenComplete(
                  () => ignoreController.animateTo(0, duration: Duration(seconds: 0)));
              BlocProvider.of<DiscoverMatchesBloc>(context).add(DiscoverMatchIgnoreEvent());
            },
          ),
        ),
      ],
    );
  }
}

///// Displays the 3 stacked faces of the discover tab.
//class MatchesFlock extends StatelessWidget {
//  static final Map<String, double> fractions = {
//    'nameAndSurname': 14 / 100,
//    'bigHead': 26 / 100,
//    'smallHead': 15 / 100,
//    'separator': 15 / 100,
//  };
//  final double height;
//
//  MatchesFlock({@required this.height});
//
//  // Handle the AnimatedList
//  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
//
//  void _nextDiscoverMatch(BuildContext context, Match match) {
//    RenderBox renderBox = context.findRenderObject();
//    var size = renderBox.size;
//    var offset = renderBox.localToGlobal(Offset.zero);
//
//    _listKey.currentState.removeItem(
//      0,
//      (BuildContext context, Animation<double> animation) {
//        // This is the height of the user picture, the name, and the separator
//        final double containerHeight = height *
//            (fractions['bigHead'] + fractions['nameAndSurname'] + fractions['separator']);
//
//        final MatchFlockPosition position = MatchFlockPosition.first;
//
//        // Creating an overlay to display the actual disappearing head.
//        // This is useful so that it is not hided be the heart and the cross.
//        final OverlayEntry overlayEntry = OverlayEntry(
//          builder: (BuildContext context) {
//            return TweenAnimationBuilder(
//              tween: Tween<double>(begin: 0, end: 50),
//              duration: Duration(milliseconds: 300),
//              builder: (BuildContext context, value, Widget child) {
//                return Positioned(
//                  left: offset.dx,
//                  top: offset.dy + height*(2*fractions['smallHead'] + fractions['separator']) + value ,
//                  child: Material(
//                    color: Colors.transparent,
//                    child: DisplayedDiscoverMatch(
//                      width: size.width,
//                      pictureHeight: height * fractions['bigHead'],
//                      match: match,
//                      matchFlockPosition: position,
//                      animation: animation,
//                      nameAndSurnameHeight: height * fractions['nameAndSurname'],
//                      separatorHeight: height * fractions['separator'],
//                    ),
//                  ),
//                );
//              },
//            );
//          },
//        );
//
//        final overlay = Overlay.of(context);
//        WidgetsBinding.instance.addPostFrameCallback(
//          (_) {
//        overlay.insert(overlayEntry);
//
//        // Remove the overlay once the animation ends
//        Future.delayed(
//          Duration(milliseconds: 300),
//          () => overlayEntry.remove(),
//        );
//          },
//        );
//
//        // Invisible Widget which height diminish to create a transition
//        return SizeTransition(
//          axis: Axis.vertical,
//          sizeFactor: animation,
//          child: Container(
//            height: containerHeight,
//          ),
//        );
//      },
//      duration: Duration(milliseconds: 300),
//    );
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return LayoutBuilder(
//      builder: (BuildContext context, BoxConstraints constraints) {
//        return BlocBuilder<DiscoverMatchesBloc, DiscoverMatchesState>(
//          buildWhen: (DiscoverMatchesState previousState, DiscoverMatchesState state) {
//            if (previousState.runtimeType != state.runtimeType) {
//              return true;
//            }
//            if (state is DiscoverMatchesLoadSuccessState) {
//              _listKey.currentState.insertItem(3, duration: Duration(milliseconds: 300));
//              _nextDiscoverMatch(
//                  context, (previousState as DiscoverMatchesLoadSuccessState).matches.first);
//              return true;
//            }
//            return false;
//          },
//          builder: (BuildContext context, DiscoverMatchesState state) {
//            if (!(state is DiscoverMatchesLoadSuccessState)) {
//              return CircularProgressIndicator();
//            }
//            return AnimatedList(
//              key: _listKey,
//              reverse: true,
//              initialItemCount: 3,
//              itemBuilder: (BuildContext context, int index, Animation<double> animation) {
//                final MatchFlockPosition position = (index == 0)
//                    ? MatchFlockPosition.first
//                    : (index == (state as DiscoverMatchesLoadSuccessState).matches.length - 1)
//                        ? MatchFlockPosition.last
//                        : MatchFlockPosition.middle;
//                return DisplayedDiscoverMatch(
//                  width: constraints.maxWidth,
//                  pictureHeight: height *
//                      ((position == MatchFlockPosition.first)
//                          ? fractions['bigHead']
//                          : fractions['smallHead']),
//                  match: (state as DiscoverMatchesLoadSuccessState).matches[index],
//                  matchFlockPosition: position,
//                  animation: animation,
//                  nameAndSurnameHeight: (position == MatchFlockPosition.first)
//                      ? height * fractions['nameAndSurname']
//                      : 0,
//                  separatorHeight: (position == MatchFlockPosition.last)
//                      ? 0
//                      : height * fractions['separator'],
//                );
//              },
//            );
//          },
//        );
//      },
//    );
//  }
//}
//
//enum MatchFlockPosition { first, middle, last }
//
//class DisplayedDiscoverMatch extends StatelessWidget {
//  final Match match;
//  final double pictureHeight;
//  final double nameAndSurnameHeight;
//  final MatchFlockPosition matchFlockPosition;
//  final Animation<double> animation;
//  final double separatorHeight;
//  final double width;
//
//  // Auto size the name and surname
//  final AutoSizeGroup nameAndSurnameAutoSizeGroup = AutoSizeGroup();
//
//  DisplayedDiscoverMatch({
//    @required this.pictureHeight,
//    @required this.match,
//    @required this.matchFlockPosition,
//    @required this.animation,
//    @required this.separatorHeight,
//    @required this.width,
//    @required this.nameAndSurnameHeight,
//  });
//
//  @override
//  Widget build(BuildContext context) {
//    return FadeTransition(
//      opacity: animation,
//      child: Container(
//        width: width,
//        child: Column(
//          children: [
//            // Separator
//            AnimatedContainer(
//              duration: Duration(milliseconds: 300),
//              height: separatorHeight,
//              width: 1,
//              color: TinterColors.primaryAccent,
//            ),
//
//            // Picture
//            AnimatedContainer(
//              duration: Duration(milliseconds: 300),
//              height: pictureHeight,
//              width: pictureHeight,
//              // TODO: change this to user picture
//              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
//            ),
//
//            // Name and surname
//            AnimatedContainer(
//              duration: Duration(milliseconds: 300),
//              height: nameAndSurnameHeight,
//              child: Column(
//                children: <Widget>[
//                  Expanded(
//                    child: AutoSizeText(
//                      match.name,
//                      group: nameAndSurnameAutoSizeGroup,
//                      style: TinterTextStyle.headline2,
//                    ),
//                  ),
//                  Expanded(
//                    child: AutoSizeText(
//                      match.surname,
//                      group: nameAndSurnameAutoSizeGroup,
//                      style: TinterTextStyle.headline2,
//                    ),
//                  ),
//                ],
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}

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

class _MatchesFlockState extends State<MatchesFlock> with SingleTickerProviderStateMixin {
  final AutoSizeGroup nameAndSurnameAutoSizeGroup = AutoSizeGroup();
  AnimationController animationController;
  Match previousFirstMatch;

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
        return BlocBuilder<DiscoverMatchesBloc, DiscoverMatchesState>(
            buildWhen: (DiscoverMatchesState previousState, DiscoverMatchesState state) {
          if (previousState.runtimeType != state.runtimeType) {
            return true;
          }
          if (state is DiscoverMatchesLoadSuccessState) {
            previousFirstMatch =
                (previousState as DiscoverMatchesLoadSuccessState).matches.first;
            animationController
                .animateTo(0, duration: Duration(milliseconds: 0))
                .whenComplete(() => animationController.forward());
            return true;
          }
          return false;
        }, builder: (BuildContext context, DiscoverMatchesState state) {
          if (!(state is DiscoverMatchesLoadSuccessState)) {
            return CircularProgressIndicator();
          }
          return Container(
            height: constraints.maxHeight,
            child: Stack(
              overflow: Overflow.visible,
              alignment: AlignmentDirectional.topCenter,
              children: <Widget>[
                // Invisible head
                Positioned(
                  top: -50 * (1 - animationController.value),
                  child: Opacity(
                    opacity: animationController.value,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: TinterColors.primaryAccent,
                        ),
                      ),
                      height: constraints.maxHeight * MatchesFlock.fractions['smallHead'],
                      width: constraints.maxHeight * MatchesFlock.fractions['smallHead'],
                      child: Center(
                          child: Text(
                              (state as DiscoverMatchesLoadSuccessState).matches[2].name)),
                    ),
                  ),
                ),

                // Invisible separator
                Positioned(
                  top: constraints.maxHeight * MatchesFlock.fractions['smallHead'] +
                      10 -
                      50 * (1 - animationController.value),
                  child: Opacity(
                    opacity: animationController.value,
                    child: Container(
                      height: constraints.maxHeight * MatchesFlock.fractions['separator'] - 20,
                      width: 1.5,
                      color: TinterColors.primaryAccent,
                    ),
                  ),
                ),

                // First head
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
                        color: TinterColors.primaryAccent,
                      ),
                    ),
                    height: constraints.maxHeight * MatchesFlock.fractions['smallHead'],
                    width: constraints.maxHeight * MatchesFlock.fractions['smallHead'],
                    child: Center(
                        child:
                            Text((state as DiscoverMatchesLoadSuccessState).matches[1].name)),
                  ),
                ),

                // First separator
                Positioned(
                  top: constraints.maxHeight * MatchesFlock.fractions['smallHead'] +
                      10 +
                      constraints.maxHeight *
                          (MatchesFlock.fractions['smallHead'] +
                              MatchesFlock.fractions['separator']) *
                          animationController.value,
                  child: Container(
                    height: constraints.maxHeight * MatchesFlock.fractions['separator'] - 20,
                    width: 1.5,
                    color: TinterColors.primaryAccent,
                  ),
                ),

                // Second head
                Positioned(
                  top: constraints.maxHeight * MatchesFlock.fractions['smallHead'] +
                      constraints.maxHeight * MatchesFlock.fractions['separator'] +
                      constraints.maxHeight *
                          (MatchesFlock.fractions['smallHead'] +
                              MatchesFlock.fractions['separator']) *
                          animationController.value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2 + 2 * animationController.value,
                        color: TinterColors.primaryAccent,
                      ),
                    ),
                    height: constraints.maxHeight * MatchesFlock.fractions['smallHead'] +
                        constraints.maxHeight *
                            (MatchesFlock.fractions['bigHead'] -
                                MatchesFlock.fractions['smallHead']) *
                            animationController.value,
                    width: constraints.maxHeight * MatchesFlock.fractions['smallHead'] +
                        constraints.maxHeight *
                            (MatchesFlock.fractions['bigHead'] -
                                MatchesFlock.fractions['smallHead']) *
                            animationController.value,
                    child: Center(
                        child:
                            Text((state as DiscoverMatchesLoadSuccessState).matches[0].name)),
                  ),
                ),

                // Second separator
                Positioned(
                  top: constraints.maxHeight * MatchesFlock.fractions['smallHead'] +
                      constraints.maxHeight * MatchesFlock.fractions['separator'] +
                      constraints.maxHeight * MatchesFlock.fractions['smallHead'] +
                      10 +
                      50 * animationController.value,
                  child: Opacity(
                    opacity: 1 - animationController.value,
                    child: Container(
                      height: constraints.maxHeight * MatchesFlock.fractions['separator'] - 20,
                      width: 1.5,
                      color: TinterColors.primaryAccent,
                    ),
                  ),
                ),

                Positioned(
                  top: constraints.maxHeight * MatchesFlock.fractions['smallHead'] +
                      constraints.maxHeight * MatchesFlock.fractions['separator'] +
                      constraints.maxHeight * MatchesFlock.fractions['bigHead'] +
                      animationController.value *
                          (constraints.maxHeight * MatchesFlock.fractions['smallHead'] +
                              constraints.maxHeight * MatchesFlock.fractions['separator']),
                  child: Opacity(
                    opacity: animationController.value,
                    child: Container(
                      height: constraints.maxHeight * MatchesFlock.fractions['nameAndSurname'],
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            child: AutoSizeText(
                              (state as DiscoverMatchesLoadSuccessState).matches[0].name,
                              group: nameAndSurnameAutoSizeGroup,
                              style: TinterTextStyle.headline2,
                            ),
                          ),
                          Expanded(
                            child: AutoSizeText(
                              (state as DiscoverMatchesLoadSuccessState).matches[0].surname,
                              group: nameAndSurnameAutoSizeGroup,
                              style: TinterTextStyle.headline2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                ...(previousFirstMatch != null)
                    ? [
                        // Third head
                        Positioned(
                          top: constraints.maxHeight * MatchesFlock.fractions['smallHead'] +
                              constraints.maxHeight * MatchesFlock.fractions['separator'] +
                              constraints.maxHeight * MatchesFlock.fractions['smallHead'] +
                              constraints.maxHeight * MatchesFlock.fractions['separator'] +
                              50 * animationController.value,
                          child: Opacity(
                            opacity: 1 - animationController.value,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: TinterColors.primaryAccent,
                                ),
                              ),
                              height:
                                  constraints.maxHeight * MatchesFlock.fractions['bigHead'],
                              width: constraints.maxHeight * MatchesFlock.fractions['bigHead'],
                              child: Center(child: Text(previousFirstMatch.name)),
                            ),
                          ),
                        ),

                        // Name and surname of the third head
                        Positioned(
                          top: constraints.maxHeight * MatchesFlock.fractions['smallHead'] +
                              constraints.maxHeight * MatchesFlock.fractions['separator'] +
                              constraints.maxHeight * MatchesFlock.fractions['smallHead'] +
                              constraints.maxHeight * MatchesFlock.fractions['separator'] +
                              constraints.maxHeight * MatchesFlock.fractions['bigHead'] +
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
                                      style: TinterTextStyle.headline2,
                                    ),
                                  ),
                                  Expanded(
                                    child: AutoSizeText(
                                      previousFirstMatch.surname,
                                      group: nameAndSurnameAutoSizeGroup,
                                      style: TinterTextStyle.headline2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ]
                    : [Container()],
              ],
            ),
          );
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
      child: BlocListener<DiscoverMatchesBloc, DiscoverMatchesState>(
        listener: (BuildContext context, state) {
          informationController.animateTo(0,
              duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        },
        child: ListView.separated(
          controller: informationController,
          itemCount: 7,
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return informationRectangle(
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
                            Text(
                              'Score',
                              style: TinterTextStyle.headline1,
                            ),
                            BlocBuilder<DiscoverMatchesBloc, DiscoverMatchesState>(
                                builder: (BuildContext context, DiscoverMatchesState state) {
                              if (!(state is DiscoverMatchesLoadSuccessState)) {
                                return CircularProgressIndicator();
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
                                child: Text(
                                  (state as DiscoverMatchesLoadSuccessState)
                                      .matches[0]
                                      .score
                                      .toString(),
                                  key: GlobalKey(),
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: TinterTextStyle.headline1.color,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.bottomEnd,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: Theme.of(context).textTheme.bodyText1.color, width: 2),
                          ),
                          height: 20,
                          width: 20,
                          child: Center(
                            child: Text(
                              '?',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyText1.color,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else if (index == 1) {
              return informationRectangle(
                context: context,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Associations',
                        style: TinterTextStyle.headline2,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 10.0),
                        width: double.infinity,
                        child: Stack(
                          alignment: AlignmentDirectional.centerStart,
                          children: <Widget>[
                            Container(
                              height: 60,
                              child: BlocBuilder<DiscoverMatchesBloc, DiscoverMatchesState>(
                                builder: (BuildContext context, DiscoverMatchesState state) {
                                  if (!(state is DiscoverMatchesLoadSuccessState)) {
                                    return CircularProgressIndicator();
                                  }
                                  return AnimatedSwitcher(
                                    duration: Duration(milliseconds: 300),
                                    child: ListView.separated(
                                      key: GlobalKey(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: (state as DiscoverMatchesLoadSuccessState)
                                          .matches[0]
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
              );
            } else if (index == 2) {
              return informationRectangle(
                context: context,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Attirance pour la vie associative',
                        textAlign: TextAlign.center,
                        style: TinterTextStyle.headline2,
                      ),
                      SliderTheme(
                        data: TinterSliderTheme.disabled,
                        child: BlocBuilder<DiscoverMatchesBloc, DiscoverMatchesState>(
                          builder: (BuildContext context, DiscoverMatchesState state) {
                            if (!(state is DiscoverMatchesLoadSuccessState)) {
                              return CircularProgressIndicator();
                            }
                            return TweenAnimationBuilder(
                              tween: Tween<double>(
                                  begin: 0.5,
                                  end: (state as DiscoverMatchesLoadSuccessState)
                                      .matches[0]
                                      .attiranceVieAsso),
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
                    ],
                  ),
                ),
              );
            } else if (index == 3) {
              return informationRectangle(
                context: context,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Cours ou soirée?',
                        style: TinterTextStyle.headline2,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      discoverSlider(
                          context,
                          SliderTheme(
                            data: TinterSliderTheme.disabled,
                            child: BlocBuilder<DiscoverMatchesBloc, DiscoverMatchesState>(
                              builder: (BuildContext context, DiscoverMatchesState state) {
                                if (!(state is DiscoverMatchesLoadSuccessState)) {
                                  return CircularProgressIndicator();
                                }
                                return TweenAnimationBuilder(
                                  tween: Tween<double>(
                                      begin: 0.5,
                                      end: (state as DiscoverMatchesLoadSuccessState)
                                          .matches[0]
                                          .feteOuCours),
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
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Parrain qui aide ou avec qui sortir?',
                        style: TinterTextStyle.headline2,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      discoverSlider(
                          context,
                          SliderTheme(
                            data: TinterSliderTheme.disabled,
                            child: BlocBuilder<DiscoverMatchesBloc, DiscoverMatchesState>(
                              builder: (BuildContext context, DiscoverMatchesState state) {
                                if (!(state is DiscoverMatchesLoadSuccessState)) {
                                  return CircularProgressIndicator();
                                }
                                return TweenAnimationBuilder(
                                  tween: Tween<double>(
                                      begin: 0.5,
                                      end: (state as DiscoverMatchesLoadSuccessState)
                                          .matches[0]
                                          .aideOuSortir),
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
                        style: TinterTextStyle.headline2,
                        textAlign: TextAlign.center,
                      ),
                      SliderTheme(
                        data: TinterSliderTheme.disabled,
                        child: BlocBuilder<DiscoverMatchesBloc, DiscoverMatchesState>(
                          builder: (BuildContext context, DiscoverMatchesState state) {
                            if (!(state is DiscoverMatchesLoadSuccessState)) {
                              return CircularProgressIndicator();
                            }
                            return TweenAnimationBuilder(
                              tween: Tween<double>(
                                  begin: 0.5,
                                  end: (state as DiscoverMatchesLoadSuccessState)
                                      .matches[0]
                                      .organisationEvenements),
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
                        style: TinterTextStyle.headline2,
                      ),
                      BlocBuilder<DiscoverMatchesBloc, DiscoverMatchesState>(
                        builder: (BuildContext context, DiscoverMatchesState state) {
                          if (!(state is DiscoverMatchesLoadSuccessState)) {
                            return CircularProgressIndicator();
                          }
                          return AnimatedSwitcher(
                            duration: Duration(milliseconds: 300),
                            child: Wrap(
                              key: GlobalKey(),
                              spacing: 15,
                              children: <Widget>[
                                for (String musicStyle
                                    in (state as DiscoverMatchesLoadSuccessState)
                                        .matches[0]
                                        .goutsMusicaux)
                                  Chip(
                                    label: Text(musicStyle),
                                    labelStyle: TinterTextStyle.goutMusicaux,
                                    backgroundColor: TinterColors.primaryAccent,
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
            return ErrorWidget('This list should not contain more than 7 items.');
          },
        ),
      ),
    );
  }

  Widget informationRectangle(
      {@required BuildContext context, @required Widget child, double width, double height}) {
    return Align(
      alignment: AlignmentDirectional.center,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: TinterColors.primary,
        ),
        width: width != null ? width : Size.infinite.width,
        height: height,
        child: child,
      ),
    );
  }

  Widget associationBubble(BuildContext context, Association association) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: TinterTextStyle.headline1.color, width: 3),
      ),
      height: 60,
      width: 60,
      child: Text(association.name), // TODO: change this to logo
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
                padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
                child: Text(
                  leftLabel,
                  style: TinterTextStyle.smallLabel,
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
                  style: TinterTextStyle.smallLabel,
                ),
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

//    Scaffold(
//        floatingActionButton: FloatingActionButton(
//          onPressed: () => controller.forward().whenComplete(() {
//            setState(() {
//              controller.animateTo(0, duration: Duration(seconds: 0));
//              user.testDiscoverLike(); // TODO: Take this for tap
//            });
//          }),
//        ),
