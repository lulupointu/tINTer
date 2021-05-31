import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: Stack(
        children: [
          Center(
            child: FractionallySizedBox(
              widthFactor: 0.75,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 30.0,
                    horizontal: 20.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LegalInformation()),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                          ),
                          child: Text(
                            'Informations légales',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).indicatorColor),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          BlocProvider.of<AuthenticationBloc>(context)
                              .add(AuthenticationLoggedOutEvent());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                          ),
                          child: Text(
                            'Se déconnecter',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).errorColor),
                        ),
                        onPressed: () {
                          showGeneralDialog(
                            transitionDuration: Duration(milliseconds: 300),
                            barrierDismissible: false,
                            context: context,
                            pageBuilder: (context, animation, _) =>
                                SimpleDialog(
                              elevation: 5.0,
                              contentPadding: EdgeInsets.all(
                                20.0,
                              ),
                              children: [
                                Text(
                                  'Es-tu sûr de vouloir supprimer ton compte ?',
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
                                                      .indicatorColor),
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
                            vertical: 15.0,
                          ),
                          child: Text(
                            'Supprimer mon compte',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ProblemOrQuestion()
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
            GestureDetector(
                onTap: _launchDiscordURL,
                child: Container(
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 20.0,
                    ),
                    child: Text(
                      'Rejoignez-nous !',
                      style: Theme.of(context).textTheme.headline5.copyWith(
                            color: Color(0xff738ADB),
                          ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  _launchDiscordURL() async {
    const url = 'https://discord.gg/sUCzJS4Q4m';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
