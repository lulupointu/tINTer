import 'dart:ui';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class TinterColors {
  static const background = Color(0xFF121212);
  static const secondaryAccent = Color(0xFFBF134E);
  static const white = Color(0xFFE8E8E8);
  static const primary = Color(0xFF4B63B3);
  static const primaryAccent = Color(0xFF51BF98);
  static const sliders = Color(0xFFFFCF33);
  static const hint = Color(0xFFFFCF33);
  static const discoverGradientGrey = Color(0xFF353535);
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
  );
  static const headline2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: TinterColors.white,
  );
  static const hint = TextStyle(
      fontSize: 14,
      color: TinterColors.hint,
  );
  static const label = TextStyle(
      fontSize: 12,
      color: Colors.black
  );
  static const goutMusicaux = TextStyle(
      fontSize: 14,
      color: Colors.black
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