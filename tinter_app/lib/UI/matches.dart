import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/rendering.dart';
import 'package:separated_column/separated_column.dart';
import 'package:tinterapp/UI/slider_label.dart';
import 'package:tinterapp/UI/const.dart';

import 'snap_scroll_sheet_physics.dart';

main() => runApp(MaterialApp(
      home: Material(
        color: TinterColors.background,
        child: MatchsTab(),
      ),
    ));

User user = User.createTestUser();

class MatchsTab extends StatefulWidget {
  final Map<String, double> fractions = {
    'matchSelectionMenu': 0.4,
  };

  @override
  _MatchsTabState createState() => _MatchsTabState();
}

class _MatchsTabState extends State<MatchsTab> {
  Match _selectedMatch;
  ScrollController _controller = ScrollController();
  double topMenuScrolledFraction = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // ignore: invalid_use_of_protected_member
        if (!_controller.hasListeners) {
          _controller.addListener(() {
            setState(() {
              topMenuScrolledFraction = min(
                  1,
                  _controller.position.pixels /
                      (widget.fractions['matchSelectionMenu'] * constraints.maxHeight));
            });
          });
        }

        return ListView(
          physics: (topMenuScrolledFraction == 0)
              ? NeverScrollableScrollPhysics()
              : SnapScrollSheetPhysics(
                  topChildrenHeight: [
                    widget.fractions['matchSelectionMenu'] * constraints.maxHeight,
                  ],
                ),
          controller: _controller,
          children: [
            MatchSelectionMenu(
                onTap: matchSelected,
                height: constraints.maxHeight * widget.fractions['matchSelectionMenu']),
            (_selectedMatch == null)
                ? noMatchSelected(constraints.maxHeight)
                : CompareView(
                    match: _selectedMatch,
                    appHeight: constraints.maxHeight,
                    topMenuScrolledFraction: topMenuScrolledFraction,
                    onCompareTapped: onCompareTapped,
                  ),
          ],
        );
      },
    );
  }

  void onCompareTapped(appHeight) {
    setState(() {
      _controller.animateTo(
        widget.fractions['matchSelectionMenu'] * appHeight,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    });
  }

  Widget noMatchSelected(appHeight) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: appHeight * 0.1,
        ),
        Icon(
          Icons.face,
          color: TinterColors.white,
          size: 70,
        ),
        SizedBox(
          height: 10,
        ),
        (user.parrainMatches.length + user.matchedMatches.length == 0)
            ? Text(
                "Aucun match pour l'instant",
                style: TinterTextStyle.headline2,
              )
            : Text(
                'Selectionnez un match.',
                style: TinterTextStyle.headline2,
              ),
      ],
    );
  }

  void matchSelected(Match match) {
    setState(() {
      _selectedMatch = match;
    });
  }
}

class CompareView extends StatelessWidget {
  final Match _match;
  final double appHeight;
  final double topMenuScrolledFraction;
  final onCompareTapped;

  CompareView({
    @required Match match,
    @required this.appHeight,
    @required this.topMenuScrolledFraction,
    @required this.onCompareTapped,
  }) : _match = match;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        facesAroundScore(),
        SizedBox(height: 50),
        statusRectangle(),
        SizedBox(height: 50),
        (topMenuScrolledFraction == 0)
            ? Container()
            : Opacity(
                opacity: topMenuScrolledFraction,
                child: informationComparison(),
              ),
      ],
    );
  }

  Widget facesAroundScore() {
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
                profilePicture(user.profile),
                profilePictureText(
                  user.profile,
                  isYou: true,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 20,
            child: score(),
          ),
          Expanded(
            flex: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                profilePicture(_match),
                profilePictureText(
                  _match,
                  isYou: false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Displays either your face text or your match face text
  Widget profilePictureText(Profile profile, {bool isYou}) {
    return Container(
      height: appHeight * 0.1,
      child: Center(
        child: AutoSizeText(
          isYou ? 'You' : profile.name + '\n' + profile.surname,
          textAlign: TextAlign.center,
          style: TinterTextStyle.headline2,
          maxFontSize: 18,
        ),
      ),
    );
  }

  /// Displays either your face or your match face
  Widget profilePicture(Profile profile) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.amber,
      ),
      height: appHeight * 0.09,
      width: appHeight * 0.09,
    );
  }

  Widget score() {
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
                  Text(
                    'Score',
                    style: TinterTextStyle.headline1,
                  ),
                  Stack(
                    children: <Widget>[
                      Text(
                        _match.score.toString(),
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: TinterTextStyle.headline1.color,
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
                    width: 2,
                  ),
                ),
                height: 20,
                width: 20,
                child: Center(
                  child: Text(
                    '?',
                    style: TextStyle(),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget statusRectangle() {
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
                child: AutoSizeText(
                  (_match.state == 1)
                      ? "Cette personne ne t'a pas encore liker"
                      : (_match.state == 2)
                          ? (user.profile.primoEntrant)
                              ? "Demande lui de te parrainer"
                              : "Propose lui d'être ton parrain"
                          : (_match.state == 3)
                              ? "Demande de parrainage envoyée"
                              : (_match.state == 4)
                                  ? (user.profile.primoEntrant)
                                      ? "Cette personne veut te parrainer"
                                      : "Cette personne veut que tu la parraine"
                                  : (_match.state == 5)
                                      ? (user.profile.primoEntrant)
                                          ? "Cette personne te parraine!"
                                          : 'Tu parraine cette personne!'
                                      : 'ERROR: the state should be between 1 and 5, not ' +
                                          _match.state.toString(),
                  style: TinterTextStyle.headline2,
                  maxLines: 1,
                ),
              ),
            ),
            ...([1, 3, 5].contains(_match.state))
                ? [Container()]
                : [
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 10,
                      ),
                    ),
                    Expanded(
                      flex: 1000,
                      child: (_match.state == 2)
                          ? Center(
                            child: InkWell(
                                child: Container(
                                  padding: EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                    color: TinterColors.secondaryAccent,
                                  ),
                                  child: AutoSizeText(
                                    "Envoyer une demande",
                                    style: TinterTextStyle.headline2,
                                  ),
                                ),
                              ),
                          )
                          : (_match.state == 4)
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                          color: TinterColors.secondaryAccent,
                                        ),
                                        child: AutoSizeText(
                                          "Accepter",
                                          style: TinterTextStyle.headline2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    InkWell(
                                      child: Container(
                                        padding: EdgeInsets.all(5.0),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(3.0)),
                                          color: TinterColors.secondaryAccent,
                                        ),
                                        child: AutoSizeText(
                                          "Refuser",
                                          style: TinterTextStyle.headline2,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : AutoSizeText(
                                  'ERROR: the state should be between 1 and 5, not ' +
                                      _match.state.toString(),
                                ),
                    ),
                  ],
            ...(topMenuScrolledFraction == 1)
                ? [Container()]
                : [
                    Container(
                      constraints: BoxConstraints(
                        minHeight: 10,
                      ),
                    ),
                    Expanded(
                      flex: (1000 * (1 - topMenuScrolledFraction)).floor(),
                      child: Center(
                        child: InkWell(
                          onTap: () => onCompareTapped(appHeight),
                          child: Container(
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(3.0)),
                              color: TinterColors.grey,
                            ),
                            child: AutoSizeText(
                              'Compare vos profils',
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              maxFontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
          ],
        ),
      ),
    );
  }

  Widget informationRectangle(
      {@required Widget child, double width, double height, EdgeInsetsGeometry padding}) {
    return Align(
      alignment: AlignmentDirectional.center,
      child: Container(
        padding: padding,
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

  Widget verticalSeparator() {
    return Container(
      width: 1.0,
      color: TinterColors.primaryAccent,
    );
  }

  Widget informationComparison() {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ProfileInformation(profile: user.profile),
          ),
          verticalSeparator(),
          Expanded(
            child: ProfileInformation(profile: _match),
          ),
        ],
      ),
    );
  }
}

