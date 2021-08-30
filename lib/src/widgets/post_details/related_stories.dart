import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/common/common_post.dart';
import 'package:onoo/src/presentation/post_details_screen.dart';
import 'package:onoo/src/utils/utils.dart';

class RelatedStoriesListRow extends StatelessWidget {
  final bool? isDark;
  final CommonPostModel relatedPosts;

  RelatedStoriesListRow(
      {Key? key, required this.isDark, required this.relatedPosts})
      : super(key: key);

  _getImageToPassNextScreen() {
    if (relatedPosts.image != null) {
      return relatedPosts.image!.bigImage.toString();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, PostDetailsScreen.route, arguments: {
            'postId': relatedPosts.id,
            'image': _getImageToPassNextScreen()
          });
        },
        child: Container(
          height: AppThemeData.newsCardHeight,
          child: Card(
            color: Utils().getCardBackgroundColor(context),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: AppThemeData.cardElevation,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                        topLeft: Radius.circular(AppThemeData.cardBorderRadius),
                        bottomLeft: Radius.circular(AppThemeData.cardBorderRadius)),
                    child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) => Image.asset("assets/images/logo_rectangle.png", fit: BoxFit.cover,),
                        placeholder: "assets/images/logo_rectangle.png",
                        image: relatedPosts.image != null ? relatedPosts.image!.mediumImage! : ""),
                  ),
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
                              strutStyle: StrutStyle(fontSize: 20),
                              maxLines: 3,
                              text: TextSpan(
                                  style: Theme.of(context).textTheme.headline2,
                                  text: relatedPosts.title),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              relatedPosts.created,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, right: 5),
                              child: Container(
                                width: 1.5,
                                height: 15,
                                color: isDark! ? AppThemeData.textColorDark : AppThemeData.textColorLight,
                              ),
                            ),
                            Text(
                              relatedPosts.postType,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            new Spacer(),
                            if (isDark!)
                              Image.asset(
                                "assets/images/icons/comment_dark.png",
                              ),
                            if (!isDark!)
                              SvgPicture.asset(
                                "assets/images/icons/comment.svg",
                              ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                relatedPosts.commentsCount.toString(),
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
