import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onoo/src/data/phone_auth_repository.dart';
import 'package:onoo/src/presentation/all_tags_screen.dart';
import 'package:onoo/src/presentation/author/author_screen.dart';
import 'package:onoo/src/presentation/comment/reply_screen.dart';
import 'package:onoo/src/presentation/forget_password_screen.dart';
import 'package:onoo/src/presentation/home_screen.dart';
import 'package:onoo/src/presentation/intro_screen.dart';
import 'package:onoo/src/presentation/post_details_screen.dart';
import 'package:onoo/src/presentation/profile/edit_profile.dart';
import 'package:onoo/src/presentation/search_screen.dart';
import 'package:onoo/src/presentation/settings/settings.dart';
import 'package:onoo/src/presentation/sign_in/login_screen.dart';
import 'package:onoo/src/presentation/sign_up/phone_auth/phone_auth_screen.dart';
import 'package:onoo/src/presentation/sign_up/sign_up.dart';
import 'package:onoo/src/presentation/sub_cat_post_screen.dart';
import 'package:onoo/src/presentation/trending_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoute() {
    return <String, WidgetBuilder>{
      LoginScreen.route: (_) => LoginScreen(),
      HomeScreen.route: (_) => HomeScreen(),
      SignupScreen.route: (_) => SignupScreen(),
      PhoneAuthScreen.route: (_) => PhoneAuthScreen(repository: PhoneAuthRepository(FirebaseAuth.instance)),
      AuthorScreen.route: (_) => AuthorScreen(),
      TrendingScreen.route: (_) => TrendingScreen(),
      PostDetailsScreen.route: (_) => PostDetailsScreen(),
      CommentReplyScreen.route: (_) => CommentReplyScreen(),
      SettingsScreen.route: (_) => SettingsScreen(),
      AllTagsScreen.route: (_) => AllTagsScreen(),
      IntroScreen.route: (_) => IntroScreen(),
      SearchScreen.route: (_) => SearchScreen(),
      SubCatPostsScreen.route: (_) => SubCatPostsScreen(),
      ForgetPasswordScreen.route: (_) => ForgetPasswordScreen(),
      EditProfile.route: (_) => EditProfile(),
    };
  }
}
