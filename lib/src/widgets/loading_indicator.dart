import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';

//loading widget
class LoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
        data: Theme.of(context)
            .copyWith(accentColor: AppThemeData.progressIndicatorColor),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              AppThemeData.progressIndicatorColor),
        ));
  }
}
