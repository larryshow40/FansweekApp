import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/home_content/home_content.dart';
import 'package:onoo/src/presentation/post_details_screen.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/constants.dart';

class TrendingRow extends StatelessWidget {
  final isDark;
  final Post? trendingPosts;

  TrendingRow({Key? key, @required this.isDark, required this.trendingPosts});

  _getImageToPassNextScreen() {
    if (trendingPosts!.image != null) {
      return trendingPosts!.image!.bigImage.toString();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    printLog("TrendingRow");
    return Padding(
      padding: const EdgeInsets.only(top: 3.0),
      child: Container(
        height: AppThemeData.newsCardHeight,
        width: MediaQuery.of(context).size.width - 50,
        child: Card(
          color: Utils().getCardBackgroundColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeData.cardBorderRadius),
          ),
          shadowColor: AppThemeData.shadowColor,
          elevation: AppThemeData.cardElevation,
          child: InkWell(
            onTap: () {
              //go to post detals  screen
              Navigator.pushNamed(context, PostDetailsScreen.route, arguments: {'postId': trendingPosts!.id!, 'image': _getImageToPassNextScreen()});},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: AppThemeData.newsCardHeight,
                  width: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppThemeData.cardBorderRadius),
                        bottomLeft:
                            Radius.circular(AppThemeData.cardBorderRadius)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppThemeData.cardBorderRadius),
                        bottomLeft:
                            Radius.circular(AppThemeData.cardBorderRadius)),
                    child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              "assets/images/fansweek.png",
                              fit: BoxFit.cover,
                            ),
                        image: trendingPosts!.image != null
                            ? trendingPosts!.image!.mediumImage!
                            : "",
                        placeholder: "assets/images/fansweek.png"),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle(fontSize: 15),
                              maxLines: 3,
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.headline2,
                                  text: trendingPosts!.title),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(trendingPosts!.created.toString(),
                                style: Theme.of(context).textTheme.headline1),
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
