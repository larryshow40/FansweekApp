import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/widgets/custom_button.dart';
import 'package:onoo/src/widgets/custom_edit_text.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class ForgetPasswordScreen extends StatefulWidget {
  static final String route = '/ForgetPasswordScreen';

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool isDark = false;
  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          helper.getTranslated(context, AppTags.forgotPassword),
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppThemeData.wholeScreenPadding),
        child: Center(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //email
                  CustomEditText().getCustomEditText(
                    isDark: isDark,
                    hintText:
                        helper.getTranslated(context, AppTags.emailAddress),
                    controller: _emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    suffixWidget: Image.asset(
                      'assets/images/login_screen/user_name.png',
                      scale: 2.0,
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  CustomButtonGradient(
                      isDark: isDark,
                      width: 200,
                      text: helper.getTranslated(context, AppTags.sendLink),
                      onPressed: () {
                        _forgetPassword();
                      }),

                  Opacity(
                    opacity: isLoading ? 1.0 : 0.0,
                    child: Center(
                      child: LoadingIndicator(),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _forgetPassword() async {
    if (_emailController.text.isNotEmpty) {
      setState(() {
        isLoading = true;
        FocusScope.of(context).unfocus();
      });
      http.Response response =
          await Repository().forgotPassword(email: _emailController.text);
      var jsonResponse = jsonDecode(response.body);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(jsonResponse['message'])));

      setState(() {
        isLoading = false;
      });
    }
  }
}
