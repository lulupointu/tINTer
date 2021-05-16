import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:tinterapp/UI/shared/shared_element/const.dart';

class CustomBottomNavigationBar2 extends StatefulWidget {
  final ValueChanged<int> onTap;
  final int selectedIndex;
  final GlobalKey discoverIconKey;

  CustomBottomNavigationBar2({@required this.onTap, @required this.selectedIndex, this.discoverIconKey});

  @override
  _CustomBottomNavigationBar2State createState() => _CustomBottomNavigationBar2State();
}

class _CustomBottomNavigationBar2State extends State<CustomBottomNavigationBar2> {
  var selection = [0, 0, 1]; // Match, Discover, Profile
  Duration duration = Duration(milliseconds: 300);
  Curve curve = Curves.easeIn;

  /// Fractions describe how much of a width space each element is taking.
  /// Note that those do not appear because they are computed:
  ///     1) Spacing between element
  ///     2) Position of the text
  Map<String, double> fractions = {
    'match': 0.061,
    'discover': 0.042,
    'profile': 0.052,
    'selectedRectangle': 0.43, //0.53, // The rectangle which appears under the selected icon.
    'spaceBeforeIconInRectangle': 0.046,
    'spacingBetweenIcons': 0,
  };

  double selectedRectangleHeight = 40;

