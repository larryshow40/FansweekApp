import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/post_by_tag.dart';
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/utils/ads/ads_utils.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/utils/widget_animator.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:onoo/src/widgets/post_by_tag_row.dart';
import 'package:provider/provider.dart';

class PostByTagScreen extends StatefulWidget {
  final String tag;
  PostByTagScreen({Key? key, required this.tag}) : super(key: key);

  @override
  _PostByTagScreenState createState() => _PostByTagScreenState();
}

class _PostByTagScreenState extends State<PostByTagScreen> {
  late Future<PostByTag> posts;
  bool isDark = false;
  bool isAdsEnabled = false;

  @override
  void initState() {
    super.initState();
    isAdsEnabled = DatabaseConfig().isAdsEnable();
    posts = Repository().getPostByTag(tag: this.widget.tag);
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          this.widget.tag,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppThemeData.wholeScreenPadding),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: isAdsEnabled ? 60 : 5),
              child: FutureBuilder<PostByTag>(
                future: posts,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    PostByTag? data = snapshot.data;

                    return data!.data.length == 0
                        ? Center(
                            child: Text(
                              helper.getTranslated(
                                  context, AppTags.noDataFound),
                              style: Theme.of(context).textTheme.headline3,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            // ignore: unnecessary_null_comparison
                            itemCount: data != null ? data.data.length : 0,
                            itemBuilder: (context, index) {
                              return WidgetAnimator(
                                child: PostByTagRow(
                                    isDark: isDark, post: data.data[index]),
                              );
                            },
                          );
                  } else if (snapshot.hasError) {
                    return Text(
                      "${snapshot.error}",
                      style: Theme.of(context).textTheme.headline3,
                    );
                  }
                  return Center(child: LoadingIndicator());
                },
              ),
            ),

            //ads
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 5),
                child: AdsUtils.showBannerAds(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
