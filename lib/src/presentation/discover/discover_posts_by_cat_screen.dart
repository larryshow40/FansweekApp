import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/discover/discover_posts_by_cat.dart';
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/widgets/common/common_article_row.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';

class DiscoverPostByCatScreen extends StatefulWidget {
  static final String route = '/DiscoverPostByCatScreen';

  final int categoryId;
  final String catName;
  final String catType;

  DiscoverPostByCatScreen(
      {Key? key,
      required this.categoryId,
      required this.catType,
      required this.catName})
      : super(key: key);

  @override
  _DiscoverPostByCatScreenState createState() =>
      _DiscoverPostByCatScreenState();
}

class _DiscoverPostByCatScreenState extends State<DiscoverPostByCatScreen> {
  late Future<DiscoverPostsByCat> postData;
  int pageNumber = 1;

  @override
  void initState() {
    super.initState();
    postData = Repository().getDiscoverPostByCategory(
        catType: this.widget.catType,
        catId: this.widget.categoryId,
        pageNumber: pageNumber);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Scaffold(
      appBar: AppBar(title: Text(this.widget.catName, style: Theme.of(context).textTheme.headline3,),
      ),
      body: FutureBuilder<DiscoverPostsByCat>(
          future: postData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildUI(snapshot.data!);
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Data loaded failed"),
              );
            }
            return Center(
              child: LoadingIndicator(),
            );
          }),
    ));
  }

  Widget _buildUI(DiscoverPostsByCat posts) {
    return Padding(
      padding: EdgeInsets.all(AppThemeData.wholeScreenPadding),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: posts.data.length,
        itemBuilder: (context, index) {
          return CommonArticleRow(post: posts.data[index]);
        },
      ),
    );
  }
}