  @override
  Widget build(BuildContext context) {
    selection = [0, 0, 0];
    selection[widget.selectedIndex] = 1;

    fractions['spacingBetweenIcons'] = (1 -
        ((1 - selection[0]) * fractions['match'] +
            (1 - selection[1]) * fractions['discover'] +
            (1 - selection[2]) * fractions['profile'] +
            fractions['selectedRectangle'])) /
        4; // /4 because there are 4 spaces.

    return Consumer<TinterTheme>(
      builder: (context, tinterTheme, child) {
        return TweenAnimationBuilder(
          duration: Duration(milliseconds: 500),
          tween: ColorTween(begin: tinterTheme.colors.background, end: tinterTheme.colors.background),
          builder: (context, animatedColor, child) {
            return Container(
              height: 60,
              color: animatedColor,
              child: child,
            );
          },
          child: child  ,
        );
      },
      child: Center(
        child: Container(
          height: selectedRectangleHeight,
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: <Widget>[
                  ...drawMatch(constraints.maxWidth),
                  ...drawDiscover(constraints.maxWidth),
                  ...drawProfile(constraints.maxWidth),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  List<Widget> drawMatch(double parentWidth) {
    return [
      // Background rectangle
      AnimatedPositioned(
        duration: duration,
        curve: curve,
        left: parentWidth * fractions['spacingBetweenIcons'],
        height: selectedRectangleHeight,
        child: AnimatedOpacity(
          duration: duration,
          curve: curve,
          opacity: selection[0].toDouble(),
          child: Consumer<TinterTheme>(
              builder: (context, tinterTheme, child) {
                return AnimatedContainer(
                  duration: duration,
                  curve: curve,
                  decoration: BoxDecoration(
                    color: tinterTheme.colors.secondary,
                    borderRadius: BorderRadius.all(Radius.circular(60.0)),
                  ),
                  width: parentWidth * fractions['selectedRectangle'] * selection[0],
                );
              }
          ),
        ),
      ),

      // Imaginary rectangle in which the match text is in the center
      AnimatedPositioned(
        duration: duration,
        curve: curve,
        left: parentWidth *
            (fractions['spacingBetweenIcons'] +
                selection[0] *
                    (fractions['spaceBeforeIconInRectangle'] + fractions['match'])) +
            5,
        // 5 is for padding
        height: selectedRectangleHeight,
        child: AnimatedContainer(
          duration: duration,
          curve: curve,
          color: Colors.transparent,
          width: parentWidth *
              (fractions['selectedRectangle'] -
                  (fractions['match'] + fractions['spaceBeforeIconInRectangle'])) -
              10,
          // 10 is for padding
          child: AnimatedOpacity(
            duration: duration,
            curve: curve,
            opacity: selection[0].toDouble(),
            child: Center(
              child: Consumer<TinterTheme>(
                  builder: (context, tinterTheme, child) {
                    return TweenAnimationBuilder(
                        duration: Duration(milliseconds: 500),
                        tween: ColorTween(begin: tinterTheme.textStyle.bottomNavigationBarTextStyle.color, end: tinterTheme.textStyle.bottomNavigationBarTextStyle.color),
                        builder: (context, animatedColor, child) {
                          return AutoSizeText(
                            "Matches",
                            textAlign: TextAlign.center,
                            maxFontSize: 18,
                            style: tinterTheme.textStyle.bottomNavigationBarTextStyle.copyWith(color: animatedColor),
                            maxLines: 1,
                          );
                        }
                    );
                  }
              ),
            ),
          ),
        ),
      ),

      // match Icon
      AnimatedPositioned(
        duration: duration,
        curve: curve,
        left: parentWidth *
            (fractions['spacingBetweenIcons'] +
                selection[0] * fractions['spaceBeforeIconInRectangle']),
        height: selectedRectangleHeight,
        child: Center(
          child: Container(
            child: Consumer<TinterTheme>(
                builder: (context, tinterTheme, child) {
                  return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 500),
                      tween: ColorTween(begin: selection[0] == 0 ? tinterTheme.colors.secondary : tinterTheme.colors.background, end: selection[0] == 0 ? tinterTheme.colors.secondary : tinterTheme.colors.background),
                      builder: (context, animatedColor, child) {
                        return SvgPicture.asset(
                          'assets/icons/match.svg',
                          width: fractions['match'] * parentWidth,
                          color: animatedColor,
                        );
                      }
                  );
                }
            ),
          ),
        ),
      ),

      // match InkWell
      AnimatedPositioned(
        duration: duration,
        curve: curve,
        left: parentWidth *
            (fractions['spacingBetweenIcons'] +
                selection[0] * fractions['spaceBeforeIconInRectangle']) -
            20,
        top: -10,
        height: selectedRectangleHeight + 20,
        child: Center(
          child: InkWell(
            onTap: () {
              widget.onTap(0);
              setState(() {
                selection[0] = 1;
                selection[1] = 0;
                selection[2] = 0;
              });
            },
            child: Container(
              padding: EdgeInsets.all(100.0),
              width: fractions['match'] * parentWidth + 40,
              height: fractions['match'] * parentWidth + 20,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> drawDiscover(double parentWidth) {
    return [
      // Background rectangle
      AnimatedPositioned(
        duration: duration,
        curve: curve,
        left: parentWidth *
            (2 * fractions['spacingBetweenIcons'] +
                selection[0] * fractions['selectedRectangle'] +
                (1 - selection[0]) * fractions['match']),
        height: selectedRectangleHeight,
        child: AnimatedOpacity(
          duration: duration,
          curve: curve,
          opacity: selection[1].toDouble(),
          child: Consumer<TinterTheme>(
              builder: (context, tinterTheme, child) {
                return AnimatedContainer(
                  duration: duration,
                  curve: curve,
                  decoration: BoxDecoration(
                    color: tinterTheme.colors.secondary,
                    borderRadius: BorderRadius.all(Radius.circular(60.0)),
                  ),
                  width: parentWidth * fractions['selectedRectangle'] * selection[1],
                );
              }
          ),
        ),
      ),

      // Imaginary rectangle in which the match text is in the center
      AnimatedPositioned(
        duration: duration,
        curve: curve,
        left: parentWidth *
            (2 * fractions['spacingBetweenIcons'] +
                selection[0] * fractions['selectedRectangle'] +
                (1 - selection[0]) * fractions['match'] +
                selection[1] *
                    (fractions['spaceBeforeIconInRectangle'] + fractions['discover'])) +
            5,
        // 5 is for padding
        height: selectedRectangleHeight,
        child: AnimatedContainer(
          duration: duration,
          curve: curve,
          color: Colors.transparent,
          width: parentWidth *
              (fractions['selectedRectangle'] -
                  (fractions['discover'] + fractions['spaceBeforeIconInRectangle'])) -
              10,
          // 10 is for padding
          child: AnimatedOpacity(
            duration: duration,
            curve: curve,
            opacity: selection[1].toDouble(),
            child: Center(
              child: Consumer<TinterTheme>(
                  builder: (context, tinterTheme, child) {
                    return TweenAnimationBuilder(
                        duration: Duration(milliseconds: 500),
                        tween: ColorTween(begin: tinterTheme.textStyle.bottomNavigationBarTextStyle.color, end: tinterTheme.textStyle.bottomNavigationBarTextStyle.color),
                        builder: (context, animatedColor, child) {
                          return AutoSizeText(
                            "Discover",
                            textAlign: TextAlign.center,
                            maxFontSize: 18,
                            style: tinterTheme.textStyle.bottomNavigationBarTextStyle.copyWith(color: animatedColor),
                            maxLines: 1,
                          );
                        }
                    );
                  }
              ),
            ),
          ),
        ),
      ),

      // discover Icon
      AnimatedPositioned(
        key: widget.discoverIconKey,
        duration: duration,
        curve: curve,
        left: parentWidth *
            (2 * fractions['spacingBetweenIcons'] +
                selection[0] * fractions['selectedRectangle'] +
                (1 - selection[0]) * fractions['match'] +
                selection[1] * (fractions['spaceBeforeIconInRectangle'])),
        height: selectedRectangleHeight,
        child: Center(
          child: Consumer<TinterTheme>(
              builder: (context, tinterTheme, child) {
                return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 500),
                    tween: ColorTween(begin: selection[1] == 0 ? tinterTheme.colors.secondary : tinterTheme.colors.background, end: selection[1] == 0 ? tinterTheme.colors.secondary : tinterTheme.colors.background),
                    builder: (context, animatedColor, child) {
                      return SvgPicture.asset(
                        'assets/icons/discover.svg',
                        width: fractions['discover'] * parentWidth,
                        color: animatedColor,
                      );
                    }
                );
              }
          ),
        ),
      ),

      // discover Inkwell
      AnimatedPositioned(
        duration: duration,
        curve: curve,
        left: parentWidth *
            (2 * fractions['spacingBetweenIcons'] +
                selection[0] * fractions['selectedRectangle'] +
                (1 - selection[0]) * fractions['match'] +
                selection[1] * (fractions['spaceBeforeIconInRectangle'])) -
            20,
        top: -10,
        height: selectedRectangleHeight + 20,
        child: Center(
          child: InkWell(
            onTap: () {
              widget.onTap(1);
              setState(() {
                selection[0] = 0;
                selection[1] = 1;
                selection[2] = 0;
              });
            },
            child: Container(
              width: fractions['discover'] * parentWidth + 40,
              height: fractions['discover'] * parentWidth + 20,
            ),
          ),
        ),
      ),
    ];
  }

  List<Widget> drawProfile(double parentWidth) {
    return [
      // Background rectangle
      AnimatedPositioned(
        duration: duration,
        curve: curve,
        left: parentWidth *
            (3 * fractions['spacingBetweenIcons'] +
                (1 - selection[0]) * fractions['match'] +
                (1 - selection[1]) * fractions['discover'] +
                (1 - selection[2]) * fractions['selectedRectangle']),
        height: selectedRectangleHeight,
        child: AnimatedOpacity(
          duration: duration,
          curve: curve,
          opacity: selection[2].toDouble(),
          child: Consumer<TinterTheme>(
              builder: (context, tinterTheme, child) {
                return AnimatedContainer(
                  duration: duration,
                  curve: curve,
                  decoration: BoxDecoration(
                    color: tinterTheme.colors.secondary,
                    borderRadius: BorderRadius.all(Radius.circular(60.0)),
                  ),
                  width: parentWidth * fractions['selectedRectangle'] * selection[2],
                );
              }
          ),
        ),
      ),

      // Imaginary rectangle in which the match text is in the center
      AnimatedPositioned(
        duration: duration,
        curve: curve,
        left: parentWidth *
            (3 * fractions['spacingBetweenIcons'] +
                (1 - selection[0]) * fractions['match'] +
                (1 - selection[1]) * fractions['discover'] +
                (1 - selection[2]) * fractions['selectedRectangle'] +
                selection[2] *
                    (fractions['spaceBeforeIconInRectangle'] + fractions['profile'])) +
            5,
        // 5 is for padding
        height: selectedRectangleHeight,
        child: AnimatedContainer(
          duration: duration,
          curve: curve,
          color: Colors.transparent,
          width: parentWidth *
              (fractions['selectedRectangle'] -
                  (fractions['profile'] + fractions['spaceBeforeIconInRectangle'])) -
              10,
          // 10 is for padding
          child: AnimatedOpacity(
            duration: duration,
            curve: curve,
            opacity: selection[2].toDouble(),
            child: Center(
              child: Consumer<TinterTheme>(
                  builder: (context, tinterTheme, child) {
                    return TweenAnimationBuilder(
                        duration: Duration(milliseconds: 500),
                        tween: ColorTween(begin: tinterTheme.textStyle.bottomNavigationBarTextStyle.color, end: tinterTheme.textStyle.bottomNavigationBarTextStyle.color),
                        builder: (context, animatedColor, child) {
                          return AutoSizeText(
                            "Profile",
                            textAlign: TextAlign.center,
                            maxFontSize: 18,
                            style: tinterTheme.textStyle.bottomNavigationBarTextStyle.copyWith(color: animatedColor),
                            maxLines: 1,
                          );
                        }
                    );
                  }
              ),
            ),
          ),
        ),
      ),

      // profile Icon
      AnimatedPositioned(
        duration: duration,
        curve: curve,
        left: parentWidth *
            (3 * fractions['spacingBetweenIcons'] +
                (1 - selection[0]) * fractions['match'] +
                (1 - selection[1]) * fractions['discover'] +
                (1 - selection[2]) * fractions['selectedRectangle'] +
                selection[2] * (fractions['spaceBeforeIconInRectangle'])),
        height: selectedRectangleHeight,
        child: Center(
          child: Consumer<TinterTheme>(
              builder: (context, tinterTheme, child) {
                return TweenAnimationBuilder(
                    duration: Duration(milliseconds: 500),
                    tween: ColorTween(begin: selection[2] == 0 ? tinterTheme.colors.secondary : tinterTheme.colors.background, end: selection[2] == 0 ? tinterTheme.colors.secondary : tinterTheme.colors.background),
                    builder: (context, animatedColor, child) {
                      return SvgPicture.asset(
                        'assets/icons/profile.svg',
                        width: fractions['profile'] * parentWidth,
                        color: animatedColor,
                      );
                    }
                );
              }
          ),
        ),
      ),

      // profile Inkwell
      AnimatedPositioned(
        duration: duration,
        curve: curve,
        left: parentWidth *
            (3 * fractions['spacingBetweenIcons'] +
                (1 - selection[0]) * fractions['match'] +
                (1 - selection[1]) * fractions['discover'] +
                (1 - selection[2]) * fractions['selectedRectangle'] +
                selection[2] * (fractions['spaceBeforeIconInRectangle'])) -
            20,
        top: -10,
        height: selectedRectangleHeight + 20,
        child: Center(
          child: InkWell(
            onTap: () {
              widget.onTap(2);
              setState(() {
                selection[0] = 0;
                selection[1] = 0;
                selection[2] = 1;
              });
            },
            child: Container(
              width: fractions['profile'] * parentWidth + 40,
              height: fractions['profile'] * parentWidth + 20,
            ),
          ),
        ),
      ),
    ];
  }
}
