import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:tinterapp/main.dart';

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
      home: SafeArea(child: UserTab()),
    ),
  ));
}

class UserTab extends StatefulWidget {
  @override
  _UserTabState createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> with RouteAware {
  Widget separator = SizedBox(
    height: 40,
  );
  OverlayEntry _saveModificationsOverlayEntry;
  bool _showSaveModificationsOverlayEntry = true;

  ScrollController _controller = ScrollController();

  static final Map<String, double> fractions = {
    'invisibleRectangle1': 0.115,
    'invisibleRectangle2': 0.087,
    'userPicture': 0.135,
  };

  /// This two double are in ~[0, 1]
  /// They describe how much of the invisible rectangle
  /// have been scrolled.
  double invisiblyScrollFraction1 = 0;
  double invisiblyScrollFraction2 = 0;

  @override
  void initState() {
    BlocProvider.of<UserBloc>(context).add(UserRefreshEvent());
    super.initState();

    _saveModificationsOverlayEntry?.remove();

    _saveModificationsOverlayEntry = OverlayEntry(builder: (BuildContext context) {
      return SaveModificationsOverlay(
        showSaveModificationsOverlayEntry: _showSaveModificationsOverlayEntry,
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(_saveModificationsOverlayEntry);
    });
  }

  @override
  void dispose() {
    _saveModificationsOverlayEntry?.remove();
    _controller.dispose();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void didPushNext() {
    setState(() {
      _showSaveModificationsOverlayEntry = false;
    });
    super.didPushNext();
  }

  @override
  void didPopNext() {
    setState(() {
      _showSaveModificationsOverlayEntry = true;
    });
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
                padding: const EdgeInsets.only(top: 30.0),
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
                          padding: EdgeInsets.only(top: 15.0, left: 20.0, bottom: 15.0),
                          child: AssociationsRectangle(),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          child: AttiranceVieAssoRectangle(),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          child: FeteOuCoursRectangle(),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          child: AideOuSortirRectangle(),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          child: OrganisationEvenementsRectangle(),
                        ),
                        separator,
                        informationRectangle(
                          context: context,
                          padding: EdgeInsets.only(top: 15.0, left: 20.0, bottom: 5.0, right: 20),
                          child: GoutsMusicauxRectangle(),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    )
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
                alignment: AlignmentDirectional.topEnd,
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OptionsTab()),
                    );
                  },
                  icon: Icon(
                    Icons.settings,
                    size: 24,
                    color: TinterColors.hint,
                  ),
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
                      ((userState is KnownUserState))
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
                      ((userState is KnownUserState)) ? userState.user.email : 'Loading...',
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
            if (!(userState is KnownUserState)) {
              return CircularProgressIndicator();
            }
            return Stack(
              children: [
                (userState as KnownUserState).user.getProfilePicture(height: 200, width: 200),
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
        BlocProvider.of<UserBloc>(context)
            .add(ProfilePicturePathChangedEvent(newPath: croppedFile.path));
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
          height: value*double.maxFinite,
          width: value*double.maxFinite,
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
          ..arcToPoint(Offset(0, 1 / 3 * size.height), radius: Radius.circular(1))
//      ..lineTo(size.width, size.height)
//      ..lineTo(0, size.height)
//      ..lineTo(0, size.height/2)
        ;
//    arcToPoint(Offset(0, 0), radius: Radius.circular(size.height))
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
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
            Container(
              width: double.infinity,
              child: Container(
                height: 60,
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (BuildContext context, UserState userState) {
                    if (!(userState is KnownUserState)) {
                      return CircularProgressIndicator();
                    }
                    return (userState as KnownUserState).user.associations.length == 0
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Aucune association séléctionnée.'),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: ListView.separated(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount:
                                  (userState as KnownUserState).user.associations.length,
                              separatorBuilder: (BuildContext context, int index) {
                                return SizedBox(
                                  width: 5,
                                );
                              },
                              itemBuilder: (BuildContext context, int index) {
                                return associationBubble(context,
                                    (userState as KnownUserState).user.associations[index]);
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
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: TinterTextStyle.headline1.color, width: 3),
      ),
      height: 60,
      width: 60,
      child: ClipOval(
        child: Container(
          alignment: AlignmentDirectional.centerStart,
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: association.getLogo(),
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
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20,),
            child: Text(
              'Attirance pour la vie associative',
              textAlign: TextAlign.start,
              style: TinterTextStyle.headline2,
            ),
          ),
        ),
        SliderTheme(
          data: TinterSliderTheme.enabled,
          child: BlocBuilder<UserBloc, UserState>(
            builder: (BuildContext context, UserState userState) {
              if (!(userState is KnownUserState)) {
                return CircularProgressIndicator();
              }
              return Slider(
                  value: (userState as KnownUserState).user.attiranceVieAsso,
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
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20,),
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
                  if (!(userState is KnownUserState)) {
                    return CircularProgressIndicator();
                  }
                  return Slider(
                      value: (userState as KnownUserState).user.feteOuCours,
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
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20,),
            child: Text(
              'Parrain qui aide ou avec qui sortir?',
              style: TinterTextStyle.headline2,
              textAlign: TextAlign.start,
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
                  if (!(userState is KnownUserState)) {
                    return CircularProgressIndicator();
                  }
                  return Slider(
                      value: (userState as KnownUserState).user.aideOuSortir,
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
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 20, right: 20,),
            child: Text(
              'Aime organiser les événements?',
              style: TinterTextStyle.headline2,
              textAlign: TextAlign.start,
            ),
          ),
        ),
        SliderTheme(
          data: TinterSliderTheme.enabled,
          child: BlocBuilder<UserBloc, UserState>(
            builder: (BuildContext context, UserState userState) {
              if (!(userState is KnownUserState)) {
                return CircularProgressIndicator();
              }
              return Slider(
                  value: (userState as KnownUserState).user.organisationEvenements,
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
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GoutsMusicauxTab()),
        );
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  if (!(userState is KnownUserState)) {
                    return CircularProgressIndicator();
                  }
                  return Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 15,
                    children: (userState as KnownUserState).user.goutsMusicaux.length == 0
                        ? [
                            Chip(
                              label: Text('Aucun'),
                              labelStyle: TinterTextStyle.goutMusicauxLiked,
                              backgroundColor: TinterColors.primaryAccent,
                            ),
                          ]
                        : <Widget>[
                            for (String musicStyle
                                in (userState as KnownUserState).user.goutsMusicaux)
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
              child: Icon(
                Icons.arrow_forward_ios,
                size: 30,
                color: TinterColors.primaryAccent,
              ),
            ),
          ),
        ],
      ),
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

class SaveModificationsOverlay extends StatelessWidget {
  final bool showSaveModificationsOverlayEntry;

  const SaveModificationsOverlay({Key key, @required this.showSaveModificationsOverlayEntry})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (BuildContext context, UserState userState) {
        bool isSaving = true;
        if (!(userState is KnownUserUnsavedState)) {
          isSaving = false;
        }
        return TweenAnimationBuilder<double>(
          tween: Tween<double>(
              begin: 0, end: (isSaving && showSaveModificationsOverlayEntry) ? 1 : 0),
          duration: Duration(milliseconds: 300),
          builder: (BuildContext context, double value, Widget child) {
            return Positioned(
              bottom: -80 * (1 - value),
              right: 0,
              left: 0,
              height: 80,
              child: child,
            );
          },
          child: Material(
            color: Colors.transparent,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return Container(
                  color: TinterColors.background,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                        child: Center(
                          child: Text(
                            (userState is KnownUserSavingFailedState)
                                ? 'Echec de la sauvegarde, réessayer?'
                                : 'Des modifications ont été effectuées',
                            style: TinterTextStyle.headline2,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () => BlocProvider.of<UserBloc>(context)
                                      .add(UserUndoUnsavedChangesEvent()),
                                  child: Center(
                                    child: Container(
                                      width: constraints.maxWidth / 3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.0),
                                        color: TinterColors.secondaryAccent,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey[850],
                                            spreadRadius: 3,
                                            blurRadius: 5,
                                            offset: Offset(0, 2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: AutoSizeText(
                                          'Annuler',
                                          style: TinterTextStyle.headline2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  onTap: () =>
                                      BlocProvider.of<UserBloc>(context).add(UserSaveEvent()),
                                  child: Center(
                                    child: Container(
                                      width: constraints.maxWidth / 3,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4.0),
                                        color: TinterColors.secondaryAccent,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey[850],
                                            spreadRadius: 3,
                                            blurRadius: 5,
                                            offset: Offset(0, 2), // changes position of shadow
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: AutoSizeText(
                                          'Valider',
                                          style: TinterTextStyle.headline2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
