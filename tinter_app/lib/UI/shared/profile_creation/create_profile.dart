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
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/Logic/models/shared/user_profile_picture.dart';
import 'dart:math';
import 'package:tinterapp/UI/associatif/profile_creation/create_profile_associatif.dart';
import 'package:tinterapp/UI/scolaire/profile_creation/create_profile_scolaire.dart';
import 'package:tinterapp/UI/shared/user_profile/associatif_to_scolaire_button.dart';
import 'package:tinterapp/UI/shared/user_profile/snap_scroll_physics.dart';

import '../shared_element/const.dart';

class UserCreationTab extends StatefulWidget {
  @override
  _UserCreationTabState createState() => _UserCreationTabState();
}

class _UserCreationTabState extends State<UserCreationTab> {
  final _associatifFormKey = GlobalKey<FormState>();
  final _scolaireFormKey = GlobalKey<FormState>();

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

  OverlayEntry associatifToScolaireButtonOverlay;
  final GlobalKey associatifToScolaireButtonKey = GlobalKey();

  bool nextPressed = false;

  @override
  void initState() {
    super.initState();

    associatifToScolaireButtonOverlay = OverlayEntry(
      builder: (context) {
        return AssociatifToScolaireButtonOverlay(
          associatifToScolaireButtonKey: associatifToScolaireButtonKey,
          removeSelf: removeAssociatifToScolaireButtonOverlay,
        );
      },
    );
  }

  void insertAssociatifToScolaireButtonOverlay() {
    Overlay.of(context).insert(this.associatifToScolaireButtonOverlay);
  }

