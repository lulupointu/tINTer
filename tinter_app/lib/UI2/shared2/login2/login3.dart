import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';

main() {
  runApp(
    MaterialApp(
      home: KeyboardVisibilityProvider(
        child: KeyboardDismissOnTap(
          child: TinterAuthenticationTab3(),
        ),
      ),
    ),
  );
}

class TinterAuthenticationTab3 extends StatefulWidget {
  static final Map<String, double> fractions = {
    'top': 0.20,
    'verticalMargin': 0.05,
    'horizontalMargin': 0.05,
  };

  @override
  _TinterAuthenticationTab3State createState() =>
      _TinterAuthenticationTab3State();
}

class _TinterAuthenticationTab3State extends State<TinterAuthenticationTab3> {
  final Duration duration = Duration(milliseconds: 150);

  bool isKeyboardVisible = false;

  @override
  void initState() {
    KeyboardVisibilityController().onChange.listen((bool visible) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Align(
                alignment: Alignment.topCenter,
                child: RichText(
                    text: TextSpan(
                        text: 't',
                        style: Theme.of(context).textTheme.headline1.copyWith(
                            color: Colors.black87, fontWeight: FontWeight.w400),
                        children: <TextSpan>[
                      TextSpan(
                          text: 'int',
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w400)),
                      TextSpan(
                          text: 'er',
                          style: Theme.of(context).textTheme.headline1.copyWith(
                              color: Colors.black87,
                              fontWeight: FontWeight.w400)),
                    ]))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0, left: 40.0, right: 40.0),
            child: Card(
              margin: EdgeInsets.zero,
              color: Colors.white,
              shadowColor: Colors.black,
              elevation: 5.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 15.0, left: 20.0),
                    child: Text(
                      'Nom de compte',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.black38),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 15.0, right: 20.0),
                    child: Icon(
                      Icons.help_outline,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 40.0, right: 40.0),
            child: Card(
              margin: EdgeInsets.zero,
              color: Colors.white,
              shadowColor: Colors.black,
              elevation: 5.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 15.0, left: 20.0),
                    child: Text(
                      'Mot de passe',
                      style: Theme.of(context)
                          .textTheme
                          .headline6
                          .copyWith(color: Colors.black38),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 15.0, bottom: 15.0, right: 20.0),
                    child: Icon(
                      Icons.visibility_off,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0, left: 80.0, right: 80.0),
            child: Card(
              margin: EdgeInsets.zero,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
              shadowColor: Colors.black,
              elevation: 5.0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Se connecter',
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
         Expanded(
           child: Padding(
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
                   Text(
                     'Rejoignez-nous !',
                     style: Theme.of(context)
                         .textTheme
                         .headline5
                         .copyWith(color: Color(0xff738ADB)),
                   ),
                 ],
               ),
             ),
           ),
         )
        ],
      ),
    );
  }
}
