import 'dart:developer';

import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:flutter/material.dart';
import 'package:onoo/request.dart';

class MatchMoreDetails extends StatelessWidget {
  final int id;

  MatchMoreDetails(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF161B25),
      appBar: AppBar(
        backgroundColor: Color(0xFF161B25),
      ),
      body: FutureBuilder(
        future: APIService.getMoreDetail("$id"),
        builder: (_, AsyncSnapshot<Map<String, dynamic>> data) {
          if (data.data == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            final item = data.data;
            log('G Kna: $item');

            return SingleChildScrollView(
              child: Container(
                color: Color(0xFF161B25),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        "${item!['competition_name']}",
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.white,
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
                                // height: 100,
                                child: Text(
                                  "${item['home_team']}",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                          Text(
                            "VS",
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 150,
                                //     height: 100,
                                child: Text(
                                  "${item['away_team']}",
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.white,
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.centerLeft,
                        width: double.infinity,
                        color: Color(0xFF161B25),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text("Last 5 Games"),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: DottedDecoration(
                          strokeWidth: 1,
                          color: Colors.white,
                          shape: Shape.box,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Center(
                          child: Text(
                            "${item['home_team']}".toUpperCase(),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        decoration: DottedDecoration(
                          strokeWidth: 1,
                          color: Colors.white,
                          shape: Shape.box,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            for (final homeMatchItem in item["home_encounters"])
                              Container(
                                decoration: BoxDecoration(
                                  // border:
                                  //     Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
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
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          ))),
                                          Expanded(
                                              child: Center(
                                                  child: Text(
                                            homeMatchItem["fulltime_result"],
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                item["home_team"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ]
                                      : [
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                item["home_team"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Center(
                                                  child: Text(
                                            homeMatchItem["fulltime_result"],
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))),
                                          Expanded(
                                              child: Center(
                                                  child: Text(
                                            homeMatchItem["played_against"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white),
                                          )))
                                        ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: DottedDecoration(
                          strokeWidth: 1,
                          color: Colors.white,
                          shape: Shape.box,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Center(
                          child: Text(
                            "${item['away_team']}".toUpperCase(),
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        decoration: DottedDecoration(
                          strokeWidth: 1,
                          color: Colors.white,
                          shape: Shape.box,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            for (final awayMatchItem in item["away_encounters"])
                              Container(
                                decoration: BoxDecoration(
                                  //  border: Border.all(color: Colors.black, width: 1),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
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
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          ))),
                                          Expanded(
                                              child: Center(
                                                  child: Text(
                                            awayMatchItem["fulltime_result"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))),
                                          Expanded(
                                            child: Center(
                                              child: Text(
                                                item["away_team"],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white),
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
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              child: Center(
                                                  child: Text(
                                            awayMatchItem["fulltime_result"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ))),
                                          Expanded(
                                              child: Center(
                                                  child: Text(
                                            awayMatchItem["played_against"],
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )))
                                        ],
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Container(
                        height: 50,
                        decoration: DottedDecoration(
                          strokeWidth: 1,
                          color: Colors.white,
                          shape: Shape.box,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                        ),
                        child: Center(
                          child: Text(
                            "HEAD TO HEAD",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      Container(
                        decoration: DottedDecoration(
                          strokeWidth: 1,
                          color: Colors.white,
                          shape: Shape.box,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20)),
                        ),
                        child: Column(
                          children: [
                            for (final headMatchItem in item["head_encounters"])
                              Container(
                                decoration: BoxDecoration(
                                  //   border: Border.all(color: Colors.white, width: 1),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
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
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    ))),
                                    Expanded(
                                        child: Center(
                                            child: Text(
                                      headMatchItem["fulltime_result"],
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ))),
                                    Expanded(
                                      child: Center(
                                        child: Text(
                                          headMatchItem["away_team"],
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
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
              ),
            );
          }
        },
      ),
    );
  }
}
