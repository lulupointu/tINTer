import 'package:flutter/cupertino.dart';
import 'package:tinterapp/UI/shared/profile_creation/sub_profile_creation/associative_to_scolaire.dart';
import 'package:tinterapp/UI/shared/profile_creation/sub_profile_creation/scolaire_profile.dart';

import 'sub_profile_creation/associative_profile.dart';

enum AccountCreationMode {
  associatif,
  associatifToScolaire,
  scolaire,
}

class ProfileCreation extends StatefulWidget {
  const ProfileCreation({Key key}) : super(key: key);

  @override
  _ProfileCreationState createState() => _ProfileCreationState();
}

class _ProfileCreationState extends State<ProfileCreation> {
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
        child = AssociativeProfile(
            onAccountCreationModeChanged: onAccountCreationModeChanged);
        break;
      case AccountCreationMode.associatifToScolaire:
        child = AssociativeToScolaire(
          onAccountCreationModeChanged: onAccountCreationModeChanged,
        );
        break;
      case AccountCreationMode.scolaire:
        child = ScolaireProfile();
        break;
    }

    return AnimatedSwitcher(
      duration: Duration(
        milliseconds: 300,
      ),
      child: child,
    );
  }
}
