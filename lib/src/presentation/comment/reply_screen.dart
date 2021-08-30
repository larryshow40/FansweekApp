import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onoo/src/data/bloc/reply_bloc/reply_bloc.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/data/model/auth/onno_user.dart';
import 'package:onoo/src/data/model/comment/reply_model.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/presentation/sign_in/login_screen.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:onoo/src/widgets/reply_row.dart';

class CommentReplyScreen extends StatefulWidget {
  static final String route = '/CommentReplyScreen';

  @override
  _CommentReplyScreenState createState() => _CommentReplyScreenState();
}

class _CommentReplyScreenState extends State<CommentReplyScreen> {
  late ReplyBloc _replyBloc;
  final TextEditingController _replyController = TextEditingController();
  late int commentId;
  late int postId;

  @override
  void initState() {
    super.initState();
    _replyBloc = BlocProvider.of<ReplyBloc>(context)..add(GetAllReplyEvent(commetnId: commentId));
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final routes = ModalRoute.of(context)!.settings.arguments as Map<String,dynamic>;
    postId = routes['postId'];
    commentId = routes['commentId'];

    return Scaffold(
        appBar: AppBar(
          title: Text(
            helper.getTranslated(context, AppTags.reply),
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        body: BlocListener<ReplyBloc, ReplyState>(
          bloc: _replyBloc,
          listener: (context, state) {
            if (state is ReplyErrorState) {
              ScaffoldMessenger.of(context)..hideCurrentSnackBar()..showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red,));
            }
          },
          child: BlocBuilder<ReplyBloc, ReplyState>(
            builder: (context, state) {
              if (state is ReplyLoadingState) {
                return Center(
                  child: LoadingIndicator(),
                );
              } else if (state is GetReplySuccessState) {
                return _ui(state.replyModel);
              } else if (state is ReplyPostSuccessState) {
                BlocProvider.of<ReplyBloc>(context)
                  ..add(GetAllReplyEvent(commetnId: commentId));
              }
              return Center(
                child: LoadingIndicator(),
              );
            },
          ),
        ));
  }

  Widget _ui(ReplyModel replyModel) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 150,
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: replyModel.data.length,
                itemBuilder: (context, index) {return ReplyRow(reply: replyModel.data[index]);},
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: Container(
            height: 80,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        textAlign: TextAlign.start,
                        controller: _replyController,
                        keyboardType: TextInputType.text,
                        style: Theme.of(context).textTheme.headline2,
                        decoration: InputDecoration(
                          hintText: helper.getTranslated(context, AppTags.saySomething),
                          hintStyle: Theme.of(context).textTheme.headline2,
                          contentPadding: EdgeInsetsDirectional.all(8),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              borderSide: BorderSide(width: 1, style: BorderStyle.solid, color: Utils.getTextColor(),)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25.0)),
                              borderSide: BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Utils.getTextColor(),
                              )),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(25.0)),
                            borderSide: BorderSide(color: Utils.getTextColor(), width: 1, style: BorderStyle.solid),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset("assets/images/icons/send.svg",),
                      iconSize: 25,
                      color: Utils.getTextColor(),
                      onPressed: () {
                        _postReply();
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
  //post_reploy_void_function
  void _postReply() async {
    FocusScope.of(context).unfocus();
    OnnoUser? user = DatabaseConfig().getOnooUser();
    if (user != null && user.token != null) {
      if (_replyController.text.isNotEmpty) {
        _replyController.clear();
        BlocProvider.of<ReplyBloc>(context)
          ..add(PostReplyEvent(
              postId: postId,
              commentId: commentId,
              reply: _replyController.text.trim(),
              token: user.token!));
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
