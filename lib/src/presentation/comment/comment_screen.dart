import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/bloc/comment_bloc/comment_bloc.dart';
import 'package:onoo/src/data/model/auth/onno_user.dart';
import 'package:onoo/src/data/model/comment/all_comments.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/comment/reply_screen.dart';
import 'package:onoo/src/presentation/sign_in/login_screen.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/widget_animator.dart';
import 'package:onoo/src/widgets/comment_row.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final int commentsCount;
  final int postId;

  CommentScreen({required this.postId, required this.commentsCount});

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  late int postId;
  bool isDark = false;
  final TextEditingController _commentController = TextEditingController();
  late CommentBloc _commentBloc;

  @override
  void initState() {
    super.initState();
    postId = widget.postId;
    _commentBloc = BlocProvider.of<CommentBloc>(context)..add(GetAllCommentEvent(postId: postId));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;


    return Scaffold(
        appBar: AppBar(
          title: Text(
            helper.getTranslated(context, AppTags.comment) + " (${widget.commentsCount})",
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        body: BlocListener<CommentBloc, CommentState>(
          bloc: _commentBloc,
          listener: (context, state) {
            if (state is CommentErrorState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ));
            } else if (state is CommentPostErrorState) {
              _showLoginAlert();
            }
          },
          child: BlocBuilder<CommentBloc, CommentState>(
            builder: (context, state) {
              if (state is CommentLoadingState) {
                return Center(
                  child: LoadingIndicator(),
                );
              } else if (state is GetCommentSuccessState) {
                return _ui(state.allComments);
              } else if (state is CommentPostSuccessState) {
                _commentBloc..add(GetAllCommentEvent(postId: postId));
                //  Utils.showSnackBar(context: context, message: state.message);
              }
              return Center(
                child: LoadingIndicator(),
              );
            },
          ),
        ));
  }

  Widget _ui(AllComments data) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: AppThemeData.wholeScreenPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 150,
                child: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: data.data!.map((comment) {
                      return WidgetAnimator(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: CommentRow(
                            commentData: comment,
                            onLikePressed: () {},
                            onReplyPressed: () {
                              //check login status and
                              // go to reply screen
                              OnnoUser? user = DatabaseConfig().getOnooUser();
                              if (user != null && user.token != null) {
                                Navigator.pushNamed(context, CommentReplyScreen.route,
                                    arguments: {'postId': comment.postId, 'commentId': comment.id}
                                    );
                              } else {
                                _showLoginAlert();
                              }
                            },
                            onSharePressed: () {},
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Container(
                height: 80,
                child: Center(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              textAlign: TextAlign.start,
                              controller: _commentController,
                              keyboardType: TextInputType.text,
                              style: Theme.of(context).textTheme.headline2,
                              decoration: InputDecoration(
                                hintText: helper.getTranslated(context, AppTags.saySomething),
                                hintStyle: Theme.of(context).textTheme.headline2,
                                contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                    borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: Utils.getTextColor(),)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                    borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: Utils.getTextColor(),)),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                  borderSide: BorderSide(color: Utils.getTextColor(), width: 1, style: BorderStyle.solid),),
                              ),
                            ),
                          ),
                          IconButton(
                              icon: SvgPicture.asset("assets/images/icons/send.svg"),
                              iconSize: 25,
                              color: isDark ? AppThemeData.textColorDark : AppThemeData.textColorLight,
                              onPressed: () {
                                _postComment();
                              }),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ));
  }
 //post_comment
  void _postComment() async {
    FocusScope.of(context).unfocus();
    OnnoUser? user = DatabaseConfig().getOnooUser();
    if (user != null && user.token != null) {
      if (_commentController.text.isNotEmpty) {
        _commentBloc..add(PostCommentEvent(comment: _commentController.text.trim(), postId: postId));
        _commentController.clear();
      }
    } else {
      _showLoginAlert();
    }
  }

  //show_login_alert
  void _showLoginAlert() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text(helper.getTranslated(context, AppTags.loginAlert)),
        backgroundColor: Colors.red,
        action: SnackBarAction(
            label: helper.getTranslated(context, AppTags.signIn),
            onPressed: () {
              Navigator.pushNamed(context, LoginScreen.route);
            }),
      ));
  }
}
