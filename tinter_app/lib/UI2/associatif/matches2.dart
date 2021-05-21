import 'dart:math';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:separated_column/separated_column.dart';
import 'package:tinterapp/Logic/blocs/associatif/matched_matches/matches_bloc.dart';
import 'package:tinterapp/Logic/blocs/associatif/user_associatif_search/user_associatif_search_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/association_logo.dart';
import 'package:tinterapp/Logic/models/shared/user_profile_picture.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/shared_element/slider_label.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';
import 'package:tinterapp/UI/shared/snap_scroll_sheet_physics/snap_scroll_sheet_physics.dart';
import 'package:tinterapp/UI2/associatif/mode_associatif_overlay.dart';
import 'package:tinterapp/main.dart';

main() => runApp(MaterialApp(
      home: Material(
        child: MatchsTab2(),
      ),
    ));

class SelectedAssociatif2 extends ChangeNotifier {
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

class MatchsTab2 extends StatefulWidget implements TinterTab {
  final Map<String, double> fractions = {
    'matchSelectionMenu': null,
  };

  @override
  MatchsTab2State createState() => MatchsTab2State();
}

class MatchsTab2State extends State<MatchsTab2> {
  ScrollController _controller = ScrollController();
  ScrollPhysics _scrollPhysics = NeverScrollableScrollPhysics();
  double topMenuScrolledFraction = 0;

