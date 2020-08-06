import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math';

import '../shared_element/slider_label.dart';
import '../shared_element/const.dart';
import '../../Logic/interface.dart';

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
    _controller =
        AnimationController(duration: duration, vsync: this);
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
    return Material(
      color: TinterColors.background,
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
                      child: SvgPicture.asset(
                        'assets/profile/topProfile.svg',
                        color: TinterColors.primaryLight,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned.fill(
                      child: Center(
                        child: Text(
                          'Options',
                          style: TinterTextStyle.headline1,
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional.topStart,
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          size: 24,
                          color: TinterColors.hint,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: fractions['separator'] * constraints.maxHeight,
              ),
              informationRectangle(
                height: fractions['options'] * constraints.maxHeight,
                width: 0.7 * constraints.maxWidth,
                color: TinterColors.grey,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment(0, 0.05),
                      child: informationRectangle(
                        width: constraints.maxWidth * 0.4,
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          'Supprimer\nmon profil',
                          textAlign: TextAlign.center,
                          style: TinterTextStyle.options,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 0.8),
                      child: informationRectangle(
                        width: constraints.maxWidth * 0.4,
                        padding: EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          'Déconnexion',
                          textAlign: TextAlign.center,
                          style: TinterTextStyle.options,
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
                          width: informationsLegalesSelected ? 500 : constraints.maxWidth * 0.4,
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
                          child: Text(
                            'Informations\nlégales',
                            textAlign: TextAlign.center,
                            style: TinterTextStyle.options.copyWith(
                              fontSize: TinterTextStyle.options.fontSize + 10*_animation.value,
                            ),
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
                            child: SingleChildScrollView(
                              child: Text('Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n' +
                                  'Ce document présente les informations légales. \n'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: fractions['separator'] * constraints.maxHeight,
              ),
              Container(
                height: fractions['logo'] * constraints.maxHeight,
                width: double.maxFinite,
                child: SvgPicture.asset(
                  'assets/Icons/match.svg',
                  fit: BoxFit.fitHeight,
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget informationRectangle({
    @required Widget child,
    double width,
    double height,
    EdgeInsets padding,
    Color color,
  }) {
    return AnimatedContainer(
      duration: duration,
      padding: padding ?? EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: color ?? TinterColors.primaryAccent,
      ),
      width: width,
      height: height,
      child: child,
    );
  }
}
