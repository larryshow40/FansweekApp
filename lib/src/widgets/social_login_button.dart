import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SocialLoginButton extends StatelessWidget {
  VoidCallback onTap;
  Widget logo;
  SocialLoginButton({Key? key, required this.onTap, required this.logo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onTap,
      child: Container(
        height: 42.0,
        width: 42.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: this.logo,
          ),
        ),
        decoration: BoxDecoration(
            gradient: new LinearGradient(
                colors: [Color(0xffB8BBC2), Color(0xff5C5E61)],
                begin:Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
            borderRadius: BorderRadius.all(Radius.circular(25.0))),
      ),
    );
  }
}