class ProfileInformation extends StatelessWidget {
  final Profile profile;

  ProfileInformation({@required this.profile});

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
        children: <Widget>[
          informationRectangle(
            context: context,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    'Associations',
                    style: TinterTextStyle.headline2,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 50,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: profile.associations.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 5,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return associationBubble(context, profile.associations[index]);
                      },
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
                  Text(
                    'Attirance pour la vie associative',
                    textAlign: TextAlign.center,
                    style: TinterTextStyle.headline2,
                  ),
                  SliderTheme(
                    data: TinterSliderTheme.disabled,
                    child: Slider(
                      value: profile.attiranceVieAsso,
                      onChanged: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          informationRectangle(
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
                          value: profile.feteOuCours,
                          onChanged: null,
                        ),
                      ),
                      leftLabel: 'Cours',
                      rightLabel: 'Soirée'),
                ],
              ),
            ),
          ),
          informationRectangle(
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
                          value: profile.aideOuSortir,
                          onChanged: null,
                        ),
                      ),
                      leftLabel: 'Aide',
                      rightLabel: 'Sortir'),
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
                  Text(
                    'Aime organiser les événements?',
                    style: TinterTextStyle.headline2,
                    textAlign: TextAlign.center,
                  ),
                  SliderTheme(
                    data: TinterSliderTheme.disabled,
                    child: Slider(
                      value: profile.organisationEvenements,
                      onChanged: null,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: informationRectangle(
              context: context,
              width: double.infinity,
              child: Column(
                children: <Widget>[
                  Text(
                    'Goûts musicaux',
                    style: TinterTextStyle.headline2,
                  ),
                  Wrap(
                    spacing: 15,
                    children: <Widget>[
                      for (String musicStyle in profile.goutsMusicaux.get)
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
          ),
        ],
      ),
    );
  }

  Widget informationRectangle(
      {@required BuildContext context, @required Widget child, double width, double height}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: TinterColors.primary,
      ),
      width: width,
      height: height,
      child: child,
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

class MatchSelectionMenu extends StatelessWidget {
  final _onTap;
  final double height;

  MatchSelectionMenu({@required onTap, @required this.height}) : _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        topMenu(displayParrain: false),
        topMenu(displayParrain: true),
      ],
    );
  }

  /// Either displays the parrain top menu or the match top menu
  Widget topMenu({bool displayParrain}) {
    return (user.matchedMatches.length == 0)
        ? Container()
        : Container(
            height: height / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
                  child: Text(
                    (displayParrain) ? 'Mes parrains et marraines' : 'Mes matchs',
                    style: TinterTextStyle.headline2,
                  ),
                ),
                Flexible(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (Match match
                          in (displayParrain) ? user.parrainMatches : user.matchedMatches)
                        InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () => _onTap(match),
                          child: Container(
                            margin: EdgeInsets.only(
                              right: 30.0,
                              left: (match ==
                                      ((displayParrain)
                                          ? user.parrainMatches[0]
                                          : user.matchedMatches[0]))
                                  ? 20.0
                                  : 0.0,
                            ),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.amber,
                            ),
                            height: 40,
                            width: 40,
                          ),
                        ),
                    ],
                  ),
                ),
                separator(),
              ],
            ),
          );
  }

  Widget separator() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
      height: 0.5,
      color: TinterColors.primaryAccent,
    );
  }
}