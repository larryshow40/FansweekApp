import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:onoo/src/data/model/prediction_model.dart';
import 'package:onoo/src/presentation/match_more_details/match_more_details.dart';

class PredictionList extends StatefulWidget {
  final List<PredictionData> data;

  const PredictionList({Key? key, required this.data}) : super(key: key);

  @override
  _PredictionListState createState() => _PredictionListState();
}

class _PredictionListState extends State<PredictionList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GroupedListView<PredictionData, String>(
      elements: widget.data,
      groupBy: (element) => element.competitionCluster,
      groupSeparatorBuilder: (String groupByValue) => Text(''),
      itemBuilder: (context, PredictionData element) => compBuilder(element),
      itemComparator: (item1, item2) => item1.competitionCluster
          .compareTo(item2.competitionCluster), // optional
      useStickyGroupSeparators: true, // optional
      floatingHeader: true, // optional
      order: GroupedListOrder.ASC, // optional
    );
  }

  Container compBuilder(PredictionData element) {
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
                '${element.competitionCluster} -  ${element.competitionName}',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
              ),
            ),
            Column(
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${element.homeTeam}",
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
                                "${element.awayTeam}",
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
                              mainAxisAlignment: MainAxisAlignment.start,
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
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${element.prediction}',
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
                                  element.getPredictions(),
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
                          builder: (_) => MatchMoreDetails(element.id),
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
          ],
        ));
  }
}
