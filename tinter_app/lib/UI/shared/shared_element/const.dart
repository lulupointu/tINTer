import 'dart:ui';
import 'package:flutter/material.dart';

enum MyTheme { light, dark }

class TinterTheme extends ChangeNotifier {
  MyTheme _theme = MyTheme.dark;

  get theme => _theme;

  set theme(MyTheme newTheme) {
    if (newTheme != _theme) {
      _theme = newTheme;
      notifyListeners();
    }
  }

  TinterColors colors;
  TinterTextStyle textStyle;
  TinterSliderTheme slider;

  TinterTheme() {
    colors = TinterColors(theme: this);
    textStyle = TinterTextStyle(theme: this);
    slider = TinterSliderTheme(theme: this);
  }
}

class TinterTabs extends ChangeNotifier {
  // final List<TinterTab> tabsAssociatif = [MatchsTab(), DiscoverAssociatifTab(), UserTab()];
  // final List<TinterTab> tabsScolaire = [BinomesTab(), DiscoverScolaireTab(), UserTab()];

  BuildContext context;

  TinterTabs();

  int _selectedTabIndex = 2;

  int get selectedTabIndex => _selectedTabIndex;

  set selectedTabIndex(int newSelectedTabIndex) {
    _selectedTabIndex = newSelectedTabIndex;
    notifyListeners();
  }

  // TinterTab selectedTab({@required MyTheme theme}) =>
}

abstract class TinterTab extends Widget {}

class TinterDarkThemeColors {
  static const Color background = Color(0xFF12121E);
  static const Color primary = Color(0xFF415599);
  static const Color secondary = Color(0xFFFA3C3C);
  static const Color primaryAccent = Color(0xFFFED766);
  static const Color secondaryAccent = Color(0xFFE1E1E1);
  static const Color defaultTextColor = Color(0xFFE8E8E8);
  static const Color bottomSheet = Color(0xFF2a2a45);
  static const Color button = Color(0xFFE1E1E1);
}

class TinterLightThemeColors {
  static const Color background = Color(0xFFF4F4F8);
  static const Color primary = Color(0xFF2AB7CA);
  static const Color secondary = Color(0xFFFE4A49);
  static const Color primaryAccent = Color(0xFFFED766);
  static const Color secondaryAccent = Color(0xFFE6E6EA);
  static const Color defaultTextColor = Color(0xFF000000);
  static const Color bottomSheet = Color(0xFFFFFFFF);
  static const Color button = Color(0xFFE1E1E1);
}

class TinterColors {
  TinterTheme theme;

  TinterColors({@required this.theme});

  Color get background => theme.theme == MyTheme.dark
      ? TinterDarkThemeColors.background
      : TinterLightThemeColors.background;

  Color get primary =>
      theme.theme == MyTheme.dark ? TinterDarkThemeColors.primary : TinterLightThemeColors.primary;

  Color get secondary => theme.theme == MyTheme.dark
      ? TinterDarkThemeColors.secondary
      : TinterLightThemeColors.secondary;

  Color get primaryAccent => theme.theme == MyTheme.dark
      ? TinterDarkThemeColors.primaryAccent
      : TinterLightThemeColors.primaryAccent;

  Color get secondaryAccent => theme.theme == MyTheme.dark
      ? TinterDarkThemeColors.secondaryAccent
      : TinterLightThemeColors.secondaryAccent;

  Color get defaultTextColor => theme.theme == MyTheme.dark
      ? TinterDarkThemeColors.defaultTextColor
      : TinterLightThemeColors.defaultTextColor;

  Color get bottomSheet => theme.theme == MyTheme.dark
      ? TinterDarkThemeColors.bottomSheet
      : TinterLightThemeColors.bottomSheet;

  Color get button =>
      theme.theme == MyTheme.dark ? TinterDarkThemeColors.button : TinterLightThemeColors.button;
}

class TinterSliderTheme {
  static const double trackHeight = 8;
  static const RoundSliderThumbShape thumbShape = RoundSliderThumbShape(
    enabledThumbRadius: 12,
  );

  final TinterTheme theme;

  TinterSliderTheme({@required this.theme});

  SliderThemeData get enabled => SliderThemeData(
        trackHeight: trackHeight,
        thumbShape: thumbShape,
        thumbColor: theme.colors.secondaryAccent,
        activeTrackColor: theme.colors.primaryAccent,
        inactiveTrackColor: theme.colors.primaryAccent,
      );

  SliderThemeData get disabled => SliderThemeData(
        trackHeight: trackHeight,
        thumbShape: thumbShape,
        disabledThumbColor: theme.colors.secondaryAccent,
        disabledActiveTrackColor: theme.colors.primaryAccent,
        disabledInactiveTrackColor: theme.colors.primaryAccent,
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
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class TinterTextStyle {
  final TinterTheme theme;

  TinterTextStyle({@required this.theme});

  TextStyle get bottomNavigationBarTextStyle => TextStyle(
        color: theme.colors.background,
        fontFamily: 'Roboto',
        fontSize: 18,
        letterSpacing: 6,
      );

  TextStyle get headline1 => TextStyle(
        fontSize: 30,
        color: theme.colors.defaultTextColor,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
      );

  TextStyle get headline2 => TextStyle(
        fontSize: 20,
        color: theme.colors.defaultTextColor,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
      );

  TextStyle get hint => TextStyle(
        fontSize: 14,
        color: theme.colors.primaryAccent,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
      );

  TextStyle get hintLarge => TextStyle(
        fontSize: 17,
        color: Colors.black,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
      );

  TextStyle get smallLabel => TextStyle(
        fontSize: 12,
        color: Colors.black,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
      );

  TextStyle get bigLabel => TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
      );

  TextStyle get chipLiked => TextStyle(
        fontSize: 16,
        color: Colors.black,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
      );

  TextStyle get chipNotLiked => TextStyle(
        fontSize: 16,
        color: Color.fromARGB(255, 180, 180, 180),
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
      );

  TextStyle get options => TextStyle(
        fontSize: 18,
        color: Colors.black,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
      );

  TextStyle get dialogTitle => TextStyle(
        fontSize: 25,
        color: Colors.black,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
      );

  TextStyle get dialogContent => TextStyle(
        fontSize: 18,
        color: Colors.black54,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
      );

  TextStyle get hidingText => TextStyle(
        fontSize: 18,
        color: theme.colors.defaultTextColor,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
      );

  TextStyle get developedBy => TextStyle(
        fontSize: 15,
        color: theme.colors.defaultTextColor,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.w400,
      );

  // Login element
  TextStyle get loginFormLabel => TextStyle(
      fontSize: 19,
      color: theme.colors.defaultTextColor,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400);

  TextStyle get loginFormButton => TextStyle(
      fontSize: 19,
      color: theme.colors.defaultTextColor,
      fontFamily: 'Roboto',
      fontWeight: FontWeight.w400);

  TextStyle get loginError => TextStyle(
        fontSize: 15,
        color: theme.colors.defaultTextColor,
      );
}
