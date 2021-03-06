import 'dart:io';
import 'dart:ui';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/association_logo.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/Logic/models/shared/user_profile_picture.dart';
import 'dart:math';
import 'package:tinterapp/UI/associatif/user_profile/user_associatif_profile.dart';
import 'package:tinterapp/UI/scolaire/user_profile/user_scolaire_profile.dart';
import 'package:tinterapp/UI/shared/user_profile/associatif_to_scolaire_button.dart';
import 'package:tinterapp/UI/shared/user_profile/associations.dart';
import 'package:tinterapp/UI/shared/user_profile/options.dart';
import 'package:tinterapp/UI/shared/user_profile/snap_scroll_physics.dart';
import 'package:tinterapp/main.dart';

import '../shared_element/slider_label.dart';
import '../shared_element/const.dart';

//main() {
//  final http.Client httpClient = http.Client();
//  TinterAPIClient tinterAPIClient = TinterAPIClient(
//    httpClient: httpClient,
//  );
//
//  final UserRepository userRepository = UserRepository(tinterAPIClient: tinterAPIClient);
//
//  runApp(BlocProvider(
//    create: (BuildContext context) => UserBloc(userRepository: userRepository),
//    child: MaterialApp(
//      home: SafeArea(child: UserTab()),
//    ),
//  ));
//}

class UserTab extends StatefulWidget implements TinterTab {
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
    return Consumer<TinterTheme>(
      builder: (context, tinterTheme, child) {
        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 500),
          tween: ColorTween(
              begin: tinterTheme.colors.background, end: tinterTheme.colors.background),
          builder: (context, animatedColor, child) {
            return Scaffold(
              backgroundColor: animatedColor,
              body: child,
//              floatingActionButton: FloatingActionButton(
//                onPressed: () {
//                  insertAssociatifToScolaireButtonOverlay();
//                },
//              ),
            );
          },
          child: child,
        );
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          // ignore: invalid_use_of_protected_member
          if (!_controller.hasListeners) {
            _controller.addListener(() {
              setState(() {
                invisiblyScrollFraction1 = max(0, min(
                    1,
                    _controller.position.pixels /
                        (fractions['invisibleRectangle1'] * constraints.maxHeight)));
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
                    Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                      return AnimatedSwitcher(
                        duration: Duration(milliseconds: 300),
                        transitionBuilder: (Widget child, Animation<double> animation) {
                          return SlideTransition(
                            child: child,
                            position: Tween<Offset>(
                              begin: const Offset(0, 1),
                              end: Offset.zero,
                            ).animate(animation),
                          );
                        },
                        child: tinterTheme.theme == MyTheme.dark
                            ? UserAssociatifProfile(
                                separator: separator,
                              )
                            : UserScolaireProfile(
                                separator: separator,
                              ),
                      );
                    }),
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
                child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                  return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 500),
                      tween: ColorTween(
                          begin: tinterTheme.colors.primary, end: tinterTheme.colors.primary),
                      builder: (context, animatedColor, child) {
                        return SvgPicture.asset(
                          'assets/profile/topProfile.svg',
                          color: animatedColor,
                          fit: BoxFit.fill,
                        );
                      });
                }),
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
                  icon: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return Icon(
                      Icons.settings,
                      size: 24,
                      color: tinterTheme.colors.primaryAccent,
                    );
                  }),
                ),
              )
            ],
          );
        },
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
      child: Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: tinterTheme.colors.secondary.withAlpha(230),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0 * (1 - invisiblyScrollFraction1)),
                topRight: Radius.circular(20.0 * (1 - invisiblyScrollFraction1)),
                bottomLeft: Radius.circular(20.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            width: width,
            height: height,
            child: child,
          );
        },
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
                    return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                      return TweenAnimationBuilder(
                          duration: Duration(milliseconds: 500),
                          tween: ColorTween(
                              begin: tinterTheme.colors.defaultTextColor,
                              end: tinterTheme.colors.defaultTextColor),
                          builder: (context, animatedColor, child) {
                            return AutoSizeText(
                              ((userState is UserLoadSuccessState))
                                  ? userState.user.name + " " + userState.user.surname
                                  : 'Loading...',
                              style: tinterTheme.textStyle.headline1
                                  .copyWith(color: animatedColor),
                            );
                          });
                    });
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
                    return Consumer<TinterTheme>(
                      builder: (context, tinterTheme, child) => (!(userState
                              is UserLoadSuccessState))
                          ? AutoSizeText(
                              'Loading...',
                              style: tinterTheme.textStyle.headline2,
                              maxLines: 1,
                            )
                          : ((userState as UserLoadSuccessState).user.school == School.TSP &&
                                  (userState as UserLoadSuccessState).user.year ==
                                      TSPYear.TSP1A)
                              ? AssociatifToScolaireButton()
                              : AutoSizeText(
                                  (userState as UserLoadSuccessState).user.email,
                                  style: tinterTheme.textStyle.headline2,
                                  maxLines: 1,
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
            if (!(userState is UserLoadSuccessState)) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Stack(
              children: [
                getProfilePictureFromLocalPathOrLogin(
                    login: (userState as UserLoadSuccessState).user.login,
                    localPath:
                        (userState as UserLoadSuccessState).user.profilePictureLocalPath,
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
                  child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return Icon(
                      Icons.add,
                      color: tinterTheme.colors.primaryAccent,
                    );
                  }),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Future changeProfilePicture(BuildContext context, ImageSource source, Color backgroundColor,
      Color defaultTextColor) async {
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
          toolbarColor: backgroundColor,
          toolbarWidgetColor: defaultTextColor,
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
        BlocProvider.of<UserBloc>(context).add(
          UserStateChangedEvent(
            newState: (BlocProvider.of<UserBloc>(context).state as UserLoadSuccessState)
                .user
                .rebuild((u) => u..profilePictureLocalPath = croppedFile.path),
          ),
        );
      }
    }
    _folderOrCameraOverlay?.remove();
    _folderOrCameraOverlay = null;
  }
}

