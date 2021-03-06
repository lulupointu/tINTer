import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:separated_column/separated_column.dart';
import 'package:tinterapp/Logic/blocs/associatif/matched_matches/matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/association_logo.dart';
import 'package:tinterapp/Logic/models/shared/user_profile_picture.dart';
import 'package:tinterapp/UI/shared/score_popup_helper/score_popup_helper.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/shared_element/slider_label.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';
import 'package:tinterapp/UI/shared/snap_scroll_sheet_physics/snap_scroll_sheet_physics.dart';
import 'package:tinterapp/main.dart';

main() => runApp(MaterialApp(
      home: Material(
        child: MatchsTab(),
      ),
    ));

class SelectedAssociatif extends ChangeNotifier {
  String _matchLogin;

  String get matchLogin => _matchLogin;

  set matchLogin(newMatchLogin) {
    if (newMatchLogin != matchLogin) {
      _matchLogin = newMatchLogin;
      notifyListeners();
      notificationHandler.removeNotification(newMatchLogin.hashCode);
    }
  }
}

class MatchsTab extends StatefulWidget implements TinterTab {
  final Map<String, double> fractions = {
    'matchSelectionMenu': null,
  };

  @override
  MatchsTabState createState() => MatchsTabState();
}

class MatchsTabState extends State<MatchsTab> {
  ScrollController _controller = ScrollController();
  ScrollPhysics _scrollPhysics = NeverScrollableScrollPhysics();
  double topMenuScrolledFraction = 0;

  @override
  void initState() {
    // Update to last information
    if (BlocProvider.of<MatchedMatchesBloc>(context).state is MatchedMatchesLoadSuccessState) {
      BlocProvider.of<MatchedMatchesBloc>(context).add(MatchedMatchesRefreshEvent());
    } else {
      BlocProvider.of<MatchedMatchesBloc>(context).add(MatchedMatchesRequestedEvent());
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
    return BlocBuilder<MatchedMatchesBloc, MatchedMatchesState>(
        builder: (BuildContext context, MatchedMatchesState state) {
      if (!(state is MatchedMatchesLoadSuccessState)) {
        return Center(child: CircularProgressIndicator());
      }

      // Get the 2 list out of all the matched matches
      final List<BuildMatch> allMatches = (state as MatchedMatchesLoadSuccessState).matches;
      final List<BuildMatch> _matchesNotParrains = allMatches
          .where((match) => match.statusAssociatif != MatchStatus.parrainAccepted)
          .toList();
      final List<BuildMatch> _parrains = allMatches
          .where((match) => match.statusAssociatif == MatchStatus.parrainAccepted)
          .toList();

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
                topMenuScrolledFraction = max(
                    0,
                    min(
                        1,
                        _controller.position.pixels /
                            (widget.fractions['matchSelectionMenu'] * constraints.maxHeight)));
              });
            });
          }

          return NotificationListener<ScrollEndNotification>(
            onNotification: (ScrollEndNotification scrollEndNotification) {
              _scrollPhysics = _controller.offset == 0
                  ? NeverScrollableScrollPhysics()
                  : SnapScrollSheetPhysics(
                      topChildrenHeight: [
                        widget.fractions['matchSelectionMenu'] * constraints.maxHeight,
                      ],
                    );
              setState(() {});
              return true;
            },
            child: ListView(
              physics: _scrollPhysics,
              controller: _controller,
              children: [
                MatchSelectionMenu(
                  height: constraints.maxHeight * widget.fractions['matchSelectionMenu'],
                  matchesNotParrains: _matchesNotParrains,
                  parrains: _parrains,
                ),
                (context.watch<SelectedAssociatif>().matchLogin == null)
                    ? noMatchSelected(constraints.maxHeight)
                    : CompareView(
                        match: allMatches.firstWhere((BuildMatch match) =>
                            match.login == context.watch<SelectedAssociatif>().matchLogin),
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
    return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: appHeight * 0.1,
          ),
          Icon(
            Icons.face,
            color: tinterTheme.colors.defaultTextColor,
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
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ((state as MatchedMatchesLoadSuccessState).matches.length == 0)
                  ? Text(
                      "Aucun match pour l'instant",
                      style: tinterTheme.textStyle.headline2,
                    )
                  : Text(
                      'Selectionnez un match.',
                      style: tinterTheme.textStyle.headline2,
                    );
            },
          ),
        ],
      );
    });
  }

