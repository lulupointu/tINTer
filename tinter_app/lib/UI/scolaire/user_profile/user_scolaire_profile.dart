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

  const UserScolaireProfile({Key key, @required this.separator}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InformationRectangle(
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 5.0, left: 20.0, right: 20.0),
            child: MaiselOuNonRectangle(),
          ),
        ),
        separator,
        InformationRectangle(
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 5.0, left: 20.0, right: 20.0),
            child: HoraireDeTravailRectangle(),
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
          child: GroupeOuSeulRectangle(),
        ),
        separator,
        InformationRectangle(
          child: EnLigneOuPresentielRectangle(),
        ),
        separator,
        InformationRectangle(
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 20.0, bottom: 5.0),
            child: MatieresRectangle(),
          ),
        ),
      ],
    );
  }
}

class MaiselOuNonRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Consumer<TinterTheme>(
                  builder: (context, tinterTheme, child) {
                    return Text(
                    'Ou habites-tu?',
                    style: tinterTheme.textStyle.headline2,
                  );
                }
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
                    if (!(userState is UserLoadSuccessState)) {
                      return Center(child: CircularProgressIndicator(),);
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () => BlocProvider.of<UserBloc>(context).add(
                                UserStateChangedEvent(
                                    newState: (userState as UserLoadSuccessState)
                                        .user
                                        .rebuild((b) => b..lieuDeVie = LieuDeVie.maisel))),
                            child: AnimatedOpacity(
                              opacity: (userState as UserLoadSuccessState).user.lieuDeVie !=
                                      LieuDeVie.maisel
                                  ? 0.5
                                  : 1,
                              duration: Duration(milliseconds: 300),
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                    return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5.0),
                                        topLeft: Radius.circular(5.0),
                                      ),
                                      color: tinterTheme.colors.primaryAccent,
                                    ),
                                    width: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Center(
                                        child: AutoSizeText(
                                          'MAISEL',
                                          maxLines: 1,
                                          minFontSize: 10,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () => BlocProvider.of<UserBloc>(context).add(
                                UserStateChangedEvent(
                                    newState: (userState as UserLoadSuccessState)
                                        .user
                                        .rebuild((b) => b..lieuDeVie = LieuDeVie.other))),
                            child: AnimatedOpacity(
                              opacity:
                                  (userState as UserLoadSuccessState).user.lieuDeVie != LieuDeVie.other
                                      ? 0.5
                                      : 1,
                              duration: Duration(milliseconds: 300),
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                    return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5.0),
                                        bottomRight: Radius.circular(5.0),
                                      ),
                                      color: tinterTheme.colors.primaryAccent,
                                    ),
                                    width: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Center(
                                        child: AutoSizeText(
                                          'Autre',
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  );
                                }
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

class HoraireDeTravailRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: <Widget>[
            Align(
              alignment: AlignmentDirectional.topStart,
              child: Consumer<TinterTheme>(
                  builder: (context, tinterTheme, child) {
                    return Text(
                    'Quand préfére-tu travailler?',
                    style: tinterTheme.textStyle.headline2,
                  );
                }
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
                    if (!(userState is UserLoadSuccessState)) {
                      return Center(child: CircularProgressIndicator(),);
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            onTap: () =>
                                BlocProvider.of<UserBloc>(context).add(UserStateChangedEvent(
                                    newState: (userState as UserLoadSuccessState).user.rebuild((b) {
                              if ((userState as UserLoadSuccessState)
                                  .user
                                  .horairesDeTravail
                                  .contains(HoraireDeTravail.morning)) {
                                b..horairesDeTravail.remove(HoraireDeTravail.morning);
                              } else {
                                b..horairesDeTravail.add(HoraireDeTravail.morning);
                              }
                            }))),
                            child: AnimatedOpacity(
                              opacity: (userState as UserLoadSuccessState)
                                      .user
                                      .horairesDeTravail
                                      .contains(HoraireDeTravail.morning)
                                  ? 1
                                  : 0.5,
                              duration: Duration(milliseconds: 300),
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                    return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5.0),
                                        topLeft: Radius.circular(5.0),
                                      ),
                                      color: tinterTheme.colors.primaryAccent,
                                    ),
                                    width: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Center(
                                        child: AutoSizeText(
                                          'Matin',
                                          maxLines: 1,
                                          minFontSize: 10,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
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
                            child: AnimatedOpacity(
                              opacity: (userState as UserLoadSuccessState)
                                      .user
                                      .horairesDeTravail
                                      .contains(HoraireDeTravail.afternoon)
                                  ? 1
                                  : 0.5,
                              duration: Duration(milliseconds: 300),
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                    return Container(
                                    color: tinterTheme.colors.primaryAccent,
                                    width: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Center(
                                        child: AutoSizeText(
                                          'Aprem',
                                          maxLines: 1,
                                          minFontSize: 10,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
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
                            child: AnimatedOpacity(
                              opacity: (userState as UserLoadSuccessState)
                                      .user
                                      .horairesDeTravail
                                      .contains(HoraireDeTravail.evening)
                                  ? 1
                                  : 0.5,
                              duration: Duration(milliseconds: 300),
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                    return Container(
                                    color: tinterTheme.colors.primaryAccent,
                                    width: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Center(
                                        child: AutoSizeText(
                                          'Soir',
                                          maxLines: 1,
                                          minFontSize: 10,
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              ),
                            ),
                          ),
                          InkWell(
                            splashColor: Colors.transparent,
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
                            child: AnimatedOpacity(
                              opacity: (userState as UserLoadSuccessState)
                                      .user
                                      .horairesDeTravail
                                      .contains(HoraireDeTravail.night)
                                  ? 1
                                  : 0.5,
                              duration: Duration(milliseconds: 300),
                              child: Consumer<TinterTheme>(
                                  builder: (context, tinterTheme, child) {
                                    return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5.0),
                                        bottomRight: Radius.circular(5.0),
                                      ),
                                      color: tinterTheme.colors.primaryAccent,
                                    ),
                                    width: 60,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Center(
                                        child: AutoSizeText(
                                          'Nuit',
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                  );
                                }
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

class GroupeOuSeulRectangle extends StatelessWidget {
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
            child: Consumer<TinterTheme>(
                builder: (context, tinterTheme, child) {
                  return Text(
                  'Preferes-tu travailler seul.e ou en groupe?',
                  style: tinterTheme.textStyle.headline2,
                  textAlign: TextAlign.start,
                );
              }
            ),
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
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return Slider(
                    value: (userState as UserLoadSuccessState).user.groupeOuSeul,
                    onChanged: (value) => BlocProvider.of<UserBloc>(context).add(
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

class EnLigneOuPresentielRectangle extends StatelessWidget {
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
            child: Consumer<TinterTheme>(
                builder: (context, tinterTheme, child) {
                  return Text(
                  'Preferes-tu travailler en ligne ou à l\'école?',
                  style: tinterTheme.textStyle.headline2,
                  textAlign: TextAlign.start,
                );
              }
            ),
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
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return Slider(
                    value: (userState as UserLoadSuccessState).user.enligneOuNon,
                    onChanged: (value) => BlocProvider.of<UserBloc>(context).add(
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

class MatieresRectangle extends StatelessWidget {
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
                  }
                ),
              ),
              SizedBox(height: 5,),
              BlocBuilder<UserBloc, UserState>(
                builder: (BuildContext context, UserState userState) {
                  if (!(userState is UserLoadSuccessState)) {
                    return Center(child: CircularProgressIndicator(),);
                  }
                  return Wrap(
                    alignment: WrapAlignment.start,
                    spacing: 15,
                    children: (userState as UserLoadSuccessState).user.matieresPreferees.length == 0
                        ? [
                      Consumer<TinterTheme>(
                          builder: (context, tinterTheme, child) {
                            return Chip(
                            label: Text('Aucune'),
                            labelStyle: tinterTheme.textStyle.chipLiked,
                            backgroundColor: tinterTheme.colors.primaryAccent,
                          );
                        }
                      ),
                    ]
                        : <Widget>[
                      for (String musicStyle
                      in (userState as UserLoadSuccessState).user.matieresPreferees)
                        Consumer<TinterTheme>(
                            builder: (context, tinterTheme, child) {
                              return Chip(
                              label: Text(musicStyle),
                              labelStyle: tinterTheme.textStyle.chipLiked,
                              backgroundColor: tinterTheme.colors.primaryAccent,
                            );
                          }
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
              child: Consumer<TinterTheme>(
                  builder: (context, tinterTheme, child) {
                    return Icon(
                    Icons.arrow_forward_ios,
                    size: 30,
                    color: tinterTheme.colors.primaryAccent,
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}

