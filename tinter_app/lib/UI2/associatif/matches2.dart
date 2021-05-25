import 'dart:html';
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
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/Logic/models/associatif/match.dart';
import 'package:tinterapp/UI/shared/snap_scroll_sheet_physics/snap_scroll_sheet_physics.dart';
import 'package:tinterapp/UI2/associatif/mode_associatif_overlay.dart';
import 'package:tinterapp/UI2/shared2/random_gender.dart';
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

  final spacing = 15.0;

  @override
  MatchsTab2State createState() => MatchsTab2State();
}

class MatchsTab2State extends State<MatchsTab2> {
  ScrollController _controller = ScrollController();
  ScrollPhysics _scrollPhysics = AlwaysScrollableScrollPhysics();
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

              widget.fractions['matchSelectionMenu'] = ((_matchesNotParrains.length == 0)
                  ? 0.0
                  : (ModeAssociatifOverlay.height +
                  2 * widget.spacing +
                  MatchSelectionMenu.height) /
                  MediaQuery.of(context).size.height) +
                  ((_parrains.length == 0) ? 0.0 : 0.175);
              return Builder(
                builder: (BuildContext context) {
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
                                        MediaQuery.of(context).size.height)));
                      });
                    });
                  }

                  return NotificationListener<ScrollEndNotification>(
                    onNotification: (ScrollEndNotification scrollEndNotification) {
                      _scrollPhysics = _controller.offset == 0
                          ? AlwaysScrollableScrollPhysics()
                          : SnapScrollSheetPhysics(
                        topChildrenHeight: [
                          widget.fractions['matchSelectionMenu'] * MediaQuery.of(context).size.height,
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
                            child: ModeAssociatifOverlay(),
                          ),
                        ),
                        SizedBox(height: widget.spacing),
                        MatchSelectionMenu(
                          matchesNotParrains: _matchesNotParrains,
                          parrains: _parrains,
                        ),
                        (context.watch<SelectedAssociatif2>().matchLogin == null)
                            ? noMatchSelected(MediaQuery.of(context).size.height)
                            : CompareView(
                          match: allMatches.firstWhere((BuildMatch match) =>
                          match.login ==
                              context.watch<SelectedAssociatif2>().matchLogin),
                          appHeight: MediaQuery.of(context).size.height,
                          topMenuScrolledFraction: topMenuScrolledFraction,
                          onCompareTapped: onCompareTapped,
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

  Future<void> onCompareTapped(appHeight) async {
    await _controller.animateTo(
      widget.fractions['matchSelectionMenu'] * appHeight,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    setState(() {});
  }

  Widget noMatchSelected(appHeight) {
    return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: appHeight * 0.1,
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
                          "Il n'y a aucun match à afficher pour l'instant.",
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
                          "Sélectionne un match !",
                          style: Theme.of(context).textTheme.headline4,
                        )
                      ],
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
  final Future<void> Function(double) onCompareTapped;

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
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 30.0,
            horizontal: 20.0,
          ),
          child: facesAroundScore(context),
        ),
        statusRectangle(context),
        SizedBox(height: 30),
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
        height: appHeight *
            0.375 *
            (1 - 0.33 * topMenuScrolledFraction) *
            (([MatchStatus.matched, MatchStatus.heAskedParrain]
                    .contains(_match.statusAssociatif))
                ? 1.0
                : 0.75),
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
                                            ? 'Cette personne a refusé ta demande de parrainage'
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
            if (topMenuScrolledFraction != 1)
              Expanded(
                flex: (1500 * (1 - topMenuScrolledFraction)).floor(),
                child: Center(
                  child: Container(
                    width: 250,
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
            if ([MatchStatus.matched, MatchStatus.heAskedParrain]
                .contains(_match.statusAssociatif)) ...[
              Expanded(
                flex: 1500,
                child: //(_match.statusAssociatif == MatchStatus.matched)
                    false
                        ? Center(
                            child: Container(
                              width: 250,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Theme.of(context).indicatorColor),
                                ),
                                onPressed: () {
                                  BlocProvider.of<MatchedMatchesBloc>(context)
                                      .add(AskParrainEvent(match: _match));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                    vertical: 15.0,
                                  ),
                                  child: Text(
                                    'Envoyer une demande',
                                    style: Theme.of(context).textTheme.headline5.copyWith(
                                          color: Colors.white,
                                        ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : (_match.statusAssociatif == MatchStatus.heAskedParrain)
                            ? Container(
                                width: 250,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          BlocProvider.of<MatchedMatchesBloc>(context)
                                              .add(AcceptParrainEvent(match: _match));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                            vertical: 15.0,
                                          ),
                                          child: Text(
                                            'Accepter',
                                            style:
                                                Theme.of(context).textTheme.headline5.copyWith(
                                                      color: Colors.white,
                                                    ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: ElevatedButton(
                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(
                                              Theme.of(context).indicatorColor),
                                        ),
                                        onPressed: () {
                                          BlocProvider.of<MatchedMatchesBloc>(context)
                                              .add(RefuseParrainEvent(match: _match));
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0,
                                            vertical: 15.0,
                                          ),
                                          child: Text(
                                            'Refuser',
                                            style:
                                                Theme.of(context).textTheme.headline5.copyWith(
                                                      color: Colors.white,
                                                    ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : AutoSizeText(
                                'ERROR: the state should not be ' +
                                    _match.statusAssociatif.toString(),
                              ),
              ),
            ],
            Expanded(
              flex: 1500,
              child: Center(
                child: Container(
                  width: 250,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).errorColor),
                    ),
                    onPressed: () async {
                      await onCompareTapped(0);
                      context.read<SelectedAssociatif2>().matchLogin = null;
                      BlocProvider.of<MatchedMatchesBloc>(context).add(
                        IgnoreMatchEvent(match: _match),
                      );
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
            ),
            SizedBox(
              height: 10.0,
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
            height: 20,
          );
        },
        includeOuterSeparators: false,
        children: <Widget>[
          Card(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Associations',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 14.0,
                        ),
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
                                height: 50,
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 300),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: user.associations.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          right: 5.0,
                                        ),
                                        child: associationBubble(
                                            context, user.associations[index]),
                                      );
                                    },
                                  ),
                                ),
                              )
                            : Text(
                                'Aucune association sélectionnée',
                                style: Theme.of(context).textTheme.headline5.copyWith(
                                      fontSize: 14.0,
                                    ),
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
              padding: const EdgeInsets.only(left: 15.0, right: 25.0, top: 10.0, bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Attirance pour la vie associative',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 14.0,
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
                          Icons.celebration,
                          color: Theme.of(context).primaryColor,
                          size: 22.0,
                        ),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: Theme.of(context).sliderTheme.copyWith(
                                disabledActiveTrackColor: Theme.of(context).primaryColor,
                                disabledThumbColor: Color(0xffCECECE),
                                overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
                                trackHeight: 6.0,
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                              ),
                          child: Slider(
                            value: user.attiranceVieAsso,
                            onChanged: null,
                          ),
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
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 15.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Préférence entre vie associative et scolaire',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 14.0,
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
                          Icons.celebration,
                          color: Theme.of(context).primaryColor,
                          size: 22.0,
                        ),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: Theme.of(context).sliderTheme.copyWith(
                                disabledActiveTrackColor: Theme.of(context).primaryColor,
                                disabledThumbColor: Color(0xffCECECE),
                                overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
                                trackHeight: 6.0,
                                disabledInactiveTrackColor: Theme.of(context).indicatorColor,
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                              ),
                          child: Slider(
                            value: user.feteOuCours,
                            onChanged: null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.school_rounded,
                          color: Theme.of(context).indicatorColor,
                          size: 22.0,
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
              padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0, bottom: 15.0),
              child: Column(
                children: <Widget>[
                  Text(
                    randomGender == Gender.M
                        ? 'Parrain qui aide ou avec qui sortir ?'
                        : 'Marraine qui aide ou avec qui sortir ?',
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 14.0,
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
                          Icons.sports_bar_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 22.0,
                        ),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: Theme.of(context).sliderTheme.copyWith(
                                disabledActiveTrackColor: Theme.of(context).primaryColor,
                                disabledThumbColor: Color(0xffCECECE),
                                overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
                                trackHeight: 6.0,
                                disabledInactiveTrackColor: Theme.of(context).indicatorColor,
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                              ),
                          child: Slider(
                            value: user.aideOuSortir,
                            onChanged: null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Icon(
                          Icons.support_rounded,
                          color: Theme.of(context).indicatorColor,
                          size: 22.0,
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
              padding: const EdgeInsets.only(left: 15.0, right: 25.0, top: 10.0, bottom: 15.0),
              child: Column(
                children: <Widget>[
                  Text(
                    "Envie d'organiser des événements ?",
                    style: Theme.of(context).textTheme.headline5.copyWith(
                          fontSize: 14.0,
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
                          Icons.event_available_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 22.0,
                        ),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: Theme.of(context).sliderTheme.copyWith(
                                disabledActiveTrackColor: Theme.of(context).primaryColor,
                                disabledThumbColor: Color(0xffCECECE),
                                overlayShape: RoundSliderOverlayShape(overlayRadius: 0.0),
                                trackHeight: 6.0,
                                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                              ),
                          child: Slider(
                            value: user.organisationEvenements,
                            onChanged: null,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                bottom: 20.0,
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Goûts musicaux',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      user.goutsMusicaux.length >= 1
                          ? Wrap(
                              alignment: WrapAlignment.center,
                              key: GlobalKey(),
                              spacing: 8,
                              runSpacing: 8,
                              children: <Widget>[
                                for (String musicStyle in user.goutsMusicaux)
                                  Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.0, vertical: 6.0),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          spreadRadius: 0.2,
                                          blurRadius: 5,
                                          offset: Offset(2, 2),
                                        )
                                      ],
                                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                      border: Border.all(
                                          color: (Theme.of(context).primaryColor),
                                          width: 3.0,
                                          style: BorderStyle.solid),
                                      color: Colors.white,
                                    ),
                                    child: Text(musicStyle),
                                  ),
                              ],
                            )
                          : Text(
                              'Aucun goût musical sélectionné',
                              style: Theme.of(context).textTheme.headline5,
                              textAlign: TextAlign.center,
                            )
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
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Theme.of(context).primaryColor, width: 2.5),
        ),
        child: ClipOval(
          child: getLogoFromAssociation(associationName: association.name),
        ),
      ),
    );
  }
}

class MatchSelectionMenu extends StatelessWidget {
  static final double height = 100;
  final List<BuildMatch> matchesNotParrains;
  final List<BuildMatch> parrains;

  MatchSelectionMenu({@required this.matchesNotParrains, @required this.parrains});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ((matchesNotParrains.length != 0) && (parrains.length != 0))
          ? 2 * height + 15.0
          : height,
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
          ((matchesNotParrains.length != 0) && (parrains.length != 0))
              ? SizedBox(
                  height: 15.0,
                )
              : Container(),
          (parrains.length != 0)
              ? Expanded(
                  child: topMenu(
                    context: context,
                    matches: parrains,
                    title: 'Mes parrains et marraines',
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
