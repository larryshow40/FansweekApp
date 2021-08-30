import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/common/common_post.dart';
import 'package:onoo/src/utils/utils.dart';

// ignore: must_be_immutable
class AuthorArticleRow extends StatelessWidget {
  bool isDark;

  final CommonPostModel post;
  AuthorArticleRow({Key? key, required this.post, required this.isDark})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              //go to post detals  screen
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
                        image: "assets/images/logo_round.png",
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
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 18,
                                      color: isDark ? AppThemeData.textColorDark : AppThemeData.textColorLight),
                                  text: "Demo Post title"),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "2h",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                        color: Utils.getTextColor()
                                            .withOpacity(0.7)),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  width: 1.5,
                                  height: 12,
                                  color: isDark
                                      ? AppThemeData.textColorDark
                                      : AppThemeData.textColorLight,
                                ),
                              ),
                              Text(
                                "Business",
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                        color: Utils.getTextColor()
                                            .withOpacity(0.7)),
                              ),
                              new Spacer(),
                              SvgPicture.asset(
                                "assets/images/icons/comment.svg",
                                // color: isDark!
                                //     ? AppThemeData.textColorDark
                                //     : AppThemeData.textColorLight,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Text(
                                  "45",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline1!
                                      .copyWith(
                                          color: Utils.getTextColor()
                                              .withOpacity(0.7)),
                                ),
                              ),
                            ],
                          ),
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
