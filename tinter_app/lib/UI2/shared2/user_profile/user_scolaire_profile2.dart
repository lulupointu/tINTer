import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/UI/scolaire/user_profile/matieres.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/user_profile/user_profile.dart';
import 'package:tinterapp/UI2/shared2/user_profile/user_profile2.dart';

import '../user_criteria_panel2/matieres2.dart';

class UserScolaireProfile2 extends StatelessWidget {
  final Widget separator;

  const UserScolaireProfile2({Key key, @required this.separator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Column(
        children: <Widget>[
          MaiselOuNonRectangle2(),
          separator,
          HoraireDeTravailRectangle2(),
          separator,
          AssociationsRectangle2(),
          separator,
          GroupeOuSeulRectangle2(),
          separator,
          EnLigneOuPresentielRectangle2(),
          separator,
          MatieresRectangle2WithoutListener(),
        ],
      ),
    );
  }
}

class MaiselOuNonRectangle2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "J'habite à la MAISEL",
              style: Theme.of(context).textTheme.headline5,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(1, 1),
                  ),
                ],
              ),
              child: BlocBuilder<UserBloc, UserState>(
                  builder: (BuildContext context, UserState userState) {
                if (!(userState is UserLoadSuccessState)) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => BlocProvider.of<UserBloc>(context).add(
                          UserStateChangedEvent(
                              newState: (userState as UserLoadSuccessState)
                                  .user
                                  .rebuild(
                                      (b) => b..lieuDeVie = LieuDeVie.maisel))),
                      child: Container(
                        width: 45,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Theme.of(context).primaryColor.withOpacity(
                              (userState as UserLoadSuccessState).user.lieuDeVie ==
                                      LieuDeVie.maisel
                                  ? 1
                                  : 0.4),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5.0),
                              bottomLeft: Radius.circular(5.0)),
                        ),
                        child: Center(
                          child: Text(
                            'Oui',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    color: Colors.black.withOpacity(
                                        (userState as UserLoadSuccessState)
                                                    .user
                                                    .lieuDeVie ==
                                                LieuDeVie.maisel
                                            ? 0.87
                                            : 0.38)),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => BlocProvider.of<UserBloc>(context).add(
                          UserStateChangedEvent(
                              newState: (userState as UserLoadSuccessState)
                                  .user
                                  .rebuild(
                                      (b) => b..lieuDeVie = LieuDeVie.other))),
                      child: Container(
                        width: 45,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Theme.of(context).primaryColor.withOpacity(
                              (userState as UserLoadSuccessState).user.lieuDeVie ==
                                      LieuDeVie.maisel
                                  ? 0.4
                                  : 1),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5.0),
                              bottomRight: Radius.circular(5.0)),
                        ),
                        child: Center(
                          child: Text('Non',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline5
                                  .copyWith(
                                      color: Colors.black.withOpacity(
                                          (userState as UserLoadSuccessState)
                                                      .user
                                                      .lieuDeVie ==
                                                  LieuDeVie.maisel
                                              ? 0.38
                                              : 0.87))),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}

