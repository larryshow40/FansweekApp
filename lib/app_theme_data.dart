import 'package:flutter/material.dart';

class AppThemeData {
  //color configuration
  // static final Color darkBackgroundColor = Color(0xff13112A);
  static final Color darkBackgroundColor = Colors.black;
  static final Color lightBackgroundColor = Color(0xffffffff);
  // static final Color darkToggleColor = Color(0xffACBBDF);
  static final Color darkToggleColor = Colors.black;
  static final Color darkSwitchColor = Color(0xff1F1C34);
  static final Color lightSwitchColor = Color(0xFFDBDBDB);
  static final Color progressIndicatorColor = Colors.red;
  static final Color darkBackgroundBottomNavColor = Colors.black;
  // static final Color darkBackgroundBottomNavColor = Color(0xFF1F1C34);

  //statusbar_color
  static final Color statusBarLight = Colors.white;
  static final Color statusBarDark = Colors.black;

  //Font size
  static final double smallTextSize = 12.0;
  static final double normalTextSize = 16.0;
  static final double mediumTextSize = 18.0;
  static final double largeTextSize = 22.0;
  static final double extraLargeTextSize = 24.0;
  //text color
  static final textColorDark = const Color(0xFFD3DDF6);
  static final textColorLight = const Color(0xFF000000);
  //intro btn color
  static final introBtnColorDark = const Color(0xff1F1C34);
  static final introBtnColorlight = const Color(0x605C5E61);
  //divider color
  // static final dividerColorDark = const Color(0xFF99A5C5);
  static final dividerColorDark = const Color(0xFF99A5C5);
  static final dividerColorLight = const Color(0xFFDBDBDB);
  //category color
  // static final categoryColorDark = const Color(0xFF99A5C5);
  static final categoryColorDark = const Color(0xFF99A5C5);
  static final categoryColorLight = const Color(0x70111029);
  //socialIcon color
  static final socialIconColorDark = const Color(0xFF99A5C5);
  static final socialIconColorLight = const Color(0xFF111029);
  //card background color
  // static final cardBackgroundColorDark = Color(0xff1F1C34);
  static final cardBackgroundColorDark = Colors.black;
  static final cardBackgroundColorLight = Colors.white;
  //padding
  static const double wholeScreenPadding = 8.0;
  static const double normalPadding = 8.0;
  //card border radius
  static const double cardBorderRadius = 8.0;
  static const double cardElevation = 2.0;
  static const double editTextBlurRadius = 2.0;
  static final shadowColor = Colors.grey.withOpacity(0.65);
  static final double newsCardHeight = 120.0;
}
