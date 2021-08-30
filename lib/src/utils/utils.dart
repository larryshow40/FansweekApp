import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static bool _isDark = DatabaseConfig().getThemeIsDark();

  static void showToastMessage({required String message}) {
    Fluttertoast.showToast(
        msg: message,
        textColor: Utils.getTextColor(),
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1);
  }

  static void showSnackBar(
      {required BuildContext context,
      required String message,
      bool isSuccess = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ));
  }

  static void launchUrl(String url) async {
    printLog("url:${url}");
    await canLaunch(url) ? await launch(url) : throw "Could not launch: $url";
  }

  static Color getBackgroundColor({required bool isDark}) {
    return isDark
        ? AppThemeData.darkBackgroundColor
        : AppThemeData.lightBackgroundColor;
  }

  Color getCardBackgroundColor(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return isDark
        ? AppThemeData.cardBackgroundColorDark.withOpacity(0.7)
        : AppThemeData.cardBackgroundColorLight;
  }

  static Color getTextColor([bool? isDark]) {
    bool darkValue = isDark ?? _isDark;
    return darkValue ? AppThemeData.textColorDark : AppThemeData.textColorLight;
  }

}
