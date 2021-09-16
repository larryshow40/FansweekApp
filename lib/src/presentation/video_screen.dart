import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';

//import 'package:nb_utils/nb_utils.dart';
//import 'package:prokit_flutter/main.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/request.dart';
import 'package:onoo/src/presentation/match_more_details/match_more_details.dart';

enum PredictionFor { Today, Tomorrow, After }

class TabBarDemo extends StatefulWidget {
  static String tag = "/MWTabBarScreen2";

  @override
  _MWTabBarScreen2State createState() => _MWTabBarScreen2State();
}

class _MWTabBarScreen2State extends State<TabBarDemo> {
  @override
  void initState() {
    getData();
    super.initState();
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
    return "${DateTime.now().day + 2}-${months[DateTime.now().month - 1]}";
  }

  String _fedValue = "";
  String _marketValue = "";
  String hint1 = "Federations";
  String hint2 = "Market";
  String selectedDate = "";

  Widget filter(List<String> list, bool fed, String hint) {
    return Container(
      height: 40,
      width: 125,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20))),
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
                                TextStyle(color: Colors.black, fontSize: 14)),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 25,
                          color: Colors.red,
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
                          color: Colors.red,
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
                                TextStyle(color: Colors.black, fontSize: 14)),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 25,
                          color: Colors.red,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // backgroundColor: appStore.appBarColor,
          // backgroundColor: Colors.red,
          // backgroundColor: AppBarData.
          title: Text('Filter Prediction',
              style: Theme.of(context).textTheme.headline3),
          bottom: PreferredSize(
            child: loading
                ? SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      filter(federations, true, hint1),
                      filter(markets, false, hint2),
                      GestureDetector(
                        onTap: () {
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2018, 3, 5),
                              theme: DatePickerTheme(
                                  headerColor: Colors.white,
                                  backgroundColor: Colors.white,
                                  itemStyle: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                  doneStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16)), onChanged: (date) {
                            print('change $date in time zone ' +
                                date.timeZoneOffset.inHours.toString());
                          }, onConfirm: (date) {
                            setState(() {
                              selectedDate =
                                  '${date.year}-${date.month}-${date.day}';
                            });
                            print(
                                'confirm ${date.year}-${date.month}-${date.day} ');
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        child: Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Date",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16)),
                              Icon(
                                Icons.date_range_outlined,
                                size: 25,
                                color: Colors.red,
                              )
                            ],
                          ),
                          height: 40,
                          width: 80,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      )
                    ],
                  ),
            preferredSize: Size.fromHeight(50.0),
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
        body: Container(
          padding: EdgeInsets.all(16),
          alignment: Alignment.center,
          // width: context.width(),
          child: FutureBuilder(
            future: APIService.getPredictions(
                selectedDate, _fedValue, _marketValue),
            builder: (_, AsyncSnapshot<List<Map<String, dynamic>>> data) {
              if (data.data == null) {
                return Center(child: CircularProgressIndicator());
              } else {
                final List<String> competitionNames = [];
                for (final comp in data.data ?? []) {
                  if (!competitionNames
                      .any((element) => element == comp['competition_name']))
                    competitionNames.add(comp['competition_name']);
                }

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
                            color: Colors.red,
                            child: Center(
                              child: Text(
                                '$item',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          ...data.data!
                              .where((element) =>
                                  element['competition_name'] ==
                                  competitionNames[index])
                              .map(
                                (item) => Column(
                                  children: [
                                    ListTile(

                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            "${validateTime(item['start_date'])}",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "${item['home_team']}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "${item['away_team']}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Tip: ${item['prediction']}',
                                                style: TextStyle(
                                                    color: Colors.deepPurple,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Odds: ${item['odds']['1']}",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios_rounded,color: Colors.black,),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                MatchMoreDetails(item['id']),
                                          ),
                                        );
                                      },
                                    ),
                                    Divider(color: Colors.black,thickness: 1.5,height: 0,),

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
            },
          ),
        ),
      ),
    );
  }
}
