import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/comment/reply_model.dart';
import 'package:onoo/src/utils/utils.dart';

class ReplyRow extends StatelessWidget {
  final Reply reply;
  const ReplyRow({Key? key, required this.reply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      child: Card(
        color: Utils().getCardBackgroundColor(context),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        elevation: AppThemeData.cardElevation,
        child: Padding(
          padding: const EdgeInsets.only(
              left: AppThemeData.wholeScreenPadding,
              right: AppThemeData.wholeScreenPadding,
              top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(reply.user.profileImage),
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
                        Text(reply.user.firstName + " " + reply.user.lastName, style: Theme.of(context).textTheme.headline3,),
                        Text(reply.date, style: Theme.of(context).textTheme.headline1!.copyWith(color: Utils.getTextColor().withOpacity(0.7),),
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.only(top: 5),
                        child: Text(reply.comment, style: Theme.of(context).textTheme.headline2!.copyWith(color: Utils.getTextColor().withOpacity(0.6),),),
                      ),
                    )
                  ],
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
