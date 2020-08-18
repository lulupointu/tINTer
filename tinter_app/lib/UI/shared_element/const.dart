import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class TinterColors {
  static const background = Color(0xFF121212);
  static const secondaryAccent = Color(0xFFBF134E);
  static const white = Color(0xFFE8E8E8);
  static const primary = Color(0xFF4B63B3);
  static const primaryLight = Color(0xFF5C7CE6);
  static const primaryAccent = Color(0xFF51BF98);
  static const sliders = Color(0xFFFFCF33);
  static const hint = Color(0xFFFFCF33);
  static const discoverGradientGrey = Color(0xFF353535);
  static const grey = Color(0xFF353535);
}

class TinterSliderTheme {
  static const double trackHeight = 8;
  static const RoundSliderThumbShape thumbShape = RoundSliderThumbShape(
    enabledThumbRadius: 12,);
  static const SliderThemeData enabled = SliderThemeData(
    trackHeight: trackHeight,
    thumbShape: thumbShape,
    thumbColor: TinterColors.primaryAccent,
    activeTrackColor: TinterColors.sliders,
    inactiveTrackColor: TinterColors.sliders,
  );
  static const SliderThemeData disabled = SliderThemeData(
    trackHeight: trackHeight,
    thumbShape: thumbShape,
    disabledThumbColor: TinterColors.primaryAccent,
    disabledActiveTrackColor: TinterColors.sliders,
    disabledInactiveTrackColor: TinterColors.sliders,
    trackShape: const NoPaddingTrackShape(),
  );
}

class NoPaddingTrackShape extends RoundedRectSliderTrackShape {

  const NoPaddingTrackShape();

  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width - 5;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}


class TinterTextStyle {
  static const BottomNavigationBarTextStyle = TextStyle(
    color: TinterColors.white,
    fontFamily: 'Roboto',
    fontSize: 18,
    letterSpacing: 6,
  );
  static const headline1 = TextStyle(
    fontSize: 30,
    color: TinterColors.white,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );
  static const headline2 = TextStyle(
    fontSize: 20,
    color: TinterColors.white,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );
  static const hint = TextStyle(
      fontSize: 14,
      color: TinterColors.hint,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );
  static const smallLabel = TextStyle(
      fontSize: 12,
      color: Colors.black,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );
  static const bigLabel = TextStyle(
      fontSize: 14,
      color: Colors.black,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );
  static const goutMusicauxLiked = TextStyle(
    fontSize: 16,
    color: Colors.black,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );
  static const goutMusicauxNotLiked = TextStyle(
    fontSize: 16,
    color: Color.fromARGB(255, 180, 180, 180),
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );
  static const options = TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );
  static const dialogTitle = TextStyle(
    fontSize: 25,
    color: Colors.black,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );
  static const dialogContent = TextStyle(
    fontSize: 18,
    color: Colors.black54,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );

  static const developedBy = TextStyle(
    fontSize: 15,
    color: TinterColors.white,
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w400,
  );

  // Login element
  static const loginFormLabel = TextStyle(
      fontSize: 19,
      color: TinterColors.white,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400
  );

  static const loginFormButton = TextStyle(
      fontSize: 19,
      color: TinterColors.white,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w300
  );

  static const loginError = TextStyle(
    fontSize: 15,
    color: TinterColors.white,
  );
}



Map<double,Map<String, Object>> shake = {
0: { 'transform': Offset(1, 1) , 'rotate': 0/360*2*math.pi, },
0.10: { 'transform': Offset(-1, -2) , 'rotate': -1/360*2*math.pi, },
0.20: { 'transform': Offset(-3, 0) , 'rotate': 1/360*2*math.pi, },
0.30: { 'transform': Offset(3, 2) , 'rotate': 0/360*2*math.pi, },
0.40: { 'transform': Offset(1, -1) , 'rotate': 1/360*2*math.pi, },
0.50: { 'transform': Offset(-1, 2) , 'rotate': -1/360*2*math.pi, },
0.60: { 'transform': Offset(-3, 1) , 'rotate': 0/360*2*math.pi, },
0.70: { 'transform': Offset(3, 1) , 'rotate': -1/360*2*math.pi, },
0.80: { 'transform': Offset(-1, -1) , 'rotate': 1/360*2*math.pi, },
0.90: { 'transform': Offset(1, 2) , 'rotate': 0/360*2*math.pi, },
1: { 'transform': Offset(1, -2) , 'rotate': -1/360*2*math.pi, },
};