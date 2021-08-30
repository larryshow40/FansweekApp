import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/sub_cat_posts_model.dart';
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:onoo/src/widgets/common/common_article_row.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';

class SubCatPostsScreen extends StatefulWidget {
  static final String route = '/SubCatPostsScreen';

  @override
  _SubCatPostsScreenState createState() => _SubCatPostsScreenState();
}

class _SubCatPostsScreenState extends State<SubCatPostsScreen> {
  late int subCatId;
  late String subCatName;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    printLog("_SubCatPostsScreenState");
    final routes = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    subCatId = routes['subCatId'];
    subCatName = routes['subCatName'];

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(subCatName, style: Theme.of(context).textTheme.headline3,),
        ),
        body: FutureBuilder<SubCatPostsModel>(
          future: Repository().getPostBySubCategory(subCatId: subCatId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _displayData(snapshot.data!);
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Failed to load data.", style: Theme.of(context).textTheme.headline3,),
              );
            }
            return Center(child: LoadingIndicator());
          },
        ),
      ),
    );
  }

  //display_data_widget
  Widget _displayData(SubCatPostsModel postsData) {
    return Padding(
      padding: EdgeInsets.all(AppThemeData.wholeScreenPadding),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: postsData.data.length,
        itemBuilder: (context, index) {
          return CommonArticleRow(post: postsData.data[index]);
        },
      ),
    );
  }
}
