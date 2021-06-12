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
        child: FractionallySizedBox(
          widthFactor: 0.75,
          child: Card(
            child: Center(
              heightFactor: 1.5,
              child: Text(
                "Hébergeur de l'application :\n\n"
                "Télécom SudParis\n"
                "9 rue Charles Fourier\n"
                "91011 Evry Cedex\n"
                "Tel.: + 33 1 60 76 40 40\n"
                "lucas.delsol@telecom-sudparis.eu\n"
                "SIRET 180 092 025 00055 - APE 8542Z",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
