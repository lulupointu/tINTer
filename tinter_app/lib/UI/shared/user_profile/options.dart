import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/Logic/blocs/shared/authentication/authentication_bloc.dart';
import 'package:tinterapp/Logic/blocs/shared/user_shared/user_shared_bloc.dart';
import 'package:tinterapp/UI/shared/splash_screen/splash_screen.dart';

import '../shared_element/const.dart';

main() => runApp(MaterialApp(
      home: OptionsTab(),
    ));

class OptionsTab extends StatefulWidget {
  @override
  _OptionsTabState createState() => _OptionsTabState();
}

class _OptionsTabState extends State<OptionsTab> with SingleTickerProviderStateMixin {
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
    return SafeArea(
      child: Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return Material(
            color: tinterTheme.colors.background,
            child: child,
          );
        },
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Column(
              children: [
                Container(
                  height: constraints.maxHeight * fractions['top'],
                  child: Stack(
                    alignment: AlignmentDirectional.topCenter,
                    children: <Widget>[
                      Positioned.fill(
                        child: Consumer<TinterTheme>(
                            builder: (context, tinterTheme, child) {
                              return SvgPicture.asset(
                              'assets/profile/topProfile.svg',
                              color: tinterTheme.colors.primary,
                              fit: BoxFit.fill,
                            );
                          }
                        ),
                      ),
                      Positioned.fill(
                        child: Center(
                          child: Consumer<TinterTheme>(
                              builder: (context, tinterTheme, child) {
                                return Text(
                                'Options',
                                style: tinterTheme.textStyle.headline1,
                              );
                            }
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Consumer<TinterTheme>(
                              builder: (context, tinterTheme, child) {
                                return Icon(
                                Icons.arrow_back,
                                size: 24,
                                color: tinterTheme.colors.primaryAccent,
                              );
                            }
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: fractions['separator'] * constraints.maxHeight,
                ),
                Consumer<TinterTheme>(
                    builder: (context, tinterTheme, child) {
                      return informationRectangle(
                      height: fractions['options'] * constraints.maxHeight,
                      width: 0.7 * constraints.maxWidth,
                      color: tinterTheme.colors.primary,
                      child: child,
                    );
                  },
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment(0, 0.05),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.pop(context);
                            BlocProvider.of<UserBloc>(context).add(DeleteUserAccountEvent());
                          },
                          child: informationRectangle(
                            width: constraints.maxWidth * 0.4,
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Consumer<TinterTheme>(
                                builder: (context, tinterTheme, child) {
                                  return Text(
                                  'Supprimer\nmon profil',
                                  textAlign: TextAlign.center,
                                  style: tinterTheme.textStyle.options,
                                );
                              }
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment(0, 0.8),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            Navigator.pop(context);
                            BlocProvider.of<AuthenticationBloc>(context)
                                .add(AuthenticationLoggedOutEvent());
                          },
                          child: informationRectangle(
                            width: constraints.maxWidth * 0.4,
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Consumer<TinterTheme>(
                                builder: (context, tinterTheme, child) {
                                  return Text(
                                  'Déconnexion',
                                  textAlign: TextAlign.center,
                                  style: tinterTheme.textStyle.options,
                                );
                              }
                            ),
                          ),
                        ),
                      ),
                      AnimatedAlign(
                        duration: duration,
                        alignment: Alignment(0, -0.8),
                        child: InkWell(
                          onTap: () => setState(() {
                            if (informationsLegalesSelected) {
                              _controller.reverse();
                            } else {
                              _controller.forward();
                            }
                            informationsLegalesSelected = !informationsLegalesSelected;
                          }),
                          child: informationRectangle(
                            width:
                            informationsLegalesSelected ? 500 : constraints.maxWidth * 0.4,
                            height: informationsLegalesSelected ? 500 : 75,
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                          ),
                        ),
                      ),
                      AnimatedAlign(
                        duration: duration,
                        alignment: Alignment(0, -0.8),
                        child: InkWell(
                          onTap: () => setState(() {
                            if (informationsLegalesSelected) {
                              _controller.reverse();
                            } else {
                              _controller.forward();
                            }
                            informationsLegalesSelected = !informationsLegalesSelected;
                          }),
                          child: informationRectangle(
                            width: constraints.maxWidth * 0.4,
                            height: informationsLegalesSelected ? 75.0 + 30.0 : 75.0,
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Consumer<TinterTheme>(
                                builder: (context, tinterTheme, child) {
                                  return AutoSizeText(
                                  'Informations\nlégales',
                                  textAlign: TextAlign.center,
                                  style: tinterTheme.textStyle.options.copyWith(
                                    fontSize: tinterTheme.textStyle.options.fontSize +
                                        10 * _animation.value,
                                  ),
                                );
                              }
                            ),
                          ),
                        ),
                      ),
                      AnimatedAlign(
                        duration: duration,
                        alignment: Alignment(0, 1),
                        child: AnimatedOpacity(
                          opacity: informationsLegalesSelected ? 1 : 0,
                          duration: duration,
                          child: InkWell(
                            onTap: () => setState(() {
                              if (informationsLegalesSelected) {
                                _controller.reverse();
                              } else {
                                _controller.forward();
                              }
                              informationsLegalesSelected = !informationsLegalesSelected;
                            }),
                            child: AnimatedContainer(
                              duration: duration,
                              height:
                              informationsLegalesSelected ? constraints.maxHeight * 0.3 : 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Align(
                                  alignment: Alignment(0, -0.5),
                                  child: SingleChildScrollView(
                                    child: AutoSizeText(
                                      "Hébergeur de l'application :\n"
                                          "Télécom SudParis\n"
                                          "9 rue Charles Fourier\n"
                                          "91011 Evry Cedex\n"
                                          "Tel.: + 33 1 60 76 40 40\n"
                                          "lucas.delsol@telecom-sudparis.eu\n"
                                          "SIRET 180 092 025 00055 - APE 8542Z",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 18),
                                      maxLines: 7,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
//              SizedBox(
//                height: fractions['separator'] * constraints.maxHeight,
//              ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    height: (fractions['logo'] + fractions['separator']) * constraints.maxHeight,
                    width: double.maxFinite,
                    child: FlareActor(
                      'assets/splash_screen/tinter_logo_splash_screen.flr',
                      controller: SplashScreenFlareController(),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 5),
                  child: Consumer<TinterTheme>(
                      builder: (context, tinterTheme, child) {
                        return AutoSizeText(
                        'Developpé par Lucas Delsol',
                        style: tinterTheme.textStyle.developedBy,
                      );
                    }
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget informationRectangle({
    Widget child,
    double width,
    double height,
    EdgeInsets padding,
    Color color,
  }) {
    return Consumer<TinterTheme>(
        builder: (context, tinterTheme, child) {
          return AnimatedContainer(
          duration: duration,
          padding: padding ?? EdgeInsets.all(0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            color: color ?? tinterTheme.colors.primaryAccent,
          ),
          width: width,
          height: height,
          child: child,
        );
      },
      child: child,
    );
  }
}
