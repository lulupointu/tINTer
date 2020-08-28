import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:separated_column/separated_column.dart';
import 'package:tinterapp/Logic/blocs/associatif/matched_matches/matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/association_logo.dart';
import 'package:tinterapp/Logic/models/shared/user_profile_picture.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/shared_element/slider_label.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';

import 'snap_scroll_sheet_physics.dart';

main() => runApp(MaterialApp(
      home: Material(
        color: TinterColors.background,
        child: MatchsTab(),
      ),
    ));

class MatchsTab extends StatefulWidget {
  final Map<String, double> fractions = {
    'matchSelectionMenu': null,
  };

  @override
  _MatchsTabState createState() => _MatchsTabState();
}

class _MatchsTabState extends State<MatchsTab> {
  String _selectedMatchLogin;
  ScrollController _controller = ScrollController();
  ScrollPhysics _scrollPhysics = NeverScrollableScrollPhysics();
  double topMenuScrolledFraction = 0;

  @override
  void initState() {
    // Update to last information
    BlocProvider.of<MatchedMatchesBloc>(context).add(MatchedMatchesRequestedEvent());

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchedMatchesBloc, MatchedMatchesState>(
        builder: (BuildContext context, MatchedMatchesState state) {
      if (!(state is MatchedMatchesLoadSuccessState)) {
        return Center(child: CircularProgressIndicator());
      }

      // Get the 2 list out of all the matched matches
      final List<BuildMatch> allMatches = (state as MatchedMatchesLoadSuccessState).matches;
      final List<BuildMatch> _matchesNotParrains =
          allMatches.where((match) => match.status != MatchStatus.parrainAccepted).toList();
      final List<BuildMatch> _parrains =
          allMatches.where((match) => match.status == MatchStatus.parrainAccepted).toList();

      // Sort them
      _matchesNotParrains
          .sort((BuildMatch matchA, BuildMatch matchB) => matchA.name.compareTo(matchB.name));
      _parrains
          .sort((BuildMatch matchA, BuildMatch matchB) => matchA.name.compareTo(matchB.name));

      widget.fractions['matchSelectionMenu'] =
          ((_matchesNotParrains.length == 0) ? 0.0 : 0.2) +
              ((_parrains.length == 0) ? 0.0 : 0.2);
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

          return NotificationListener<ScrollEndNotification>(
            onNotification: (ScrollEndNotification scrollEndNotification) {
              _scrollPhysics = scrollEndNotification.metrics.pixels == 0
                  ? NeverScrollableScrollPhysics()
                  : SnapScrollSheetPhysics(
                      topChildrenHeight: [
                        widget.fractions['matchSelectionMenu'] * constraints.maxHeight,
                      ],
                    );
              return true;
            },
            child: ListView(
              physics: _scrollPhysics,
              controller: _controller,
              children: [
                MatchSelectionMenu(
                  onTap: matchSelected,
                  height: constraints.maxHeight * widget.fractions['matchSelectionMenu'],
                  matchesNotParrains: _matchesNotParrains,
                  parrains: _parrains,
                ),
                (_selectedMatchLogin == null)
                    ? noMatchSelected(constraints.maxHeight)
                    : CompareView(
                        match: allMatches.firstWhere(
                            (BuildMatch match) => match.login == _selectedMatchLogin),
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
        BlocBuilder<MatchedMatchesBloc, MatchedMatchesState>(
          buildWhen: (MatchedMatchesState previousState, MatchedMatchesState state) {
            if (previousState.runtimeType != state.runtimeType) {
              return true;
            }
            if (previousState is MatchedMatchesLoadSuccessState &&
                state is MatchedMatchesLoadSuccessState) {
              if (previousState.matches.length != state.matches.length) {
                return true;
              }
            }
            return false;
          },
          builder: (BuildContext context, MatchedMatchesState state) {
            if (!(state is MatchedMatchesLoadSuccessState)) {
              return CircularProgressIndicator();
            }
            return ((state as MatchedMatchesLoadSuccessState).matches.length == 0)
                ? Text(
                    "Aucun match pour l'instant",
                    style: TinterTextStyle.headline2,
                  )
                : Text(
                    'Selectionnez un match.',
                    style: TinterTextStyle.headline2,
                  );
          },
        ),
      ],
    );
  }

  void matchSelected(BuildMatch match) {
    setState(() {
      _selectedMatchLogin = match.login;
    });
  }
}

class CompareView extends StatelessWidget {
  final BuildMatch _match;
  final double appHeight;
  final double topMenuScrolledFraction;
  final onCompareTapped;

  CompareView({
    @required BuildMatch match,
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
        statusRectangle(context),
        SizedBox(height: 50),
        Opacity(
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
                BlocBuilder<UserBloc, UserState>(
                    builder: (BuildContext context, UserState userState) {
                  if (!(userState is UserLoadSuccessState)) {
                    return CircularProgressIndicator();
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
            child: score(),
          ),
          Expanded(
            flex: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                userPicture(
                    getProfilePicture: ({@required height, @required width}) =>
                        getProfilePictureFromLocalPathOrLogin(
                            login: _match.login,
                            localPath: _match.profilePictureLocalPath,
                            height: height,
                            width: width)),
                userPictureText(title: _match.name + '\n' + _match.surname),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Displays either your face text or your match face text
  Widget userPictureText({String title}) {
    return Container(
      height: appHeight * 0.1,
      child: Center(
        child: AutoSizeText(
          title,
          textAlign: TextAlign.center,
          style: TinterTextStyle.headline2,
          maxFontSize: 18,
        ),
      ),
    );
  }

  /// Displays either your face or your match face
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
                  child: AutoSizeText(
                    (_match.status == MatchStatus.liked ||
                            _match.status == MatchStatus.heIgnoredYou)
                        ? "Cette personne ne t'a pas encore liker"
                        : (_match.status == MatchStatus.matched)
                            ? (_match.primoEntrant)
                                ? "Demande lui de te parrainer"
                                : "Propose lui d'être ton parrain"
                            : (_match.status == MatchStatus.youAskedParrain)
                                ? "Demande de parrainage envoyée"
                                : (_match.status == MatchStatus.heAskedParrain)
                                    ? (_match.primoEntrant)
                                        ? "Cette personne veut te parrainer"
                                        : "Cette personne veut que tu la parraine"
                                    : (_match.status == MatchStatus.parrainAccepted)
                                        ? (_match.primoEntrant)
                                            ? "Cette personne te parraine!"
                                            : 'Tu parraine cette personne!'
                                        : (_match.status == MatchStatus.parrainHeRefused)
                                            ? 'Cette personne à refusée ta demande'
                                            : (_match.status == MatchStatus.parrainYouRefused)
                                                ? (_match.primoEntrant)
                                                    ? "Tu as refusé de parrainer cette personne."
                                                    : "Tu as refusé que cette personne te parraine."
                                                : 'ERROR: the status should not be ${_match.status}',
                    style: TinterTextStyle.headline2,
                    maxLines: 1,
                  ),
                ),
              ),
            ),
            if ([MatchStatus.matched, MatchStatus.heAskedParrain].contains(_match.status)) ...[
              Container(
                constraints: BoxConstraints(
                  minHeight: 10,
                ),
              ),
              Expanded(
                flex: 1000,
                child: (_match.status == MatchStatus.matched)
                    ? Center(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            BlocProvider.of<MatchedMatchesBloc>(context)
                                .add(AskParrainEvent(match: _match));
                          },
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
                    : (_match.status == MatchStatus.heAskedParrain)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  BlocProvider.of<MatchedMatchesBloc>(context)
                                      .add(AcceptParrainEvent(match: _match));
                                },
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
                                splashColor: Colors.transparent,
                                onTap: () {
                                  BlocProvider.of<MatchedMatchesBloc>(context)
                                      .add(RefuseParrainEvent(match: _match));
                                },
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
                            'ERROR: the state should not be ' + _match.status.toString(),
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
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(3.0)),
                        color: TinterColors.background.withOpacity(0.8),
                      ),
                      child: AutoSizeText(
                        'Compare vos profils',
                        style: TinterTextStyle.goutMusicauxNotLiked,
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        maxFontSize: 15,
                      ),
                    ),
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
            child: BlocBuilder<UserBloc, UserState>(
                builder: (BuildContext context, UserState state) {
              if (!(state is KnownUserState)) {
                BlocProvider.of<UserBloc>(context).add(UserRequestEvent());
                return CircularProgressIndicator();
              }
              return ProfileInformation(user: (state as KnownUserState).user);
            }),
          ),
          verticalSeparator(),
          Expanded(
            child: ProfileInformation(user: _match),
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
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: user.associations.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: EdgeInsets.only(right: 5.0, left: index == 0 ? 5.0 : 0),
                          child: associationBubble(context, user.associations[index]),
                        );
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
                      value: user.attiranceVieAsso,
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
                          value: user.feteOuCours,
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
                          value: user.aideOuSortir,
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
                      value: user.organisationEvenements,
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
                      for (String musicStyle in user.goutsMusicaux)
                        Chip(
                          label: Text(musicStyle),
                          labelStyle: TinterTextStyle.goutMusicauxLiked,
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
  final List<BuildMatch> matchesNotParrains;
  final List<BuildMatch> parrains;

  MatchSelectionMenu(
      {@required onTap,
      @required this.height,
      @required this.matchesNotParrains,
      @required this.parrains})
      : _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
        children: [
          (matchesNotParrains.length != 0)
              ? Expanded(child: topMenu(matches: matchesNotParrains, title: 'Mes matchs'))
              : Container(),
          (parrains.length != 0)
              ? Expanded(child: topMenu(matches: parrains, title: 'Mes Parrains et marraines'))
              : Container(),
        ],
      ),
    );
  }

  /// Either displays the parrain top menu or the match top menu
  Widget topMenu({@required List<BuildMatch> matches, @required String title}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20),
          child: Text(
            title,
            style: TinterTextStyle.headline2,
          ),
        ),
        Flexible(
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (BuildMatch match in matches)
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () => _onTap(match),
                  child: Container(
                    margin: EdgeInsets.only(
                      right: 20.0,
                      left: match == matches[0] ? 20.0 : 0.0,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    height: 50,
                    width: 50,
                    child: getProfilePictureFromLocalPathOrLogin(
                      login: match.login,
                      localPath: match.profilePictureLocalPath,
                      height: 50,
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

  Widget separator() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 60, vertical: 10),
      height: 0.5,
      color: TinterColors.primaryAccent,
    );
  }
}
