import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';

import 'legal_information2.dart';

main() => runApp(MaterialApp(
      home: OptionsTab2(),
    ));

class OptionsTab2 extends StatefulWidget {
  @override
  _OptionsTab2State createState() => _OptionsTab2State();
}

class _OptionsTab2State extends State<OptionsTab2>
    with SingleTickerProviderStateMixin {
  final Map<String, double> fractions = {
    'top': 0.2,
    'options': 0.5,
    'logo': 0.2,
    'separator': 0.05,
  };

  AnimationController _controller;
  Animation<double> _animation;

  @override
  void initState() {
    _controller = AnimationController(duration: duration, vsync: this);
    _animation = CurveTween(curve: Curves.easeOut).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Duration duration = Duration(milliseconds: 200);

  bool informationsLegalesSelected = false;

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
          'Options',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0, left: 50.0, right: 50.0),
            child: Center(
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, left: 30.0, right: 30.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LegalInformation()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 15.0),
                          child: Text('Informations légales'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 30.0, right: 30.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).accentColor),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          BlocProvider.of<AuthenticationBloc>(context)
                              .add(AuthenticationLoggedOutEvent());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 15.0),
                          child: Text('Déconnexion'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, left: 30.0, right: 30.0, bottom: 30.0),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).errorColor),
                        ),
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) => SimpleDialog(
                              elevation: 5.0,
                              contentPadding: EdgeInsets.all(20.0),
                              children: [
                                Text(
                                  'Es-tu sûr de vouloir supprimer ton profil ?',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                          Navigator.pop(context);
                                          BlocProvider.of<UserBloc>(context)
                                              .add(DeleteUserAccountEvent());
                                        },
                                        child: Text('Oui'),
                                      ),
                                      width: 100.0,
                                      height: 40.0,
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    SizedBox(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: Text('Annuler'),
                                        style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  Theme.of(context)
                                                      .accentColor),
                                        ),
                                      ),
                                      width: 100.0,
                                      height: 40.0,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30.0, vertical: 15.0),
                          child: Text(
                            'Supprimer mon profil',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ProblemOrQuestion(),
          )
        ],
      ),
    );
  }
}

class ProblemOrQuestion extends StatelessWidget {
  const ProblemOrQuestion({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Un problème ou une question ?',
              style: Theme.of(context).textTheme.headline5,
            ),
            ButtonTheme(
              minWidth: 0,
              height: 0,
              padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
              //adds padding inside the button
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              //limits the touch area to the button area
              child: FlatButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => SimpleDialog(
                      children: [
                        Text(
                          'ToDo',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ],
                    ),
                  );
                },
                child: Text(
                  'Rejoignez-nous !',
                  style: Theme.of(context)
                      .textTheme
                      .headline5
                      .copyWith(color: Color(0xff738ADB)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
