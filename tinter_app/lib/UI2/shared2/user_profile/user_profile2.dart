import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/associatif/association.dart';
import 'package:tinterapp/Logic/models/associatif/association_logo.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/user_profile/associations.dart';
import 'package:tinterapp/UI2/shared2/options_button/options2.dart';
import 'package:tinterapp/UI2/shared2/profile_creation/sub_profile_creation/associative_profile2.dart';
import 'package:tinterapp/UI2/shared2/user_profile/user_associatif_profile2.dart';
import 'package:tinterapp/UI2/shared2/user_profile/user_scolaire_profile2.dart';

import '../../../main.dart';
import '../associatif_to_scolaire_button2.dart';
import '../associations2.dart';

class UserTab3 extends StatefulWidget implements TinterTab {
  const UserTab3({Key key}) : super(key: key);

  @override
  _UserTab3State createState() => _UserTab3State();
}

class _UserTab3State extends State<UserTab3> with RouteAware {
  Widget separator = SizedBox(
    height: 20,
  );
  OverlayEntry _saveModificationsOverlayEntry;
  bool _showSaveModificationsOverlayEntry = true;

  ScrollController _controller = ScrollController();

  @override
  void initState() {
    BlocProvider.of<UserBloc>(context).add(UserRefreshEvent());
    super.initState();

    _saveModificationsOverlayEntry?.remove();

    _saveModificationsOverlayEntry =
        OverlayEntry(builder: (BuildContext context) {
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
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    ExistingProfileHeader(),
                    Align(
                      alignment: AlignmentDirectional.topEnd,
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => OptionsTab2()),
                          );
                        },
                        icon: Consumer<TinterTheme>(
                            builder: (context, tinterTheme, child) {
                          return Icon(
                            Icons.settings,
                            size: 24,
                            color: Theme.of(context).primaryColor,
                          );
                        }),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0, bottom: 80.0),
                  child: Consumer<TinterTheme>(
                      builder: (context, tinterTheme, child) {
                    return AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return SlideTransition(
                          child: child,
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(animation),
                        );
                      },
                      child: tinterTheme.theme == MyTheme.dark
                          ? UserAssociatifProfile2(
                              separator: separator,
                            )
                          : UserScolaireProfile2(
                              separator: separator,
                            ),
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExistingProfileHeader extends StatelessWidget {
  const ExistingProfileHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            width: 280,
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
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  HoveringUserPicture2(
                    size: 95.0,
                    showModifyOption: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                    child: BlocBuilder<UserBloc, UserState>(
                      builder: (BuildContext context, UserState userState) {
                        return Text(
                          ((userState is UserLoadSuccessState))
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
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40.0,
                      vertical: 5.0,
                    ),
                    child: AssociatifToScolaireButton2(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class SaveModificationsOverlay extends StatelessWidget {
  final bool showSaveModificationsOverlayEntry;

  const SaveModificationsOverlay(
      {Key key, @required this.showSaveModificationsOverlayEntry})
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
              begin: 0,
              end: (isSaving && showSaveModificationsOverlayEntry) ? 1 : 0),
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
                return Consumer<TinterTheme>(
                    builder: (context, tinterTheme, child) {
                  return AnimatedContainer(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15.0),
                        topRight: Radius.circular(15.0),
                      ),
                    ),
                    duration: Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Center(
                              child: AutoSizeText(
                                (userState is KnownUserSavingFailedState)
                                    ? 'Echec de la sauvegarde, réessayer ?'
                                    : 'Sauvegarder mes modifications',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline5
                                    .copyWith(
                                      color: Colors.white,
                                    ),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  BlocProvider.of<UserBloc>(context)
                                      .add(UserSaveEvent());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).primaryColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7.5),
                                    ),
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 2.0,
                                        style: BorderStyle.solid),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 3.0,
                                    ),
                                    child: Text(
                                      'OUI',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 25.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  BlocProvider.of<UserBloc>(context)
                                      .add(UserUndoUnsavedChangesEvent());
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).errorColor,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(7.5),
                                    ),
                                    border: Border.all(
                                        color: Colors.white,
                                        width: 2.0,
                                        style: BorderStyle.solid),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 3.0,
                                    ),
                                    child: Text(
                                      'NON',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline5
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
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

class AssociationsRectangle2 extends StatelessWidget {
  const AssociationsRectangle2({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AssociationsTab2()),
        );
      },
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 20.0, top: 15.0, bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Mes associations',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Expanded(
                        child: SizedBox(),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  BlocBuilder<UserBloc, UserState>(
                    builder: (BuildContext context, UserState userState) {
                      if (!(userState is UserLoadSuccessState)) {
                        return Center(
                          child: Container(
                            height: 60,
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return (userState as UserLoadSuccessState)
                                  .user
                                  .associations
                                  .length ==
                              0
                          ? Container(
                              height: 30.0,
                              child: Row(
                                children: [
                                  Text(
                                    'Aucune association sélectionée',
                                    style:
                                        Theme.of(context).textTheme.headline5,
                                  ),
                                  Expanded(
                                    child: SizedBox(),
                                  ),
                                ],
                              ),
                            )
                          : Container(
                              height: 60.0,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 65.0),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: (userState as UserLoadSuccessState)
                                      .user
                                      .associations
                                      .length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Padding(
                                      padding: EdgeInsets.only(
                                        right: (index ==
                                                (userState as UserLoadSuccessState)
                                                        .user
                                                        .associations
                                                        .length -
                                                    1)
                                            ? 48.0
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
                              ),
                            );
                    },
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: Theme.of(context).primaryColor,
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
          color: Colors.white,
          border: Border.all(
              color: Theme.of(context).primaryColor,
              width: 2.5,
              style: BorderStyle.solid),
        ),
        child: ClipOval(
          child: getLogoFromAssociation(associationName: association.name),
        ),
      ),
    );
  }
}
