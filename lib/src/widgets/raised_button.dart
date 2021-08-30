import 'package:flutter/material.dart';
import 'package:onoo/src/utils/utils.dart';

class RaisedGradientButton extends StatelessWidget {
  final String text;
  final bool isDark;
  final double? width;
  final double? height;
  final VoidCallback onPressed;

  const RaisedGradientButton({
    Key? key,
    required this.text,
    required this.isDark,
    this.width = double.infinity,
    this.height = 45.0,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 45.0,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.black12.withOpacity(0.4), Colors.black87]),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset: Offset(0.0, 0),
              blurRadius: 0,
            ),
          ]),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: onPressed,
            child: Center(child: Text(text, style: TextStyle(color: isDark ? Utils.getTextColor() : Colors.white),
            ))),
      ),
    );
  }
}
