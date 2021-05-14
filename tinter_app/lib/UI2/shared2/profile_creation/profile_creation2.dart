import 'package:flutter/cupertino.dart';
import 'package:tinterapp/UI2/shared2/profile_creation/associative_to_scolaire2.dart';
import 'package:tinterapp/UI2/shared2/profile_creation/scolaire_profile2.dart';

import 'associative_profile2.dart';

enum AccountCreationMode {
  associatif,
  associatifToScolaire,
  scolaire,
}

class ProfileCreation2 extends StatefulWidget {
  const ProfileCreation2({Key key}) : super(key: key);

  @override
  _ProfileCreation2State createState() => _ProfileCreation2State();
}

class _ProfileCreation2State extends State<ProfileCreation2> {

  void onAccountCreationModeChanged({@required AccountCreationMode accountCreationMode}) {
    setState(() {
      this.accountCreationMode = accountCreationMode;
    });
  }

  AccountCreationMode accountCreationMode = AccountCreationMode.associatif;

  @override
  Widget build(BuildContext context) {
    switch (accountCreationMode) {
      case AccountCreationMode.associatif:
        return AssociativeProfile2(onAccountCreationModeChanged: onAccountCreationModeChanged);
        break;
      case AccountCreationMode.associatifToScolaire:
        return AssociativeToScolaire2();
        break;
      case AccountCreationMode.scolaire:
        return ScolaireProfile2();
        break;
    }
    throw Exception('This should NEVER happen.');
  }
}
