import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/helper/auth_helper.dart';
import 'package:onoo/src/data/model/auth/onno_user.dart';
import 'package:onoo/src/data/model/common/common_post.dart';
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/profile/edit_profile.dart';
import 'package:onoo/src/presentation/settings/settings.dart';
import 'package:onoo/src/presentation/sign_in/login_screen.dart';
import 'package:onoo/src/presentation/sign_up/phone_auth/phone_auth_screen.dart';
import 'package:onoo/src/presentation/sign_up/sign_up.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:onoo/src/widgets/custom_button.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';
import '../home_screen.dart';
import '../post_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isFromDrawer;

  const ProfileScreen({Key? key, required this.isFromDrawer}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<List<CommonPostModel>> posts;
  bool isLoading = false;
  late int id;

  @override
  void initState() {
    super.initState();
    if (DatabaseConfig().isUserLoggedIn()) {
      int id = DatabaseConfig().getOnooUser()!.id!;
      posts = Repository().getMyPosts(id: id);
    }
  }

  @override
  Widget build(BuildContext context) {
    printLog("_ProfileScreenState");
    bool isLoggedIn = DatabaseConfig().isUserLoggedIn();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    if (DatabaseConfig().isUserLoggedIn()) {
      id = DatabaseConfig().getOnooUser()!.id!;
    }

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              helper.getTranslated(context, AppTags.profile),
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          body: isLoggedIn
              ? _profileWithLogin(isDark)
              : _profileWithoutLogin(context, isDark)),
    );
  }

  Widget _profileWithLogin(isDark) {
    OnnoUser? user = DatabaseConfig().getOnooUser();

    return SingleChildScrollView(
      child: Padding(
          padding: EdgeInsets.all(AppThemeData.wholeScreenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  new IconButton(
                    tooltip: "Edit",
                    icon: SvgPicture.asset(
                      "assets/images/icons/edit.svg",
                      height: 25,
                      width: 25,
                    ),
                    onPressed: () {
                      if (user!.token != null) {
                        Navigator.pushNamed(context, EditProfile.route);
                      }
                    },
                  ),
                  new IconButton(
                    tooltip: "Settings",
                    icon: SvgPicture.asset(
                      "assets/images/icons/settings.svg",
                      height: 25,
                      width: 25,
                      color:AppThemeData.socialIconColorDark,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, SettingsScreen.route);
                    },
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user!.firstName! + " " + user.lastName!,
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w400,
                              color: isDark
                                  ? AppThemeData.textColorDark
                                  : AppThemeData.textColorLight)),
                      // ignore: unnecessary_null_comparison
                      if(user != null)
                      Text(user.about!.length > 2 ? user.about! : "Bangladesh, Dhaka", style: TextStyle(fontSize: 18, color: Color(0xff999999)),),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                  Container(
                    height: 140,
                    width: 110,
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                          image: user.image != null && user.image != ""
                              ? NetworkImage(user.image!)
                              : new AssetImage("assets/images/logo_rectangle.png")
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            offset: Offset(0.0, 1.5),
                            blurRadius: 1.0,
                          ),
                        ]),
                  )
                ],
              ),
              SizedBox(height: 30),
              FutureBuilder<List<CommonPostModel>>(
                future: Repository().getMyPosts(id: id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return _buildMyPost(context, snapshot.data!);
                  }
                  return Center(
                    child: LoadingIndicator(),
                  );
                },
              )
            ],
          )),
    );
  }

  Widget _buildMyPost(BuildContext context, List<CommonPostModel> postList) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              helper.getTranslated(context, AppTags.myPost),
              style: Theme.of(context).textTheme.headline3,
            ),
            Text(
              helper.getTranslated(context, AppTags.wishList),
              style: Theme.of(context).textTheme.headline3,
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        //grid view
        Container(
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: (120 / 180),
            controller: ScrollController(keepScrollOffset: false),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            // to disable GridView's scrolling
            children: List.generate(postList.length, (index) {
              return InkWell(
                onTap: () {
                  //go to post detals  screen
                  Navigator.pushNamed(context, PostDetailsScreen.route,
                      arguments: {
                        'postId': postList[index].id,
                        'image': postList[index].image != null
                            ? postList[index].image!.bigImage ?? null
                            : null,
                      });
                },
                child: Stack(fit: StackFit.expand, children: [
                  Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              AppThemeData.cardBorderRadius)),
                      elevation: AppThemeData.cardElevation,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                            Radius.circular(AppThemeData.cardBorderRadius)),
                        child: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset("assets/images/logo_round.png",
                                    fit: BoxFit.contain),
                            placeholder: "assets/images/logo_round.png",
                            image: postList[index].image!.mediumImage!),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 10),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          postList[index].title,
                          maxLines: 4,
                          style: Theme.of(context).textTheme.headline4,
                        )),
                  ),
                ]),
              );
            }),
          ),
        ),
      ],
    );
  }

  void showSnackbar({required String message}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
          content: Text(
            message,
            style: Theme.of(context).textTheme.headline1,
          ),
          backgroundColor: Colors.red));
  }

  Widget _profileWithoutLogin(context, isDark) {
    return SingleChildScrollView(
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
        child: Column(
          children: [
            SizedBox(height: 60),
            _buildTopUI(isDark),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  //sign up button
                  CustomButtonGradient(
                      isDark: isDark,
                      text: helper.getTranslated(context, AppTags.signUp),
                      onPressed: () {
                        Navigator.pushNamed(context, SignupScreen.route);
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  //sign in button
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                        height: 50, width: double.infinity),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.route);
                      },
                      child: Text(
                        helper.getTranslated(context, AppTags.signIn),
                        style: TextStyle(color: Utils.getTextColor(isDark)),
                      ),
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(
                              color: isDark
                                  ? Utils.getTextColor(isDark)
                                  : Colors.black,
                              width: 1.0),
                          primary: isDark
                              ? AppThemeData.darkBackgroundColor
                              : Colors.white),
                    ),
                  ),

                  //social login button
                  Padding(
                    padding: EdgeInsets.only(top: 35, left: 55, right: 55),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          tooltip: "Phone Login",
                          icon: SvgPicture.asset(
                            'assets/images/login_screen/phone.svg',
                            color:isDark ? AppThemeData.socialIconColorDark : AppThemeData.textColorLight
                          ),
                          onPressed: () {
                            printLog('Login with phone');
                            Navigator.pushNamed(context, PhoneAuthScreen.route);
                          },
                        ),
                        if(Platform.isAndroid)
                        IconButton(
                          tooltip: "Facebook Login",
                          icon: SvgPicture.asset(
                            'assets/images/login_screen/facebook.svg',
                              color:isDark ? AppThemeData.socialIconColorDark : AppThemeData.textColorLight
                          ),
                          onPressed: () {
                            printLog('Login with Facebook');
                            _signInWithFacebook();
                          },
                        ),
                        if(Platform.isIOS)
                        //Apple_login_here
                        IconButton(
                          tooltip: "Apple Login",
                          icon: SvgPicture.asset(
                            'assets/images/login_screen/apple.svg',
                              color:isDark ? AppThemeData.socialIconColorDark : AppThemeData.textColorLight
                          ),
                          onPressed: () {
                            printLog('Login with Apple');
                            _loginWithApple();
                          },
                        ),
                        IconButton(
                          tooltip: "Google Login",
                          icon: SvgPicture.asset(
                              'assets/images/login_screen/google.svg',
                              color:isDark ? AppThemeData.socialIconColorDark : AppThemeData.textColorLight
                          ),
                          onPressed: () {
                            printLog('Login with google');
                            _loginWithGoogle();
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

//sign_in_with_google
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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong.\nPlease try again.")));
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
//sign_in_with_apple
//sign_in_with_google
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

  //build_screen_header
  Widget _buildTopUI(bool isDark) {
    return isDark
        ? Image.asset('assets/images/logo_round_dark.png', scale: 4)
        : Image.asset('assets/images/logo_round_light.png', scale: 4);
  }
}
