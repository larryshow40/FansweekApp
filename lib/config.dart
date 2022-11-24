import 'package:flutter/material.dart';

class Config {
  //API server url
  // static const String API_SERVER_URL    = "https://onno.demo.spagreen.net/api";
  // static const String API_SERVER_URL = "http://www.fansweek.com/api/v10";
  static const String API_SERVER_URL = "https://fansweek.com/api";
  //API key
  // static const String API_KEY           = "Yu%(iz3x8tt@U9!FuppgUJjwYdJI04G5";
  static const String API_KEY = "DyXStdqO5dx4&ed35!0pCV83EJqtAx3x";
  // OneSignal App ID
  static const String ONE_SIGNAL_APP_ID =
      "aebb5e8f-7915-44aa-b1d6-badfc190803a";

  static final bool defaultDarkTheme = true;
  static final bool enableGoogleLogin = true;
  static final bool enablePhoneLogin = true;
  static final bool enableFacebookLogin = false;
  static final bool enableAppleLogin = true;
  //supported language list
  static var supportedLanguageList = [
    Locale("en", "US"),
    Locale("bn", "BD"),
    Locale("ar", "SA"),
    Locale("hi", "IN"),
  ];

  //country picker
  static final String selectedCountryCode = "+880";
  static final String initialCountrySelection = "BD";
  static const List<String> favouriteCountryCode = ['+880', 'BD'];
}
