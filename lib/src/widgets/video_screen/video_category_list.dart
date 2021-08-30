import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:provider/provider.dart';

class VideoScreenCatagoryListRow extends StatelessWidget {
  final bool? isSelected;
  final String? name;

  VideoScreenCatagoryListRow(
      {Key? key, @required this.name, @required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    printLog("VideoScreenCatagoryListRow");
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Container(
      color: isDark
          ? AppThemeData.darkBackgroundColor
          : AppThemeData.lightBackgroundColor,
      width: 100,
      height: 50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: RichText(
                overflow: TextOverflow.ellipsis,
                strutStyle: StrutStyle(fontSize: 12.0),
                text: TextSpan(
                    style: TextStyle(
                      color: isDark
                          ? AppThemeData.textColorDark
                          : AppThemeData.textColorLight,
                    ),
                    text: this.name),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Visibility(
            child: Container(
              height: 3,
              color: isDark
                  ? AppThemeData.textColorDark
                  : AppThemeData.textColorLight,
            ),
            visible: this.isSelected!,
          )
        ],
      ),
    );
  }
}
