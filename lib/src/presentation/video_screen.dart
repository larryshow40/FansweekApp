import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:intl/intl.dart';

//import 'package:nb_utils/nb_utils.dart';
//import 'package:prokit_flutter/main.dart';
import 'package:onoo/request.dart';
import 'package:onoo/src/data/helper/date_helper.dart';
import 'package:onoo/src/data/model/auth/onno_user.dart';
import 'package:onoo/src/data/model/prediction_model.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/presentation/match_more_details/match_more_details.dart';
import 'package:onoo/src/presentation/subscription_verification.dart';
// import 'package:onoo/src/presentation/subscription_verification.dart';
import 'package:onoo/src/widgets/prediction_list.dart';

enum PredictionFor { Today, Tomorrow, After }
class TabBarDemo extends StatefulWidget {
  static String tag = "/MWTabBarScreen2";

  @override
  _MWTabBarScreen2State createState() => _MWTabBarScreen2State();
}

class _MWTabBarScreen2State extends State<TabBarDemo> {
  final APIService apiService = APIService();
  List<PredictionData> todayPredictiondataList = [];
  List<PredictionData> tomorrowPredictiondataList = [];
  List<PredictionData> nextPredictiondataList = [];
  final List<String> competitionNames = [];
  DateTime today = DateTime.now();
  String todaysDate = "";
  String tomorrowsDate = "";
  String nextTomorrowsDate = "";
  String _fedValue = "";
  String _marketValue = "";
  Future<List<PredictionData>> fetchPredictions(date, fed, market) async =>
      apiService.getPredictions(date, _fedValue, _marketValue);
//    String dateSwitch()
//     {
// if(tabIndex==0)
// {

// }
//     }

  @override
  void initState() {
    getData();
    todaysDate = "${today.year}-${today.month}-${today.day}";
    print("line 51");
    print (todaysDate);
    getTodayPredictions(todaysDate);
    super.initState();
  }

  void getTodayPredictions(todaysDate) {
    fetchPredictions(todaysDate, "", "").then((value) => {
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

  String validateTime(String date) {
    final time = date.split('T').last;
    final hM = time.split(':');
    return '${hM.first}:${hM[1]}';
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  List<String> federations = [];
  List<String> markets = [];
  bool loading = false;

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

  String hint1 = "Federations";
  String hint2 = "Market";
  int tabIndex = 0;
  DateTime now = DateTime.now();

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
                                  TextStyle(color: Colors.black, fontSize: 14)),
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
                                  TextStyle(color: Colors.black, fontSize: 14)),
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
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //  String selectedDate = "${now.year}-${now.month}-${now.day + 1}";

    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: appStore.appBarColor,
            // backgroundColor: Colors.red,
            // backgroundColor: AppBarData.
            title: Text('FREE PREDICTIONS',
                style: Theme.of(context).textTheme.headline3),
            centerTitle: true,
            bottom: PreferredSize(
              child: loading
                  ? SizedBox()
                  : Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Padding(
                        // padding: const EdgeInsets.only(left: 10, right: 10),
                        // child: Row(
                        //   children: [
                        //     // Expanded(
                        //   child: Container(
                        //     child: TextField(
                        //       decoration: InputDecoration(
                        //           border: OutlineInputBorder(
                        //             borderRadius: const BorderRadius.all(
                        //               Radius.circular(20.0),
                        //             ),
                        //           ),
                        //           prefixIcon: Icon(Icons.search),
                        //           labelText: 'Search'),
                        //     ),
                        //     height: 40,
                        //     // width: MediaQuery.of(context).size.width/1.2,
                        //     decoration: BoxDecoration(
                        //         border: Border.all(color: Colors.white),
                        //         borderRadius: BorderRadius.all(
                        //             Radius.circular(20))),
                        //   ),
                        // ),
                        // SizedBox(
                        //   width: 10,
                        // ),
                        //  ],
                        //   ),
                        //  ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        TabBar(
                          onTap: (int value) {
                            tabIndex = value;
                            print("the value is $value");
                            if (value == 0) {
                              getTodayPredictions(todaysDate);
                              print("the date is $todaysDate");
                            }
                            if (value == 1) {
                              setState(() {
                                tomorrowsDate = DateHelper().nextDay(
                                    today.year, today.month, today.day);
                              });

                              getTomorrowPredictions(tomorrowsDate);
                              print("the date is $tomorrowsDate");
                            }
                            if (value == 2) {
                              setState(() {
                                nextTomorrowsDate = DateHelper().nextTomorrow(
                                    DateHelper().nextDay(
                                        today.year, today.month, today.day));
                              });
                              getNextTomorrowPredictions(nextTomorrowsDate);
                              print("the date is $nextTomorrowsDate");
                            }
                          },
                          unselectedLabelColor: Colors.grey,
                          tabs: <Widget>[
                            Tab(
                              text: 'Today',
                            ),
                            Tab(
                              text: 'Tomorrow',
                            ),
                            Tab(
                              text: dayAfterTomorrow(),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Container(
                        //   color: Color(0xFF161A25),
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(
                        //         top: 5, left: 10, right: 10),
                        //     child: Row(
                        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //       children: [
                        //         filter(federations, true, hint1),
                        //         SizedBox(width: 10),
                        //         filter(markets, false, hint2),
                        //         SizedBox(width: 10),
                        Container(
                            height: 40,
                            padding: const EdgeInsets.only(
                                top: 1, left: 10, right: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            //Container(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SubscriptionScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Membership',
                                  style: TextStyle(color: Colors.red),
                                )))
                        // GestureDetector(
                        //   onTap: () {
                        //     DatePicker.showDatePicker(context,
                        //         showTitleActions: true,
                        //         minTime: DateTime(2018, 3, 5),
                        //         theme: DatePickerTheme(
                        //             headerColor: Colors.white,
                        //             backgroundColor: Colors.white,
                        //             itemStyle: TextStyle(
                        //                 color: Colors.black,
                        //                 fontWeight: FontWeight.bold,
                        //                 fontSize: 18),
                        //             doneStyle: TextStyle(
                        //                 color: Colors.black,
                        //                 fontSize: 16)),
                        //         onChanged: (date) {
                        //       print('change $date in time zone ' +
                        //           date.timeZoneOffset.inHours
                        //               .toString());
                        //     }, onConfirm: (date) {
                        //       setState(() {
                        //         selectedDate =
                        //             '${date.year}-${date.month}-${date.day}';
                        //       });
                        //       print(
                        //           'confirm ${date.year}-${date.month}-${date.day} ');
                        //     },
                        //         currentTime: DateTime.now(),
                        //         locale: LocaleType.en);
                        //   },
                        //   child: Container(
                        //     child: Icon(
                        //       Icons.date_range_outlined,
                        //       size: 25,
                        //       color: Colors.white,
                        //     ),
                        //     //  height: 40,
                        //     //  width: 80,
                        //     decoration: BoxDecoration(
                        //         color: Colors.black,
                        //         borderRadius: BorderRadius.all(
                        //             Radius.circular(20))),
                        //   ),
                        // ),
                        //         ],
                        //       ),
                        //     ),
                        //  ),
                      ],
                    ),
              preferredSize: Size.fromHeight(70.0),
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
                      : PredictionList(data: tomorrowPredictiondataList)),
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
    );
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
}
