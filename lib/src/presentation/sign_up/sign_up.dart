import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onoo/config.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/helper/auth_helper.dart';
import 'package:onoo/src/data/model/sign_up_model.dart';
import 'package:onoo/src/data/phone_auth_repository.dart';
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/sign_in/login_screen.dart';
import 'package:onoo/src/presentation/sign_up/phone_auth/phone_auth_screen.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/utils/constants.dart';
import 'package:onoo/src/widgets/custom_button.dart';
import 'package:onoo/src/widgets/custom_edit_text.dart';
import 'package:onoo/src/widgets/raised_button.dart';
import 'package:onoo/src/widgets/social_login_button.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:provider/provider.dart';
import '../home_screen.dart';

class SignupScreen extends StatefulWidget {
  static final String route = '/SignupScreen';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool isDark = false;
  bool isLoading = false;

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
      Navigator.pushReplacementNamed(context, HomeScreen.route);
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text(helper.getTranslated(context, AppTags.somethingWentWrong))));
      throw Exception();
    }
  }
  //signIn_with_facebook
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
      Navigator.pushReplacementNamed(context, HomeScreen.route);
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(helper.getTranslated(context, AppTags.somethingWentWrong))));
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

  @override
  Widget build(BuildContext context) {
    printLog("_SignupScreenState");
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          helper.getTranslated(context, AppTags.signUp),
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.fill,
            image: isDark
                ? AssetImage('assets/images/login_screen_dark.png')
                : AssetImage('assets/images/login_screen_dark.png'),
          )),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppThemeData.wholeScreenPadding * 2),
                child: Column(
                  children: [
                               SizedBox(height: MediaQuery.of(context).size.height / 3.7),

                  //  _buildTopUI(context, isDark),
                    SizedBox(height: 10),
                    //first name
                    //_buildFullNameTF(),
                    CustomEditText().getCustomEditText(
                      isDark: isDark,
                      hintText:
                          helper.getTranslated(context, AppTags.firstName),
                      controller: _firstNameController,
                      keyboardType: TextInputType.name,
                      suffixWidget: Image.asset(
                        'assets/images/login_screen/user_name.png',
                        scale: 2.0,
                        height: 45.0,
                      ),
                    ),
                    //last name
                    //_buildFullNameTF(),
                    _fieldSpacing(),
                    CustomEditText().getCustomEditText(
                      isDark: isDark,
                      hintText:
                          helper.getTranslated(context, AppTags.lastName),
                      controller: _lastNameController,
                      keyboardType: TextInputType.name,
                      suffixWidget: Image.asset(
                        'assets/images/login_screen/user_name.png',
                        scale: 2.0,
                        height: 45.0,
                      ),
                    ),
                    //email field
                    _fieldSpacing(),
                    CustomEditText().getCustomEditText(
                      isDark: isDark,
                      hintText:
                          helper.getTranslated(context, AppTags.email),
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      suffixWidget: Image.asset(
                        'assets/images/login_screen/email.png',
                        scale: 2.0,
                        height: 45.0,
                      ),
                    ),

                    //password field
                    _fieldSpacing(),
                    CustomEditText().getCustomEditText(
                      isDark: isDark,
                      hintText:
                          helper.getTranslated(context, AppTags.password),
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureValue: true,
                      suffixWidget: Image.asset(
                        'assets/images/login_screen/password.png',
                        scale: 2.0,
                        height: 45.0,
                      ),
                    ),

                    //confirm password field
                    _fieldSpacing(),
                    CustomEditText().getCustomEditText(
                      isDark: isDark,
                      hintText: helper.getTranslated(
                          context, AppTags.confirmPassword),
                      controller: _confirmPasswordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureValue: true,
                      suffixWidget: Image.asset(
                        'assets/images/login_screen/password.png',
                        scale: 2.0,
                        height: 45.0,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomButtonGradient(
                            isDark: isDark,
                            width: 150,
                            text: helper.getTranslated(context, AppTags.signUpNow),
                            onPressed: () {
                              _signUp();
                            }),

                        //Spacer(),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Visibility(
                                visible: Config.enablePhoneLogin,
                                child: SocialLoginButton(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PhoneAuthScreen(
                                        repository: PhoneAuthRepository(
                                            FirebaseAuth.instance),
                                      ),
                                    ));
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
                    SizedBox(height: 25.0,),
                    _buildSignInButton(),
                    SizedBox(height: 25.0,),
                  ],
                ),
              ),

              //loading indicator
              Visibility(
                visible: isLoading,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignInButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () async {
          //navigate to sign in screen
          Navigator.pushNamed(context, LoginScreen.route);
        },
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: helper.getTranslated(context, AppTags.alreadyHaveAccount),
                style: TextStyle(
                    color: Color(0xff9FA9C5),
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto'),
              ),
              TextSpan(
                text: ' ' +
                    helper.getTranslated(context, AppTags.signInLowerCase),
                style: TextStyle(
                    color: Color(0xff008CD5),
                    fontSize: 16.0,
                    fontFamily: 'Roboto'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _signUp() async {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
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
      String firstName = _firstNameController.text.trim();
      String lastName = _lastNameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      SignUp? signUpResponse = await Repository().signUp(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password);
      if (signUpResponse != null && signUpResponse.success) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(
            content: Text(signUpResponse.message),
            backgroundColor: Colors.green,
          ));
        //after complete registration user will go to login screen and email verification
        Navigator.pushNamedAndRemoveUntil(
            context, LoginScreen.route, (Route<dynamic> route) => false);
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
}

Widget _buildTopUI(BuildContext context, bool isDark) {
  return Image.asset(
    isDark
        ? 'assets/images/logo_round_dark.png'
        : 'assets/images/logo_round_light.png',
    scale: 4,
  );
}

Widget _fieldSpacing() {
  return SizedBox(height: 20);
}

//phone sign in section
//final FirebaseAuth _auth = FirebaseAuth.instance;