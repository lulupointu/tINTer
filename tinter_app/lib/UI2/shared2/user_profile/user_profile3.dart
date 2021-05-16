import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI2/shared2/options_button/options2.dart';
import 'package:tinterapp/UI2/shared2/profile_creation/sub_profile_creation/associative_profile2.dart';
import 'package:tinterapp/UI2/shared2/user_profile/user_associatif_profile2.dart';
import 'package:tinterapp/UI2/shared2/user_profile/user_scolaire_profile2.dart';

import '../associatif_to_scolaire_button2.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
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
                        MaterialPageRoute(builder: (context) => OptionsTab2()),
                      );
                    },
                    icon: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
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
              padding: const EdgeInsets.only(top: 40.0, bottom: 20.0),
              child:
                  Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
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
                      padding: const EdgeInsets.only(
                          top: 5.0, bottom: 3.0, left: 30.0, right: 30.0),
                      child: AssociatifToScolaireButton2(),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                                builder: (BuildContext context, double value,
                                    Widget child) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical:
                                            (1 - value) * 10.0 + value * 2.0),
                                    child: (userState is KnownUserSavingState ||
                                            userState is KnownUserSavedState)
                                        ? LayoutBuilder(
                                            builder: (BuildContext context,
                                                BoxConstraints
                                                    smallConstraints) {
                                              return AnimatedContainer(
                                                duration:
                                                    Duration(milliseconds: 300),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
                                                  color: tinterTheme
                                                      .colors.secondary,
                                                ),
                                                width: value *
                                                        smallConstraints
                                                            .maxHeight +
                                                    4 +
                                                    (1 - value) *
                                                        (constraints.maxWidth *
                                                                2 /
                                                                3 +
                                                            constraints
                                                                    .maxWidth *
                                                                1 /
                                                                9),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Center(
                                                    child: AnimatedSwitcher(
                                                      duration: Duration(
                                                          milliseconds: 100),
                                                      child: value == 1
                                                          ? Center(
                                                              child:
                                                                  CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(
                                                                  tinterTheme
                                                                      .colors
                                                                      .defaultTextColor,
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
                                        onTap: () => BlocProvider.of<UserBloc>(
                                                context)
                                            .add(UserUndoUnsavedChangesEvent()),
                                        child: Center(
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 300),
                                            width: constraints.maxWidth / 3,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              color:
                                                  tinterTheme.colors.secondary,
                                            ),
                                            child: Center(
                                              child: AutoSizeText(
                                                'Annuler',
                                                style: tinterTheme
                                                    .textStyle.headline2,
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
                                            BlocProvider.of<UserBloc>(context)
                                                .add(UserSaveEvent()),
                                        child: Center(
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 300),
                                            width: constraints.maxWidth / 3,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              color:
                                                  tinterTheme.colors.secondary,
                                            ),
                                            child: Center(
                                              child: AutoSizeText(
                                                'Valider',
                                                style: tinterTheme
                                                    .textStyle.headline2,
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
