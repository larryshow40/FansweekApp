import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/home_content/home_content.dart';
import 'package:onoo/src/presentation/post_details_screen.dart';
import 'package:onoo/src/utils/utils.dart';

class SliderListRow extends StatelessWidget {
  final bool? isDark;
  final Post? posts;

  SliderListRow({Key? key, required this.isDark, required this.posts})
      : super(key: key);
  _getImageToPassNextScreen() {
    if (posts!.image != null) {
      return posts!.image!.mediumImage.toString();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        width: 265,
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
              Navigator.pushNamed(context, PostDetailsScreen.route, arguments: {
                'postId': posts!.id!,
                'image': _getImageToPassNextScreen()
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        topRight: Radius.circular(8.0)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppThemeData.cardBorderRadius),
                        topRight:
                            Radius.circular(AppThemeData.cardBorderRadius)),
                    child: FadeInImage.assetNetwork(
                      fit: BoxFit.cover,
                      imageErrorBuilder: (context, error, stackTrace) =>
                          Image.asset("assets/images/medium_logo_rectangle.png",
                              fit: BoxFit.cover),
                      image: posts!.image != null
                          ? posts!.image!.mediumImage!
                          : "",
                      placeholder: "assets/images/fansweek.png",
                    ),
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: RichText(
                        overflow: TextOverflow.ellipsis,
                        strutStyle: StrutStyle(fontSize: 20),
                        maxLines: 2,
                        text: TextSpan(
                            style: Theme.of(context).textTheme.headline2,
                            text: posts!.title),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                    child: Row(
                      children: [
                        Container(
                          height: 40.0,
                          width: 40.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image:
                                    AssetImage("assets/images/logo_round.png")),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  posts!.user!.firstName! +
                                      " " +
                                      posts!.user!.lastName!,
                                  style: Theme.of(context).textTheme.headline1),
                              Text(posts!.created!,
                                  style: Theme.of(context).textTheme.headline1),
                            ],
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
