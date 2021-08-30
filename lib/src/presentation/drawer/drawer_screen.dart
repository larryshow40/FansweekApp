import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:launch_review/launch_review.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/config/config_model.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/profile/profile_screen.dart';
import 'package:onoo/src/presentation/settings/settings.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:provider/provider.dart';

class DrawerScreen extends StatefulWidget {
  static final String route = '/DrawerScreen';
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    printLog("_DrawerScreenState");
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: isDark
                        ? Image.asset('assets/images/logo_dark.png', scale: 2,)
                        : Image.asset('assets/images/logo_light.png', scale: 2,)),
                SizedBox(
                  height: 50.0,
                ),
                drawerItem(
                    leading: 'home',
                    title: helper.getTranslated(context, AppTags.home),
                    onTap: () {
                      Scaffold.of(context).openEndDrawer();
                    }),
                drawerItem(
                    leading: 'user',
                    title: helper.getTranslated(context, AppTags.myAccount),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => ProfileScreen(isFromDrawer: true,)));
                    }),
                drawerItem(
                    leading: 'settings',
                    title: helper.getTranslated(context, AppTags.settigns),
                    onTap: () {
                      Navigator.pushNamed(context, SettingsScreen.route);
                    }),
                drawerItem(
                    leading: 'support',
                    title: helper.getTranslated(context, AppTags.support),
                    onTap: () {
                      ConfigData configData = DatabaseConfig().getConfigData()!;
                      Utils.launchUrl(
                          configData.data!.appConfig!.supportUrl ?? "");
                    }),
                drawerItem(
                    leading: 'star',
                    title: helper.getTranslated(context, AppTags.rateTheApp),
                    onTap: () {
                      LaunchReview.launch();
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
  //drawer_item
  drawerItem(
      {required String leading,
      required String title,
      required GestureTapCallback onTap}) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25),
        child: Row(
          children: [
            Container(
                width: 25.0,
                height: 25.0,
                child: SvgPicture.asset(
                  "assets/images/drawer_icon/$leading.svg",
                  height: 30,
                  width: 30,
                  color: isDark
                      ? AppThemeData.textColorDark
                      : AppThemeData.textColorLight,
                )),
            SizedBox(width: 15.0),
            Text(title, style: Theme.of(context).textTheme.headline2),
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
