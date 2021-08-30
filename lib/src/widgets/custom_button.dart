import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:onoo/app_theme_data.dart';

class CustomButton extends StatelessWidget {
  final bool isDark;
  final String text;
  final double? width;
  final double? height;
  final VoidCallback onPressed;

  CustomButton(
      {Key? key,
      required this.isDark,
      required this.text,
      required this.onPressed,
      this.height = 50.0,
      this.width = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints.tightFor(height: this.height, width: this.width),
      child: ElevatedButton(
        onPressed: this.onPressed,
        child: Text(
          this.text,
          style: Theme.of(context).textTheme.headline2!.copyWith(
              color: isDark ? AppThemeData.textColorDark : Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            primary: isDark ? Color(0xff333740) : Colors.black),
      ),
    );
  }
}

class CustomButtonGradient extends StatelessWidget {
  final bool isDark;
  final String text;
  final double? width;
  final double? height;
  final VoidCallback onPressed;

  CustomButtonGradient(
      {Key? key,
      required this.isDark,
      required this.text,
      required this.onPressed,
      this.height = 50.0,
      this.width = double.infinity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: this.height,
        width: this.width,
        decoration: BoxDecoration(
            gradient: new LinearGradient(
                colors: [Color(0xff161A25), Color(0xff63666D)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
            borderRadius: BorderRadius.all(Radius.circular(5.0))
        ),
        child: Center(
          child: Text(
            this.text,
            style: Theme.of(context).textTheme.headline2!.copyWith(
                color: isDark ? AppThemeData.textColorDark : Colors.white),
          ),
        ),
      ),
    );
  }
}
