import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:provider/provider.dart';

class CodeVerificationScreen extends StatefulWidget {
  static final String route = '/CodeVerificationScreen';
  @override
  _CodeVerificationScreenState createState() => _CodeVerificationScreenState();
}

class _CodeVerificationScreenState extends State<CodeVerificationScreen> {
  bool isDark = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppThemeData.darkBackgroundColor
          : AppThemeData.lightBackgroundColor,
      body: Stack(
        children: [
          ListView(
            children: [
              _buildTopUI(context, isDark),
              SizedBox(height: 80),
              Container(
                child: Center(
                  child: Text(
                    'Verification Code',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Center(
                  child: Text(
                    'Enter the 4 digits code that we have sent',
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 18),
                  ),
                ),
              ),
              Container(
                child: Center(
                  child: Text(
                    'through your email',
                    style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                        fontSize: 18),
                  ),
                ),
              ),
              // code fields
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 20, top: 30),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 50.0,
                      width: 50.0,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                        boxShadow: [
                          BoxShadow(color: const Color(0x4d678bb2), blurRadius: 10.0, offset: Offset(0, 2),),
                        ],
                      ),
                      child: TextField(
                        obscureText: true,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Color(0xff9FA9C5),
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          letterSpacing: 0.78,
                        ),
                        decoration: InputDecoration(
                          counter: Offstage(),
                          border: InputBorder.none,
                          hintText: "*",
                          contentPadding:
                              EdgeInsets.only(left: 20.0, right: 20.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      height: 50.0,
                      width: 50.0,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x4d678bb2),
                            blurRadius: 10.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        obscureText: true,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Color(0xff9FA9C5),
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          letterSpacing: 0.78,
                        ),
                        decoration: InputDecoration(
                          counter: Offstage(),
                          border: InputBorder.none,
                          hintText: "*",
                          contentPadding:
                              EdgeInsets.only(left: 20.0, right: 20.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      height: 50.0,
                      width: 50.0,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x4d678bb2),
                            blurRadius: 10.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        obscureText: true,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Color(0xff9FA9C5),
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          letterSpacing: 0.78,
                        ),
                        decoration: InputDecoration(
                          counter: Offstage(),
                          border: InputBorder.none,
                          hintText: "*",
                          contentPadding:
                              EdgeInsets.only(left: 20.0, right: 20.0),
                        ),
                      ),
                    ),
                    SizedBox(width: 20,),
                    Container(
                      height: 50.0,
                      width: 50.0,
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4.0),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x4d678bb2),
                            blurRadius: 10.0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        obscureText: true,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Color(0xff9FA9C5),
                          fontFamily: 'Roboto',
                          fontSize: 18,
                          letterSpacing: 0.78,
                        ),
                        decoration: InputDecoration(
                          counter: Offstage(),
                          border: InputBorder.none,
                          hintText: "*",
                          contentPadding:
                              EdgeInsets.only(left: 20.0, right: 20.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              //confirm button
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: _buildConfirmBtn(),
              ),
            ],
          ),

          //bottom view
          _buildBottomUI(context, isDark),

          Visibility(
            visible: isLoading,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildTopUI(BuildContext context, bool isDark) {
  return Stack(
    children: [
      SvgPicture.string(
        isDark ? _svg_top_dark : _svg_top_light,
        allowDrawingOutsideViewBox: false,
        width: MediaQuery.of(context).size.width,
      ),
      Transform.translate(
        offset: Offset(66.0, 68.0),
        child: Container(
          width: 241.0,
          height: 241.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
            color: isDark ? const Color(0x0deff2f9) : const Color(0xffeff2f9),
          ),
        ),
      ),
      Transform.translate(
        offset: Offset(79.0, 81.0),
        child: Container(
          width: 215.0,
          height: 215.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
            color: isDark ? const Color(0x0deff2f9) : const Color(0xffeff2f9),
          ),
        ),
      ),
      Transform.translate(
        offset: Offset(109, 172),
        child: isDark
            ? Image.asset('assets/images/logo_dark.png')
            : Image.asset('assets/images/logo_light.png'),
      )
    ],
  );
}

Widget _buildBottomUI(BuildContext context, bool isDark) {
  return Transform.translate(
    offset: Offset(230.0, 666.0),
    child: Container(
      width: 241.0,
      height: 241.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
        color: isDark ? const Color(0x0df1f7fe) : const Color(0xfff1f7fe),
      ),
    ),
  );
}

Widget _buildConfirmBtn() {
  return Container(
    width: 150,
    height: 50,
    decoration: BoxDecoration(
        gradient: new LinearGradient(
            colors: [Color(0xff161A25), Color(0xff63666D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
        borderRadius: BorderRadius.all(Radius.circular(4.0))),
    child: Center(
      child: Text(
        'CONFIRM',
        style: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontFamily: 'Roboto',
        ),
      ),
    ),
  );
}

const String _svg_top_light = '<svg viewBox="0.2 0.0 375.0 257.8" ><path transform="translate(6927.0, -12846.0)" d="M -6926.80029296875 13091.607421875 C -6886.72119140625 13116.3779296875 -6856.95947265625 13099.283203125 -6811.72021484375 13076.2587890625 C -6811.017578125 13075.6396484375 -6551.80029296875 12939.150390625 -6551.80029296875 12939.150390625 L -6551.80029296875 12846 L -6926.80029296875 12846 L -6926.80029296875 13091.607421875 Z" fill="#fff5f5" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';

const String _svg_top_dark = '<svg viewBox="0.2 0.0 375.0 257.8" ><path transform="translate(6927.0, -12846.0)" d="M -6926.80029296875 13091.607421875 C -6886.72119140625 13116.3779296875 -6856.95947265625 13099.283203125 -6811.72021484375 13076.2587890625 C -6811.017578125 13075.6396484375 -6551.80029296875 12939.150390625 -6551.80029296875 12939.150390625 L -6551.80029296875 12846 L -6926.80029296875 12846 L -6926.80029296875 13091.607421875 Z" fill="#fff5f5" fill-opacity="0.05" stroke="none" stroke-width="1" stroke-opacity="0.05" stroke-miterlimit="4" stroke-linecap="butt" /></svg>';
