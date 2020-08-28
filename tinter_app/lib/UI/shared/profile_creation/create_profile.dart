import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/association_logo.dart';
import 'package:tinterapp/Logic/models/shared/user_profile_picture.dart';
import 'package:tinterapp/Logic/repository/shared/user_repository.dart';
import 'package:tinterapp/Network/tinter_api_client.dart';
import 'package:tinterapp/UI/user_profile/associations.dart';
import 'package:tinterapp/UI/user_profile/gout_musicaux.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:tinterapp/UI/user_profile/snap_scroll_physics.dart';

import '../shared_element/slider_label.dart';
import '../shared_element/const.dart';

main() {
  final http.Client httpClient = http.Client();
  TinterAPIClient tinterAPIClient = TinterAPIClient(
    httpClient: httpClient,
  );

  final UserRepository userRepository = UserRepository(tinterAPIClient: tinterAPIClient);

  runApp(BlocProvider(
    create: (BuildContext context) => UserBloc(userRepository: userRepository),
    child: MaterialApp(
      home: SafeArea(
        child: BlocBuilder<UserBloc, UserState>(
          builder: (BuildContext context, UserState state) {
            if (state is UserInitialState || state is UserInitializingState) {
              BlocProvider.of<UserBloc>(context).add(UserInitEvent());
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

  // This describes which hiding rectangle have been clicked
  List<bool> hidingRectangleHasBeenClicked = [false, false, false, false, false, false];

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
                padding: EdgeInsets.only(
                    top: 30.0, bottom: fractions['nextButton'] * constraints.maxHeight),
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
                          padding: EdgeInsets.only(top: 15.0, left: 20.0),
                          child: PrimoEntrantRectangle(),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                          child: HidingRectangle(
                            child: AssociationsRectangle(),
                            text: 'Clique pour choisir tes associations.',
                            onTap: () {
                              setState(() => hidingRectangleHasBeenClicked[0] = true);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AssociationsTab()),
                              );
                            },
                          ),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          child: HidingRectangle(
                            onTap: () => setState(() => hidingRectangleHasBeenClicked[1] = true),
                            child: AttiranceVieAssoRectangle(),
                            text: 'Clique pour dire à quel point te plait la vie associative.',
                          ),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          child: HidingRectangle(
                            onTap: () => setState(() => hidingRectangleHasBeenClicked[2] = true),
                            child: FeteOuCoursRectangle(),
                            text: 'Clique pour dire si tu es plutôt fête ou cours.',
                          ),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          child: HidingRectangle(
                            onTap: () => setState(() => hidingRectangleHasBeenClicked[3] = true),
                            child: AideOuSortirRectangle(),
                            text:
                                "Clique pour dire si tu préfére un parrain qui t'aide scolairement ou avec qui sortir.",
                          ),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          child: HidingRectangle(
                            onTap: () => setState(() => hidingRectangleHasBeenClicked[4] = true),
                            child: OrganisationEvenementsRectangle(),
                            text: 'Clique pour dire si tu aimes organiser des événements.',
                          ),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          padding: EdgeInsets.only(top: 15.0, left: 20.0, bottom: 5.0),
                          child: HidingRectangle(
                            child: GoutsMusicauxRectangle(),
                            text: 'Clique pour choisir tes goûts musicaux.',
                            onTap: () {
                              setState(() {
                                hidingRectangleHasBeenClicked[5] = true;
                              });
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => GoutsMusicauxTab()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
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
                  enabled: !hidingRectangleHasBeenClicked.contains(false),
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
  final bool enabled;

  NextButton({@required this.height, @required this.enabled});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        UserState userState = BlocProvider.of<UserBloc>(context).state;
        if (userState is NewUserState) {
          if (enabled) {
            BlocProvider.of<UserBloc>(context).add(UserSaveEvent());
          }
        }
      },
      child: Container(
        height: height,
        width: double.maxFinite,
        color: TinterColors.secondaryAccent,
        child: Center(child: Text('Next')),
      ),
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
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HoveringUserPicture extends StatefulWidget {
  final double size;

  HoveringUserPicture({@required this.size});

  @override
  _HoveringUserPictureState createState() => _HoveringUserPictureState();
}

class _HoveringUserPictureState extends State<HoveringUserPicture> {
  final GlobalKey hoveringUserPictureKey = GlobalKey();
  final Duration _folderOrCameraOverlayAnimationDuration = Duration(milliseconds: 200);
  OverlayEntry _folderOrCameraOverlay;

  void showFolderOrCameraOverlay() {
    _folderOrCameraOverlay?.remove();

    _folderOrCameraOverlay = OverlayEntry(builder: (BuildContext context) {
      return GestureDetector(
        onTap: hideFolderOrCameraOverlay,
        child: FolderOrCameraOverlay(
          shouldHide: false,
          hoveringUserPictureKey: hoveringUserPictureKey,
          changeProfilePicture: changeProfilePicture,
          animationDuration: _folderOrCameraOverlayAnimationDuration,
        ),
      );
    });
    Overlay.of(context).insert(_folderOrCameraOverlay);
  }

  void hideFolderOrCameraOverlay() {
    _folderOrCameraOverlay?.remove();

    _folderOrCameraOverlay = OverlayEntry(builder: (BuildContext context) {
      return GestureDetector(
        onTap: hideFolderOrCameraOverlay,
        child: FolderOrCameraOverlay(
          shouldHide: true,
          hoveringUserPictureKey: hoveringUserPictureKey,
          changeProfilePicture: changeProfilePicture,
          animationDuration: _folderOrCameraOverlayAnimationDuration,
        ),
      );
    });
    Overlay.of(context).insert(_folderOrCameraOverlay);

    Future.delayed(_folderOrCameraOverlayAnimationDuration, () {
      _folderOrCameraOverlay.remove();
      _folderOrCameraOverlay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: hoveringUserPictureKey,
      splashColor: Colors.transparent,
      onTap: showFolderOrCameraOverlay,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              spreadRadius: 0,
              blurRadius: 3,
              offset: Offset(0, 3),
            ),
          ],
        ),
        height: widget.size,
        width: widget.size,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (BuildContext context, UserState userState) {
            if (!(userState is NewUserState)) {
              return CircularProgressIndicator();
            }
            return Stack(
              children: [
                getProfilePictureFromLocalPathOrLogin(
                    login: (userState as NewUserState).user.login,
                    localPath: (userState as NewUserState).user.profilePictureLocalPath,
                    height: widget.size,
                    width: widget.size),
                ClipPath(
                  clipper: ModifyProfilePictureClipper(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                    child: Container(
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Icon(
                    Icons.add,
                    color: TinterColors.hint,
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future changeProfilePicture(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: source,
    );

    if (pickedFile != null) {
      File croppedFile = await ImageCropper.cropImage(
        sourcePath: pickedFile.path,
        cropStyle: CropStyle.circle,
        maxWidth: 200,
        maxHeight: 200,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: '',
          toolbarColor: TinterColors.background,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true,
          showCropGrid: false,
        ),
        iosUiSettings: IOSUiSettings(
          aspectRatioLockEnabled: true,
          minimumAspectRatio: 1.0,
        ),
      );

      if (croppedFile != null) {
        BlocProvider.of<UserBloc>(context).add(UserStateChangedEvent(
            newState: (BlocProvider.of<UserBloc>(context).state as UserLoadSuccessState)
                .user
                .rebuild((u) => u..profilePictureLocalPath = croppedFile.path)));
      }
    }
    _folderOrCameraOverlay?.remove();
    _folderOrCameraOverlay = null;
  }
}

class FolderOrCameraOverlay extends StatelessWidget {
  final bool shouldHide;
  final GlobalKey hoveringUserPictureKey;
  final void Function(BuildContext, ImageSource) changeProfilePicture;
  final Duration animationDuration;

  const FolderOrCameraOverlay({
    Key key,
    @required this.shouldHide,
    @required this.hoveringUserPictureKey,
    @required this.changeProfilePicture,
    @required this.animationDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (hoveringUserPictureKey.currentContext == null) {
      return Container();
    }
    final box = hoveringUserPictureKey.currentContext.findRenderObject() as RenderBox;
    final pos = box.localToGlobal(Offset.zero);
    final size = box.size;
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: shouldHide ? 1 : 0, end: shouldHide ? 0 : 1),
      duration: animationDuration,
      builder: (BuildContext context, double value, Widget child) {
        return Container(
          height: value * double.maxFinite,
          width: value * double.maxFinite,
          color: Colors.transparent,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double profilePictureWidthFraction = size.width / constraints.maxWidth;
              double littleWidgetSize = 30;
              return Stack(
                children: [
                  Positioned(
                    top: pos.dy,
                    height: size.height,
                    left: 0,
                    right: 0,
                    child: Container(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment(
                              -value *
                                  (profilePictureWidthFraction +
                                      (littleWidgetSize + 40) / constraints.maxWidth),
                              (1 - value) * (1 - value) * (1 - value),
                            ),
                            child: GestureDetector(
                              onTap: () => changeProfilePicture(context, ImageSource.camera),
                              child: Container(
                                height: littleWidgetSize,
                                width: littleWidgetSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      spreadRadius: 0,
                                      blurRadius: 3,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.camera_alt,
                                  size: littleWidgetSize - 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: pos.dy,
                    height: size.height,
                    left: 0,
                    right: 0,
                    child: Container(
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment(
                              value *
                                  (profilePictureWidthFraction +
                                      (littleWidgetSize + 40) / constraints.maxWidth),
                              (1 - value) * (1 - value) * (1 - value),
                            ),
                            child: GestureDetector(
                              onTap: () => changeProfilePicture(context, ImageSource.gallery),
                              child: Container(
                                height: littleWidgetSize,
                                width: littleWidgetSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      spreadRadius: 0,
                                      blurRadius: 3,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.folder_open,
                                  size: littleWidgetSize - 10,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class ModifyProfilePictureClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 2 / 3 * size.height)
      ..lineTo(size.width, 2 / 3 * size.height)
      ..arcToPoint(Offset(0, 1 / 3 * size.height), radius: Radius.circular(1));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class PrimoEntrantRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Text(
                'Est-tu primo-entrant?',
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
                    if (((userState as NewUserState).user.primoEntrant) == null) {
                      BlocProvider.of<UserBloc>(context)
                          .add(                                UserStateChangedEvent(
                          newState: (userState as NewUserState)
                              .user
                              .rebuild((b) => b..primoEntrant = true)));
                      return CircularProgressIndicator();
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () => BlocProvider.of<UserBloc>(context)
                                .add(                                UserStateChangedEvent(
                                newState: (userState as NewUserState)
                                    .user
                                    .rebuild((b) => b..primoEntrant = true))),
                            child: AnimatedOpacity(
                              opacity: (userState as NewUserState).user.primoEntrant ? 1 : 0.5,
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5.0),
                                    bottomLeft: Radius.circular(5.0),
                                  ),
                                  color: TinterColors.primaryAccent,
                                ),
                                width: 50,
                                child: Center(
                                  child: AutoSizeText('Oui'),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () => BlocProvider.of<UserBloc>(context).add(
                                UserStateChangedEvent(
                                    newState: (userState as NewUserState)
                                        .user
                                        .rebuild((b) => b..primoEntrant = false))),
                            child: AnimatedOpacity(
                              opacity: (userState as NewUserState).user.primoEntrant ? 0.5 : 1,
                              duration: Duration(milliseconds: 300),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5.0),
                                    bottomRight: Radius.circular(5.0),
                                  ),
                                  color: TinterColors.primaryAccent,
                                ),
                                width: 50,
                                child: Center(
                                  child: AutoSizeText('Non'),
                                ),
                              ),
                            ),
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
      ],
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
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text(
                  'Associations',
                  style: TinterTextStyle.headline2,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: Container(
                height: 60,
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (BuildContext context, UserState userState) {
                    if (!(userState is NewUserState) ||
                        (userState as NewUserState).user.associations == null) {
                      return Text('Loading');
                    }
                    return (userState as NewUserState).user.associations.length == 0
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                'Aucune association séléctionnée.',
                                style: TinterTextStyle.headline2.copyWith(fontSize: 16),
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: (userState as NewUserState).user.associations.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      right: (index ==
                                              (userState as NewUserState)
                                                      .user
                                                      .associations
                                                      .length -
                                                  1)
                                          ? 48
                                          : 8.0,
                                      left: (index == 0) ? 20.0 : 0),
                                  child: associationBubble(context,
                                      (userState as NewUserState).user.associations[index]),
                                );
                              },
                            ),
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
}

class AttiranceVieAssoRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              left: 20,
              right: 20,
            ),
            child: AutoSizeText(
              'Attirance pour la vie associative',
              style: TinterTextStyle.headline2,
            ),
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
                value: (userState as NewUserState).user.attiranceVieAsso ?? 0.5,
                onChanged: (value) => BlocProvider.of<UserBloc>(context).add(
                    UserStateChangedEvent(
                        newState: (userState as NewUserState)
                            .user
                            .rebuild((u) => u..attiranceVieAsso = value))),
              );
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
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              left: 20,
              right: 20,
            ),
            child: Text(
              'Cours ou soirée?',
              style: TinterTextStyle.headline2,
            ),
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
                      value: (userState as NewUserState).user.feteOuCours ?? 0.5,
                      onChanged: (value) => BlocProvider.of<UserBloc>(context).add(
                          UserStateChangedEvent(
                              newState: (userState as NewUserState)
                                  .user
                                  .rebuild((u) => u..feteOuCours = value))));
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
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              left: 20,
              right: 20,
            ),
            child: AutoSizeText(
              'Parrain qui aide ou avec qui sortir?',
              style: TinterTextStyle.headline2,
            ),
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
                      value: (userState as NewUserState).user.aideOuSortir ?? 0.5,
                      onChanged: (value) => BlocProvider.of<UserBloc>(context).add(
                          UserStateChangedEvent(
                              newState: (userState as NewUserState)
                                  .user
                                  .rebuild((u) => u..aideOuSortir = value))));
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
          child: Padding(
            padding: const EdgeInsets.only(
              top: 15,
              left: 20,
              right: 20,
            ),
            child: AutoSizeText(
              'Aime organiser les événements?',
              style: TinterTextStyle.headline2,
            ),
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
                  value: (userState as NewUserState).user.organisationEvenements ?? 0.5,
                  onChanged: (value) => BlocProvider.of<UserBloc>(context).add(
                      UserStateChangedEvent(
                          newState: (userState as NewUserState)
                              .user
                              .rebuild((u) => u..organisationEvenements = value))));
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
                if (!(userState is NewUserState) ||
                    (userState as NewUserState).user.goutsMusicaux == null) {
                  return Text('Loading');
                }
                return Wrap(
                  spacing: 15,
                  children: (userState as NewUserState).user.goutsMusicaux.length == 0
                      ? [
                          Chip(
                            label: Text('Aucun'),
                            labelStyle: TinterTextStyle.goutMusicauxLiked,
                            backgroundColor: TinterColors.primaryAccent,
                          )
                        ]
                      : <Widget>[
                          for (String musicStyle
                              in (userState as NewUserState).user.goutsMusicaux)
                            Chip(
                              label: Text(musicStyle),
                              labelStyle: TinterTextStyle.goutMusicauxLiked,
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
                        child: AutoSizeText(
                          widget.text,
                          textAlign: TextAlign.center,
                          style: TinterTextStyle.hidingText,
                        ),
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
