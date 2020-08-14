import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tinterapp/Logic/blocs/user/user_bloc.dart';
import 'package:tinterapp/Logic/models/association.dart';
import 'package:tinterapp/Logic/repository/user_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';
import 'package:tinterapp/UI/user_profile/associations.dart';
import 'package:tinterapp/UI/user_profile/gout_musicaux.dart';
import 'package:tinterapp/UI/user_profile/options.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:tinterapp/UI/user_profile/snap_scroll_physics.dart';

import '../shared_element/slider_label.dart';
import '../shared_element/const.dart';

main() {
  final http.Client httpClient = http.Client();
  TinterApiClient tinterApiClient = TinterApiClient(
    httpClient: httpClient,
  );

  final UserRepository userRepository = UserRepository(tinterApiClient: tinterApiClient);

  runApp(BlocProvider(
    create: (BuildContext context) => UserBloc(userRepository: userRepository),
    child: MaterialApp(
      home: SafeArea(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (BuildContext context, UserState state) {
            if (state is UserInitialState || state is UserInitializingState) {
              BlocProvider.of<UserBloc>(context).add(UserInitEvent());
              return CircularProgressIndicator();
            }
            return UserCreationTab();
          },
        ),
      ),
    ),
  ));
}

class UserCreationTab extends StatefulWidget {
  @override
  _UserCreationTabState createState() => _UserCreationTabState();
}

class _UserCreationTabState extends State<UserCreationTab> {
  Widget separator = SizedBox(
    height: 40,
  );

  ScrollController _controller = ScrollController();

  static final Map<String, double> fractions = {
    'invisibleRectangle1': 0.115,
    'invisibleRectangle2': 0.087,
    'userPicture': 0.135,
    'nextButton': 0.1,
  };

