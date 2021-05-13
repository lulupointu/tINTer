import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/UI/associatif/user_profile/gout_musicaux.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/user_profile/user_profile.dart';
import 'package:tinterapp/UI2/shared2/gouts_musicaux2.dart';

class UserAssociatifProfile extends StatelessWidget {
  final Widget separator;

  const UserAssociatifProfile({Key key, @required this.separator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InformationRectangle(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: AssociationsRectangle(),
        ),
        separator,
        InformationRectangle(
          child: AttiranceVieAssoRectangle2(),
        ),
        separator,
        InformationRectangle(
          child: FeteOuCoursRectangle2(),
        ),
        separator,
        InformationRectangle(
          child: AideOuSortirRectangle2(),
        ),
        separator,
        InformationRectangle(
          child: OrganisationEvenementsRectangle2(),
        ),
        separator,
        InformationRectangle(
          padding:
              EdgeInsets.only(top: 15.0, left: 20.0, bottom: 5.0, right: 20),
          child: GoutsMusicauxRectangle2(),
        ),
      ],
    );
  }
}

class AttiranceVieAssoRectangle2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attirance pour la vie associative',
              style: Theme.of(context).textTheme.headline5,
            ),
            Row(
              children: [
                Icon(
                  Icons.celebration,
                  color: Theme.of(context).primaryColor,
                ),
                SliderTheme(
                  data: Theme.of(context).sliderTheme,
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (BuildContext context, UserState userState) {
                      if (!(userState is UserLoadSuccessState)) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Expanded(
                        child: Slider(
                          value: (userState as UserLoadSuccessState)
                              .user
                              .attiranceVieAsso,
                          onChanged: (value) =>
                              BlocProvider.of<UserBloc>(context).add(
                            UserStateChangedEvent(
                              newState: (userState as UserLoadSuccessState)
                                  .user
                                  .rebuild((u) => u..attiranceVieAsso = value),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FeteOuCoursRectangle2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Préférence entre vie scolaire et associative',
              style: Theme.of(context).textTheme.headline5,
            ),
            Row(
              children: [
                Icon(
                  Icons.school_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                SliderTheme(
                  data: Theme.of(context).sliderTheme.copyWith(inactiveTrackColor: Theme.of(context).accentColor),
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (BuildContext context, UserState userState) {
                      if (!(userState is UserLoadSuccessState)) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Expanded(
                        child: Slider(
                          value: (userState as UserLoadSuccessState)
                              .user
                              .feteOuCours,
                          onChanged: (value) =>
                              BlocProvider.of<UserBloc>(context).add(
                                UserStateChangedEvent(
                                  newState: (userState as UserLoadSuccessState)
                                      .user
                                      .rebuild((u) => u..feteOuCours = value),
                                ),
                              ),
                        ),
                      );
                    },
                  ),
                ),
                Icon(
                  Icons.celebration,
                  color: Theme.of(context).accentColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AideOuSortirRectangle2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Parain qui aide ou avec qui sortir ?',
              style: Theme.of(context).textTheme.headline5,
            ),
            Row(
              children: [
                Icon(
                  Icons.support,
                  color: Theme.of(context).primaryColor,
                ),
                SliderTheme(
                  data: Theme.of(context).sliderTheme.copyWith(inactiveTrackColor: Theme.of(context).accentColor),
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (BuildContext context, UserState userState) {
                      if (!(userState is UserLoadSuccessState)) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Expanded(
                        child: Slider(
                          value: (userState as UserLoadSuccessState)
                              .user
                              .aideOuSortir,
                          onChanged: (value) =>
                              BlocProvider.of<UserBloc>(context).add(
                                UserStateChangedEvent(
                                  newState: (userState as UserLoadSuccessState)
                                      .user
                                      .rebuild((u) => u..aideOuSortir = value),
                                ),
                              ),
                        ),
                      );
                    },
                  ),
                ),
                Icon(
                  Icons.sports_bar_rounded,
                  color: Theme.of(context).accentColor,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class OrganisationEvenementsRectangle2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Organiser des événements ?',
              style: Theme.of(context).textTheme.headline5,
            ),
            Row(
              children: [
                Icon(
                  Icons.event_available_rounded,
                  color: Theme.of(context).primaryColor,
                ),
                SliderTheme(
                  data: Theme.of(context).sliderTheme,
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (BuildContext context, UserState userState) {
                      if (!(userState is UserLoadSuccessState)) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Expanded(
                        child: Slider(
                          value: (userState as UserLoadSuccessState)
                              .user
                              .organisationEvenements,
                          onChanged: (value) =>
                              BlocProvider.of<UserBloc>(context).add(
                                UserStateChangedEvent(
                                  newState: (userState as UserLoadSuccessState)
                                      .user
                                      .rebuild((u) => u..organisationEvenements = value),
                                ),
                              ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class GoutsMusicauxRectangle2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GoutsMusicauxTab2()),
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
                    'Goûts musicaux',
                    style: tinterTheme.textStyle.headline2,
                  );
                }),
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
                                .goutsMusicaux
                                .length ==
                            0
                        ? [
                            Consumer<TinterTheme>(
                                builder: (context, tinterTheme, child) {
                              return Chip(
                                label: Text('Aucun'),
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
                                    .goutsMusicaux)
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