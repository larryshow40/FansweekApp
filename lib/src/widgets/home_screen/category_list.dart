import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:provider/provider.dart';

class HomeScreenCategoryListRow extends StatelessWidget {
  final bool? isSelected;
  final String? name;
  final bool? isDark = false;

  HomeScreenCategoryListRow(
      {Key? key, @required this.name, @required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isDark ? AppThemeData.darkBackgroundColor : AppThemeData.lightBackgroundColor,
          border: Border(
            bottom: BorderSide(width:2.0 , color: isSelected! ? isDark ? AppThemeData.textColorDark : AppThemeData.categoryColorLight : Colors.transparent,),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(this.name!,style: TextStyle(color: isDark ? AppThemeData.textColorDark : AppThemeData.textColorLight,fontWeight: isSelected! ? FontWeight.bold:FontWeight.w400),),
            SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
}
