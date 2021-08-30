import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/video_content.dart';
import 'package:onoo/src/presentation/post_details_screen.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/constants.dart';

class VideoSliderListRow extends StatelessWidget {
  final bool? isDark;
  final Post? posts;

  VideoSliderListRow({Key? key, required this.isDark, required this.posts})
      : super(key: key);

  _getImageToPassNextScreen() {
    if (posts!.image != null) {
      return posts!.image!.bigImage.toString();
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    printLog("VideoSliderListRow");
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        width: 260,
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
              Navigator.pushNamed(context, PostDetailsScreen.route, arguments: {
                'postId': posts!.id!,
                'image': _getImageToPassNextScreen(),
                "isVideo": true
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    height: 140,
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: double.infinity,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    AppThemeData.cardBorderRadius),
                                topRight: Radius.circular(
                                    AppThemeData.cardBorderRadius)),
                            child: FadeInImage.assetNetwork(
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                "assets/images/medium_logo_rectangle.png",
                                fit: BoxFit.cover,
                              ),
                              image: posts!.image != null
                                  ? posts!.image!.mediumImage!
                                  : "",
                              placeholder: "assets/images/medium_logo_rectangle.png",
                            ),
                          ),
                        ),
                        Center(
                          child: Image.asset(
                            "assets/images/icons/play.png",
                            color: Colors.white,
                            height: 50,
                            width: 50,
                          ),
                        ),
                      ],
                    )),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5.0, vertical: 5),
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
                    padding:
                        const EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
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
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              Text(
                                posts!.created!,
                                style: Theme.of(context).textTheme.headline1,
                              ),
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