class FolderOrCameraOverlay extends StatelessWidget {
  final bool shouldHide;
  final GlobalKey hoveringUserPictureKey;
  final void Function(BuildContext, ImageSource, Color, Color) changeProfilePicture;
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
                            child: Consumer<TinterTheme>(
                              builder: (context, tinterTheme, child) {
                                return GestureDetector(
                                  onTap: () => changeProfilePicture(
                                    context,
                                    ImageSource.camera,
                                    tinterTheme.colors.background,
                                    tinterTheme.colors.defaultTextColor,
                                  ),
                                  child: child,
                                );
                              },
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
                            child: Consumer<TinterTheme>(
                              builder: (context, tinterTheme, child) {
                                return GestureDetector(
                                  onTap: () => changeProfilePicture(
                                    context,
                                    ImageSource.gallery,
                                    tinterTheme.colors.background,
                                    tinterTheme.colors.defaultTextColor,
                                  ),
                                  child: child,
                                );
                              },
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

class InformationRectangle extends StatelessWidget {
  final Widget child;
  final double width, height;
  final EdgeInsets padding;

  const InformationRectangle({
    Key key,
    this.width,
    this.height,
    this.padding,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.center,
      child: Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return TweenAnimationBuilder(
            duration: Duration(milliseconds: 500),
            tween:
                ColorTween(begin: tinterTheme.colors.primary, end: tinterTheme.colors.primary),
            builder: (context, animatedColor, child) {
              return Container(
                padding: padding ?? EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: animatedColor,
                ),
                width: width != null ? width : Size.infinite.width,
                height: height,
                child: child,
              );
            },
            child: child,
          );
        },
        child: child,
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
                child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                  return Text(
                    leftLabel,
                    style: tinterTheme.textStyle.bigLabel,
                  );
                }),
                side: Side.Left,
                triangleSize: 14,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: SliderLabel(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 2.0),
                  child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                    return Text(
                      rightLabel,
                      style: tinterTheme.textStyle.bigLabel,
                    );
                  }),
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
                return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    color: tinterTheme.colors.background,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                          child: Center(
                            child: AutoSizeText(
                              (userState is KnownUserSavingFailedState)
                                  ? 'Echec de la sauvegarde, réessayer?'
                                  : 'Des modifications ont été effectuées',
                              style: tinterTheme.textStyle.headline2,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 200),
                              child: TweenAnimationBuilder(
                                duration: Duration(milliseconds: 200),
                                tween: Tween<double>(
                                    begin: 0,
                                    end: (userState is KnownUserSavingState ||
                                            userState is KnownUserSavedState)
                                        ? 1
                                        : 0),
                                builder: (BuildContext context, double value, Widget child) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: (1 - value) * 10.0 + value * 2.0),
                                    child: (userState is KnownUserSavingState ||
                                            userState is KnownUserSavedState)
                                        ? LayoutBuilder(
                                            builder: (BuildContext context,
                                                BoxConstraints smallConstraints) {
                                              return AnimatedContainer(
                                                duration: Duration(milliseconds: 300),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(4.0),
                                                  color: tinterTheme.colors.secondary,
                                                ),
                                                width: value * smallConstraints.maxHeight +
                                                    4 +
                                                    (1 - value) *
                                                        (constraints.maxWidth * 2 / 3 +
                                                            constraints.maxWidth * 1 / 9),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: AnimatedSwitcher(
                                                      duration: Duration(milliseconds: 100),
                                                      child: value == 1
                                                          ? Center(
                                                              child: CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  tinterTheme
                                                                      .colors.defaultTextColor,
                                                                ),
                                                                strokeWidth: 3,
                                                              ),
                                                            )
                                                          : Container(),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          )
                                        : child,
                                  );
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () => BlocProvider.of<UserBloc>(context)
                                            .add(UserUndoUnsavedChangesEvent()),
                                        child: Center(
                                          child: AnimatedContainer(
                                            duration: Duration(milliseconds: 300),
                                            width: constraints.maxWidth / 3,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4.0),
                                              color: tinterTheme.colors.secondary,
                                            ),
                                            child: Center(
                                              child: AutoSizeText(
                                                'Annuler',
                                                style: tinterTheme.textStyle.headline2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        splashColor: Colors.transparent,
                                        onTap: () => BlocProvider.of<UserBloc>(context)
                                            .add(UserSaveEvent()),
                                        child: Center(
                                          child: AnimatedContainer(
                                            duration: Duration(milliseconds: 300),
                                            width: constraints.maxWidth / 3,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(4.0),
                                              color: tinterTheme.colors.secondary,
                                            ),
                                            child: Center(
                                              child: AutoSizeText(
                                                'Valider',
                                                style: tinterTheme.textStyle.headline2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                });
              },
            ),
          ),
        );
      },
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
                child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                  return Text(
                    'Associations',
                    style: tinterTheme.textStyle.headline2,
                  );
                }),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              child: BlocBuilder<UserBloc, UserState>(
                builder: (BuildContext context, UserState userState) {
                  if (!(userState is UserLoadSuccessState)) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return (userState as UserLoadSuccessState).user.associations.length == 0
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child:
                                Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                              return Text(
                                'Aucune association sélectionnée.',
                                style: tinterTheme.textStyle.headline2.copyWith(fontSize: 16),
                              );
                            }),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                (userState as UserLoadSuccessState).user.associations.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: (index == 0) ? 20.0 : 0,
                                  right: (index ==
                                          (userState as UserLoadSuccessState)
                                                  .user
                                                  .associations
                                                  .length -
                                              1)
                                      ? 48
                                      : 8.0,
                                ),
                                child: associationBubble(
                                    context,
                                    (userState as UserLoadSuccessState)
                                        .user
                                        .associations[index]),
                              );
                            },
                          ),
                        );
                },
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
              icon: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                return Icon(
                  Icons.arrow_forward_ios,
                  size: 30,
                  color: tinterTheme.colors.primaryAccent,
                );
              }),
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