class HoraireDeTravailRectangle2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            Text(
              "Mes horaires préférés pour travailler",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 15.0,
            ),
            BlocBuilder<UserBloc, UserState>(
                builder: (BuildContext context, UserState userState) {
              if (!(userState is UserLoadSuccessState)) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => BlocProvider.of<UserBloc>(context).add(
                        UserStateChangedEvent(
                            newState: (userState as UserLoadSuccessState)
                                .user
                                .rebuild((b) {
                      if ((userState as UserLoadSuccessState)
                          .user
                          .horairesDeTravail
                          .contains(HoraireDeTravail.morning)) {
                        b..horairesDeTravail.remove(HoraireDeTravail.morning);
                      } else {
                        b..horairesDeTravail.add(HoraireDeTravail.morning);
                      }
                    }))),
                    child: Container(
                      width: 60,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Theme.of(context).primaryColor.withOpacity(
                            (userState as UserLoadSuccessState)
                                    .user
                                    .horairesDeTravail
                                    .contains(HoraireDeTravail.morning)
                                ? 1
                                : 0.4),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0)),
                      ),
                      child: Center(
                        child: Text(
                          'Matin',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.black.withOpacity(
                                  (userState as UserLoadSuccessState)
                                          .user
                                          .horairesDeTravail
                                          .contains(HoraireDeTravail.morning)
                                      ? 0.87
                                      : 0.38)),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => BlocProvider.of<UserBloc>(context).add(
                        UserStateChangedEvent(
                            newState: (userState as UserLoadSuccessState)
                                .user
                                .rebuild((b) {
                      if ((userState as UserLoadSuccessState)
                          .user
                          .horairesDeTravail
                          .contains(HoraireDeTravail.afternoon)) {
                        b..horairesDeTravail.remove(HoraireDeTravail.afternoon);
                      } else {
                        b..horairesDeTravail.add(HoraireDeTravail.afternoon);
                      }
                    }))),
                    child: Container(
                      width: 65,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Theme.of(context).primaryColor.withOpacity(
                            (userState as UserLoadSuccessState)
                                    .user
                                    .horairesDeTravail
                                    .contains(HoraireDeTravail.afternoon)
                                ? 1
                                : 0.4),
                      ),
                      child: Center(
                        child: Text('Aprem',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    color: Colors.black.withOpacity(
                                        (userState as UserLoadSuccessState)
                                                .user
                                                .horairesDeTravail
                                                .contains(
                                                    HoraireDeTravail.afternoon)
                                            ? 0.87
                                            : 0.38))),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => BlocProvider.of<UserBloc>(context).add(
                        UserStateChangedEvent(
                            newState: (userState as UserLoadSuccessState)
                                .user
                                .rebuild((b) {
                      if ((userState as UserLoadSuccessState)
                          .user
                          .horairesDeTravail
                          .contains(HoraireDeTravail.evening)) {
                        b..horairesDeTravail.remove(HoraireDeTravail.evening);
                      } else {
                        b..horairesDeTravail.add(HoraireDeTravail.evening);
                      }
                    }))),
                    child: Container(
                      width: 60,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Theme.of(context).primaryColor.withOpacity(
                            (userState as UserLoadSuccessState)
                                    .user
                                    .horairesDeTravail
                                    .contains(HoraireDeTravail.evening)
                                ? 1
                                : 0.4),
                      ),
                      child: Center(
                        child: Text(
                          'Soir',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.black.withOpacity(
                                  (userState as UserLoadSuccessState)
                                          .user
                                          .horairesDeTravail
                                          .contains(HoraireDeTravail.evening)
                                      ? 0.87
                                      : 0.38)),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => BlocProvider.of<UserBloc>(context).add(
                        UserStateChangedEvent(
                            newState: (userState as UserLoadSuccessState)
                                .user
                                .rebuild((b) {
                      if ((userState as UserLoadSuccessState)
                          .user
                          .horairesDeTravail
                          .contains(HoraireDeTravail.night)) {
                        b..horairesDeTravail.remove(HoraireDeTravail.night);
                      } else {
                        b..horairesDeTravail.add(HoraireDeTravail.night);
                      }
                    }))),
                    child: Container(
                      width: 60,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Theme.of(context).primaryColor.withOpacity(
                            (userState as UserLoadSuccessState)
                                    .user
                                    .horairesDeTravail
                                    .contains(HoraireDeTravail.night)
                                ? 1
                                : 0.4),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0)),
                      ),
                      child: Center(
                        child: Text(
                          'Nuit',
                          style: Theme.of(context).textTheme.headline5.copyWith(
                              color: Colors.black.withOpacity(
                                  (userState as UserLoadSuccessState)
                                          .user
                                          .horairesDeTravail
                                          .contains(HoraireDeTravail.night)
                                      ? 0.87
                                      : 0.38)),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class GroupeOuSeulRectangle2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Travailler à plusieurs ou seul.e ?',
              style: Theme.of(context).textTheme.headline5,
            ),
            Row(
              children: [
                Icon(
                  Icons.group_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                SliderTheme(
                  data: Theme.of(context).sliderTheme.copyWith(
                      inactiveTrackColor: Theme.of(context).indicatorColor),
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (BuildContext context, UserState userState) {
                      if (!(userState is UserLoadSuccessState)) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Slider(
                            value: (userState as UserLoadSuccessState)
                                .user
                                .groupeOuSeul,
                            onChanged: (value) {
                              BlocProvider.of<UserBloc>(context).add(
                                UserStateChangedEvent(
                                  newState: (userState as UserLoadSuccessState)
                                      .user
                                      .rebuild((u) => u..groupeOuSeul = value),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Icon(
                  Icons.person_rounded,
                  color: Theme.of(context).indicatorColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class EnLigneOuPresentielRectangle2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Travailler à l'école ou en ligne ?",
              style: Theme.of(context).textTheme.headline5,
            ),
            Row(
              children: [
                Icon(
                  Icons.school_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                SliderTheme(
                  data: Theme.of(context).sliderTheme.copyWith(
                      inactiveTrackColor: Theme.of(context).indicatorColor),
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (BuildContext context, UserState userState) {
                      if (!(userState is UserLoadSuccessState)) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: Slider(
                            value: (userState as UserLoadSuccessState)
                                .user
                                .enligneOuNon,
                            onChanged: (value) {
                              BlocProvider.of<UserBloc>(context).add(
                                UserStateChangedEvent(
                                  newState: (userState as UserLoadSuccessState)
                                      .user
                                      .rebuild((u) => u..enligneOuNon = value),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Icon(
                  Icons.wifi,
                  color: Theme.of(context).indicatorColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MatieresRectangle2WithListener extends StatelessWidget {
  final bool isMatieresPressed;
  final void Function() onMatieresPressed;

  const MatieresRectangle2WithListener(
      {Key key,
      @required this.isMatieresPressed,
      @required this.onMatieresPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onMatieresPressed();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MatieresTab2()),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Choisir mes matières préférées',
                style: Theme.of(context).textTheme.headline5,
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MatieresRectangle2WithoutListener extends StatelessWidget {

  const MatieresRectangle2WithoutListener(
      {Key key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MatieresTab2()),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Choisir mes matières préférées',
                style: Theme.of(context).textTheme.headline5,
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

