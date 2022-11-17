import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:onoo/config.dart';
import 'package:onoo/request.dart';
import 'package:onoo/src/data/helper/date_helper.dart';
import 'package:onoo/src/data/model/auth/onno_user.dart';
import 'package:onoo/src/data/model/prediction_model.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/match_more_details/match_more_details.dart';
import 'package:onoo/src/presentation/sign_in/login_screen.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/widgets/custom_button.dart';
import 'package:onoo/src/widgets/prediction_list.dart';
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
  final APIService apiService = APIService();
  List<PredictionData> todayPredictiondataList = [];
  List<PredictionData> tomorrowPredictiondataList = [];
  List<PredictionData> nextPredictiondataList = [];
  var publicKey = '[YOUR_PAYSTACK_PUBLIC_KEY]';
  final plugin = PaystackPlugin();
  String selectedDate = " ";
  late Timer _timer;
  int _start = 5;
  bool isTimerOff = false;

  List<String> federations = [];
  List<String> markets = [];
  bool loading = false;
  int tabIndex = 0;
  DateTime now = DateTime.now();
  String todaysDate = "";
  String tomorrowsDate = "";
  String nextTomorrowsDate = "";
  Future<List<PredictionData>> fetchPredictions(date, fed, market) async =>
      apiService.getPredictions(date, _fedValue, _marketValue);

  bool isLiked = false;
  late bool isSubscribed = false;
  late int id;
  late String email;
  late String token;

  String _fedValue = "";
  String _marketValue = "";
  String hint1 = "Federations";
  String hint2 = "Market";
  dayAfterTomorrow() {
    final months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return "${months[DateTime.now().month - 1]} ${DateTime.now().day + 2}";
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

  void getTodayPredictions(todaysDate) {
    fetchPredictions(todaysDate, "", "").then((value) => {
          setState(() {
            todayPredictiondataList = value;
            print(todayPredictiondataList);
          })
        });
  }

  void getFilteredPredictions(todaysDate, fedValue, market) {
    fetchPredictions(todaysDate, fedValue, market).then((value) => {
          setState(() {
            todayPredictiondataList = value;
            print(todayPredictiondataList);
          })
        });
  }

  void getTomorrowPredictions(tomorrowsDate) {
    fetchPredictions(tomorrowsDate, "", "").then((value) => {
          setState(() {
            tomorrowPredictiondataList = value;
            print(tomorrowPredictiondataList);
          })
        });
  }

  void getNextTomorrowPredictions(nextTomorrowsDate) {
    fetchPredictions(nextTomorrowsDate, "", "").then((value) => {
          setState(() {
            nextPredictiondataList = value;
            print(nextPredictiondataList);
          })
        });
  }

  getData() async {
    setState(() {
      loading = true;
    });
    federations = await APIService.federationsOptions();
    markets = await APIService.marketsOptions();
    print(federations);
    setState(() {
      loading = false;
    });
  }

  Widget filter(List<String> list, bool fed, String hint) {
    return Expanded(
      child: Container(
        height: 40,
        width: 125,
        decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(10))),
        child: DropdownButton<String>(
          isExpanded: true,
          iconSize: 0.0,
          underline: SizedBox(),
          hint: fed
              ? _fedValue == ""
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(hint,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 25,
                            color: Colors.white,
                          )
                        ],
                      ))
                  : Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_fedValue,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 25,
                            color: Colors.white,
                          )
                        ],
                      ),
                    )
              : _marketValue == ""
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(hint,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 25,
                            color: Colors.white,
                          )
                        ],
                      ))
                  : Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(_marketValue,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 25,
                            color: Colors.red,
                          )
                        ],
                      ),
                    ),
          items: list.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (_) {
            print(_);
            setState(() {
              fed ? _fedValue = _! : _marketValue = _!;
              fed
                  ? getFilteredPredictions(todaysDate, _fedValue, "")
                  : getFilteredPredictions(todaysDate, "", _marketValue);
            });
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    todaysDate = "${now.year}-${now.month}-${now.day}";
    getData();
    print("line 51");
    getTodayPredictions(todaysDate);

    plugin.initialize(
        publicKey: "pk_live_149845f20ad29777e6a3a8e24a90d054cdd3742e");

    if (DatabaseConfig().isUserLoggedIn()) {
      int uid = DatabaseConfig().getOnooUser()!.id!;
      token = DatabaseConfig().getOnooUser()!.token!;
      print(token);

      print("The id is $uid");

      checkSubscription(uid).then((value) => setState(() {
            isSubscribed = value;
          }));
    }
    startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = DatabaseConfig().isUserLoggedIn();
    bool isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    if (DatabaseConfig().isUserLoggedIn()) {
      id = DatabaseConfig().getOnooUser()!.id!;
      email = DatabaseConfig().getOnooUser()!.email!;
    }

    return isLoggedIn
        ? isSubscribed
            ? SafeArea(
                child: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                    appBar: AppBar(
                      // backgroundColor: appStore.appBarColor,
                      // backgroundColor: Colors.red,
                      // backgroundColor: AppBarData.
                      title: Text('PREDICTIONS',
                          style: Theme.of(context).textTheme.headline3),
                      centerTitle: true,
                      bottom: PreferredSize(
                        child: loading
                            ? SizedBox()
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            // height: 100,
                                            child: TextField(
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(20.0),
                                                    ),
                                                  ),
                                                  prefixIcon:
                                                      Icon(Icons.search),
                                                  labelText: 'Search'),
                                            ),
                                            height: 40,
                                            // width: MediaQuery.of(context).size.width/1.2,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20))),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                          height: 60,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  // TabBar(
                                  //   onTap: (int value) {
                                  //     tabIndex = value;
                                  //     print("the value is $value");
                                  //     if (value == 0) {
                                  //       getTodayPredictions(todaysDate);
                                  //       print("the date is $todaysDate");
                                  //     }
                                  //     if (value == 1) {
                                  //       setState(() {
                                  //         tomorrowsDate = DateHelper().nextDay(
                                  //             now.year, now.month, now.day);
                                  //       });

                                  //       getTomorrowPredictions(tomorrowsDate);
                                  //       print("the date is $tomorrowsDate");
                                  //     }
                                  //     if (value == 2) {
                                  //       setState(() {
                                  //         nextTomorrowsDate = DateHelper()
                                  //             .nextTomorrow(DateHelper()
                                  //                 .nextDay(now.year, now.month,
                                  //                     now.day));
                                  //       });
                                  //       getNextTomorrowPredictions(
                                  //           nextTomorrowsDate);
                                  //       print("the date is $nextTomorrowsDate");
                                  //     }
                                  //   },
                                  //   unselectedLabelColor: Colors.grey,
                                  //   tabs: <Widget>[
                                  //     Tab(
                                  //       text: 'Today',
                                  //     ),
                                  //     Tab(
                                  //       text: 'Tomorrow',
                                  //     ),
                                  //     Tab(
                                  //       text: dayAfterTomorrow(),
                                  //     ),
                                  //   ],
                                  // ),
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  Container(
                                    color: Color(0xFF161A25),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1, left: 10, right: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          filter(federations, true, hint1),
                                          SizedBox(width: 10),
                                          filter(markets, false, hint2),
                                          SizedBox(width: 10),
                                          GestureDetector(
                                            onTap: () {
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
                                                  selectedDate =
                                                      '${date.year}-${date.month}-${date.day}';
                                                  getFilteredPredictions(
                                                      selectedDate, "", "");
                                                });
                                                print(
                                                    'confirm ${date.year}-${date.month}-${date.day} ');
                                              },
                                                  currentTime: DateTime.now(),
                                                  locale: LocaleType.en);
                                            },
                                            child: Container(
                                              child: Icon(
                                                Icons.date_range_outlined,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                              // height: 40,
                                              //  width: 80,
                                              decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(20))),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        preferredSize: Size.fromHeight(80.0),
                      ),

                      // title: Text('TabBar with Title and Icon', style: boldTextStyle(color: appStore.textPrimaryColor, size: 20)),
                      // bottom: TabBar(
                      //   onTap: (index) {
                      //     print(index);
                      //   },
                      //   labelStyle: Theme.of(context).textTheme.headline3,
                      //   indicatorColor: Colors.red,
                      //   physics: BouncingScrollPhysics(),
                      //   labelColor: Colors.red,
                      //   tabs: [
                      //     Tab(
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Icon(Icons.home, color: Colors.white),
                      //           // 5.width,
                      //           Text(
                      //             'Today',
                      //             //style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Tab(
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Icon(Icons.insert_drive_file, color: Colors.white
                      //               // color: appStore.iconSecondaryColor,
                      //               ),
                      //           // 5.width,
                      //           Text(
                      //             'Tomorrow',
                      //             style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //     Tab(
                      //       child: Row(
                      //         mainAxisAlignment: MainAxisAlignment.center,
                      //         crossAxisAlignment: CrossAxisAlignment.center,
                      //         mainAxisSize: MainAxisSize.min,
                      //         children: [
                      //           Icon(Icons.supervised_user_circle, color: Colors.yellow),
                      //           // 5.width,
                      //           Text(
                      //             dayAfterTomorrow(),
                      //             style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ),
                    body: TabBarView(
                      children: [
                        Container(
                          color: Color(0xFF161A25),
                          padding: EdgeInsets.all(16),
                          alignment: Alignment.center,
                          // width: context.width(),
                          child: todayPredictiondataList.length <= 0
                              ? CircularProgressIndicator()
                              : PredictionList(data: todayPredictiondataList),
                        ),
                        Container(
                            color: Color(0xFF161A25),
                            padding: EdgeInsets.all(16),
                            alignment: Alignment.center,
                            // width: context.width(),
                            child: tomorrowPredictiondataList.length <= 0
                                ? CircularProgressIndicator()
                                : PredictionList(
                                    data: tomorrowPredictiondataList)),
                        Container(
                            color: Color(0xFF161A25),
                            padding: EdgeInsets.all(16),
                            alignment: Alignment.center,
                            // width: context.width(),
                            child: nextPredictiondataList.length <= 0
                                ? CircularProgressIndicator()
                                : PredictionList(data: nextPredictiondataList)),
                      ],
                    ),
                  ),
                ),
              )
            : isTimerOff
                ? Material(child: _subscribePaystack(context, isDark))
                : Material(
                    child: Center(
                      child: CircularProgressIndicator(),
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
              ? AssetImage('assets/images/splash_screen_light.png')
              : AssetImage('assets/images/splash_screen_light.png'),
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

  Widget _subscribePaystack(context, isDark) {
    return WillPopScope(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.fill,
                image: isDark
                    ? AssetImage('assets/images/splash_screen_dark.png')
                    : AssetImage('assets/images/splash_screen_light.png'),
              )),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height / 4),
                  //_buildTopUI(isDark),
                  SizedBox(height: 250),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: Column(
                      children: [
                        //sign up button
                        CustomButtonGradient(
                            isDark: false,
                            text: "Subscribe N1,000",
                            onPressed: () {
                              setState(() {
                                final provider = Provider.of<ThemeProvider>(
                                    context,
                                    listen: false);
                                provider.toggleTheme(false);
                              });

                              chargeCard(1);
                            }),
                        // //social login button

                        Padding(
                            padding:
                                EdgeInsets.only(top: 35, left: 50, right: 50),
                            child:
                                Text("A subscription is required for access")),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        onWillPop: onWillPop);
  }

  Future<bool> onWillPop() async {
    setState(() {
      final provider = Provider.of<ThemeProvider>(context, listen: false);
      provider.toggleTheme(true);
    });
    return true; // return true if the route to be popped
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
      ..amount = 1000 * 100
      ..reference = _getReference()

      // or ..accessCode = _getAccessCodeFrmInitialization()
      ..email = email;
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

  ListView futureBody(List<String> competitionNames, BuildContext context,
      AsyncSnapshot<List<Map<String, dynamic>>> data) {
    return ListView.builder(
      itemCount: competitionNames.length,
      itemBuilder: (_, index) {
        final item = competitionNames[index];
        return Container(
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 25,
                width: MediaQuery.of(context).size.width,
                color: Color(0xFF161A25),
                alignment: Alignment.centerLeft,
                child: Text(
                  '  $item',
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
                ),
              ),
              ...data.data!
                  .where((element) =>
                      element['competition_name'] == competitionNames[index])
                  .map(
                    (item) => Column(
                      children: [
                        Container(
                          color: Color(0xFF161A25),
                          child: ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${item['home_team']}",
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "${item['away_team']}",
                                        textAlign: TextAlign.left,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 20,
                                  color: Colors.grey,
                                ),
                                // Text(
                                //   "${validateTime(item['start_date'])}",
                                //   style: TextStyle(
                                //       color: Colors.white,
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.bold),
                                // ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Tip',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Odds",
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${item['prediction']}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "${item['odds']['1']}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            trailing: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 13,
                              color: Colors.white,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => MatchMoreDetails(item['id']),
                                ),
                              );
                            },
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                          thickness: 1.5,
                          height: 0,
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTopUI(bool isDark) {
    return isDark
        ? Image.asset('assets/images/logo_round_dark.png', scale: 4)
        : Image.asset('assets/images/logo_round_light.png', scale: 4);
  }
}
