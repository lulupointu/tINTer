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
        HoraireDeTravailRectangle2(),
        separator,
        GroupeOuSeulRectangle2(),
        separator,
        EnLigneOuPresentielRectangle2(),
        separator,
        MatieresRectangle2(),
      ],
    );
  }
}