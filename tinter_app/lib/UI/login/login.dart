import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tinterapp/Logic/blocs/authentication/authentication_bloc.dart';
import 'package:tinterapp/UI/const.dart';

main() {
  runApp(
    MaterialApp(
      home: KeyboardVisibilityProvider(
        child: KeyboardDismissOnTap(
          child: TinterAuthenticationTab(),
        ),
      ),
    ),
  );
}

class TinterAuthenticationTab extends StatefulWidget {
  static final Map<String, double> fractions = {
    'top': 0.20,
    'verticalMargin': 0.05,
    'horizontalMargin': 0.05,
  };

  @override
  _TinterAuthenticationTabState createState() => _TinterAuthenticationTabState();
}

class _TinterAuthenticationTabState extends State<TinterAuthenticationTab> {
  final Duration duration = Duration(milliseconds: 150);

  bool isKeyboardVisible = false;

  @override
  void initState() {
    KeyboardVisibility.onChange.listen((bool visible) {
      if (!visible) {
        FocusScope.of(context).unfocus();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TinterColors.background,
      body: Theme(
        data: ThemeData(
          brightness: Brightness.light,
          primaryColor: TinterColors.background,
        ),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height:
                        constraints.maxHeight * (1 - TinterAuthenticationTab.fractions['top']),
                    child: LoginFormAndLogo(),
                  ),
                ),

                // Top Part
                Positioned(
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    height: constraints.maxHeight * TinterAuthenticationTab.fractions['top'],
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: SvgPicture.asset(
                            'assets/profile/topProfile.svg',
                            color: TinterColors.primaryLight,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned.fill(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Center(
                              child: AutoSizeText(
                                'tINTer',
                                style: TextStyle(
                                  fontFamily: 'Podkova',
                                  fontSize: 75,
                                  fontWeight: FontWeight.w600,
                                  color: TinterColors.grey,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class HelpOnLogin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            title: Text(
              'Aide',
              textAlign: TextAlign.center,
              style: TinterTextStyle.dialogTitle,
            ),
            contentPadding: EdgeInsets.all(24.0),
            children: [
              Text(
                "Le login et le mot de passe à utiliser sont ceux de l'école.",
                textAlign: TextAlign.center,
                style: TinterTextStyle.dialogContent,
              ),
            ],
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: TinterColors.white, width: 2),
          color: Colors.transparent,
        ),
        height: 20,
        width: 20,
        child: Center(
          child: Text(
            '?',
            style: TextStyle(
              color: TinterColors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
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
    KeyboardVisibility.onChange.listen((bool visible) {
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
        Flexible(
          flex: KeyboardVisibility.isVisible ? 1 : 0,
          child: SingleChildScrollView(
            padding: EdgeInsets.only(left: 30.0, right: 30.0, top: 40, bottom: 20.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                color: TinterColors.grey,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Error message
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (BuildContext context, AuthenticationState state) {
                      final hasError = state is AuthenticationFailureState;

                      return AnimatedContainer(
                        duration: Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: TinterColors.secondaryAccent.withAlpha(150),
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          border: Border.all(
                              color: TinterColors.secondaryAccent.withAlpha(170), width: 1),
                        ),
                        height: hasError && displayError ? 40 : 0,
                        margin: EdgeInsets.only(bottom: hasError && displayError ? 20 : 0),
                        padding: EdgeInsets.only(
                          left: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                  hasError && displayError
                                      ? (state as AuthenticationFailureState)
                                          .error
                                          .getMessage()
                                      : '',
                                  style: TinterTextStyle.loginError),
                            ),
                            InkWell(
                              onTap: () => setState(
                                () => displayError = false,
                              ),
                              child: SizedBox(
                                width: hasError && displayError ? 40 : 0,
                                child: Center(
                                  child: Icon(
                                    Icons.close,
                                    size: hasError && displayError ? 20 : 0,
                                    color: TinterColors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),

                  // Login
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Login',
                            style: TinterTextStyle.loginFormLabel,
                          ),
                          HelpOnLogin(),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: TinterColors.primaryAccent,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        height: 40,
                        child: TextField(
                          focusNode: _loginFocusNode,
                          controller: _loginController,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) {
                            _passwordFocusNode.requestFocus();
                          },
                          style: TextStyle(textBaseline: TextBaseline.alphabetic),
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 14, left: 10.0),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Spacing
                  SizedBox(
                    height: 25,
                  ),

                  // Password
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Mot de passe',
                            style: TinterTextStyle.loginFormLabel,
                          ),
                          HelpOnLogin(),
                        ],
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: TinterColors.primaryAccent,
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        ),
                        height: 40,
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
                            suffixIcon: IconButton(
                              icon: Icon(
                                  _passwordVisible ? Icons.visibility : Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(bottom: 8, left: 10.0),
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Spacing
                  SizedBox(
                    height: 30,
                  ),

                  // Connect button
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 40,
                      child: Center(
                        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                          builder: (BuildContext context, AuthenticationState state) {
                            final bool isLoading = (state is AuthenticationLoadingState);
                            return LayoutBuilder(
                              builder: (BuildContext context, BoxConstraints constraints) {
                                return AnimatedContainer(
                                  duration: Duration(milliseconds: 150),
                                  decoration: BoxDecoration(
                                    color: TinterColors.secondaryAccent,
                                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                                  ),
                                  height: 40,
                                  width: isLoading ? 40 : constraints.maxWidth,
                                  child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 150),
                                    child: isLoading
                                        ? SizedBox(
                                            height: 23,
                                            width: 23,
                                            child: CircularProgressIndicator(
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                TinterColors.white,
                                              ),
                                              strokeWidth: 3,
                                            ),
                                          )
                                        : FlatButton(
                                            onPressed: _onAuthenticationTry,
                                            child: Text(
                                              'Se connecter',
                                              style: TinterTextStyle.loginFormButton,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Logo
        KeyboardVisibility.isVisible
            ? Container()
            : Flexible(
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Icon(Icons.favorite_border),
                    ),
                    Text('Developpé par Lucas Delsol.'),
                  ],
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
    final AuthenticationBloc authenticationBloc = BlocProvider.of<AuthenticationBloc>(context);

    // If one of the two field is empty, immediately return an error event
    if (_loginController.text == "" || _loginController.text == "") {
      authenticationBloc
          .add(AuthenticationLoggedFailedEvent(error: AuthenticationEmptyCredentialError()));
      return;
    }
    authenticationBloc.add(
      AuthenticationLoggedRequestSentEvent(
        login: _loginController.text,
        password: _passwordController.text,
      ),
    );
  }
}
