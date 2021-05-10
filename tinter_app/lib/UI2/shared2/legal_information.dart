import 'package:flutter/material.dart';

main() => runApp(MaterialApp(
      home: LegalInformation(),
    ));

class LegalInformation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Informations légales',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Container(
          height: 180,
          width: 300,
          child: Card(
            child: Center(
              child: Text(
                "Les informations collectées sur \n"
                "cette application sont uniquement \n"
                " utilisées à l'intérieur de celle-ci. \n\n"
                "Aucune information relative \n"
                "à l'activité sur l'application \n"
                "n'est collectée.",
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