  bool isMatchDeleted = false;

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
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: BlocBuilder<MatchedMatchesBloc, MatchedMatchesState>(
            builder: (BuildContext context, MatchedMatchesState state) {
          if (!(state is MatchedMatchesLoadSuccessState)) {
            return Center(child: CircularProgressIndicator());
          }
          // Get the 2 list out of all the matched matches
          final List<BuildMatch> allMatches =
              (state as MatchedMatchesLoadSuccessState).matches;
          final List<BuildMatch> _matchesNotParrains = allMatches
              .where((match) => match.statusAssociatif != MatchStatus.parrainAccepted)
              .toList();
          final List<BuildMatch> _parrains = allMatches
              .where((match) => match.statusAssociatif == MatchStatus.parrainAccepted)
              .toList();

          // Sort them
          _matchesNotParrains.sort(
              (BuildMatch matchA, BuildMatch matchB) => matchA.name.compareTo(matchB.name));
          _parrains.sort(
              (BuildMatch matchA, BuildMatch matchB) => matchA.name.compareTo(matchB.name));

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
                                (widget.fractions['matchSelectionMenu'] *
                                    constraints.maxHeight)));
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
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20.0,
                        top: 15.0,
                      ),
                      child: Row(
                        children: [
                          ModeAssociatifOverlay(),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    MatchSelectionMenu(
                      height: 100,
                      matchesNotParrains: _matchesNotParrains,
                      parrains: _parrains,
                    ),
                    (context.watch<SelectedAssociatif2>().matchLogin == null) ||
                            isMatchDeleted
                        ? noMatchSelected(constraints.maxHeight)
                        : CompareView(
                            match: allMatches.firstWhere((BuildMatch match) =>
                                match.login ==
                                context.watch<SelectedAssociatif2>().matchLogin),
                            appHeight: constraints.maxHeight,
                            topMenuScrolledFraction: topMenuScrolledFraction,
                            onCompareTapped: onCompareTapped,
                            onDeleteTapped: onDeleteTapped,
                          ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }

  void onDeleteTapped() {
    setState(() {
      isMatchDeleted = true;
      Future.delayed(Duration(milliseconds: 100), () {
        isMatchDeleted = false;
      });
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
  final onDeleteTapped;

  CompareView({
    @required BuildMatch match,
    @required this.appHeight,
    @required this.topMenuScrolledFraction,
    @required this.onCompareTapped,
    @required this.onDeleteTapped,
  }) : _match = match;

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
                      getProfilePicture: ({@required height, @required width}) =>
                          getProfilePictureFromLocalPathOrLogin(
                              login: (userState as UserLoadSuccessState).user.login,
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
                  'Moi',
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
                        getProfilePictureFromLocalPathOrLogin(
                            login: _match.login,
                            localPath: _match.profilePictureLocalPath,
                            height: height,
                            width: width)),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  _match.name + '\n' + _match.surname,
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
        border: Border.all(color: Color(0xff79BFC9), width: 4.0, style: BorderStyle.solid),
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
        alignment: Alignment.bottomRight,
        children: [
          Container(
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
                    _match.score.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 5.0, bottom: 5.0),
            child: GestureDetector(
              onTap: () {
                showGeneralDialog(
                    transitionDuration: Duration(milliseconds: 300),
                    context: context,
                    pageBuilder: (BuildContext context, animation, _) => SimpleDialog(
                          elevation: 5.0,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                'Aide',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
                              child: Text(
                                "Le score est un indicateur sur 100 de l'affinité supposée entre deux étudiants."
                                " Il est basé sur les critères renseignés dans le profil.",
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headline5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 75.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context, false);
                                },
                                child: Text("Continuer"),
                              ),
                            ),
                          ],
                        ));
              },
              child: Icon(
                Icons.help_outline_outlined,
                color: Colors.black54,
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
        height: appHeight * 0.30,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1000,
              child: Center(
                child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                  return AutoSizeText(
                    (_match.statusAssociatif == MatchStatus.liked ||
                            _match.statusAssociatif == MatchStatus.heIgnoredYou)
                        ? "Cette personne ne t'a pas encore liké.e"
                        : (_match.statusAssociatif == MatchStatus.matched)
                            ? (_match.primoEntrant)
                                ? "Demande lui de te parrainer"
                                : "Propose lui d'être ton parrain"
                            : (_match.statusAssociatif == MatchStatus.youAskedParrain)
                                ? "Demande de parrainage envoyée"
                                : (_match.statusAssociatif == MatchStatus.heAskedParrain)
                                    ? (_match.primoEntrant)
                                        ? "Cette personne souhaite te parrainer"
                                        : "Cette personne souhaite que tu la parraine"
                                    : (_match.statusAssociatif == MatchStatus.parrainAccepted)
                                        ? (_match.primoEntrant)
                                            ? "Cette personne te parraine !"
                                            : 'Tu parraine cette personne !'
                                        : (_match.statusAssociatif ==
                                                MatchStatus.parrainHeRefused)
                                            ? 'Cette personne a refusé ta demande'
                                            : (_match.statusAssociatif ==
                                                    MatchStatus.parrainYouRefused)
                                                ? (_match.primoEntrant)
                                                    ? "Tu as refusé de parrainer cette personne"
                                                    : "Tu as refusé que cette personne te parraine"
                                                : 'ERROR: the status should not be ${_match.statusAssociatif}',
                    style: Theme.of(context).textTheme.headline5,
                    maxLines: 1,
                  );
                }),
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
                flex: (1500 * (1 - topMenuScrolledFraction)).floor(),
                child: Padding(
                  padding: const EdgeInsets.only(
                    bottom: 20.0,
                  ),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: () {
                        onCompareTapped(appHeight);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30.0,
                          vertical: 15.0,
                        ),
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
              ),
            Expanded(
              flex: (1500 * (1 - 0.33 * topMenuScrolledFraction)).floor(),
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0,
                ),
                child: Center(
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).errorColor),
                    ),
                    onPressed: () {
                      onCompareTapped(0);
                      Future.delayed(Duration(milliseconds: 500), () {
                        onDeleteTapped();
                        BlocProvider.of<MatchedMatchesBloc>(context).add(
                          IgnoreMatchEvent(match: _match),
                        );
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 15.0,
                      ),
                      child: Text(
                        'Supprimer ce match',
                        style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.white,
                            ),
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
      {@required Widget child, double width, double height, EdgeInsetsGeometry padding}) {
    return Align(
      alignment: AlignmentDirectional.center,
      child: Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return Container(
            width: width != null ? width : Size.infinite.width,
            height: height,
            child: Card(
              child: child,
            ),
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
                    for (BuildMatch match in matches)
                      GestureDetector(
                        onTap: () =>
                            context.read<SelectedAssociatif2>().matchLogin = match.login,
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
                              login: match.login,
                              localPath: match.profilePictureLocalPath,
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
}
