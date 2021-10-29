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
import 'package:share/share.dart';
import 'dart:convert' as cnv;
import 'data_model.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:flutter_paystack/flutter_paystack.dart';

class DiscoverScreen extends StatefulWidget {
  static final String route = '/DiscoverScreen';
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
 // var publicKey = '[YOUR_PAYSTACK_PUBLIC_KEY]';
  final plugin = PaystackPlugin();
  late List<Data> model = [];
  bool isLiked = false;
  bool isSubscribed = false;
  late int id;
  late String token;
  @override
  void initState() {
    print(model);

    print(model);
    if (DatabaseConfig().isUserLoggedIn()) {
      int uid = DatabaseConfig().getOnooUser()!.id!;
      token = DatabaseConfig().getOnooUser()!.token!;
      print(token);
      getData();
      print("The id is $uid");

     
    }


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
       
            ? Scaffold(
                appBar: AppBar(
                  title: Text('Fansweek Codes'),
                ),
                // body: model.length < 1
                body: model.length < 1
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: ListTile(
                              title: Text(model[index].code),
                              subtitle: Text(
                                  "${model[index].name} by ${model[index].user.substring(0, 5)}"),
                              // date: Text(model[index].name),
                              // subtitle: Text(model[index].body),
                              leading: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(model[index]
                                          .createdAt
                                          .substring(3, 6)),
                                      Text(
                                        model[index].createdAt.substring(0, 2),
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CircleAvatar(
                                      backgroundImage:
                                          AssetImage("assets/soccer.png")),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  //  Text(model[index].user.substring(0, 5)),

                                  IconButton(
                                      onPressed: () {
                                        if (model[index].liked) {
                                          setState(() {
                                            model[index].liked = false;
                                            model[index].likesCount =
                                                (int.parse(model[index]
                                                            .likesCount) -
                                                        1)
                                                    .toString();
                                          });
                                          codeLike(int.parse(model[index].id));
                                        } else if (!model[index].liked) {
                                          setState(() {
                                            model[index].liked = true;
                                            model[index].likesCount =
                                                (int.parse(model[index]
                                                            .likesCount) +
                                                        1)
                                                    .toString();
                                          });
                                          codeLike(int.parse(model[index].id));
                                        }
                                      },
                                      icon: model[index].liked
                                          ? Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.favorite_border,
                                            )),
                                  Text(model[index].likesCount),

                                  IconButton(
                                      onPressed: () {
                                        // Share.share('check out my website https://example.com', subject: 'Look what I made!');
                                        Share.share(model[index].code);
                                      },
                                      icon: Icon(Icons.share)),
                                  // IconButton(onPressed: () {}, icon: Icon(Icons.comment)),
                                ],
                                // LikeButton(),
                              ),
                              // trailing: Icon(Icons.star)),
                            ),
                          );
                        },
                        itemCount: model.length,
                      ),
              )
           
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

  Future<void> getData() async {
    // print('Getting Data ====');
    // Uri url = Uri.https('jsonplaceholder.typicode.com', '/posts');
    String url = 'https://fansweek.com/api/list-codes';
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
    final parsed = jsonResponse['data'].cast<Map<String, dynamic>>();
    // print(parsed);
    model = parsed.map<Data>((json) => Data.fromJson(json)).toList();
    var model1 = parsed[1]['id'];
    print("The model1 is $model1");
    // print(parsed);

    setState(() {});
    // print(res.body);
    // http.Response res = await http.get(url);
    // print(url);

    // print(res.body);
    // var body = cnv.jsonDecode(res.body);
    // var list = body['data'];
    // print(list);
    // model = body
    //     .map<DataModel>((dynamic item) => DataModel.fromJson(item))
    //     .toList();
    // print(list.runtimeType);
    // model = list.map((i) => Data.fromJson(i)).toList();
    // List<Data> newlist = list.map((i) => Data.fromJson(i)).toList();
    // print(newlist);
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
  
  Widget _buildTopUI(bool isDark) {
    return isDark
        ? Image.asset('assets/images/logo_round_dark.png', scale: 4)
        : Image.asset('assets/images/logo_round_light.png', scale: 4);
  }
}
