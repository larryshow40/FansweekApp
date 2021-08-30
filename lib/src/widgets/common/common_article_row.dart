import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/common/common_post.dart';
import 'package:onoo/src/presentation/post_details_screen.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/constants.dart';

class CommonArticleRow extends StatelessWidget {
  final CommonPostModel post;

  CommonArticleRow({Key? key, required this.post}) : super(key: key);

  _getImageToPassNextScreen() {
    if (post.image != null) {
      return post.image!.mediumImage.toString();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    printLog("CommonArticleRow");
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Container(
        height: AppThemeData.newsCardHeight,
        child: Card(
          color: Utils().getCardBackgroundColor(context),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeData.cardBorderRadius),
          ),
          shadowColor: AppThemeData.shadowColor,
          elevation: AppThemeData.cardElevation,
          child: InkWell(
            onTap: () {
              print("---------article clicked, id: ${this.post.id}");
              //go to post detals  screen
              Navigator.pushNamed(context, PostDetailsScreen.route, arguments: {
                'postId': post.id,
                'image': _getImageToPassNextScreen()
              });
            },
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
                        bottomLeft:
                            Radius.circular(AppThemeData.cardBorderRadius)),
                    child: FadeInImage.assetNetwork(
                        fit: BoxFit.cover,
                        imageErrorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              "assets/images/logo_round.png",
                              fit: BoxFit.cover,
                            ),
                        image:
                            post.image != null ? post.image!.smallImage! : "",
                        placeholder: "assets/images/logo_round.png"),
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
                                  text: post.title),
                            ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              post.created,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 10, right: 10),
                              child: Container(
                                width: 1.5,
                                height: 12,
                                color: Utils.getTextColor(),
                              ),
                            ),
                            Text(
                              post.postType.toString(),
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            new Spacer(),
                            SvgPicture.asset(
                              "assets/images/icons/comment.svg",
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                post.commentsCount.toString(),
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
