import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/bloc/trending_bloc/trending_bloc.dart';
import 'package:onoo/src/data/model/common/common_post.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/utils/constants.dart';
import 'package:onoo/src/utils/widget_animator.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:onoo/src/widgets/trending_screen/trending_row.dart';
import 'package:onoo/src/utils/app_tags.dart';

class TrendingScreen extends StatefulWidget {
  static final String route = '/TrendingScreen';
  @override
  _TrendingScreenState createState() => _TrendingScreenState();
}

class _TrendingScreenState extends State<TrendingScreen> {
  ScrollController scrollController = ScrollController();
  bool isLoading = true;
  late List<CommonPostModel> posts;

  @override
  void initState() {
    super.initState();
    posts = [];
    BlocProvider.of<TrendingBloc>(context)..add(GetTrendingPostsEvent());
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        BlocProvider.of<TrendingBloc>(context)..add(GetMoreTrendingPostEvent());
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
    printLog("_TrendingScreenState");
    return SafeArea(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(
              helper.getTranslated(context, AppTags.trending),
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          body: BlocBuilder<TrendingBloc, TrendingState>(
            builder: (context, state) {
              return _buildViewsAsPerState(state);
            },
          )),
    );
  }

  _buildViewsAsPerState(TrendingState state) {
    if (state is TrendingPostLoadingState) {
      return Center(child: LoadingIndicator());
    } else if (state is TrendingSuccessState) {
      posts.addAll(state.postList);
      return ListView.builder(
        controller: scrollController,
        itemCount: posts.length + (isLoading ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < posts.length) {
            return WidgetAnimator(
              child: InkWell(
                child: Container(
                    height: AppThemeData.newsCardHeight,
                    child: TrendingRow(post: posts[index])),
              ),
            );
          } else {
            // Timer(Duration(milliseconds: 30), () {
            //   scrollController
            //       .jumpTo(scrollController.position.maxScrollExtent);
            // });
            return Center(child: LoadingIndicator());
          }
        },
      );
    } else if (state is TrendingErrorState) {
      return Center(
        child: Text(
          helper.getTranslated(context, AppTags.somethingWentWrong),
          style: Theme.of(context).textTheme.headline3,
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
