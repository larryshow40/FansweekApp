import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/bloc/author_bloc/author_bloc.dart';
import 'package:onoo/src/data/model/author/author_profile.dart';
import 'package:onoo/src/data/model/common/common_post.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:onoo/src/utils/widget_animator.dart';
import 'package:onoo/src/widgets/common/common_article_row.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class AuthorScreen extends StatefulWidget {
  static final String route = '/AuthorScreen';
  @override
  _AuthorScreenState createState() => _AuthorScreenState();
}

class _AuthorScreenState extends State<AuthorScreen> {
  bool isDark = false;
  late List<CommonPostModel> posts;
  final bool isLoading = true;
  ScrollController scrollController = ScrollController();
  late AuthorBloc _authorBloc;
  late int authorId;

  @override
  void initState() {
    super.initState();
    posts = [];
    _authorBloc = BlocProvider.of<AuthorBloc>(context)
      ..add(GetAuthorPostEvent(authorId: authorId));
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _authorBloc..add(GetMoreAuthorPostEvent(authorId: authorId));
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    printLog("_AuthorScreenState");
    final routes =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    authorId = routes['authorId'];
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    return SafeArea(
      child: Scaffold(
        body: BlocListener<AuthorBloc, AuthorState>(
          bloc: _authorBloc,
          listener: (context, state) {
            if (state is AuthorPostErrorState) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(helper.getTranslated(
                      context, AppTags.somethingWentWrong)),
                  backgroundColor: Colors.red,
                ));
            }
          },
          child: BlocBuilder<AuthorBloc, AuthorState>(
            builder: (context, state) {
              if (state is AuthorPostLoadingState) {
                return Center(
                  child: LoadingIndicator(),
                );
              } else if (state is AuthorPostSuccessState) {
                posts.addAll(state.postList);
                return _buildUI(state);
              } else if (state is AuthorMorePostSuccessState) {
                posts.addAll(state.postList);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  //build_screen_ui
  Widget _buildUI(AuthorPostSuccessState state) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(AppThemeData.wholeScreenPadding),
        child: ListView(
          children: [
            SizedBox(height: 40.0),
            _buildProfileUi(state.profileData),
            _buildPostsDetailsUI()
          ],
        ),
      ),
    );
  }

  //build_profile_ui
  Widget _buildProfileUi(AuthorProfile profile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //round profile picture and notification icon
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  IconButton(
                    tooltip: "back",
                    icon: Image.asset(
                      "assets/images/icons/back.png",
                      scale: 1.7,
                      color: Utils.getTextColor(isDark),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(height: 70.0),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                height: 150.0,
                width: 150.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                      color: AppThemeData.textColorDark,
                      width: 4.0,
                      style: BorderStyle.solid),
                ),
                child: CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(profile.data.profileImage),
                ),
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  IconButton(
                    tooltip: "Notification",
                    icon: Image.asset(
                      "assets/images/icons/notification.png",
                      scale: 1.7,
                    ),
                    onPressed: () {},
                  ),
                  SizedBox(
                    height: 70.0,
                  ),
                ],
              ),
            )
          ],
        ),
        // author name
        Align(
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              profile.data.name,
              style: Theme.of(context).textTheme.headline4,
            ),
          ),
        ),
        // middle row
        // video, subscription, comment
        Padding(
          padding: const EdgeInsets.only(top: 25, left: 10, right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    profile.data.totalComments.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    helper.getTranslated(context, AppTags.video).toUpperCase(),
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: Utils.getTextColor().withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.8,
                        ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    "18.5 K",
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    helper
                        .getTranslated(context, AppTags.subscription)
                        .toUpperCase(),
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: Utils.getTextColor(isDark).withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.8,
                        ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    profile.data.totalComments.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .headline3!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    helper
                        .getTranslated(context, AppTags.comment)
                        .toUpperCase(),
                    style: Theme.of(context).textTheme.headline2!.copyWith(
                          color: Utils.getTextColor().withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                          letterSpacing: 0.8,
                        ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  //post_details_ui
  Widget _buildPostsDetailsUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //list view
        Padding(
          padding: EdgeInsets.only(top: 25),
          child: Text(
            helper.getTranslated(context, AppTags.authorArticle),
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        //list item
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: ListView.builder(
            shrinkWrap: true,
            controller: scrollController,
            itemCount: posts.length + (isLoading ? 1 : 0),
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if (index < posts.length) {
                return WidgetAnimator(
                    child: CommonArticleRow(post: posts[index]));
              } else {
                return Center(
                  child: LoadingIndicator(),
                );
              }
            },
          ),
        )
      ],
    );
  }
}
