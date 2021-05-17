import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/UI/shared/user_profile/associations.dart';
import 'package:tinterapp/UI2/shared2/user_profile/user_associatif_profile2.dart';

import '../../user_criteria_panel2/gouts_musicaux2.dart';

class AssociativeCriteriaList2 extends StatelessWidget {
  final Widget separator;

  final bool isAssociationPressed;

  final bool isMusicTastePressed;

  final void Function() onAssociationPressed;

  final void Function() onMusicTastePressed;

  const AssociativeCriteriaList2({
    Key key,
    @required this.separator,
    @required this.isAssociationPressed,
    @required this.onAssociationPressed,
    @required this.isMusicTastePressed,
    @required this.onMusicTastePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              PrimoEntrantRectangle(),
              separator,
              YearRectangle(),
              separator,
              AttiranceVieAssoRectangle2(),
              separator,
              FeteOuCoursRectangle2(),
              separator,
              AideOuSortirRectangle2(),
              separator,
              OrganisationEvenementsRectangle2(),
              separator,
              DefineAssociations(
                isAssociationPressed: isAssociationPressed,
                onAssociationPressed: onAssociationPressed,
              ),
              separator,
              DefineMusicTaste(
                isMusicTastePressed: isMusicTastePressed,
                onMusicTastePressed: onMusicTastePressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DefineMusicTaste extends StatelessWidget {
  final bool isMusicTastePressed;
  final void Function() onMusicTastePressed;

  const DefineMusicTaste({
    Key key,
    @required this.isMusicTastePressed,
    @required this.onMusicTastePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onMusicTastePressed();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GoutsMusicauxTab2()),
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

class DefineAssociations extends StatelessWidget {
  final bool isAssociationPressed;
  final void Function() onAssociationPressed;

  const DefineAssociations({
    Key key,
    @required this.isAssociationPressed,
    @required this.onAssociationPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onAssociationPressed();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AssociationsTab()),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sélectionner mes associations',
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

class PrimoEntrantRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Je suis primo entrant.e',
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
                                  .rebuild((b) => b..primoEntrant = true))),
                      child: Container(
                        width: 45,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Theme.of(context).primaryColor.withOpacity(
                              (userState as NewUserState).user.primoEntrant
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
                                                .primoEntrant
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
                                  .rebuild((b) => b..primoEntrant = false))),
                      child: Container(
                        width: 45,
                        height: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Theme.of(context).primaryColor.withOpacity(
                              (userState as NewUserState).user.primoEntrant
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
                                                  .primoEntrant
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

class YearRectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          children: [
            Text(
              "Mon année scolaire actuelle",
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 15.0,
            ),
            BlocBuilder<UserBloc, UserState>(
                builder: (BuildContext context, UserState userState) {
              if (!(userState is NewUserState)) {
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
                            newState: (userState as NewUserState)
                                .user
                                .rebuild((b) => b..year = TSPYear.TSP1A))),
                    child: Container(
                      width: 45,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Theme.of(context).primaryColor.withOpacity(
                            (userState as NewUserState).user.year ==
                                    TSPYear.TSP1A
                                ? 1
                                : 0.4),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(5.0),
                            bottomLeft: Radius.circular(5.0)),
                      ),
                      child: Center(
                        child: Text(
                          '1A',
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(
                                  color: Colors.black.withOpacity(
                                      (userState as NewUserState).user.year ==
                                              TSPYear.TSP1A
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
                                .rebuild((b) => b..year = TSPYear.TSP2A))),
                    child: Container(
                      width: 45,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Theme.of(context).primaryColor.withOpacity(
                            (userState as NewUserState).user.year ==
                                    TSPYear.TSP2A
                                ? 1
                                : 0.4),
                      ),
                      child: Center(
                        child: Text('2A',
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                .copyWith(
                                    color: Colors.black.withOpacity(
                                        (userState as NewUserState)
                                                    .user
                                                    .year ==
                                                TSPYear.TSP2A
                                            ? 0.87
                                            : 0.38))),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => BlocProvider.of<UserBloc>(context).add(
                        UserStateChangedEvent(
                            newState: (userState as NewUserState)
                                .user
                                .rebuild((b) => b..year = TSPYear.TSP3A))),
                    child: Container(
                      width: 45,
                      height: 35,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Theme.of(context).primaryColor.withOpacity(
                            (userState as NewUserState).user.year ==
                                    TSPYear.TSP3A
                                ? 1
                                : 0.4),
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(5.0),
                            bottomRight: Radius.circular(5.0)),
                      ),
                      child: Center(
                        child: Text(
                          '3A',
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              .copyWith(
                                  color: Colors.black.withOpacity(
                                      (userState as NewUserState).user.year ==
                                              TSPYear.TSP3A
                                          ? 0.87
                                          : 0.38)),
                        ),
                      ),
                    ),
                  )
                ],
              );
            })
          ],
        ),
      ),
    );
  }
}
