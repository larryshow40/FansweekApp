import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:share/share.dart';
import 'package:onoo/config.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/sign_in/login_screen.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as cnv;
import '../../../app_theme_data.dart';
import 'data_model.dart';

class DiscoverScreen extends StatefulWidget {
  static final String route = '/DiscoverScreen';
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  late List<Data> model = [];
  late String token;
  late bool isLiked;
  TextEditingController endDateController = TextEditingController();
  late String betComp = '';
  late String betCode = '';
  late String endDate = '';

  late Timer _timer;
  int _start = 20;
  bool isTimerOff = false;
  @override
  void initState() {
    print(model);
    print(model);
    endDateController.text = '';
    if (DatabaseConfig().isUserLoggedIn()) {
      int uid = DatabaseConfig().getOnooUser()!.id!;
      token = DatabaseConfig().getOnooUser()!.token!;
      print(token);
      print("The id is $uid");
      // startTimer();
      getData();
    }
    super.initState();
  }

  void startTimer() {
    const duration = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      duration,
      (Timer timer) => setState(
        () {
          if (_start < 1) {
            print('Timer stopped');
            isTimerOff = true;
            timer.cancel();
          } else {
            _start = _start - 1;
            print(_start);
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = DatabaseConfig().isUserLoggedIn();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return isLoggedIn
        ? Scaffold(
            appBar: AppBar(
              //tetsing something 
              backgroundColor: isDark
            ? AppThemeData.darkBackgroundColor
            : AppThemeData.lightBackgroundColor,
        title: Center(
          child: Container(
            child: isDark
                ? Image.asset(
                    "assets/images/Fansweek codes.png",
                    height: 40,
                  )
                : Image.asset(
                    'assets/images/Fansweek codes.png',
                    height: 40,
                  ),
          ),
        ),

              //end of testing 
              // title: Text(' Betting Codes'),
              actions: <Widget>[
                // Text('Share Code'),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 10,
                    //         padding: const EdgeInsets.only(
                    //             top: 1, left: 10, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: TextButton(
                      style: ButtonStyle(),
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          Text(
                            'Share Code',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      onPressed: () {
                        // do something
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                scrollable: true,
                                title: Text('Share Betting Codes'),
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Form(
                                    child: Column(
                                      children: <Widget>[
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Betting Company',
                                            icon: Icon(Icons.account_box),
                                          ),
                                          onChanged: (input) => betComp = input,
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Betting Code',
                                            icon: Icon(Icons.arrow_right),
                                          ),
                                          onChanged: (input) => betCode = input,
                                        ),
                                        TextFormField(
                                          controller: endDateController,
                                          // initialValue: endDateController.text,
                                          decoration: InputDecoration(
                                            labelText: 'End Date',
                                            icon: Icon(Icons.date_range),
                                          ),
                                          onChanged: (input) => endDate = input,
                                          onTap: () async {
                                            //  _selectDate(context);
                                            DatePicker.showDatePicker(context,
                                                showTitleActions: true,
                                                minTime: DateTime(2018, 3, 5),
                                                theme: DatePickerTheme(
                                                    headerColor: Colors.white,
                                                    backgroundColor:
                                                        Colors.white,
                                                    itemStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18),
                                                    doneStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16)),
                                                onChanged: (date) {
                                              print(
                                                  'change $date in time zone ' +
                                                      date.timeZoneOffset
                                                          .inHours
                                                          .toString());
                                            }, onConfirm: (date) {
                                              setState(() {
                                                endDateController.text =
                                                    '${date.year}-${date.month}-${date.day}';
                                                endDate =
                                                    '${date.year}-${date.month}-${date.day}';
                                              });
                                              print(
                                                  'confirm ${date.year}-${date.month}-${date.day} ');
                                            },
                                                currentTime: DateTime.now(),
                                                locale: LocaleType.en);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  RaisedButton(
                                      child: Text("Share Code"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        // your code
                                        shareCode();
                                      })
                                ],
                              );
                            });
                      },
                    ),
                  ),
                )
              ],
            ),

            // body: model.length < 1

            body: model.length < 1
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Row(
                          children: [
                            Container(
                              width: 30,
                              child: Column(
                                children: [
                                  Text(model[index].createdAt.substring(0, 2)),
                                  Text(model[index].createdAt.substring(3, 6)),
                                ],
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(model[index].code),
                                subtitle: Text(
                                    "${model[index].name} by ${model[index].user.substring(0, 5)}"),
                                // subtitle: Text(model[index].body),
                                leading: CircleAvatar(
                                    // backgroundImage: AssetImage("assets/images/soccer.png")),
                                    backgroundImage:
                                        AssetImage("assets/images/soccer.png")),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(model[index].likesCount),
                                    model[index].liked
                                        ? IconButton(
                                            onPressed: () {
                                              if (model[index].liked) {
                                                codeLike(
                                                    int.parse(model[index].id));

                                                setState(() {
                                                  model[index].liked = false;
                                                  model[index].likesCount =
                                                      (int.parse(model[index]
                                                                  .likesCount) -
                                                              1)
                                                          .toString();
                                                });
                                              } else {
                                                codeLike(
                                                    int.parse(model[index].id));

                                                setState(() {
                                                  model[index].liked = true;
                                                  model[index].likesCount =
                                                      (int.parse(model[index]
                                                                  .likesCount) +
                                                              1)
                                                          .toString();
                                                });
                                              }
                                            },
                                            icon: Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            ))
                                        : IconButton(
                                            onPressed: () {
                                              if (model[index].liked) {
                                                codeLike(
                                                    int.parse(model[index].id));

                                                setState(() {
                                                  model[index].liked = false;
                                                  model[index].likesCount =
                                                      (int.parse(model[index]
                                                                  .likesCount) -
                                                              1)
                                                          .toString();
                                                });
                                              } else {
                                                codeLike(
                                                    int.parse(model[index].id));

                                                setState(() {
                                                  model[index].liked = true;
                                                  model[index].likesCount =
                                                      (int.parse(model[index]
                                                                  .likesCount) +
                                                              1)
                                                          .toString();
                                                });
                                              }
                                            },
                                            icon: model[index].liked
                                                ? Icon(Icons.favorite)
                                                : Icon(Icons.favorite_border)),
                                    IconButton(
                                        onPressed: () {
                                          Share.share(model[index].code,
                                              subject: 'Share Code');
                                        },
                                        icon: Icon(Icons.share)),
                                  ],
                                  // LikeButton(),
                                ),
                                // trailing: Icon(Icons.star)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: model.length,
                  ),
          )
        : Material(child: _profileWithoutLogin(context, isDark));
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
    final res = await http.Client().get(Uri.parse(url), headers: headers);
    // print(res);
    var jsonResponse = cnv.jsonDecode(res.body);
    print(jsonResponse);
    final parsed = jsonResponse['data'].cast<Map<String, dynamic>>();
    // print(parsed);
    model = parsed.map<Data>((json) => Data.fromJson(json)).toList();
    //var model1 = parsed[1]['id'];
    //print("The model1 is $model");
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

  shareCode() async {
    var url = Uri.parse("https://fansweek.com/api/share-code");

    var headers = {
      "apiKey": Config.API_KEY,
      'Authorization': 'Bearer $token',
    };
    var body = {
      'bet_company': betComp,
      'bet_code': betCode,
      'end_date': endDate,
    };
    final client = new http.Client();
    final response = await client.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      //TODO:: CHANGE SUCCESS TO MESSAGE
      showDialog(
          context: context,
          builder: (BuildContext modalContext) {
            return AlertDialog(
              title: Text('Success!'),
              content: Text('Thank you for sharing!'),
              actions: [
                RaisedButton(
                    child: Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            );
          });

      print('The message is ${response.statusCode}');

      return jsonDecode(response.body)["message"];
    }
    if (response.statusCode != 200) {
      print("there is an error!");
      print('The message is ${response.body}');
    }
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
              ? AssetImage('assets/images/splash_screen_dark.png')
              : AssetImage('assets/images/background_light.png'),
        )),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height / 2),
            //  _buildTopUI(isDark),
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
}
