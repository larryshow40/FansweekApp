import 'package:country_code_picker/country_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:onoo/service/navigation_servicce.dart';
import 'package:onoo/src/data/bloc/all_tags_bloc/all_tags_bloc.dart';
import 'package:onoo/src/data/bloc/author_bloc/author_bloc.dart';
import 'package:onoo/src/data/bloc/comment_bloc/comment_bloc.dart';
import 'package:onoo/src/data/bloc/config_bloc/config_bloc.dart';
import 'package:onoo/src/data/bloc/reply_bloc/reply_bloc.dart';
import 'package:onoo/src/data/bloc/trending_bloc/trending_bloc.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:onoo/src/data/bloc/home_content/home_content_bloc.dart';
import 'package:onoo/src/data/bloc/phone_auth/phone_auth_bloc.dart';
import 'package:onoo/src/data/bloc/post_details/details_content_bloc.dart';
import 'package:onoo/src/data/bloc/video_bloc/video_bloc.dart';
import 'package:onoo/src/data/phone_auth_repository.dart';
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/localizations.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/splash_screen.dart';
import 'package:onoo/src/utils/connection_status.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';
import 'service/locator.dart';
import 'src/data/bloc/firebase_auth/firebase_auth_bloc.dart';
import 'package:onoo/config.dart';
import 'src/presentation/post_details_screen.dart';
import 'src/utils/route.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //internet connectivity initialization
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();
  //initialize hive database
  await DatabaseConfig().initHiveDatabase();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocal(BuildContext context, Locale locale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state!.setLocale(locale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final NavigationService _navigationService = locator<NavigationService>();


  bool? isDark;
  Locale? _locale;
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void didChangeDependencies() {
    helper.getLocale().then((locale) {
      setState(() {
        _locale = locale;
      });
    });
    super.didChangeDependencies();
  }

  @override
  void initState() {
    printLog("_MyAppState initState");
    initPlatformState();
    super.initState();
  }

  Future<void> initPlatformState() async {
    //if (!mounted) return;
    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setRequiresUserPrivacyConsent(await OneSignal.shared.userProvidedPrivacyConsent());
    OneSignal.shared.setNotificationWillShowInForegroundHandler((event) {event.complete(event.notification);});
    OneSignal.shared.promptUserForPushNotificationPermission();
    OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      printLog("result:${result.notification.additionalData}");
      String postId = result.notification.additionalData!["id"];
      String imageUrl = result.notification.additionalData!["image_url"];
      _navigationService.navigateTo(PostDetailsScreen.route, postId,imageUrl);
    });
    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {});
    OneSignal.shared.setInAppMessageClickedHandler((OSInAppMessageAction action) {});
    await OneSignal.shared.setAppId(Config.ONE_SIGNAL_APP_ID);
  }

  @override
  Widget build(BuildContext context) {
    String appName = "";
    PackageInfo.fromPlatform().then((value) => appName == value.appName); //update_app_name_from_packageInfo
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PhoneAuthBloc(repository: PhoneAuthRepository(null))),
        BlocProvider(create: (context) => FirebaseAuthBloc(Repository())),
        BlocProvider(create: (context) => HomeContentBloc(repository: Repository())),
        BlocProvider(create: (context) => VideoBloc(repository: Repository()),),
        BlocProvider(create: (context) => DetailsContentBloc(repository: Repository()),),
        BlocProvider(create: (context) => ConfigBloc(repository: Repository())),
        BlocProvider(create: (context) => AllTagsBloc(repository: Repository())),
        BlocProvider(create: (context) => TrendingBloc(repository: Repository())),
        BlocProvider(create: (context) => CommentBloc(repository: Repository())),
        BlocProvider(create: (context) => ReplyBloc(),),
        BlocProvider(create: (context) => AuthorBloc()),
      ],
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            title: appName,
            navigatorKey: locator<NavigationService>().navigatorKey,
            routes: Routes.getRoute(),
            supportedLocales: Config.supportedLanguageList,
            locale: _locale,
            localizationsDelegates: [
              MyLocalization.delegate,
              CountryLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback: (deviceLocale, supportedLocales) {
              for (var locale in supportedLocales) {
                if (locale.languageCode == deviceLocale!.languageCode &&
                    locale.countryCode == deviceLocale.countryCode) {
                  return deviceLocale;
                }
              }
              return supportedLocales.first;
            },
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: MyThemes.lightTheme,
            darkTheme: MyThemes.darkTheme,
            // home: AuthorScreen(authorId: 1),
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}
