import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';

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
      resizeToAvoidBottomInset: false,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 75.0),
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
          LoginFormAndLogo(),
          Container(
            child: Expanded(
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
            ),
          ),
        ],
      ),
    );
  }
}

class HelpOnLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
        icon: Icon(
          Icons.help_outline,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) => SimpleDialog(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          'Aide',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 10.0, bottom: 20.0),
                        child: Text(
                          "Le login et le mot de passe à utiliser sont ceux de l'école.",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                    ],
                  ));
        });
  }
}

class LoginFormAndLogo extends StatefulWidget {
  @override
  _LoginFormAndLogoState createState() => _LoginFormAndLogoState();
}

class _LoginFormAndLogoState extends State<LoginFormAndLogo> {
  FocusNode _loginFocusNode = FocusNode();
  FocusNode _passwordFocusNode = FocusNode();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool displayError = true;

  @override
  void initState() {
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (!visible) {
        _passwordVisible = false;
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _loginFocusNode.dispose();
    _passwordFocusNode.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      obscureText: false,
                      focusNode: _loginFocusNode,
                      controller: _loginController,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) {
                        _passwordFocusNode.requestFocus();
                      },
                      style: TextStyle(textBaseline: TextBaseline.alphabetic),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        labelText: 'Nom de compte',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        labelStyle: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.black38),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: HelpOnLogin(),
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
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: TextField(
                  focusNode: _passwordFocusNode,
                  controller: _passwordController,
                  textInputAction: TextInputAction.done,
                  obscureText: !_passwordVisible,
                  onEditingComplete: () {
                    _passwordFocusNode.unfocus();
                    _onAuthenticationTry();
                  },
                  style: TextStyle(textBaseline: TextBaseline.alphabetic),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    suffixIconConstraints: BoxConstraints(),
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                        icon: Icon(
                          _passwordVisible ? Icons.visibility : Icons.visibility_off,
                          color: Theme.of(context).primaryColor,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    labelText: 'Mot de passe',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    labelStyle: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.black38),
                  ),
                ),
              ),
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
      ],
    );
  }

  _onAuthenticationTry() {
    // Stop displaying the previous error if the user didn't do it manually
    displayError = true;

    // Unfocus all text fields
    FocusScope.of(context).unfocus();

    // get the authentication bloc
    // note: close_sinks is a false positive, ignore it.
    // ignore: close_sinks
    final AuthenticationBloc authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context);

    // If one of the two field is empty, immediately return an error event
    if (_loginController.text == "" || _passwordController.text == "") {
      authenticationBloc.add(AuthenticationLoggedFailedEvent(
          error: AuthenticationEmptyCredentialError()));
      return;
    }

    print('Send request with login: ' +
        _loginController.text
            .toLowerCase()
            .replaceAll(' ', '')
            .replaceAll(' ', '') +
        ' | password: ' +
        _passwordController.text.replaceAll(' ', '').replaceAll(' ', ''));

    authenticationBloc.add(
      AuthenticationLoggedRequestSentEvent(
        login: _loginController.text.toLowerCase().replaceAll(' ', ''),
        password: _passwordController.text,
      ),
    );
  }
}
