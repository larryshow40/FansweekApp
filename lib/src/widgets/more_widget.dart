import 'package:flutter/material.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import '../../app_theme_data.dart';
//common_more_widget
Widget moreWidget(isDark, context){
  return Container(
    height: 30,
    width: 60,
    decoration: BoxDecoration(
        gradient: new LinearGradient(
            colors:isDark ? [
              Color(0xff161A25),
              Color(0xff63666D)
            ] :[
              Color(0xffBABCBF),
              Color(0xff9190A7)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        borderRadius: BorderRadius.all(Radius.circular(15.0))),
    child: Center(
      child: Text(
        helper.getTranslated(context, AppTags.more),
        style: Theme.of(context).textTheme.headline1!.copyWith(color: isDark ? AppThemeData.textColorDark : Colors.white),
      ),
    ),
  );
}