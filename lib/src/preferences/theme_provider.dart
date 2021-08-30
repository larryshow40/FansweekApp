import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/preferences/database_config.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode themeMode =
      DatabaseConfig().getThemeIsDark() ? ThemeMode.dark : ThemeMode.light;

  bool get isDarkMode {
    if (themeMode == ThemeMode.system) {
      final brightness = SchedulerBinding.instance!.window.platformBrightness;
      return brightness == Brightness.dark;
    } else {
      return themeMode == ThemeMode.dark;
    }
  }

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    DatabaseConfig().saveThemeMode(isOn);
    notifyListeners();
  }
}

class MyThemes {
  static final ThemeData baseDark = ThemeData.dark();
  static final darkTheme = baseDark.copyWith(
    textTheme: _darkTextTheme(baseDark.textTheme),
    primaryColor: AppThemeData.darkBackgroundColor,
    indicatorColor: AppThemeData.progressIndicatorColor,
    accentColor: Colors.grey,
    scaffoldBackgroundColor: AppThemeData.darkBackgroundColor,
    colorScheme: ColorScheme.dark(),
    cardTheme: CardTheme(color: AppThemeData.cardBackgroundColorDark),
    iconTheme: IconThemeData(color: AppThemeData.textColorDark.withOpacity(0.5)),
    appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: AppThemeData.textColorDark)),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    tabBarTheme: TabBarTheme(labelColor: Colors.amber, unselectedLabelColor: Colors.black,),
    //text  field cursor color
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppThemeData.textColorDark,
      selectionColor: AppThemeData.textColorDark,
      selectionHandleColor: AppThemeData.textColorDark,
    ),
  );
  static TextTheme _darkTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1!.copyWith(
        fontFamily: "Roboto",
        fontSize: AppThemeData.smallTextSize,
        color: AppThemeData.textColorDark,
        fontWeight: FontWeight.normal,
      ),
      headline2: base.headline2!.copyWith(
        fontFamily: "Roboto",
        fontSize: AppThemeData.normalTextSize,
        color: AppThemeData.textColorDark,
        fontWeight: FontWeight.normal,
      ),
      headline3: base.headline3!.copyWith(
        fontFamily: "Roboto",
        fontSize: AppThemeData.mediumTextSize,
        color: AppThemeData.textColorDark,
        fontWeight: FontWeight.normal,
      ),
      headline4: base.headline4!.copyWith(
        fontFamily: "Roboto",
        fontSize: AppThemeData.largeTextSize,
        color: AppThemeData.textColorDark,
        fontWeight: FontWeight.normal,
      ),
      headline5: base.headline5!.copyWith(
        fontFamily: "Roboto",
        fontSize: AppThemeData.extraLargeTextSize,
        color: AppThemeData.textColorDark,
        fontWeight: FontWeight.normal,
      ),
    );
  }

  //light theme
  static final ThemeData baseLight = ThemeData.light();
  static final lightTheme = baseLight.copyWith(
    textTheme: _lightTextTheme(baseLight.textTheme),
    indicatorColor: AppThemeData.progressIndicatorColor,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.white,
    accentColor: Colors.grey,
    colorScheme: ColorScheme.light(),
    cardTheme: CardTheme(color: AppThemeData.cardBackgroundColorLight),
    iconTheme: IconThemeData(color: AppThemeData.textColorLight.withOpacity(0.5)),
    appBarTheme: AppBarTheme(iconTheme: IconThemeData(color: AppThemeData.textColorLight,)),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    tabBarTheme: TabBarTheme(
      labelColor: Colors.amber,
      unselectedLabelColor: Colors.black,
    ),
    //text  field cursor color
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppThemeData.textColorLight,
      selectionColor: AppThemeData.textColorLight,
      selectionHandleColor: AppThemeData.textColorLight,
    ),
  );

  static TextTheme _lightTextTheme(TextTheme base) {
    return base.copyWith(
      headline1: base.headline1!.copyWith(
        fontFamily: "Roboto",
        fontSize: AppThemeData.smallTextSize,
        color: AppThemeData.textColorLight,
        fontWeight: FontWeight.normal,
      ),
      headline2: base.headline2!.copyWith(
        fontFamily: "Roboto",
        fontSize: AppThemeData.normalTextSize,
        color: AppThemeData.textColorLight,
        fontWeight: FontWeight.normal,
      ),
      headline3: base.headline3!.copyWith(
        fontFamily: "Roboto",
        fontSize: AppThemeData.mediumTextSize,
        color: AppThemeData.textColorLight,
        fontWeight: FontWeight.normal,
      ),
      headline4: base.headline4!.copyWith(
        fontFamily: "Roboto",
        fontSize: AppThemeData.largeTextSize,
        color: AppThemeData.textColorLight,
        fontWeight: FontWeight.normal,
      ),
      headline5: base.headline5!.copyWith(
        fontFamily: "Roboto",
        fontSize: AppThemeData.extraLargeTextSize,
        color: AppThemeData.textColorLight,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