  void removeAssociatifToScolaireButtonOverlay() {
    associatifToScolaireButtonOverlay.remove();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TinterTheme>(
      builder: (context, tinterTheme, child) {
        return Scaffold(
          backgroundColor: tinterTheme.colors.background,
          body: child,
        );
      },
      child: LayoutBuilder(
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
                    Consumer<TinterTheme>(
                      builder: (context, tinterTheme, child) {
                        return Stack(
                          children: [
                            Form(
                              key: _associatifFormKey,
                              child: Offstage(
                                offstage: tinterTheme.theme != MyTheme.dark,
                                child: CreateProfileAssociatif(
                                  separator: separator,
                                ),
                              ),
                            ),
                            Form(
                              key: _scolaireFormKey,
                              child: Offstage(
                                offstage: tinterTheme.theme != MyTheme.light,
                                child: CreateProfileScolaire(
                                  separator: separator,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
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
                child: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                  return SvgPicture.asset(
                    'assets/profile/topProfile.svg',
                    color: tinterTheme.colors.primary,
                    fit: BoxFit.fill,
                  );
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
                  associatifToScolaireButtonKey: associatifToScolaireButtonKey,
                  nextPressed: nextPressed,
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
                  onNextPressed: onNextPressed,
                  height: constraints.maxHeight * fractions['nextButton'],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void onNextPressed(MyTheme currentTheme) {
    UserState userState = BlocProvider.of<UserBloc>(context).state;
    if (userState is NewUserState) {
      if (!nextPressed) {
        if (_associatifFormKey.currentState.validate()) {
          if (userState.user.school == School.TSP &&
              userState.user.year == TSPYear.TSP1A &&
              !nextPressed) {
            _controller.animateTo(0,
                duration: Duration(milliseconds: 200), curve: Curves.easeIn);
            Future.delayed(Duration(milliseconds: 200), () {
              setState(() {
                nextPressed = true;
              });
              WidgetsBinding.instance.addPostFrameCallback((_) {
                insertAssociatifToScolaireButtonOverlay();
              });
            });
          } else {
            BlocProvider.of<UserBloc>(context).add(UserSaveEvent());
          }
        } else {
          _controller.animateTo(0,
              duration: Duration(milliseconds: 400), curve: Curves.easeIn);
        }
      } else {
        if (currentTheme == MyTheme.light) {
          if (_scolaireFormKey.currentState.validate()) {
            if (_associatifFormKey.currentState.validate()) {
              BlocProvider.of<UserBloc>(context).add(UserSaveEvent());
            } else {
              Provider.of<TinterTheme>(context, listen: false).changeTheme();
              _controller.animateTo(0,
                  duration: Duration(milliseconds: 400), curve: Curves.easeIn);
            }
          } else {
            _controller.animateTo(0,
                duration: Duration(milliseconds: 400), curve: Curves.easeIn);
          }
        } else {
          if (_associatifFormKey.currentState.validate()) {
            if (_scolaireFormKey.currentState.validate()) {
              BlocProvider.of<UserBloc>(context).add(UserSaveEvent());
            } else {
              Provider.of<TinterTheme>(context, listen: false).changeTheme();
              _controller.animateTo(0,
                  duration: Duration(milliseconds: 400), curve: Curves.easeIn);
            }
          } else {
            _controller.animateTo(0,
                duration: Duration(milliseconds: 400), curve: Curves.easeIn);
          }
        }
      }
    }
  }
}

class NextButton extends StatelessWidget {
  final double height;
  final Function(MyTheme) onNextPressed;

  NextButton({@required this.height, @required this.onNextPressed});

  @override
  Widget build(BuildContext context) {
    return Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
      return InkWell(
        splashColor: Colors.transparent,
        onTap: () => onNextPressed(tinterTheme.theme),
        child: Container(
          height: height,
          width: double.maxFinite,
          color: tinterTheme.colors.secondary,
          child: Center(child: Text('Next')),
        ),
      );
    });
  }
}

class HoveringUserInformation extends StatelessWidget {
  final double invisiblyScrollFraction1, invisiblyScrollFraction2;
  final double width, height;
  final GlobalKey associatifToScolaireButtonKey;
  final bool nextPressed;

  HoveringUserInformation({
    @required this.width,
    @required this.height,
    @required this.invisiblyScrollFraction1,
    @required this.invisiblyScrollFraction2,
    @required this.associatifToScolaireButtonKey,
    @required this.nextPressed,
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
                      return AutoSizeText(
                        ((userState is NewUserState))
                            ? userState.user.name + " " + userState.user.surname
                            : 'Loading...',
                        style: tinterTheme.textStyle.headline1,
                      );
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
                                        TSPYear.TSP1A &&
                                    nextPressed)
                                ? AssociatifToScolaireButton(
                                    key: associatifToScolaireButtonKey,
                                  )
                                : AutoSizeText(
                                    (userState as UserLoadSuccessState).user.email,
                                    style: tinterTheme.textStyle.headline2,
                                    maxLines: 1,
                                  ),
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
              return Center(child: CircularProgressIndicator(),);
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

  Future changeProfilePicture(
      BuildContext context, ImageSource source, Color backgroundColor) async {
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
  final void Function(BuildContext, ImageSource, Color) changeProfilePicture;
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
                                  onTap: () => changeProfilePicture(context,
                                      ImageSource.camera, tinterTheme.colors.background),
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
                                  onTap: () => changeProfilePicture(context,
                                      ImageSource.gallery, tinterTheme.colors.background),
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
      ..arcToPoint(Offset(0, 1 / 3 * size.height), radius: Radius.circular(1));
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class HidingRectangle extends StatefulWidget {
  final Widget child;
  final String text;
  final VoidCallback onTap;
  final EdgeInsets padding;

  HidingRectangle({@required this.text, @required this.child, this.onTap, this.padding});

  @override
  _HidingRectangleState createState() => _HidingRectangleState();
}

class _HidingRectangleState extends State<HidingRectangle> {
  bool isReviled = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FormField(
      autovalidate: false,
      validator: (_) {
        if (isReviled) {
          return null;
        }
        return 'This rectangle should not be hided in order to validate';
      },
      builder: (FormFieldState<dynamic> field) {
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 800),
          tween: Tween<double>(begin: 0, end: field.errorText == null ? 0 : 1),
          builder: (BuildContext context, double value, Widget child) {
            double x = value * 5 * 2 * pi - pi;
            return Transform.translate(
              offset: Offset(value == 0 ? 0 : 10 * sin(x) / x, 0),
              child: child,
            );
          },
          child: Stack(
            children: [
              widget.child,
              Positioned.fill(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 150),
                  child: isReviled
                      ? Container()
                      : InkWell(
                          onTap: onTap,
                          child: Consumer<TinterTheme>(
                            builder: (context, tinterTheme, child) {
                              return Container(
                                padding: EdgeInsets.symmetric(horizontal: 50),
                                decoration: BoxDecoration(
                                  border: field.errorText == null
                                      ? null
                                      : Border.all(
                                          color: tinterTheme.colors.secondary,
                                          width: 2,
                                        ),
                                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  color: tinterTheme.colors.primary,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: widget.padding ?? EdgeInsets.all(0.0),
                                    child: AutoSizeText(
                                      widget.text,
                                      textAlign: TextAlign.center,
                                      style: tinterTheme.textStyle.hidingText,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
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
