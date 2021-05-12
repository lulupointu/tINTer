import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/UI/scolaire/user_profile/matieres.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/user_profile/user_profile.dart';

class UserScolaireProfile extends StatelessWidget {
  final Widget separator;

  const UserScolaireProfile({Key key, @required this.separator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InformationRectangle(
          child: Padding(
            padding: EdgeInsets.only(
                top: 15.0, bottom: 5.0, left: 20.0, right: 20.0),
            child: MaiselOuNonRectangle2(),
          ),
        ),
        separator,
        InformationRectangle(
          child: Padding(
            padding: EdgeInsets.only(
                top: 15.0, bottom: 5.0, left: 20.0, right: 20.0),
            child: HoraireDeTravailRectangle2(),
          ),
        ),
        separator,
        InformationRectangle(
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: AssociationsRectangle(),
          ),
        ),
        separator,
        InformationRectangle(
          child: GroupeOuSeulRectangle2(),
        ),
        separator,
        InformationRectangle(
          child: EnLigneOuPresentielRectangle2(),
        ),
        separator,
        InformationRectangle(
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 20.0, bottom: 5.0),
            child: MatieresRectangle2(),
          ),
        ),
      ],
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
                if (!(userState is NewUserState)) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Row(
                  children: [
                    GestureDetector(
                      onTap: () => BlocProvider.of<UserBloc>(context).add(
                          UserStateChangedEvent(
                              newState: (userState as NewUserState)
                                  .user
                                  .rebuild(
                                      (b) => b..lieuDeVie = LieuDeVie.maisel))),
                      child: Container(
                        width: 45,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Theme.of(context).primaryColor.withOpacity(
                              (userState as NewUserState).user.lieuDeVie ==
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
                                        (userState as NewUserState)
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
                              newState: (userState as NewUserState)
                                  .user
                                  .rebuild(
                                      (b) => b..lieuDeVie = LieuDeVie.other))),
                      child: Container(
                        width: 45,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Theme.of(context).primaryColor.withOpacity(
                              (userState as NewUserState).user.lieuDeVie ==
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
                                          (userState as NewUserState)
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
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Column(
          children: [
            Text(
              "Mes horaires de travail préférés",
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
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(
                                  color: Colors.black.withOpacity((userState
                                              as UserLoadSuccessState)
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
                        b
                          ..horairesDeTravail
                              .remove(HoraireDeTravail.afternoon);
                      } else {
                        b..horairesDeTravail.add(HoraireDeTravail.afternoon);
                      }
                    }))),
                    child: Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Theme.of(context).primaryColor.withOpacity(
                            (userState as NewUserState)
                                    .user
                                    .horairesDeTravail
                                    .contains(HoraireDeTravail.afternoon)
                                ? 1
                                : 0.4),
                      ),
                      child: Center(
                        child: Text('Après-midi',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    color: Colors.black.withOpacity((userState
                                                as UserLoadSuccessState)
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
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(
                                  color: Colors.black.withOpacity((userState
                                              as UserLoadSuccessState)
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
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(
                                  color: Colors.black.withOpacity((userState
                                              as NewUserState)
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
            child:
                Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
              return Text(
                'Préfères-tu travailler seul.e ou en groupe?',
                style: tinterTheme.textStyle.headline2,
                textAlign: TextAlign.start,
              );
            }),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Consumer<TinterTheme>(
          builder: (context, tinterTheme, child) {
            return SliderTheme(
              data: tinterTheme.slider.enabled,
              child: child,
            );
          },
          child: DiscoverSlider(
              slider: BlocBuilder<UserBloc, UserState>(
                builder: (BuildContext context, UserState userState) {
                  if (!(userState is UserLoadSuccessState)) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Slider(
                    value:
                        (userState as UserLoadSuccessState).user.groupeOuSeul,
                    onChanged: (value) =>
                        BlocProvider.of<UserBloc>(context).add(
                      UserStateChangedEvent(
                        newState: (userState as UserLoadSuccessState)
                            .user
                            .rebuild((u) => u..groupeOuSeul = value),
                      ),
                    ),
                  );
                },
              ),
              leftLabel: 'Seul',
              rightLabel: 'Groupe'),
        ),
      ],
    );
  }
}

class EnLigneOuPresentielRectangle2 extends StatelessWidget {
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
            child:
                Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
              return Text(
                'Préfères-tu travailler en ligne ou à l\'école?',
                style: tinterTheme.textStyle.headline2,
                textAlign: TextAlign.start,
              );
            }),
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Consumer<TinterTheme>(
          builder: (context, tinterTheme, child) {
            return SliderTheme(
              data: tinterTheme.slider.enabled,
              child: child,
            );
          },
          child: DiscoverSlider(
              slider: BlocBuilder<UserBloc, UserState>(
                builder: (BuildContext context, UserState userState) {
                  if (!(userState is UserLoadSuccessState)) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Slider(
                    value:
                        (userState as UserLoadSuccessState).user.enligneOuNon,
                    onChanged: (value) =>
                        BlocProvider.of<UserBloc>(context).add(
                      UserStateChangedEvent(
                        newState: (userState as UserLoadSuccessState)
                            .user
                            .rebuild((u) => u..enligneOuNon = value),
                      ),
                    ),
                  );
                },
              ),
              leftLabel: 'En ligne',
              rightLabel: 'A l\'école'),
        ),
      ],
    );
  }
}

class MatieresRectangle2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MatieresTab()),
        );
      },
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Consumer<TinterTheme>(
                    builder: (context, tinterTheme, child) {
                  return Text(
                    'Matières préférées',
                    style: tinterTheme.textStyle.headline2,
                  );
                }),
              ),
              SizedBox(
                height: 5,
              ),
              BlocBuilder<UserBloc, UserState>(
                builder: (BuildContext context, UserState userState) {
                  if (!(userState is UserLoadSuccessState)) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 15,
                    children: (userState as UserLoadSuccessState)
                                .user
                                .matieresPreferees
                                .length ==
                            0
                        ? [
                            Consumer<TinterTheme>(
                                builder: (context, tinterTheme, child) {
                              return Chip(
                                label: Text('Aucune'),
                                labelStyle: tinterTheme.textStyle.chipLiked,
                                backgroundColor:
                                    tinterTheme.colors.primaryAccent,
                              );
                            }),
                          ]
                        : <Widget>[
                            for (String musicStyle
                                in (userState as UserLoadSuccessState)
                                    .user
                                    .matieresPreferees)
                              Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                return Chip(
                                  label: Text(musicStyle),
                                  labelStyle: tinterTheme.textStyle.chipLiked,
                                  backgroundColor:
                                      tinterTheme.colors.primaryAccent,
                                );
                              })
                          ],
                  );
                },
              )
            ],
          ),
          Positioned.fill(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child:
                  Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
                return Icon(
                  Icons.arrow_forward_ios,
                  size: 30,
                  color: tinterTheme.colors.primaryAccent,
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
