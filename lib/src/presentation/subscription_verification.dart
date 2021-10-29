import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:onoo/config.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/sign_in/login_screen.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as cnv;

import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:flutter_paystack/flutter_paystack.dart';

class SubscriptionScreen extends StatefulWidget {
  static final String route = '/SubscriptionScreen';
  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  var publicKey = '[YOUR_PAYSTACK_PUBLIC_KEY]';
  final plugin = PaystackPlugin();

  bool isLiked = false;
  bool isSubscribed = false;
  late int id;
  late String token;
  @override
  void initState() {
    if (DatabaseConfig().isUserLoggedIn()) {
      int uid = DatabaseConfig().getOnooUser()!.id!;
      token = DatabaseConfig().getOnooUser()!.token!;
      print(token);

      print("The id is $uid");

      checkSubscription(uid).then((value) => isSubscribed = value);
    }
    plugin.initialize(
        publicKey: "pk_test_ad1cdc33f2e01d79ffb44f39b3bb4e04613f8e43");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = DatabaseConfig().isUserLoggedIn();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    if (DatabaseConfig().isUserLoggedIn()) {
      id = DatabaseConfig().getOnooUser()!.id!;
    }

    return isLoggedIn
        ? isSubscribed
            ? Scaffold(
                body: Center(child: Text('You are a subscriber')),
              )
            : Material(child: _subscribePaystack(context, isDark))
        : Material(child: _profileWithoutLogin(context, isDark));
  }

  codeLike(int codeId) async {
    var url = Uri.parse("https://fansweek.com/api/like-code");

    var headers = {
      "apiKey": Config.API_KEY,
      'Authorization': 'Bearer $token',
    };
    var body = {"code_id": codeId.toString()};
    final client = new http.Client();
    final response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      //TODO:: CHANGE SUCCESS TO MESSAGE

      print('The message is ${response.statusCode}');

      return jsonDecode(response.body)["message"];
    }
    if (response.statusCode != 200) {
      print("there is an error!");
      print('The message is ${response.body}');
    }
  }

  Future<bool> checkSubscription(int id) async {
    String url =
        'https://fansweek.com/api/v10/user/user-details-by-id?id=${id.toString()}';
    var headers = {
      "apiKey": Config.API_KEY,
      'Authorization': 'Bearer $token',
    };

    print(url);
    final res = await http.Client().get(
      Uri.parse(url),
      headers: headers,
    );
    // print(res);
    var jsonResponse = cnv.jsonDecode(res.body);
    print(jsonResponse);
    final value = jsonResponse['data']['isSubscribed'];

    return value;
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
            SizedBox(height: MediaQuery.of(context).size.height / 4),
            _buildTopUI(isDark),
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                children: [
                  //sign up button
                  CustomButtonGradient(
                      isDark: isDark,
                      text:
                          "${helper.getTranslated(context, AppTags.signUp)}/${helper.getTranslated(context, AppTags.signIn)}",
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.route);
                      }),
                  //social login button
                  Padding(
                      padding: EdgeInsets.only(top: 35, left: 55, right: 55),
                      child: Text("You must be signed in to continue")),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _subscribePaystack(context, isDark) {
    return Scaffold(
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
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 4),
              _buildTopUI(isDark),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Column(
                  children: [
                    //sign up button
                    CustomButtonGradient(
                        isDark: isDark,
                        text: "Subscribe",
                        onPressed: () {
                          chargeCard(1);
                        }),
                    //social login button
                    Padding(
                        padding: EdgeInsets.only(top: 35, left: 50, right: 50),
                        child: Text("A subscription is required for access")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }
    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  chargeCard(int id) async {
    Charge charge = Charge()
      ..amount = 100 * 100
      ..reference = _getReference()

      // or ..accessCode = _getAccessCodeFrmInitialization()
      ..email = "adeyemi.pj@gmail.com";
    CheckoutResponse response = await plugin.checkout(context,
        method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
        charge: charge,
        fullscreen: false);

    if (response.status == true) {
      print('the response is good ${response.message}');
    } else {
      print('the response is false');

      print('The response is bad ${response.message}');
    } 
  }

  Widget _buildTopUI(bool isDark) {
    return isDark
        ? Image.asset('assets/images/logo_round_dark.png', scale: 4)
        : Image.asset('assets/images/logo_round_light.png', scale: 4);
  }
}
