import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/UI/shared/profile_creation/create_profile2.dart';

main() => runApp(MaterialApp(
      home: AlmostThere(),
    ));

class AlmostThere extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50.0),
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: Text(
                        'Tu y es presque !',
                        style: Theme.of(context).textTheme.headline3,
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
                  AlmostThereExample(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    child: Text(
                      "Tu peux switch entre ces deux modes autant de fois que tu le souhaites. Le mode 'Scolaire' te "
                      "permettra de trouver un binôme pour ta scolarité à TSP et le mode 'Associatif' des parains.",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class AlmostThereExample extends StatelessWidget {
  const AlmostThereExample({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
        width: 275,
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
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Column(
            children: [
              HoveringUserPicture(size: 95.0),
              Padding(
                padding: const EdgeInsets.only(top: 5.0),
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
                padding: const EdgeInsets.only(top: 5.0, bottom: 3.0),
                child: SwitchButton(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SwitchButton extends StatefulWidget {

  const SwitchButton({Key key}) : super(key: key);

  @override
  _SwitchButtonState createState() => _SwitchButtonState();
}

class _SwitchButtonState extends State<SwitchButton> {
  bool isAsso = true;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: 25,
          width: 180,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).disabledColor,
            border: Border.all(
                color: Colors.white, width: 2.5, style: BorderStyle.solid),
            borderRadius: BorderRadius.all(
              Radius.circular(25.0),
            ),
          ),
        ),
        if (!isAsso)
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isAsso = !isAsso;
                });
              },
              child: Container(
                height: 25,
                width: 110,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 2.0, left: 20.0),
                  child: Center(
                    child: Text(
                      'associatif',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(fontSize: 14.0),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Theme.of(context).disabledColor,
                  border: Border.all(
                      color: Colors.white, width: 2.5, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
              ),
            ),
          ),
        GestureDetector(
          onTap: () {
            if (isAsso) {
              setState(() {
                isAsso = !isAsso;
              });
            }
          },
          child: Container(
            height: 25,
            width: isAsso ? 110 : 100,
            child: Padding(
              padding: EdgeInsets.only(bottom: 2.0, right: isAsso ? 20.0 : 0.0),
              child: Center(
                  child: Text(
                'scolaire',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontSize: 14.0),
              )),
            ),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: isAsso
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).accentColor,
              border: Border.all(
                  color: Colors.white, width: 2.5, style: BorderStyle.solid),
              borderRadius: BorderRadius.all(
                Radius.circular(25.0),
              ),
            ),
          ),
        ),
        if (isAsso)
          Positioned(
            right: 0,
            child: Container(
              height: 25,
              width: 100,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2.0),
                child: Center(
                  child: Text(
                    'associatif',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontSize: 14.0),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: Theme.of(context).primaryColor,
                border: Border.all(
                    color: Colors.white, width: 2.5, style: BorderStyle.solid),
                borderRadius: BorderRadius.all(
                  Radius.circular(25.0),
                ),
              ),
            ),
          )
      ],
    );
  }
}
