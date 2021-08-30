import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:launch_review/launch_review.dart';
import 'package:onoo/main.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/auth/onno_user.dart';
import 'package:onoo/src/data/model/config/config_model.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/sign_in/login_screen.dart';
import 'package:onoo/src/presentation/sign_up/sign_up.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:onoo/src/utils/widget_animator.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/widgets/custom_button.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class SettingsScreen extends StatefulWidget {
  static final String route = '/SettingsScreen';
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDark = false;
  bool isUserLoggedIn = false;
  bool isNotificationOn = false;
  //language
  late String selectedLanguage = "English";

  void _changeLanguage(Languages language) {
    Locale _locale = helper.setLocal(language.code!);
    // MyApp.setLocal(context, _locale);
  }

  @override
  void initState() {
    super.initState();
    selectedLanguage = DatabaseConfig().getSelectedLanguage();
    isUserLoggedIn = DatabaseConfig().isUserLoggedIn();
    isNotificationOn = DatabaseConfig().getSelectedNotificationStatus();
  }

  @override
  Widget build(BuildContext context) {
    printLog("_SettingsScreenState");
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          helper.getTranslated(context, AppTags.settigns),
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: isUserLoggedIn ? _buildUiWithLogin() : _buildUiWithoutLogin(),
    );
  }

  getImage(OnnoUser? user) {
    if (user != null && user.image != null) {
      return NetworkImage(user.image.toString(), scale: 1.0);
    } else {
      return AssetImage("assets/images/logo_round.png");
    }
  }

  _buildUiWithLogin() {
    //get saved user data
    OnnoUser? user = DatabaseConfig().getOnooUser();

    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: AppThemeData.normalPadding * 2,
                right: AppThemeData.normalPadding * 2),
            child: WidgetAnimator(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 150.0,
                    width: 150.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: AppThemeData.textColorDark,
                            width: 3.0,
                            style: BorderStyle.solid),
                        image: DecorationImage(
                            fit: BoxFit.cover, image: getImage(user))),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(
                      user != null && user.firstName != null
                          ? user.firstName! + " " + user.lastName!
                          : helper.getTranslated(
                              context, AppTags.noNameToDisplay),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  //main ui
                  _mainUi(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

//build login ui if user not logged in
  _buildUiWithoutLogin() {
    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: 20,
                left: AppThemeData.normalPadding * 2,
                right: AppThemeData.normalPadding * 2),
            child: WidgetAnimator(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/icons/profile.png",
                    height: 100,
                    width: 100,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    helper.getTranslated(context, AppTags.noNameToDisplay),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Text(
                    helper.getTranslated(context, AppTags.updateProfile),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CustomButtonGradient(
                          isDark: isDark,
                          width: 150,
                          height: 45,
                          text: helper.getTranslated(
                            context,
                            AppTags.signIn,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.route);
                          }),
                      CustomButtonGradient(
                          isDark: isDark,
                          width: 150,
                          height: 45,
                          text: helper.getTranslated(
                            context,
                            AppTags.signUp,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SignupScreen()));
                          }),
                    ],
                  ),
                  _mainUi(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //setting screen ui
  _mainUi() {
    final themeProvider = Provider.of<ThemeProvider>(context);
    ConfigData configData = DatabaseConfig().getConfigData()!;
    print("configData${configData.data!.languages!.length}");

    return Padding(
      padding: const EdgeInsets.only(
          top: AppThemeData.normalPadding * 2,
          bottom: AppThemeData.normalPadding * 2),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppThemeData.normalPadding),
            child: Divider(
              height: 5,
              color: isDark
                  ? AppThemeData.dividerColorDark
                  : AppThemeData.dividerColorLight,
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                helper.getTranslated(context, AppTags.language),
                style: Theme.of(context).textTheme.headline3,
              ),
              Container(
                child: Center(
                    child: DropdownButton<Languages>(
                  isExpanded: false,
                  underline: SizedBox(),
                  icon: Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Utils.getTextColor(),
                  ),
                  hint: Container(
                    width: 60,
                    child: Center(
                      child: Text(
                        selectedLanguage,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value!.name!;
                    });
                    DatabaseConfig().saveSelectedLanguage(value!.name!);
                    DatabaseConfig().saveSelectedLanguageCode(value.code!);
                    _changeLanguage(value);
                  },
                  // items: Language.languageList()
                  items: DatabaseConfig()
                      .getLanguageList()!
                      .map(
                        (e) => DropdownMenuItem<Languages>(
                          value: e,
                          child: Text(e.name!),
                        ),
                      )
                      .toList(),
                )),
              )
            ],
          ),
          SizedBox(
            height: AppThemeData.normalPadding,
          ),
          //dark mode
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                helper.getTranslated(context, AppTags.darkMode),
                style: Theme.of(context).textTheme.headline3,
              ),
              Container(
                child: Center(
                  child: Container(
                    child: FlutterSwitch(
                        width: 70.0,
                        height: 30.0,
                        valueFontSize: 22.0,
                        toggleSize: 30.0,
                        borderRadius: 30.0,
                        padding: 2.0,
                        showOnOff: false,
                        toggleColor: isDark
                            ? AppThemeData.darkToggleColor
                            : Colors.white,
                        activeColor:isDark? AppThemeData.darkSwitchColor:AppThemeData.dividerColorLight,
                        inactiveColor: isDark? AppThemeData.darkSwitchColor:AppThemeData.dividerColorLight,
                        value: themeProvider.isDarkMode,
                        onToggle: (value) {
                          setState(() {
                            final provider = Provider.of<ThemeProvider>(context,
                                listen: false);
                            provider.toggleTheme(value);
                          });
                        }),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeData.normalPadding * 1.5),
          // Notification
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                helper.getTranslated(context, AppTags.notification),
                style: Theme.of(context).textTheme.headline3,
              ),
              Container(
                child: Center(
                  child: Container(
                    child: FlutterSwitch(
                        width: 70.0,
                        height: 30.0,
                        valueFontSize: 22.0,
                        toggleSize: 30.0,
                        borderRadius: 30.0,
                        padding: 2.0,
                        showOnOff: false,
                        toggleColor: isDark ? AppThemeData.darkToggleColor : Colors.white,
                        activeColor:isDark? AppThemeData.darkSwitchColor:AppThemeData.dividerColorLight,
                        inactiveColor: isDark? AppThemeData.darkSwitchColor:AppThemeData.dividerColorLight,
                        value: isNotificationOn,
                        onToggle: (value) {
                          DatabaseConfig().saveNotificationStatus(value);
                          setState(() {
                            isNotificationOn = value;
                          });
                        }),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppThemeData.normalPadding * 1.5),
          //Notification Settings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                helper.getTranslated(context, AppTags.notificationSettings),
                style: Theme.of(context).textTheme.headline3,
              ),
              Container(child: Icon(Icons.chevron_right_rounded)),
            ],
          ),

          Padding(
            padding: const EdgeInsets.only(
              left: AppThemeData.normalPadding,
              right: AppThemeData.normalPadding,
              top: AppThemeData.normalPadding * 2,
              bottom: AppThemeData.normalPadding,
            ),
            child: Divider(
              height: 5,
              color: isDark
                  ? AppThemeData.dividerColorDark
                  : AppThemeData.dividerColorLight,
            ),
          ),

          //share this app
          InkWell(
            onTap: () async {
              if (Platform.isAndroid) {
                //get package name
                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                Share.share(
                    "https://play.google.com/store/apps/details?id=${packageInfo.packageName}",
                    subject: "Share this app via:");
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 2, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    helper.getTranslated(context, AppTags.shareThisApp),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Container(
                      child: Icon(
                    Icons.chevron_right_rounded,
                  )),
                ],
              ),
            ),
          ),

          // Rate this app
          InkWell(
            onTap: () {
              LaunchReview.launch();
            },
            child: Container(
              margin: EdgeInsets.only(left: 2, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    helper.getTranslated(context, AppTags.rateTheApp),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Container(
                      child: Icon(
                    Icons.chevron_right_rounded,
                  )),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(5),
            child: Divider(
              height: 5,
              color: isDark
                  ? AppThemeData.dividerColorDark
                  : AppThemeData.dividerColorLight,
            ),
          ),
          // help
          InkWell(
            onTap: () {
              Utils.launchUrl(configData.data!.appConfig!.supportUrl ?? "");
            },
            child: Container(
              margin: EdgeInsets.only(left: 2, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    helper.getTranslated(context, AppTags.help),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Container(
                      child: Icon(
                    Icons.chevron_right_rounded,
                  )),
                ],
              ),
            ),
          ),

          // Privacy
          InkWell(
            onTap: () {
              Utils.launchUrl(
                  configData.data!.appConfig!.privacyPolicyUrl ?? "");
            },
            child: Container(
              margin: EdgeInsets.only(left: 2, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    helper.getTranslated(context, AppTags.privacy),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Container(
                      child: Icon(
                    Icons.chevron_right_rounded,
                  )),
                ],
              ),
            ),
          ),

          //terms and condition
          InkWell(
            onTap: () {
              Utils.launchUrl(
                  configData.data!.appConfig!.termsNConditionUrl ?? "");
            },
            child: Container(
              margin: EdgeInsets.only(left: 2, top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    helper.getTranslated(context, AppTags.termsAndConditions),
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Container(child: Icon(Icons.chevron_right_rounded)),
                ],
              ),
            ),
          ),

          //logout
          Visibility(
            visible: isUserLoggedIn,
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: InkWell(
                onTap: () {
                  printLog("logout_tapped !");
                  _logOutUser();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      helper.getTranslated(context, AppTags.logout),
                      style: Theme.of(context)
                          .textTheme
                          .headline3!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

//user logout function
  _logOutUser() async {
    await FirebaseAuth.instance.signOut();
    //delete user data from local database
    DatabaseConfig().saveIsUserLoggedIn(false);
    DatabaseConfig().deleteUserData();
    setState(() {
      isUserLoggedIn = false;
    });
  }
}
