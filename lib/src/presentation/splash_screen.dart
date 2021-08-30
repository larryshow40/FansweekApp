import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/data/bloc/config_bloc/config_bloc.dart';
import 'package:onoo/src/data/model/config/config_model.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/home_screen.dart';
import 'package:onoo/src/presentation/intro_screen.dart';
import 'package:onoo/src/presentation/sign_up/sign_up.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/utils/connection_status.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:onoo/src/widgets/no_interner.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double? screenWidth;
  double? screenHeight;
  bool? isLoading = true;
  bool isOffline = false;
  ConfigBloc? _configBloc;

  @override
  void initState() {
    _configBloc = BlocProvider.of<ConfigBloc>(context)..add(GetConfigEvent());
    super.initState();
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    checkIsConnected(connectionStatus);
  }

  checkIsConnected(ConnectionStatusSingleton connectionStatus) async {
    await connectionStatus.checkConnection().then((value) {
      if (!value) {
        _configBloc!.add(ConfigNoInternetEvent());
      }
    });
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
    if (isOffline) {
      _configBloc!.add(ConfigNoInternetEvent());
    } else {
      _configBloc!.add(GetConfigEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocListener<ConfigBloc, ConfigState>(
        bloc: _configBloc,
        listener: (context, state) {
          if (state is ConfigRetryState) {
            _configBloc!.add(GetConfigEvent());
          } else if (state is ConfigErrorState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ));
          } else if (state is ConfigSuccessState) {
            _manageConfigData(state.configData);
          } else if (state is ConfigErrorState) {
            _configBloc!.add(GetConfigEvent());
          }
        },
        child: BlocBuilder<ConfigBloc, ConfigState>(
          builder: (context, state) {
            if (state is ConfigNoInternetState) {
              return NoInternetScreen(onRetry: () {
                _configBloc!.add(ConfigRetryEvent());
              });
            }
            return buildUI(context);
          },
        ),
      ),
    );
  }

  Widget buildUI(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isDark ? darkSplashImage() : lightSplashImage(),
        ),
        //loading
        Align(
          alignment: Alignment.bottomCenter,
          child: Visibility(
              visible: isLoading!,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30,
                ),
                child: LoadingIndicator(),
              )),
        )
      ],
    );
  }

  //SPLASH_IMAGE_FOR_DARK_THEME
  Widget darkSplashImage() {
    return Image.asset(
      "assets/images/splash_screen_dark.png",
      height: screenHeight, width: screenWidth, fit: BoxFit.fitWidth,
    );
  }
  //SPLASH_IMAGE_FOR_LIGHT_THEME
  Widget lightSplashImage() {
    return Image.asset(
      "assets/images/splash_screen_light.png",
      height: screenHeight, width: screenWidth, fit: BoxFit.fitWidth,
    );
  }

  //check update available or not for android and ios
  void _manageConfigData(ConfigData configData) async {
    bool updatable = await _checkForUpdate(configData);
    if (updatable) {
      if (Platform.isAndroid) {
        updateDialogForAndroid(configData);
      } else if (Platform.isIOS) {
        updateDialogForIos(configData);
      }
      return;
    } else {
      _navigate(configData);
    }
  }

  void _navigate(ConfigData configData) {
    //then check first open or not
    //check mandatory login enabled or not
    //if yes check user is logged in or not
    if (DatabaseConfig().isFirstOpen()) {
      AppIntro? appIntro = DatabaseConfig().getIntroData();
      if (appIntro != null && appIntro.intro!.length != 0) {
        navigateToIntroScreen();
      } else {
        _navigateToOtherScreen(
            configData.data!.appConfig!.mandatoryLogin == "true");
      }
    } else {
      if (configData.data!.appConfig!.mandatoryLogin == "true") {
        _navigateToOtherScreen(true);
      } else {
        _navigateToOtherScreen(false);
      }
    }
  }

  updateDialogForAndroid(ConfigData configData) {
    bool skipable = configData.data!.androidVersionInfo!.apkUpdateSkipableStatus != null ? configData.data!.androidVersionInfo!.apkUpdateSkipableStatus == "true" : false;
    String content = configData.data!.androidVersionInfo!.whatsNewOnLatestApk ?? "";
    String updateUrl = configData.data!.androidVersionInfo!.apkFileUrl ?? "";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          helper.getTranslated(context, AppTags.updateAvailable),
          style: Theme.of(context).textTheme.headline3,
        ),
        content: Text(
          content,
          style: Theme.of(context).textTheme.headline2,
        ),
        actions: [
          Visibility(
            visible: skipable,
            child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigate(configData);
                },
                child: Text(
                  helper.getTranslated(context, AppTags.skip),
                  style: Theme.of(context).textTheme.headline1,
                )),
          ),
          TextButton(
              onPressed: () {Utils.launchUrl(updateUrl);
              },
              child: Text(
                helper.getTranslated(context, AppTags.updateNow),
                style: Theme.of(context).textTheme.headline1,
              )),
        ],
        elevation: AppThemeData.cardElevation,
      ),
    );
  }

  //UPDATE_DIALOG_TO_UPDATE_APP_FROM_APPSTORE
  updateDialogForIos(ConfigData configData) {
    bool skipable = configData.data!.iosVersionInfo!.iosUpdateSkipableStatus != null ? configData.data!.iosVersionInfo!.iosUpdateSkipableStatus == "true" : false;
    String content = configData.data!.iosVersionInfo!.whatsNewOnLatestIpa ?? "";
    String updateUrl = configData.data!.iosVersionInfo!.ipaFileUrl ?? "";
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(
          helper.getTranslated(context, AppTags.updateAvailable),
          style: Theme.of(context).textTheme.headline3,
        ),
        content: Text(
          content,
          style: Theme.of(context).textTheme.headline2,
        ),
        actions: [
          Visibility(
            visible: skipable,
            child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _navigate(configData);
                },
                child: Text(
                  helper.getTranslated(context, AppTags.skip),
                  style: Theme.of(context).textTheme.headline1,
                )),
          ),
          TextButton(
              onPressed: () {
                Utils.launchUrl(updateUrl);
              },
              child: Text(
                helper.getTranslated(context, AppTags.updateNow),
                style: Theme.of(context).textTheme.headline1,
              )),
        ],
        elevation: AppThemeData.cardElevation,
      ),
    );
  }

  //FUNCTION_TO_CHECK_IF_UPDATE_IS_AVAILABLE_OR_NOT
  Future<bool> _checkForUpdate(ConfigData configData) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    // printLog("buildNumber:${packageInfo.buildNumber.toString()}");
    if (Platform.isAndroid) {
      AndroidVersionInfo info = configData.data!.androidVersionInfo!;

      return info.latestApkCode != null
          ? info.latestApkCode != packageInfo.buildNumber
          : false;
    } else if (Platform.isIOS) {
      IosVersionInfo info = configData.data!.iosVersionInfo!;
      return info.latestIpaCode != null
          ? info.latestIpaCode != packageInfo.buildNumber
          : false;
    }
    return false;
  }

  void navigateToIntroScreen() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, IntroScreen.route);
    });
  }

  void _navigateToOtherScreen(bool isMandatoryLoginEnabled) {
    bool isLoggedIn = DatabaseConfig().isUserLoggedIn();
    if (isMandatoryLoginEnabled && !isLoggedIn) {
      print("-------Mandatory login enabled and user is not loggedIn");
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => SignupScreen()));
      });
    } else {
      print("-------Mandatory login disabled");
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
      });
    }
  }
}
