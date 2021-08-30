import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/video_content.dart';
import 'package:onoo/src/presentation/post_details_screen.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/constants.dart';

class VideoArticleListRow extends StatelessWidget {
  final bool? isDark;
  final Post? post;

  VideoArticleListRow({Key? key, required this.isDark, required this.post})
      : super(key: key);

  _getImageToPassNextScreen() {
    if (post!.image != null) {
      return post!.image!.mediumImage.toString();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    printLog("VideoArticleListRow");
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, PostDetailsScreen.route, arguments: {'postId': post!.id!, 'image': _getImageToPassNextScreen()});
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Container(
          height: AppThemeData.newsCardHeight,
          child: Card(
            color: Utils().getCardBackgroundColor(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            shadowColor: AppThemeData.shadowColor,
            elevation: AppThemeData.cardElevation,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Container(
                      height: double.infinity,
                      width: 165,
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(AppThemeData.cardBorderRadius),
                            bottomLeft:
                                Radius.circular(AppThemeData.cardBorderRadius)),
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            "assets/images/logo_round.png",
                            fit: BoxFit.cover,
                          ),
                          image: post!.image != null
                              ? "post!.image!.smallImage!"
                              : "",
                          placeholder: "assets/images/logo_round.png",
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        "assets/images/icons/play.png",
                        color: Colors.white,
                        height: 30,
                        width: 30,
                      ),
                    ),
                  ],
                ),
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
                              strutStyle: StrutStyle(fontSize: 16),
                              maxLines: 3,
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.headline2,
                                  text:
                                      "Article title Article title Article title Article title Article title Article title Article title Article title "),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '2h',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                width: 1.5,
                                height: 15,
                                color: isDark!
                                    ? AppThemeData.textColorDark
                                    : AppThemeData.textColorLight,
                              ),
                            ),
                            Text(
                              'Business',
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            new Spacer(),
                            Icon(
                              Icons.message_rounded,
                              size: 18,
                              color: isDark!
                                  ? AppThemeData.textColorDark
                                  : AppThemeData.textColorLight,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                '45',
                                style: Theme.of(context).textTheme.headline1,
                              ),
                            ),
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
