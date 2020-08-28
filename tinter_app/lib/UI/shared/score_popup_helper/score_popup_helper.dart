import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';

void showWhatIsScore(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) => SimpleDialog(
      title: Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
        return Text(
          'Score',
          textAlign: TextAlign.center,
          style: tinterTheme.textStyle.dialogTitle,
        );
      }),
      contentPadding: EdgeInsets.all(24.0),
      children: [
        Consumer<TinterTheme>(builder: (context, tinterTheme, child) {
          return Text(
            "Le score est un indicateur (sur 100) de l'affinité supposée.\nIl est basé sur les critères renseignés dans le profil.",
            textAlign: TextAlign.center,
            style: tinterTheme.textStyle.dialogContent,
          );
        }),
      ],
    ),
  );
}
