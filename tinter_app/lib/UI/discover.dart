import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tinterapp/UI/custom_flare_controller.dart';
import 'package:tinterapp/UI/recherche_etudiant.dart';
import 'package:tinterapp/UI/slider_label.dart';
import 'package:tinterapp/UI/const.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MaterialApp(
    home: DiscoverTab(),
  ));
}

User user = User.createTestUser();

class DiscoverTab extends StatefulWidget {
  @override
  _DiscoverTabState createState() => _DiscoverTabState();
}

class _DiscoverTabState extends State<DiscoverTab> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  ScrollController informationController;

  @override
  void initState() {
    super.initState();
    informationController = ScrollController();
    controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    animation = CurveTween(curve: Curves.easeOut).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Stack(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  flex: 55,
                  child: MatchInformation(animation, informationController),
                ),
                Expanded(
                  flex: 45,
                  child: DiscoverRight(
                      animation, controller, animateNextMatch, constraints.maxHeight),
                ),
              ],
            ),
            Positioned(
              left: constraints.maxWidth*55/100,
              child: SvgPicture.asset(
                'assets/Discover/DiscoverBackground.svg',
                color: TinterColors.background,
                height: constraints.maxHeight,
              ),
            ),
            Positioned(
              left: constraints.maxWidth*55/100,
              child: SvgPicture.asset(
                'assets/Discover/DiscoverTop.svg',
                color: TinterColors.primaryAccent,
                height: constraints.maxHeight / 2,
              ),
            ),
            Positioned(
              left: constraints.maxWidth*55/100,
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
  }

  void animateNextMatch() {
    informationController.animateTo(0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    controller.forward().whenComplete(() {
      setState(() {
        controller.animateTo(0, duration: Duration(seconds: 0));
        user.testDiscoverLike();
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

/// All the right side of the discover tab put together
class DiscoverRight extends StatelessWidget {
  final Animation<double> animation;
  final AnimationController controller;
  final VoidCallback animateNextMatch;
  final double appHeight;

  DiscoverRight(this.animation, this.controller, this.animateNextMatch, this.appHeight);

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
                height: ((this.appHeight - 8 * 2 - 50 - 15) - this.appHeight *1/2) /
                    (1 -
                        (1 / 2 * MatchesFlock.fractions['bigHead'] +
                            MatchesFlock.fractions['nameAndSurname'])),
                child: MatchesFlock(animation),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            LikeOrIgnore(animateNextMatch),
          ],
        ),
      ),
    );
  }

  Widget studentSearch(BuildContext context, {@required double height}) {
    return Container(
      height: height,
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RechercheEtudiantTab()),
              );
            },
            child: Hero(
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
                    onChanged: (String text) {
                      print('CHANGED');
                    },
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RechercheEtudiantTab()),
              );
            },
            child: Align(
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
          ),
        ],
      ),
    );
  }

  Widget likeOrIgnore(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: IconButton(
            padding: EdgeInsets.only(left: 6.0),
            iconSize: 60,
            color: TinterColors.secondaryAccent,
            icon: FlareActor(
              'assets/Icons/Heart.flr',
              color: TinterColors.secondaryAccent,
              animation: animation.value == 0 ? 'None' : 'Validate',
              fit: BoxFit.fill,
            ),
            onPressed: () {
              animateNextMatch(); // TODO: say it's liked
            },
          ),
        ),
        Flexible(
          child: IconButton(
            padding: EdgeInsets.all(0.0),
            iconSize: 70,
            color: TinterColors.secondaryAccent,
            icon: FlareActor(
              'assets/Icons/Clear.flr',
              color: TinterColors.secondaryAccent,
              animation: animation.value == 0 ? 'None' : 'Validate',
              fit: BoxFit.fill,
            ),
            onPressed: () {
              animateNextMatch(); // TODO: say it's ignored
            },
          ),
        ),
      ],
    );
  }
}

class LikeOrIgnore extends StatefulWidget {
  final VoidCallback animateNextMatch;

  LikeOrIgnore(this.animateNextMatch);

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
              controller: CustomFlareController(controller: likeController, forwardAnimationName: 'Validate'),
            ),
            onPressed: () {
              likeController.forward().whenComplete(
                  () => likeController.animateTo(0, duration: Duration(seconds: 0)));
              widget.animateNextMatch(); // TODO: say it's like
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
              widget.animateNextMatch(); // TODO: say it's ignore
            },
          ),
        ),
      ],
    );
  }
}

