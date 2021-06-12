import 'package:flutter/material.dart';
import 'package:tinterapp/UI/shared/user_profile/user_scolaire_profile.dart';

class ScolaireCriteriaList extends StatelessWidget {
  final Widget separator;

  final bool isMatieresPressed;

  final void Function() onMatieresPressed;

  const ScolaireCriteriaList({
    Key key,
    @required this.separator,
    @required this.isMatieresPressed,
    @required this.onMatieresPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30.0,
      ),
      child: Column(
        children: <Widget>[
          MaiselOuNonRectangle(),
          separator,
          HoraireDeTravailRectangle(),
          separator,
          GroupeOuSeulRectangle(),
          separator,
          EnLigneOuPresentielRectangle(),
          separator,
          MatieresRectangle2WithListener(
            isMatieresPressed: isMatieresPressed,
            onMatieresPressed: onMatieresPressed,
          ),
        ],
      ),
    );
  }
}