  /// This two double are in ~[0, 1]
  /// They describe how much of the invisible rectangle
  /// have been scrolled.
  double invisiblyScrollFraction1 = 0;
  double invisiblyScrollFraction2 = 0;

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
    return Scaffold(
      backgroundColor: TinterColors.background,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // ignore: invalid_use_of_protected_member
          if (!_controller.hasListeners) {
            _controller.addListener(() {
              setState(() {
                invisiblyScrollFraction1 = min(
                    1,
                    _controller.position.pixels /
                        (fractions['invisibleRectangle1'] * constraints.maxHeight));
                invisiblyScrollFraction2 = min(
                    1,
                    max(
                        0,
                        (_controller.position.pixels -
                                fractions['invisibleRectangle1'] * constraints.maxHeight) /
                            (fractions['invisibleRectangle2'] * constraints.maxHeight)));
              });
            });
          }
          return Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 30.0, bottom: fractions['nextButton'] * constraints.maxHeight),
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 28.0),
                  controller: _controller,
                  scrollDirection: Axis.vertical,
                  physics: SnapScrollPhysics(topChildrenHeight: [
                    fractions['invisibleRectangle1'] * constraints.maxHeight,
                    fractions['invisibleRectangle2'] * constraints.maxHeight
                  ]),
                  children: <Widget>[
                    Container(
                      height: 0.17 * constraints.maxHeight,
                      color: Colors.transparent,
                    ),
                    Container(
                      height: fractions['invisibleRectangle1'] * constraints.maxHeight,
                      color: Colors.transparent,
                    ),
                    Container(
                      height: fractions['invisibleRectangle2'] * constraints.maxHeight,
                      color: Colors.transparent,
                    ),
                    Column(
                      children: <Widget>[
                        informationRectangle(
                          context: context,
                          child: HidingRectangle(
                            child: AssociationsRectangle(),
                            text: 'Clique pour choisir tes associations.',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => AssociationsTab()),
                            ),
                          ),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          child: HidingRectangle(
                            child: AttiranceVieAssoRectangle(),
                            text: 'Clique pour dire à quel point te plait la vie associative.',
                          ),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          child: HidingRectangle(
                            child: FeteOuCoursRectangle(),
                            text: 'Clique pour dire si tu es plutôt fête ou cours.',
                          ),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          child: HidingRectangle(
                            child: AideOuSortirRectangle(),
                            text:
                                "Clique pour dire si tu préfére un parrain qui t'aide scolairement ou avec qui sortir.",
                          ),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          child: HidingRectangle(
                            child: OrganisationEvenementsRectangle(),
                            text: 'Clique pour dire si tu aimes organiser des événements.',
                          ),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          child: HidingRectangle(
                            child: GoutsMusicauxRectangle(),
                            text: 'Clique pour choisir tes goûts musicaux.',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GoutsMusicauxTab()),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
              Container(
                height: constraints.maxHeight *
                    (0.19 - 0.07 * invisiblyScrollFraction1 - 0.04 * invisiblyScrollFraction2),
                width: constraints.maxWidth,
                child: SvgPicture.asset(
                  'assets/profile/topProfile.svg',
                  color: TinterColors.primaryLight,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                top: constraints.maxHeight * (0.095 - 0.1 * invisiblyScrollFraction1) -
                    100 * invisiblyScrollFraction2,
                child: HoveringUserInformation(
                  width: 2 / 3 * constraints.maxWidth,
                  height: 0.24 * constraints.maxHeight,
                  invisiblyScrollFraction1: invisiblyScrollFraction1,
                  invisiblyScrollFraction2: invisiblyScrollFraction2,
                ),
              ),
              Positioned(
                top: constraints.maxHeight * (0.027 - 0.012 * invisiblyScrollFraction2),
                child: HoveringUserPicture(
                  size: fractions['userPicture'] * constraints.maxHeight,
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: NextButton(
                  height: constraints.maxHeight * fractions['nextButton'],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget informationRectangle(
      {@required BuildContext context,
      @required Widget child,
      double width,
      double height,
      EdgeInsets padding}) {
    return Align(
      alignment: AlignmentDirectional.center,
      child: Container(
        padding: padding ?? EdgeInsets.all(0.0),
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
}

class NextButton extends StatelessWidget {
  final double height;

  NextButton({@required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.maxFinite,
      color: TinterColors.secondaryAccent,
      child: Center(child: Text('Next')),
    );
  }

}

class HoveringUserInformation extends StatelessWidget {
  final double invisiblyScrollFraction1, invisiblyScrollFraction2;
  final double width, height;

  HoveringUserInformation({
    @required this.width,
    @required this.height,
    @required this.invisiblyScrollFraction1,
    @required this.invisiblyScrollFraction2,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1 - invisiblyScrollFraction2,
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: TinterColors.secondaryAccent.withAlpha(230),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0 * (1 - invisiblyScrollFraction1)),
            topRight: Radius.circular(20.0 * (1 - invisiblyScrollFraction1)),
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        width: width,
        height: height,
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(0, invisiblyScrollFraction1),
              child: Opacity(
                opacity: 1 - invisiblyScrollFraction2,
                child: Transform.translate(
                  offset: Offset(0, -20 * invisiblyScrollFraction2),
                  child: BlocBuilder<UserBloc, UserState>(
                      builder: (BuildContext context, UserState userState) {
                    return AutoSizeText(
                      ((userState is NewUserState))
                          ? userState.user.name + " " + userState.user.surname
                          : 'Loading...',
                      style: TinterTextStyle.headline1,
                    );
                  }),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Opacity(
                opacity: 1 - invisiblyScrollFraction1,
                child: Transform.translate(
                  offset: Offset(0, -20 * invisiblyScrollFraction1),
                  child: BlocBuilder<UserBloc, UserState>(
                      builder: (BuildContext context, UserState userState) {
                    return AutoSizeText(
                      ((userState is NewUserState)) ? userState.user.email : 'Loading...',
                      style: TinterTextStyle.headline2,
                      maxLines: 1,
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
}

class HoveringUserPicture extends StatelessWidget {
  final double size;

  HoveringUserPicture({@required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.cyan,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            spreadRadius: 0,
            blurRadius: 3,
            offset: Offset(0, 3),
          ),
        ],
      ),
      height: size,
      width: size,
    );
  }
}

class AssociationsRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                'Associations',
                style: TinterTextStyle.headline2,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0),
              width: double.infinity,
              child: Container(
                height: 60,
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (BuildContext context, UserState userState) {
                    if (!(userState is NewUserState)) {
                      return CircularProgressIndicator();
                    }
                    return (userState as NewUserState).user.associations.length == 0
                    ? Text('Aucune association sélectionnée.')
                    : ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: (userState as NewUserState).user.associations.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          width: 5,
                        );
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return associationBubble(
                            context, (userState as NewUserState).user.associations[index]);
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Positioned.fill(
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AssociationsTab()),
                );
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 30,
                color: TinterColors.primaryAccent,
              ),
            ),
          ),
        ),
      ],
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
      child: Text(association.name), //TODO: change to logo
    );
  }
}

class AttiranceVieAssoRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            'Attirance pour la vie associative',
            textAlign: TextAlign.center,
            style: TinterTextStyle.headline2,
          ),
        ),
        SliderTheme(
          data: TinterSliderTheme.enabled,
          child: BlocBuilder<UserBloc, UserState>(
            builder: (BuildContext context, UserState userState) {
              if (!(userState is NewUserState)) {
                return CircularProgressIndicator();
              }
              return Slider(
                  value: (userState as NewUserState).user.attiranceVieAsso,
                  onChanged: (value) => BlocProvider.of<UserBloc>(context)
                      .add(AttiranceVieAssoChanged(newValue: value)));
            },
          ),
        ),
      ],
    );
  }
}

class FeteOuCoursRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            'Cours ou soirée?',
            style: TinterTextStyle.headline2,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        SliderTheme(
          data: TinterSliderTheme.enabled,
          child: DiscoverSlider(
              slider: BlocBuilder<UserBloc, UserState>(
                builder: (BuildContext context, UserState userState) {
                  if (!(userState is NewUserState)) {
                    return CircularProgressIndicator();
                  }
                  return Slider(
                      value: (userState as NewUserState).user.feteOuCours,
                      onChanged: (value) => BlocProvider.of<UserBloc>(context)
                          .add(FeteOuCoursChanged(newValue: value)));
                },
              ),
              leftLabel: 'Cours',
              rightLabel: 'Soirée'),
        ),
      ],
    );
  }
}

class AideOuSortirRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            'Parrain qui aide ou avec qui sortir?',
            style: TinterTextStyle.headline2,
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        SliderTheme(
          data: TinterSliderTheme.enabled,
          child: DiscoverSlider(
              slider: BlocBuilder<UserBloc, UserState>(
                builder: (BuildContext context, UserState userState) {
                  if (!(userState is NewUserState)) {
                    return CircularProgressIndicator();
                  }
                  return Slider(
                      value: (userState as NewUserState).user.aideOuSortir,
                      onChanged: (value) => BlocProvider.of<UserBloc>(context)
                          .add(AideOuSortirChanged(newValue: value)));
                },
              ),
              leftLabel: 'Aide',
              rightLabel: 'Sortir'),
        ),
      ],
    );
  }
}

class OrganisationEvenementsRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            'Aime organiser les événements?',
            style: TinterTextStyle.headline2,
            textAlign: TextAlign.center,
          ),
        ),
        SliderTheme(
          data: TinterSliderTheme.enabled,
          child: BlocBuilder<UserBloc, UserState>(
            builder: (BuildContext context, UserState userState) {
              if (!(userState is NewUserState)) {
                return CircularProgressIndicator();
              }
              return Slider(
                  value: (userState as NewUserState).user.organisationEvenements,
                  onChanged: (value) => BlocProvider.of<UserBloc>(context)
                      .add(OrganisationEvenementsChanged(newValue: value)));
            },
          ),
        ),
      ],
    );
  }
}

class GoutsMusicauxRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                'Goûts musicaux',
                style: TinterTextStyle.headline2,
              ),
            ),
            BlocBuilder<UserBloc, UserState>(
              builder: (BuildContext context, UserState userState) {
                if (!(userState is NewUserState)) {
                  return CircularProgressIndicator();
                }
                return Wrap(
                  spacing: 15,
                  children: (userState as NewUserState).user.goutsMusicaux.length == 0
                      ? [
                          Chip(
                            label: Text('Aucun'),
                            labelStyle: TinterTextStyle.goutMusicaux,
                            backgroundColor: TinterColors.primaryAccent,
                          )
                        ]
                      : <Widget>[
                          for (String musicStyle
                              in (userState as NewUserState).user.goutsMusicaux)
                            Chip(
                              label: Text(musicStyle),
                              labelStyle: TinterTextStyle.goutMusicaux,
                              backgroundColor: TinterColors.primaryAccent,
                            )
                        ],
                );
              },
            )
          ],
        ),
        Positioned.fill(
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GoutsMusicauxTab()),
                );
              },
              icon: Icon(
                Icons.arrow_forward_ios,
                size: 30,
                color: TinterColors.primaryAccent,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class DiscoverSlider extends StatelessWidget {
  final String leftLabel, rightLabel;
  final Widget slider;

  DiscoverSlider({@required this.leftLabel, @required this.rightLabel, @required this.slider});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 23.0),
              child: SliderLabel(
                padding: EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
                child: Text(
                  leftLabel,
                  style: TinterTextStyle.bigLabel,
                ),
                side: Side.Left,
                triangleSize: 14,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SliderLabel(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
                  child: Text(
                    rightLabel,
                    style: TinterTextStyle.bigLabel,
                  ),
                ),
                side: Side.Right,
                triangleSize: 14,
              ),
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

class HidingRectangle extends StatefulWidget {
  final Widget child;
  final String text;
  final VoidCallback onTap;

  HidingRectangle({@required this.text, @required this.child, this.onTap});

  @override
  _HidingRectangleState createState() => _HidingRectangleState();
}

class _HidingRectangleState extends State<HidingRectangle> {
  bool isReviled;

  @override
  void initState() {
    isReviled = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 150),
            child: isReviled
                ? Container()
                : InkWell(
                    onTap: onTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: TinterColors.primary,
                      ),
                      child: Center(
                        child: Text(widget.text, textAlign: TextAlign.center,),
                      ),
                    ),
                  ),
          ),
        )
      ],
    );
  }

  onTap() {
    setState(() {
      isReviled = true;
    });
    if (widget.onTap != null) {
      widget.onTap();
    }
  }
}
