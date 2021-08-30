import 'package:flutter/material.dart';
class TabBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    textStyle() {
      return TextStyle(color: Colors.white, fontSize: 30.0);
    }
    return new DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title:Text("TabBar Widget"),
          bottom:TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.cake)),
              Tab(icon: Icon(Icons.android)),
              Tab(icon: Icon(Icons.phone_android)),
            ],
          ),
        ),
        body:TabBarView(
          children: <Widget>[
            Container(
              color: Colors.deepOrangeAccent,
              child:Center(
                child:Text(
                  "Cake",
                  style: textStyle(),
                ),
              ),
            ),
            Container(
              color: Colors.blueGrey,
              child:Center(
                child:Text(
                  "Android",
                  style: textStyle(),
                ),
              ),
            ),
            Container(
              color: Colors.teal,
              child:Center(
                child:Text(
                  "Mobile",
                  style: textStyle(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}