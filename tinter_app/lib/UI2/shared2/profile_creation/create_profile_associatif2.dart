import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/Logic/models/shared/user.dart';
import 'package:tinterapp/UI/associatif/user_profile/gout_musicaux.dart';
import 'package:tinterapp/UI/associatif/user_profile/user_associatif_profile.dart';
import 'package:tinterapp/UI/shared/profile_creation/create_profile.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';
import 'package:tinterapp/UI/shared/user_profile/associations.dart';
import 'package:tinterapp/UI/shared/user_profile/user_profile.dart';
import 'package:tinterapp/UI2/shared2/profile_creation/user_associatif_profile2.dart';

import '../gouts_musicaux2.dart';

class CreateProfileAssociatif2 extends StatelessWidget {
  final Widget separator;

  const CreateProfileAssociatif2({
    Key key,
    @required this.separator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PrimoEntrantRectangle(),
        separator,
        YearRectangle(),
        separator,
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AssociationsTab()),
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30.0, vertical: 25.0),
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
        ),
        separator,
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GoutsMusicauxTab2()),
            );
          },
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30.0, vertical: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Définir mes goûts musicaux',
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
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: AssociationsRectangle(),
            ),
          ),
          text: 'Clique pour choisir tes associations.',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AssociationsTab()),
            );
          },
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: AttiranceVieAssoRectangle2(),
          ),
          text: 'Clique pour dire à quel point te plait la vie associative.',
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: FeteOuCoursRectangle(),
          ),
          text: 'Clique pour dire si tu es plutôt fête ou cours.',
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: AideOuSortirRectangle(),
          ),
          text:
              "Clique pour dire si tu préféres un parrain qui t'aide scolairement ou avec qui sortir.",
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: OrganisationEvenementsRectangle(),
          ),
          text: 'Clique pour dire si tu aimes organiser des événements.',
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 20.0, bottom: 5.0),
              child: GoutsMusicauxRectangle(),
            ),
          ),
          text: 'Clique pour choisir tes goûts musicaux.',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GoutsMusicauxTab()),
            );
          },
        ),
      ],
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
              'Je suis primo entrant',
              style: Theme.of(context).textTheme.headline5,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(3, 3),
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
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Mon année d'étude",
              style: Theme.of(context).textTheme.headline5,
            ),
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 2,
                    offset: Offset(3, 3),
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
              }),
            )
          ],
        ),
      ),
    );
  }
}
