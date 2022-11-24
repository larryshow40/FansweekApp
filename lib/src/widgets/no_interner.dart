import 'package:flutter/material.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;

//if internet connection is not available
class NoInternetScreen extends StatelessWidget {
  final VoidCallback onRetry;
  NoInternetScreen({Key? key, required this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return new Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Container(
          alignment: Alignment.center,
          width: 280,
          child: Stack(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Image.asset('assets/images/fansweek.png'),
                  Text(helper.getTranslated(context, AppTags.whoops), style: Theme.of(context).textTheme.headline4),
                  Container(height: 10),
                  Text(helper.getTranslated(context, AppTags.noInternet),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headline2),
                  Container(height: 25),
                  CustomButton(
                      isDark: isDark,
                      width: 180,
                      height: 40,
                      text: helper.getTranslated(context, AppTags.retry),
                      onPressed: this.onRetry),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
