import 'package:flutter/material.dart';
import 'package:tinterapp/UI/scolaire/user_profile/matieres.dart';
import 'package:tinterapp/UI/scolaire/user_profile/user_scolaire_profile.dart';
import 'package:tinterapp/UI/shared/profile_creation/create_profile.dart';
import 'package:tinterapp/UI/shared/user_profile/user_profile.dart';

class CreateProfileScolaire extends StatelessWidget {
  final Widget separator;

  const CreateProfileScolaire({Key key, @required this.separator,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        HidingRectangle(
          child: InformationRectangle(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 5.0, left: 20.0, right: 20.0),
              child: MaiselOuNonRectangle(),
            ),
          ),
          text: 'Clique pour dire si tu habite à la maisel ou non.',
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 5.0, left: 20.0, right: 20.0),
              child: HoraireDeTravailRectangle(),
            ),
          ),
          text: 'Clique pour dire à quel moment de la journée tu aimes travailler.',
        ),
        separator,
        InformationRectangle(
          child: Padding(
            padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
            child: AssociationsRectangle(),
          ),
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: GroupeOuSeulRectangle(),
          ),
          text: 'Clique pour dire si tu aime travailler en groupe.',
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: EnLigneOuPresentielRectangle(),
          ),
          text:
          "Clique pour dire si tu préfére travailler en ligne ou à l\'école.",
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 20.0, bottom: 5.0),
              child: MatieresRectangle(),
            ),
          ),
          text: 'Clique pour selectionner tes matières préférées.',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MatieresTab()),
            );
          },
        ),
      ],
    );
  }
}