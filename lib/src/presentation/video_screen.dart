import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
//import 'package:nb_utils/nb_utils.dart';
//import 'package:prokit_flutter/main.dart';
import 'package:onoo/app_theme_data.dart';

class TabBarDemo extends StatefulWidget {
  static String tag = "/MWTabBarScreen2";

  @override
  _MWTabBarScreen2State createState() => _MWTabBarScreen2State();
}

class _MWTabBarScreen2State extends State<TabBarDemo> {
  @override
  void initState() {
    super.initState();
  }

  init() async {}

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            // backgroundColor: appStore.appBarColor,
           // backgroundColor: Colors.red,
            // backgroundColor: AppBarData.
            title: Text('Predition', style: Theme.of(context).textTheme.headline3),
            // title: Text('TabBar with Title and Icon', style: boldTextStyle(color: appStore.textPrimaryColor, size: 20)),
            bottom: TabBar(
              onTap: (index) {
                print(index);
              },
              labelStyle:Theme.of(context).textTheme.headline3,
              indicatorColor: Colors.red,
              physics: BouncingScrollPhysics(),
              labelColor: Colors.red,
             tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.home,
                        color: Colors.white
                      ),
                      // 5.width,
                      Text(
                        'Home',
                        //style: TextStyle(color: Colors.white.withOpacity(0.6)),
     
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.insert_drive_file,
                        color: Colors.white
                        // color: appStore.iconSecondaryColor,
                      ),
                      // 5.width,
                      Text(
                        'Today',
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.supervised_user_circle,
                        color: Colors.yellow
                      ),
                      // 5.width,
                      Text(
                        'User',
                        style: TextStyle(color: Colors.white.withOpacity(0.6)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                // width: context.width(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Home',
                      style: TextStyle(color: Colors.blueGrey, fontSize: 24),
                    ),
                    // 15.height,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                // width: context.width(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Articles',
                      style: TextStyle(color: Colors.amberAccent, fontSize: 24),
                    ),
                    // 15.height,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                // width: context.width(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'User',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 24),
                    ),
                    // 15.height,
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
