import 'dart:io';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onoo/config.dart';
import 'package:onoo/src/data/model/auth/onno_user.dart';
import 'package:onoo/src/data/model/config/config_model.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConfig {
  Future initHiveDatabase() async {
    Directory appDocDirectory = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocDirectory.path);
    await Hive.openBox(Constants.themeModeConstant);
    await Hive.openBox(Constants.userLoginStatusBoxName);
    await Hive.openBox("isFirstOpen");
    await Hive.openBox("languageCode");
    await Hive.openBox("language");
    await Hive.openBox("notification");
    //config data
    Hive.registerAdapter(ConfigDataAdapter());
    Hive.registerAdapter(DataAdapter());
    Hive.registerAdapter(AppConfigAdapter());
    Hive.registerAdapter(AppIntroAdapter());
    Hive.registerAdapter(IntroAdapter());
    Hive.registerAdapter(AdsConfigAdapter());
    Hive.registerAdapter(AndroidVersionInfoAdapter());
    Hive.registerAdapter(IosVersionInfoAdapter());
    Hive.registerAdapter(LanguagesAdapter());
    await Hive.openBox<ConfigData>(Constants.configDataBoxName);

    //user data
    Hive.registerAdapter(OnnoUserAdapter());
    await Hive.openBox<OnnoUser>(Constants.userDataBoxName);
  }

  saveThemeMode(bool theme) {
    var box = Hive.box(Constants.themeModeConstant);
    box.put(Constants.themeModeConstant, theme);
    print("DataBase input: $theme");
  }

  bool getThemeIsDark() {
    var box = Hive.box(Constants.themeModeConstant);
    bool? value = box.get(Constants.themeModeConstant);
    //if value is not null then check value is dark or not. if dark return true else false
    // if value is null then check config data is true or false
    bool? isDark = value != null ? value : Config.defaultDarkTheme;
    return isDark;
  }

  saveConfigData(ConfigData configData) {
    Box<ConfigData> configBox =
        Hive.box<ConfigData>(Constants.configDataBoxName);
    configBox.put(Constants.configDataBoxName, configData);
  }

  ConfigData? getConfigData() {
    var box = Hive.box<ConfigData>(Constants.configDataBoxName);
    ConfigData? configData = box.get(Constants.configDataBoxName);
    return configData != null ? configData : null;
  }

  bool isAdsEnable() {
    var box = Hive.box<ConfigData>(Constants.configDataBoxName);
    ConfigData? configData = box.get(Constants.configDataBoxName);
    if (configData != null) {
      if (configData.data != null) {
        if (configData.data!.adsConfig != null) {
          if (configData.data!.adsConfig!.adsEnable == "true") {
            return true;
          }
        }
      }
    }

    return false;
  }

  AppIntro? getIntroData() {
    var box = Hive.box<ConfigData>(Constants.configDataBoxName);
    ConfigData? configData = box.get(Constants.configDataBoxName);
    if (configData != null && configData.data != null) {
      if (configData.data!.appConfig!.appIntro != null) {
        return configData.data!.appConfig!.appIntro;
      }
    }
    return null;
  }
  List<Languages>? getLanguageList() {
    var box = Hive.box<ConfigData>(Constants.configDataBoxName);
    ConfigData? configData = box.get(Constants.configDataBoxName);
    if (configData != null && configData.data != null) {
      if (configData.data!.languages != null) {
        return configData.data!.languages;
      }
    }
    return null;
  }

  String activeAdNetwork() {
    var box = Hive.box<ConfigData>(Constants.configDataBoxName);
    ConfigData? configData = box.get(Constants.configDataBoxName);

    if (configData != null) {
      if (configData.data != null) {
        if (configData.data!.adsConfig != null) {
          if (configData.data!.adsConfig!.adsEnable == "true") {
            if (configData.data!.adsConfig!.mobileAdsNetwork == "admob") {
              return "admob";
            } else if (configData.data!.adsConfig!.mobileAdsNetwork == "fan") {
              return "fan";
            } else if (configData.data!.adsConfig!.mobileAdsNetwork ==
                "startapp") {
              return "startapp";
            }
          }
        }
      }
    }
    return "";
  }

  //user logged in status
  saveIsUserLoggedIn(bool isLoggedIn) {
    Box userBox = Hive.box(Constants.userLoginStatusBoxName);
    userBox.put(Constants.userLoginStatusBoxName, isLoggedIn);
  }

  bool isUserLoggedIn() {
    var box = Hive.box(Constants.userLoginStatusBoxName);
    bool? isUserLoggedIn = box.get(Constants.userLoginStatusBoxName);
    return isUserLoggedIn != null ? isUserLoggedIn : false;
  }

 

  //user data
  saveUserData(OnnoUser user) {
    Box<OnnoUser> box = Hive.box<OnnoUser>(Constants.userDataBoxName);
    box.put(Constants.userDataBoxName, user);
  }

  OnnoUser? getOnooUser() {
    var box = Hive.box<OnnoUser>(Constants.userDataBoxName);
    OnnoUser? user = box.get(Constants.userDataBoxName);
    return user != null ? user : null;
  }

  deleteUserData() {
    Hive.box<OnnoUser>(Constants.userDataBoxName).clear();
  }

  bool isFirstOpen() {
    var box = Hive.box("isFirstOpen");
    return box.get("isFirstOpen") ?? true;
  }

  saveFirstOpenStatus(bool status) {
    Box box = Hive.box('isFirstOpen');
    box.put("isFirstOpen", status);
  }

  saveSelectedLanguage(String languageName) {
    Box box = Hive.box("language");
    box.put("language", languageName);
  }

  String getSelectedLanguage() {
    var box = Hive.box("language");
    String? value = box.get("language");
    if (value != null) {
      return value;
    }
    return "English";
  }

  saveNotificationStatus(bool status) {
    Box box = Hive.box("notification");
    box.put("notification", status);
  }

  bool getSelectedNotificationStatus() {
    var box = Hive.box("notification");
    bool? value = box.get("notification");
    return value ?? true;
  }

  saveSelectedLanguageCode(String languageCode) {
    Box box = Hive.box("languageCode");
    box.put("languageCode", languageCode);
  }

  String getSelectedLanguageCode() {
    var box = Hive.box("languageCode");
    String? value = box.get("languageCode");
    if (value != null) {
      return value;
    }
    return 'en';
  }
}
