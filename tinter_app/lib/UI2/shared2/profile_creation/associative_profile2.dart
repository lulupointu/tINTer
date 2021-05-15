import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/Logic/models/shared/user_profile_picture.dart';
import 'package:tinterapp/UI2/shared2/profile_creation/associative_criteria_list2.dart';
import 'package:tinterapp/UI2/shared2/profile_creation/profile_creation2.dart';

class AssociativeProfile2 extends StatefulWidget {
  final void Function({@required AccountCreationMode accountCreationMode})
      onAccountCreationModeChanged;

  const AssociativeProfile2(
      {Key key, @required this.onAccountCreationModeChanged})
      : super(key: key);

  @override
  _AssociativeProfile2State createState() => _AssociativeProfile2State();
}

class _AssociativeProfile2State extends State<AssociativeProfile2> {
  Widget separator = SizedBox(
    height: 25,
  );

  bool isAssociationPressed = false;

  void onAssociationPressed() {
    setState(() {
      isAssociationPressed = true;
    });
  }

  bool isMusicTastePressed = false;

  void onMusicTastePressed() {
    setState(() {
      isMusicTastePressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(),
            Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: AssociativeCriteriaList2(
                isAssociationPressed: isAssociationPressed,
                isMusicTastePressed: isMusicTastePressed,
                onAssociationPressed: onAssociationPressed,
                onMusicTastePressed: onMusicTastePressed,
                separator: SizedBox(
                  height: 20.0,
                ),
              ),
            ),
            separator,
            AssociativeNextButton(
                isAssociationPressed: isAssociationPressed,
                isMusicTastePressed: isMusicTastePressed,
                onAccountCreationModeChanged:
                    widget.onAccountCreationModeChanged),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60.0),
            child: Container(
              width: 275,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Column(
                  children: [
                    HoveringUserPicture2(size: 95.0),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (BuildContext context, UserState userState) {
                          return Text(
                            ((userState is NewUserState))
                                ? userState.user.name +
                                    " " +
                                    userState.user.surname
                                : 'En chargement...',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(color: Colors.white),
                          );
                        },
                      ),
                    ),
                    Text(
                      'Nouvel utilisateur',
                      style: Theme.of(context)
                          .textTheme
                          .headline5
                          .copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HoveringUserPicture2 extends StatefulWidget {
  final double size;

  HoveringUserPicture2({@required this.size});

  @override
  _HoveringUserPicture2State createState() => _HoveringUserPicture2State();
}

class _HoveringUserPicture2State extends State<HoveringUserPicture2> {
  final GlobalKey hoveringUserPictureKey = GlobalKey();
  final Duration _folderOrCameraOverlayAnimationDuration =
      Duration(milliseconds: 200);
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
          border: Border.all(
              color: Colors.white, width: 3.5, style: BorderStyle.solid),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              spreadRadius: 0,
              blurRadius: 5,
              offset: Offset(0.5, 0.5),
            ),
          ],
        ),
        height: widget.size,
        width: widget.size,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (BuildContext context, UserState userState) {
            if (!(userState is NewUserState)) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Stack(
              children: [
                getProfilePictureFromLocalPathOrLogin(
                    login: (userState as NewUserState).user.login,
                    localPath: (userState as NewUserState)
                        .user
                        .profilePictureLocalPath,
                    height: widget.size,
                    width: widget.size),
                ClipPath(
                  clipper: ModifyProfilePictureClipper(),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                    child: Container(
                      color: Colors.white.withOpacity(0.3),
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: Icon(
                      Icons.camera_enhance_rounded,
                      color: Colors.black.withOpacity(0.55),
                      size: 23.0,
                    ),
                  ),
                ),
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
            newState: (BlocProvider.of<UserBloc>(context).state
                    as UserLoadSuccessState)
                .user
                .rebuild(
                    (u) => u..profilePictureLocalPath = croppedFile.path)));
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
    final box =
        hoveringUserPictureKey.currentContext.findRenderObject() as RenderBox;
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
              double profilePictureWidthFraction =
                  size.width / constraints.maxWidth;
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
                                      (littleWidgetSize + 40) /
                                          constraints.maxWidth),
                              (1 - value) * (1 - value) * (1 - value),
                            ),
                            child: GestureDetector(
                              onTap: () => changeProfilePicture(
                                  context, ImageSource.camera, Colors.black),
                              child: Container(
                                height: littleWidgetSize,
                                width: littleWidgetSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      offset: Offset(1, 1),
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
                                      (littleWidgetSize + 40) /
                                          constraints.maxWidth),
                              (1 - value) * (1 - value) * (1 - value),
                            ),
                            child: GestureDetector(
                              onTap: () => changeProfilePicture(
                                  context, ImageSource.gallery, Colors.black),
                              child: Container(
                                height: littleWidgetSize,
                                width: littleWidgetSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.folder_open_outlined,
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

class AssociativeNextButton extends StatelessWidget {
  const AssociativeNextButton({
    Key key,
    @required this.isAssociationPressed,
    @required this.onAccountCreationModeChanged,
    @required this.isMusicTastePressed,
  }) : super(key: key);

  final bool isAssociationPressed;

  final bool isMusicTastePressed;

  final void Function({@required AccountCreationMode accountCreationMode})
      onAccountCreationModeChanged;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, UserState userState) {
      if (!(userState is UserLoadSuccessState)) {
        return Center(
          child: CircularProgressIndicator(),
        );
      }
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        ),
        height: 65,
        child: ElevatedButton(
          onPressed: !isAssociationPressed || !isMusicTastePressed
              ? null
              : () {
                  UserState userState =
                      BlocProvider.of<UserBloc>(context).state;
                  if (userState is NewUserState) {
                    if (userState.user.school == School.TSP &&
                        userState.user.year == TSPYear.TSP1A) {
                      onAccountCreationModeChanged(
                          accountCreationMode:
                              AccountCreationMode.associatifToScolaire);
                    } else {
                      BlocProvider.of<UserBloc>(context).add(UserSaveEvent());
                    }
                  }
                },
          style: ElevatedButton.styleFrom(
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              ),
            ),
          ),
          child: Center(
            child: Text(
              "Créer mon profil",
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    });
  }
}
