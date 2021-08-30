import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/comment/all_comments.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/constants.dart';

class CommentRow extends StatelessWidget {
  final CommentData commentData;
  final VoidCallback onLikePressed;
  final VoidCallback onReplyPressed;
  final VoidCallback onSharePressed;

  const CommentRow(
      {Key? key,
      required this.commentData,
      required this.onLikePressed,
      required this.onReplyPressed,
      required this.onSharePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    printLog("CommentRow");
    return mainUI(context);
  }

  Widget mainUI(BuildContext context) {
    return Container(
      height: 160,
      child: Card(
        color: Utils().getCardBackgroundColor(context),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: AppThemeData.cardElevation,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppThemeData.wholeScreenPadding,
              vertical: AppThemeData.wholeScreenPadding,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(commentData.user.profileImage),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            this.commentData.user.firstName +
                                " " +
                                this.commentData.user.lastName,
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            this.commentData.date,
                            style: Theme.of(context)
                                .textTheme
                                .headline1!
                                .copyWith(
                                    color:
                                        Utils.getTextColor().withOpacity(0.7)),
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: Text(
                              this.commentData.comment,
                              maxLines: 3,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2!
                                  .copyWith(
                                      color: Utils.getTextColor()
                                          .withOpacity(0.6)),
                            )),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: Icon(Icons.thumb_up_outlined),
                                iconSize: 18,
                                onPressed: () {}),
                            Text(
                              "0",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                              icon: Icon(Icons.comment_outlined),
                              iconSize: 18,
                              onPressed: this.onReplyPressed,
                            ),
                            Text(
                              "0",
                              style: Theme.of(context).textTheme.headline1,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                                icon: Icon(Icons.share_outlined),
                                iconSize: 18,
                                onPressed: () {}),
                            SizedBox(
                              width: 10,
                            ),
                            IconButton(
                                icon: Icon(Icons.more_horiz_outlined),
                                iconSize: 18,
                                onPressed: () {}),
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
    );
  }
}
