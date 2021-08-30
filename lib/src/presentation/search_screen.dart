import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/data/model/common/common_post.dart';
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/widgets/common/common_article_row.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';

class SearchScreen extends StatefulWidget {
  static final String route = '/SearchScreen';

  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool finishLoading = true;
  bool showClear = false;
  bool showNoContent = false;
  final TextEditingController inputController = new TextEditingController();
  late List<CommonPostModel> data;

  @override
  void initState() {
    super.initState();
    data = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          maxLines: 1,
          controller: inputController,
          style: Theme.of(context).textTheme.headline2,
          keyboardType: TextInputType.text,
          onSubmitted: (query) {
            setState(() {
              finishLoading = false;
              showNoContent = false;
            });
            searchData(query);
          },
          onChanged: (query) {
            setState(() {
              showClear = (query.length > 2);
            });
          },
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: helper.getTranslated(context, AppTags.search),
              hintStyle: Theme.of(context).textTheme.headline3),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          showClear
              ? IconButton(
                  onPressed: () {
                    inputController.clear();
                    showClear = false;
                    data.clear();
                    showNoContent = true;
                    setState(() {});
                  },
                  icon: const Icon(Icons.close))
              : Container()
        ],
      ),
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedOpacity(
            opacity: showNoContent ? 1.0 : 0.0,
            duration: Duration(milliseconds: 100),
            child: buildNoDataContent(context)),
        AnimatedOpacity(
          opacity:
              finishLoading && !showNoContent && data.length > 0 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 100),
          child: buildDataContent(context),
        ),
        AnimatedOpacity(
          opacity: finishLoading ? 0.0 : 1.0,
          duration: Duration(milliseconds: 100),
          child: buildLoading(context),
        ),
      ],
    );
  }

  Widget buildDataContent(BuildContext context) {
    return ListView.builder(
      itemCount: data.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return CommonArticleRow(post: data[index]);
      },
    );
  }

  Widget buildLoading(BuildContext context) {
    return Align(
      child: Container(
        width: 80,
        height: 80,
        alignment: Alignment.center,
        child: LoadingIndicator(),
      ),
      alignment: Alignment.center,
    );
  }

  Widget buildNoDataContent(BuildContext context) {
    return Align(
      child: Container(
        width: 180,
        height: 100,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(helper.getTranslated(context, AppTags.noDataFound),
                style: Theme.of(context).textTheme.headline3!.copyWith(
                    color: Colors.grey[500], fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      alignment: Alignment.center,
    );
  }

  void searchData(String query) async {
    var response = await Repository().getSearchResults(query: query);
    setState(() {
      if (response.length > 0) {
        data.clear();
        data = response;
        showNoContent = false;
      } else {
        showNoContent = true;
      }
      finishLoading = true;
    });
  }
}
