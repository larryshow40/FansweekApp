import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onoo/config.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/helper/auth_helper.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/data/model/auth/auth_model.dart';
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/forget_password_screen.dart';
import 'package:onoo/src/presentation/sign_up/phone_auth/phone_auth_screen.dart';
import 'package:onoo/src/presentation/sign_up/sign_up.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:onoo/src/widgets/custom_button.dart';
import 'package:onoo/src/widgets/custom_edit_text.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:onoo/src/widgets/social_login_button.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:provider/provider.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  static final String route = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isDark = false;
  bool isLoading = false;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    printLog("_LoginScreenState");
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            helper.getTranslated(context, AppTags.signIn),
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        body: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
          fit: BoxFit.fill,
          image: isDark
              ? AssetImage('assets/images/background_dark.png')
              : AssetImage('assets/images/background_light.png'),
        )),
        child: Stack(
          children: [
            ListView(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: AppThemeData.wholeScreenPadding * 2),
                  child: Column(
                    children: [
                      SizedBox(height: 60),
                      Image.asset(
                        isDark
                            ? 'assets/images/logo_round_dark.png'
                            : 'assets/images/logo_round_light.png',
                        scale: 4,
                      ),
                      SizedBox(height: 80),
                      //email
                      CustomEditText().getCustomEditText(
                        isDark: isDark,
                        hintText:
                            helper.getTranslated(context, AppTags.email),
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        suffixWidget: Image.asset(
                          'assets/images/login_screen/user_name.png',
                          scale: 2.0,
                        ),
                      ),
                      SizedBox(height: 20),
                      //password field
                      CustomEditText().getCustomEditText(
                        isDark: isDark,
                        hintText:
                            helper.getTranslated(context, AppTags.password),
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.visiblePassword,
                        obscureValue: true,
                        suffixWidget: Image.asset(
                            'assets/images/login_screen/password.png',
                            scale: 2.0),
                      ),

                      _buildForgotPasswordBtn(context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildSignInButton(),
                          //Spacer(),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Visibility(
                                  visible: Config.enablePhoneLogin,
                                  child: SocialLoginButton(
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, PhoneAuthScreen.route);
                                    },
                                    logo: SvgPicture.asset(
                                      'assets/images/login_screen/phone.svg',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                if(Platform.isAndroid)
                                Visibility(
                                  visible: Config.enableFacebookLogin,
                                  child: SocialLoginButton(
                                    onTap: () {
                                      _signInWithFacebook();
                                    },
                                    logo: SvgPicture.asset(
                                      'assets/images/login_screen/facebook.svg',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                if(Platform.isIOS)
                                  Visibility(
                                    visible: Config.enableAppleLogin,
                                    child: SocialLoginButton(
                                      onTap: () {
                                        _loginWithApple();
                                      },
                                      logo: SvgPicture.asset(
                                        'assets/images/login_screen/apple.svg',
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                SizedBox(
                                  width: 20,
                                ),

                                  Visibility(
                                  visible: Config.enableGoogleLogin,
                                  child: SocialLoginButton(
                                    onTap: () {
                                      _loginWithGoogle();
                                    },
                                    logo: SvgPicture.asset(
                                      'assets/images/login_screen/google.svg',
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 25.0,
                      ),
                      _buildSignupBtn(context),
                      SizedBox(
                        height: 25.0,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //loading indicator
            Visibility(
              visible: isLoading,
              child: Center(
                child: LoadingIndicator(),
              ),
            )
          ],
        ),
      ),
    ));
  }

  Widget _buildSignInButton() {
    return CustomButtonGradient(
        isDark: isDark,
        width: 150,
        text: helper.getTranslated(context, AppTags.signInNow),
        onPressed: () {
          _signIn();
        });
  }

  void _signIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          content: Text("Email & password must not be empty."),
          backgroundColor: Colors.red,
        ));
    } else {
      setState(() {
        isLoading = true;
        FocusScope.of(context).unfocus();
      });
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      AuthModel? authModel = await Repository().login(email: email, password: password);
      if (authModel != null && authModel.success) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(authModel.message),
            backgroundColor: Colors.green,
          ));
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content:
                Text(helper.getTranslated(context, AppTags.somethingWentWrong)),
            backgroundColor: Colors.red,
          ));
      }
      setState(() {
        isLoading = false;
      });
    }
  }

//sign_in_with_facebook
  _signInWithFacebook() async {
    setState(() {
      isLoading = true;
    });
    bool isLoginSuccess = await AuthHelper().signInWithFacebook();
    if (isLoginSuccess) {
      setState(() {
        isLoading = false;
      });
      //navigate screen
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Something went wrong.\nPlease try again.")));
    }
  }

  _loginWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    bool? isLoginSuccess = await AuthHelper().signInWithGoogle();
    if (isLoginSuccess!) {
      setState(() {
        isLoading = false;
      });
      //navigate screen
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => HomeScreen()));
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Something went wrong.\nPlease try again.")));
    }
  }


  //SignIn_with_Apple
  _loginWithApple() async {
    setState(() {
      isLoading = true;
    });
    bool? isLoginSuccess = await AuthHelper().signInWithApple();
    if (isLoginSuccess!) {
      setState(() {
        isLoading = false;
      });
      //navigate screen
      Navigator.pushReplacementNamed(context, HomeScreen.route);
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong.\nPlease try again.")));
    }
  }



}

Widget _buildForgotPasswordBtn(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, ForgetPasswordScreen.route);
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        alignment: Alignment.centerRight,
        child: Text(
          helper.getTranslated(context, AppTags.forgotPassword),
          style: TextStyle(
            fontSize: 15,
            color: Color(0xff9FA9C5),
            fontFamily: 'Roboto',
          ),
        ),
      ),
    ),
  );
}

Widget _buildSignupBtn(BuildContext context) {
  return Align(
    alignment: Alignment.centerLeft,
    child: GestureDetector(
      onTap: () {
        //navigate to sign up screen
        Navigator.pushReplacementNamed(context, SignupScreen.route);
      },
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: helper.getTranslated(context, AppTags.newUser),
              style: TextStyle(
                  color: Color(0xff9FA9C5),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto'),
            ),
            TextSpan(
              text:
                  " " + helper.getTranslated(context, AppTags.signUpLowerCase),
              style: TextStyle(
                  color: Color(0xff008CD5),
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Roboto'),
            ),
          ],
        ),
      ),
    ),
  );
}
