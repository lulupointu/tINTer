import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/UI/shared/user_criteria_panel/gouts_musicaux.dart';
import 'package:tinterapp/UI/shared/user_profile/user_profile.dart';

import '../random_gender.dart';

class UserAssociatifProfile extends StatelessWidget {
  final Widget separator;

  const UserAssociatifProfile({Key key, @required this.separator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: Column(
        children: <Widget>[
          AssociationsRectangle(),
          separator,
          AttiranceVieAssoRectangle(),
          separator,
          FeteOuCoursRectangle(),
          separator,
          AideOuSortirRectangle(),
          separator,
          OrganisationEvenementsRectangle(),
          separator,
          GoutsMusicauxRectangle(),
        ],
      ),
    );
  }
}

class AttiranceVieAssoRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 30.0, top: 15.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Attirance pour la vie associative',
              style: Theme.of(context).textTheme.headline5,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(
                    Icons.celebration,
                    color: Theme.of(context).primaryColor,
                  ),
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
                          onChanged: (value) {
                            BlocProvider.of<UserBloc>(context).add(
                              UserStateChangedEvent(
                                newState: (userState as UserLoadSuccessState)
                                    .user
                                    .rebuild(
                                        (u) => u..attiranceVieAsso = value),
                              ),
                            );
                            print((userState as UserLoadSuccessState)
                                .user
                                .aideOuSortir);
                          },
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

class FeteOuCoursRectangle extends StatelessWidget {
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
              'Préférence entre vie associative et scolaire',
              style: Theme.of(context).textTheme.headline5,
            ),
            Row(
              children: [
                Icon(
                  Icons.celebration,
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
                                .feteOuCours,
                            onChanged: (value) {
                              BlocProvider.of<UserBloc>(context).add(
                                UserStateChangedEvent(
                                  newState: (userState as UserLoadSuccessState)
                                      .user
                                      .rebuild((u) => u..feteOuCours = value),
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
                  Icons.school_rounded,
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

class AideOuSortirRectangle extends StatelessWidget {
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
              randomGender == Gender.M
                  ? 'Parrain qui aide ou avec qui sortir ?'
                  : 'Marraine qui aide ou avec qui sortir ?',
              style: Theme.of(context).textTheme.headline5,
            ),
            Row(
              children: [
                Icon(
                  Icons.sports_bar_rounded,
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
                                .aideOuSortir,
                            onChanged: (value) {
                              BlocProvider.of<UserBloc>(context).add(
                                UserStateChangedEvent(
                                  newState: (userState as UserLoadSuccessState)
                                      .user
                                      .rebuild((u) => u..aideOuSortir = value),
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
                  Icons.support,
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

class OrganisationEvenementsRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, right: 30.0, top: 15.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Envie d'organiser des événements ?",
              style: Theme.of(context).textTheme.headline5,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Icon(
                    Icons.event_available_rounded,
                    color: Theme.of(context).primaryColor,
                  ),
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
                                  .rebuild(
                                      (u) => u..organisationEvenements = value),
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

class GoutsMusicauxRectangle extends StatelessWidget {
  const GoutsMusicauxRectangle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GoutsMusicauxTab()),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Choisir mes goûts musicaux',
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