import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';

import '../../associatif_to_scolaire_button2.dart';
import '../profile_creation.dart';
import 'associative_profile.dart';

main() => runApp(MaterialApp(
      home: AssociativeToScolaire(
        onAccountCreationModeChanged: null,
      ),
    ));

class AssociativeToScolaire extends StatefulWidget {
  final void Function({@required AccountCreationMode accountCreationMode})
      onAccountCreationModeChanged;

  const AssociativeToScolaire(
      {Key key, @required this.onAccountCreationModeChanged})
      : super(key: key);

  @override
  _AssociativeToScolaireState createState() => _AssociativeToScolaireState();
}

class _AssociativeToScolaireState extends State<AssociativeToScolaire> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: Card(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Center(
                                  child: Text(
                                    'Tu y es presque !',
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 20.0),
                                child: Text(
                                  "Comme tu es en première année, nous allons te présenter une fonctionnalité importante de l'application. Sur la page 'Profil', "
                                  "tu verras que tu as la possibilité de switch entre deux modes : 'Scolaire' et 'Associatif'.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                              AssociativeToScolaireProfileHeader(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 20.0),
                                child: Text(
                                  "Tu peux switch entre ces deux modes autant de fois que tu le souhaites. Le mode 'Scolaire' te "
                                  "permettra de trouver un binôme pour ta scolarité à TSP et le mode 'Associatif' des parains et marraines.",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: AssociativeToScolaireButton(
                  onAccountCreationModeChanged:
                      widget.onAccountCreationModeChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssociativeToScolaireProfileHeader extends StatelessWidget {
  const AssociativeToScolaireProfileHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(10.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10.0,
          ),
          HoveringUserPicture2(
            size: 100.0,
            showModifyOption: false,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5.0,
            ),
            child: BlocBuilder<UserBloc, UserState>(
              builder: (BuildContext context, UserState userState) {
                return Text(
                  ((userState is NewUserState))
                      ? userState.user.name + " " + userState.user.surname
                      : 'En chargement...',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: Colors.white),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 40.0,
              right: 40.0,
              bottom: 15.0,
            ),
            child: AssociatifToScolaireButton2(),
          ),
        ],
      ),
    );
  }
}

class AssociativeToScolaireButton extends StatelessWidget {
  final void Function({@required AccountCreationMode accountCreationMode})
      onAccountCreationModeChanged;

  const AssociativeToScolaireButton(
      {Key key, @required this.onAccountCreationModeChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
      ),
      height: 65,
      child: ElevatedButton(
        onPressed: () {
          onAccountCreationModeChanged(
              accountCreationMode: AccountCreationMode.scolaire);
        },
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.only(
              topLeft: Radius.circular(15.0),
              topRight: Radius.circular(15.0),
            ),
          ),
        ),
        child: Center(
          child: Text(
            "Créer mon profil",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}