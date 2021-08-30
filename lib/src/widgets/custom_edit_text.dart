import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';

class CustomEditText {
  Widget getCustomEditText(
      {required bool isDark,
      required String hintText,
      required TextEditingController controller,
      required TextInputType keyboardType,
      TextInputAction? textInputAction,
      TextStyle? hintStyle,
      TextStyle? textStyle,
      Widget? suffixWidget,
      Widget? prefixWidget,
      bool obscureValue = false,
      int maxLines = 1,
      int? maxLength,
      double height = 50,
      double width = double.infinity}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppThemeData.darkBackgroundColor.withOpacity(0.8)
            : Colors.white,
        borderRadius: BorderRadius.circular(4.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            //color: AppThemeData.shadowColor.withOpacity(0.5),
            blurRadius: AppThemeData.editTextBlurRadius,
            spreadRadius: 0.4,
            offset: Offset(0, 2),
          ),
          if(!isDark)
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            //color: AppThemeData.shadowColor.withOpacity(0.5),
            blurRadius: AppThemeData.editTextBlurRadius,
            spreadRadius: 0.3,
            offset: Offset(-2, -2),
          ),
        ],
      ),
      height: height,
      width: width,
      child: Align(
        alignment: Alignment.centerLeft,
        child: TextFormField(
          keyboardType: keyboardType,
          controller: controller,
          maxLength: maxLength ?? null,
          maxLines: maxLines,
          textInputAction: textInputAction ?? TextInputAction.next,
          obscureText: obscureValue,
          validator: (value) {},
          style: textStyle ??
              TextStyle(
                  color: isDark
                      ? AppThemeData.textColorDark
                      : AppThemeData.textColorLight,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.normal,
                  fontSize: 13),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent, width: 5.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(
                width: 1,
                color: Colors.transparent,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              borderSide: BorderSide(
                width: 1,
                color: Colors.transparent,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            suffixIcon: suffixWidget ?? null,
            prefixIcon: prefixWidget ?? null,
            hintText: hintText,
            hintStyle: hintStyle ??
                TextStyle(
                  color: Color(0xff9FA9C5),
                  fontFamily: 'Roboto',
                  fontSize: 13,
                  letterSpacing: 0.78,
                ),
          ),
        ),
      ),
    );
  }
}