/// Displays the 3 stacked faces of the discover tab.
class MatchesFlock extends StatelessWidget {
  final Animation animation;

  MatchesFlock(this.animation);

  // fraction describes the proportions
  // of each part of the widget
  static final Map<String, double> fractions = {
    'nameAndSurname': 14 / 100,
    'bigHead': 26 / 100,
    'smallHead': 15 / 100,
    'separator': 15 / 100,
  };

  // Auto size the name and surname
  final AutoSizeGroup nameAndSurnameAutoSizeGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    print('Animation value: ' + animation.value.toString());

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Container(
          height: constraints.maxHeight,
          child: Stack(
            overflow: Overflow.visible,
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              // Invisible head
              Positioned(
                top: -50 * (1 - animation.value),
                child: Opacity(
                  opacity: animation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: TinterColors.primaryAccent,
                      ),
                    ),
                    height: constraints.maxHeight * fractions['smallHead'],
                    width: constraints.maxHeight * fractions['smallHead'],
                    child: Center(child: Text(user.discoverMatches[3].name)),
                  ),
                ),
              ),

              // Invisible separator
              Positioned(
                top: constraints.maxHeight * fractions['smallHead'] +
                    10 -
                    50 * (1 - animation.value),
                child: Opacity(
                  opacity: animation.value,
                  child: Container(
                    height: constraints.maxHeight * fractions['separator'] - 20,
                    width: 1.5,
                    color: TinterColors.primaryAccent,
                  ),
                ),
              ),

              // First head
              Positioned(
                top: 0 +
                    constraints.maxHeight *
                        (fractions['smallHead'] + fractions['separator']) *
                        animation.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2,
                      color: TinterColors.primaryAccent,
                    ),
                  ),
                  height: constraints.maxHeight * fractions['smallHead'],
                  width: constraints.maxHeight * fractions['smallHead'],
                  child: Center(child: Text(user.discoverMatches[2].name)),
                ),
              ),

              // First separator
              Positioned(
                top: constraints.maxHeight * fractions['smallHead'] +
                    10 +
                    constraints.maxHeight *
                        (fractions['smallHead'] + fractions['separator']) *
                        animation.value,
                child: Container(
                  height: constraints.maxHeight * fractions['separator'] - 20,
                  width: 1.5,
                  color: TinterColors.primaryAccent,
                ),
              ),

              // Second head
              Positioned(
                top: constraints.maxHeight * fractions['smallHead'] +
                    constraints.maxHeight * fractions['separator'] +
                    constraints.maxHeight *
                        (fractions['smallHead'] + fractions['separator']) *
                        animation.value,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      width: 2 + 2 * animation.value,
                      color: TinterColors.primaryAccent,
                    ),
                  ),
                  height: constraints.maxHeight * fractions['smallHead'] +
                      constraints.maxHeight *
                          (fractions['bigHead'] - fractions['smallHead']) *
                          animation.value,
                  width: constraints.maxHeight * fractions['smallHead'] +
                      constraints.maxHeight *
                          (fractions['bigHead'] - fractions['smallHead']) *
                          animation.value,
                  child: Center(child: Text(user.discoverMatches[1].name)),
                ),
              ),

              // Second separator
              Positioned(
                top: constraints.maxHeight * fractions['smallHead'] +
                    constraints.maxHeight * fractions['separator'] +
                    constraints.maxHeight * fractions['smallHead'] +
                    10 +
                    50 * animation.value,
                child: Opacity(
                  opacity: 1 - animation.value,
                  child: Container(
                    height: constraints.maxHeight * fractions['separator'] - 20,
                    width: 1.5,
                    color: TinterColors.primaryAccent,
                  ),
                ),
              ),

              // Third head
              Positioned(
                top: constraints.maxHeight * fractions['smallHead'] +
                    constraints.maxHeight * fractions['separator'] +
                    constraints.maxHeight * fractions['smallHead'] +
                    constraints.maxHeight * fractions['separator'] +
                    50 * animation.value,
                child: Opacity(
                  opacity: 1 - animation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 4,
                        color: TinterColors.primaryAccent,
                      ),
                    ),
                    height: constraints.maxHeight * fractions['bigHead'],
                    width: constraints.maxHeight * fractions['bigHead'],
                    child: Center(child: Text(user.discoverMatches[0].name)),
                  ),
                ),
              ),

              // Name and surname of the third head
              Positioned(
                top: constraints.maxHeight * fractions['smallHead'] +
                    constraints.maxHeight * fractions['separator'] +
                    constraints.maxHeight * fractions['smallHead'] +
                    constraints.maxHeight * fractions['separator'] +
                    constraints.maxHeight * fractions['bigHead'] +
                    50 * animation.value,
                child: Opacity(
                  opacity: 1 - animation.value,
                  child: Container(
                    height: constraints.maxHeight * fractions['nameAndSurname'],
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: AutoSizeText(
                            user.discoverMatches[0].name,
                            group: nameAndSurnameAutoSizeGroup,
                            style: TinterTextStyle.headline2,
                          ),
                        ),
                        Expanded(
                          child: AutoSizeText(
                            user.discoverMatches[0].surname,
                            group: nameAndSurnameAutoSizeGroup,
                            style: TinterTextStyle.headline2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
//
//  Transform.translate(
//  offset: Offset(0, 50)*animation.value,
//  child: Opacity(
//  opacity: 1-animation.value,
//  child: Column(
//  children: <Widget>[
//  Text(user.discoverMatches[0].name, style: TinterTextStyle.headline2,),
//  Text(user.discoverMatches[0].surname, style: TinterTextStyle.headline2,),
//  ],
//  ),
//  ),
//  )

}

/// matchInformation displays a match information
/// in a column.
class MatchInformation extends StatelessWidget {
  final Animation<double> animation;
  final ScrollController informationController;

  MatchInformation(this.animation, this.informationController);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
      ),
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
                          Stack(
                            children: <Widget>[
                              Opacity(
                                opacity: 1 - animation.value,
                                child: Text(
                                  user.discoverMatches[0].score.toString(),
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: TinterTextStyle.headline1.color,
                                  ),
                                ),
                              ),
                              Opacity(
                                opacity: animation.value,
                                child: Text(
                                  user.discoverMatches[1].score.toString(),
                                  style: TextStyle(
                                    fontSize: 50,
                                    fontWeight: FontWeight.bold,
                                    color: TinterTextStyle.headline1.color,
                                  ),
                                ),
                              ),
                            ],
                          ),
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
                          Opacity(
                            opacity: 1 - animation.value,
                            child: Container(
                              height: 60,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: user.discoverMatches[0].associations.length,
                                separatorBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    width: 5,
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return associationBubble(
                                      context, user.discoverMatches[0].associations[index]);
                                },
                              ),
                            ),
                          ),
                          Opacity(
                            opacity: animation.value,
                            child: Container(
                              height: 60,
                              child: ListView.separated(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: user.discoverMatches[1].associations.length,
                                separatorBuilder: (BuildContext context, int index) {
                                  return SizedBox(
                                    width: 5,
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return associationBubble(
                                      context, user.discoverMatches[1].associations[index]);
                                },
                              ),
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
                      child: Slider(
                        value:
                            user.discoverMatches[0].attiranceVieAsso * (1 - animation.value) +
                                user.discoverMatches[1].attiranceVieAsso * animation.value,
                        onChanged: null,
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
                          child: Slider(
                            value:
                                user.discoverMatches[0].feteOuCours * (1 - animation.value) +
                                    user.discoverMatches[1].feteOuCours * animation.value,
                            onChanged: null,
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
                          child: Slider(
                            value:
                                user.discoverMatches[0].aideOuSortir * (1 - animation.value) +
                                    user.discoverMatches[1].aideOuSortir * animation.value,
                            onChanged: null,
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
                      child: Slider(
                        value: user.discoverMatches[0].organisationEvenements *
                                (1 - animation.value) +
                            user.discoverMatches[1].organisationEvenements * animation.value,
                        onChanged: null,
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
                    Wrap(
                      spacing: 15,
                      children: <Widget>[
                        for (String musicStyle in user.discoverMatches[0].goutsMusicaux.get)
                          Chip(
                            label: Text(musicStyle),
                            labelStyle: TinterTextStyle.goutMusicaux,
                            backgroundColor: TinterColors.primaryAccent,
                          )
                      ],
                    )
                  ],
                ),
              ),
            );
          }
          return ErrorWidget('This list should not contain more than 7 items.');
        },
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
