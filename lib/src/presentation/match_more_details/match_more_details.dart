import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:onoo/request.dart';

class MatchMoreDetails extends StatelessWidget {
  final int id;

  MatchMoreDetails(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: FutureBuilder(
        future: APIService.getMoreDetail("$id"),
        builder: (_, AsyncSnapshot<Map<String, dynamic>> data) {
          if (data.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            final item = data.data;
            log('G Kna: $item');

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                      "${item!['competition_name']}",
                      style: TextStyle(
                          fontSize: 21,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Container(
                              width: 150,
                              height: 100,
                              child: Text(
                                "${item['home_team']}",
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Srength: ${(item['home_strength'] as double).toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        Text(
                          "VS",
                          style: TextStyle(
                              fontSize: 21,
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.w600),
                        ),
                        Column(
                          children: [
                            Container(
                              width: 150,
                              height: 100,
                              child: Text(
                                "${item['away_team']}",
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "Srength: ${(item['away_strength'] as double).toStringAsFixed(2)}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      color: Colors.red,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text("Team's last 10 matches"),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          "${item['home_team']} last 10 matches",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    SizedBox(height: 0),
                    for (final homeMatchItem in item["home_encounters"])
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  0.0) //                 <--- border radius here
                              ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: homeMatchItem["played_away"]
                              ? [
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    homeMatchItem["played_against"],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  ))),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    homeMatchItem["fulltime_result"],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        item["home_team"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ]
                              : [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        item["home_team"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    homeMatchItem["fulltime_result"],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    homeMatchItem["played_against"],
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.black),
                                  )))
                                ],
                        ),
                      ),
                    SizedBox(height: 0),
                    Container(
                      height: 25,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          "${item['away_team']} last 10 matches",
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
                    for (final awayMatchItem in item["away_encounters"])
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  0.0) //                 <--- border radius here
                              ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: awayMatchItem["played_away"]
                              ? [
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    awayMatchItem["played_against"],
                                    style: TextStyle(color: Colors.black),
                                  ))),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    awayMatchItem["fulltime_result"],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        item["away_team"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ]
                              : [
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        item["away_team"],
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    awayMatchItem["fulltime_result"],
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ))),
                                  Expanded(
                                      child: Center(
                                          child: Text(
                                    awayMatchItem["played_against"],
                                    style: TextStyle(color: Colors.black),
                                  )))
                                ],
                        ),
                      ),
                    Container(
                      height: 30,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.red,
                      child: Center(
                        child: Text(
                          "HEAD TO HEAD",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    for (final headMatchItem in item["head_encounters"])
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(
                                  0.0) //                 <--- border radius here
                              ),
                        ),
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Center(
                                    child: Text(
                              headMatchItem["home_team"],
                              style: TextStyle(color: Colors.black),
                            ))),
                            Expanded(
                                child: Center(
                                    child: Text(
                              headMatchItem["fulltime_result"],
                              style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
                            ))),
                            Expanded(
                              child: Center(
                                child: Text(
                                  headMatchItem["away_team"],
                                  style: TextStyle(color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
