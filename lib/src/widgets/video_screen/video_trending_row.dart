import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/video_content.dart';
import 'package:onoo/src/presentation/post_details_screen.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/constants.dart';

class VideoTrendingRow extends StatelessWidget {
  final isDark;
  final Post? trendingPost;

  VideoTrendingRow({Key? key, required this.isDark, required this.trendingPost}) : super(key: key);

  _getImageToPassNextScreen() {
    if (trendingPost!.image != null) {
      return trendingPost!.image!.bigImage.toString();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    printLog("VideoTrendingRow");
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Container(
        height: AppThemeData.newsCardHeight,
        width: MediaQuery.of(context).size.width - 50,
        child: Card(
          color: Utils().getCardBackgroundColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          shadowColor: AppThemeData.shadowColor,
          elevation: AppThemeData.cardElevation,
          child: InkWell(
            onTap: () {
              //go to post detals  screen
              Navigator.pushNamed(context, PostDetailsScreen.route, arguments: {'postId': trendingPost!.id!, 'image': _getImageToPassNextScreen()});
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    height: AppThemeData.newsCardHeight,
                    width: 140,
                    child: Stack(
                      children: [
                        Container(
                          height: double.infinity,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(AppThemeData.cardBorderRadius),
                                bottomLeft: Radius.circular(AppThemeData.cardBorderRadius)),
                            child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) => Image.asset("assets/images/logo_round.png", fit: BoxFit.cover,),
                              image: trendingPost!.image != null ? trendingPost!.image!.smallImage! : "",
                              placeholder: "assets/images/logo_round.png",
                            ),
                          ),
                        ),
                        Center(child: Image.asset("assets/images/icons/play.png", color: Colors.white, height: 30, width: 30,),),
                      ],
                    )),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: RichText(
                              overflow: TextOverflow.ellipsis,
                              strutStyle: StrutStyle(fontSize: 20),
                              maxLines: 3, text: TextSpan(style: Theme.of(context).textTheme.headline2, text: trendingPost!.title),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(trendingPost!.created.toString(), style: Theme.of(context).textTheme.headline1,),
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