// void matchSelected(BuildMatch match) {
//   setState(() {
//     selectedMatchLogin = match.login;
//   });
// }
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
        facesAroundScore(context),
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
                    return Center(
                      child: CircularProgressIndicator(),
                    );
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
    return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
      return Container(
        height: appHeight * 0.1,
        child: Center(
          child: AutoSizeText(
            title,
            textAlign: TextAlign.center,
            style: tinterTheme.textStyle.headline2,
            maxFontSize: 18,
          ),
        ),
      );
    });
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

  Widget score(BuildContext context) {
    return informationRectangle(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.center,
              child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Score',
                      style: tinterTheme.textStyle.headline1,
                    ),
                    Stack(
                      children: <Widget>[
                        Text(
                          _match.score.toString(),
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            color: tinterTheme.textStyle.headline1.color,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ),
            Align(
              alignment: AlignmentDirectional.bottomEnd,
              child: InkWell(
                onTap: () => showWhatIsScore(context),
                child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                  return Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 2,
                        color: tinterTheme.colors.defaultTextColor,
                      ),
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
                      (_match.statusAssociatif == MatchStatus.liked ||
                              _match.statusAssociatif == MatchStatus.heIgnoredYou)
                          ? "Cette personne ne t'a pas encore liker"
                          : (_match.statusAssociatif == MatchStatus.matched)
                              ? (_match.primoEntrant)
                                  ? "Demande lui de te parrainer"
                                  : "Propose lui d'être ton parrain"
                              : (_match.statusAssociatif == MatchStatus.youAskedParrain)
                                  ? "Demande de parrainage envoyée"
                                  : (_match.statusAssociatif == MatchStatus.heAskedParrain)
                                      ? (_match.primoEntrant)
                                          ? "Cette personne veut te parrainer"
                                          : "Cette personne veut que tu la parraine"
                                      : (_match.statusAssociatif ==
                                              MatchStatus.parrainAccepted)
                                          ? (_match.primoEntrant)
                                              ? "Cette personne te parraine!"
                                              : 'Tu parraine cette personne!'
                                          : (_match.statusAssociatif ==
                                                  MatchStatus.parrainHeRefused)
                                              ? 'Cette personne à refusée ta demande'
                                              : (_match.statusAssociatif ==
                                                      MatchStatus.parrainYouRefused)
                                                  ? (_match.primoEntrant)
                                                      ? "Tu as refusé de parrainer cette personne."
                                                      : "Tu as refusé que cette personne te parraine."
                                                  : 'ERROR: the status should not be ${_match.statusAssociatif}',
                      style: tinterTheme.textStyle.headline2,
                      maxLines: 1,
                    );
                  }),
                ),
              ),
            ),
            if ([MatchStatus.matched, MatchStatus.heAskedParrain]
                .contains(_match.statusAssociatif)) ...[
              Container(
                constraints: BoxConstraints(
                  minHeight: 10,
                ),
              ),
              Expanded(
                flex: 1000,
                child: (_match.statusAssociatif == MatchStatus.matched)
                    ? Center(
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            BlocProvider.of<MatchedMatchesBloc>(context)
                                .add(AskParrainEvent(match: _match));
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
                    : (_match.statusAssociatif == MatchStatus.heAskedParrain)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  BlocProvider.of<MatchedMatchesBloc>(context)
                                      .add(AcceptParrainEvent(match: _match));
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
                                  BlocProvider.of<MatchedMatchesBloc>(context)
                                      .add(RefuseParrainEvent(match: _match));
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
                                _match.statusAssociatif.toString(),
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
                          color: tinterTheme.colors.background.withOpacity(0.8),
                        ),
                        child: AutoSizeText(
                          'Compare vos profils',
                          style: tinterTheme.textStyle.chipNotLiked,
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
        color: tinterTheme.colors.secondaryAccent,
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
              child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                return Column(
                  children: <Widget>[
                    Text(
                      'Attirance pour la vie associative',
                      textAlign: TextAlign.center,
                      style: tinterTheme.textStyle.headline2,
                    ),
                    SliderTheme(
                      data: tinterTheme.slider.disabled,
                      child: Slider(
                        value: user.attiranceVieAsso,
                        onChanged: null,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          informationRectangle(
            context: context,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
              child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                return Column(
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
                          child: Slider(
                            value: user.feteOuCours,
                            onChanged: null,
                          ),
                        ),
                        leftLabel: 'Cours',
                        rightLabel: 'Soirée'),
                  ],
                );
              }),
            ),
          ),
          informationRectangle(
            context: context,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5),
              child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                return Column(
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
                          child: Slider(
                            value: user.aideOuSortir,
                            onChanged: null,
                          ),
                        ),
                        leftLabel: 'Aide',
                        rightLabel: 'Sortir'),
                  ],
                );
              }),
            ),
          ),
          informationRectangle(
            context: context,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                return Column(
                  children: <Widget>[
                    Text(
                      'Aime organiser les événements?',
                      style: tinterTheme.textStyle.headline2,
                      textAlign: TextAlign.center,
                    ),
                    SliderTheme(
                      data: tinterTheme.slider.disabled,
                      child: Slider(
                        value: user.organisationEvenements,
                        onChanged: null,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: informationRectangle(
              context: context,
              width: double.infinity,
              child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                return Column(
                  children: <Widget>[
                    Text(
                      'Goûts musicaux',
                      style: tinterTheme.textStyle.headline2,
                    ),
                    Wrap(
                      spacing: 15,
                      children: <Widget>[
                        for (String musicStyle in user.goutsMusicaux)
                          Chip(
                            label: Text(musicStyle),
                            labelStyle: tinterTheme.textStyle.chipLiked,
                            backgroundColor: tinterTheme.colors.primaryAccent,
                          )
                      ],
                    )
                  ],
                );
              }),
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

class MatchSelectionMenu extends StatelessWidget {
  final double height;
  final List<BuildMatch> matchesNotParrains;
  final List<BuildMatch> parrains;

  MatchSelectionMenu(
      {@required this.height, @required this.matchesNotParrains, @required this.parrains});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: Column(
        children: [
          (matchesNotParrains.length != 0)
              ? Expanded(
                  child: topMenu(
                    context: context,
                    matches: matchesNotParrains,
                    title: 'Mes matchs',
                  ),
                )
              : Container(),
          (parrains.length != 0)
              ? Expanded(
                  child: topMenu(
                    context: context,
                    matches: parrains,
                    title: 'Mes Parrains et marraines',
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  /// Either displays the parrain top menu or the match top menu
  Widget topMenu(
      {@required BuildContext context,
      @required List<BuildMatch> matches,
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
              for (BuildMatch match in matches)
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () => context.read<SelectedAssociatif>().matchLogin = match.login,
                  child: Center(
                    child: Consumer<TinterTheme>(
                      builder: (context, tinterTheme, child) {
                        return Container(
                          margin: EdgeInsets.only(
                            right: 20.0,
                            left: match == matches[0] ? 20.0 : 0.0,
                          ),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: tinterTheme.colors.background),
                          height: 50,
                          width: 50,
                          child: child,
                        );
                      },
                      child: getProfilePictureFromLocalPathOrLogin(
                        login: match.login,
                        localPath: match.profilePictureLocalPath,
                        height: 50,
                        width: 50,
                      ),
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
        color: tinterTheme.colors.secondaryAccent,
      );
    });
  }
}
