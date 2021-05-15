import 'package:flutter/cupertino.dart';
import 'package:tinterapp/UI2/shared2/profile_creation/sub_profile_creation/associative_to_scolaire2.dart';
import 'package:tinterapp/UI2/shared2/profile_creation/sub_profile_creation/scolaire_profile2.dart';

import 'sub_profile_creation/associative_profile2.dart';

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
  void onAccountCreationModeChanged(
      {@required AccountCreationMode accountCreationMode}) {
    setState(() {
      this.accountCreationMode = accountCreationMode;
    });
  }

  AccountCreationMode accountCreationMode = AccountCreationMode.associatif;

  @override
  Widget build(BuildContext context) {
    Widget child;

    switch (accountCreationMode) {
      case AccountCreationMode.associatif:
        child = AssociativeProfile2(
            onAccountCreationModeChanged: onAccountCreationModeChanged);
        break;
      case AccountCreationMode.associatifToScolaire:
        child = AssociativeToScolaire2(
          onAccountCreationModeChanged: onAccountCreationModeChanged,
        );
        break;
      case AccountCreationMode.scolaire:
        child = ScolaireProfile2();
        break;
    }

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: child,
    );
  }
}
