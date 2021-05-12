import 'package:flutter/material.dart';
import 'package:tinterapp/UI/scolaire/user_profile/matieres.dart';
import 'package:tinterapp/UI/scolaire/user_profile/user_scolaire_profile.dart';
import 'package:tinterapp/UI/shared/profile_creation/create_profile.dart';
import 'package:tinterapp/UI/shared/user_profile/user_profile.dart';
import 'package:tinterapp/UI2/shared2/profile_creation/user_scolaire_profile2.dart';

class CreateProfileScolaire2 extends StatelessWidget {
  final Widget separator;

  const CreateProfileScolaire2({Key key, @required this.separator,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        MaiselOuNonRectangle2(),
        separator,
        HidingRectangle(
          child: HoraireDeTravailRectangle2(),
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
            child: GroupeOuSeulRectangle2(),
          ),
          text: 'Clique pour dire si tu aimes travailler en groupe.',
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: EnLigneOuPresentielRectangle2(),
          ),
          text:
          "Clique pour dire si tu préféres travailler en ligne ou à l\'école.",
        ),
        separator,
        HidingRectangle(
          child: InformationRectangle(
            child: Padding(
              padding: EdgeInsets.only(top: 15.0, left: 20.0, bottom: 5.0),
              child: MatieresRectangle2(),
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