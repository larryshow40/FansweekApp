import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/bloc/video_bloc/video_bloc.dart';
import 'dart:math' as math;
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/data/model/video_content.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/search_screen.dart';
import 'package:onoo/src/presentation/trending_screen.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/ads/ads_utils.dart';
import 'package:onoo/src/utils/widget_animator.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:onoo/src/widgets/video_screen/video_article_row.dart';
import 'package:onoo/src/widgets/video_screen/video_category_list.dart';
import 'package:onoo/src/widgets/video_screen/video_slider_row.dart';
import 'package:onoo/src/widgets/video_screen/video_trending_row.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:provider/provider.dart';

class VideoScreen extends StatefulWidget {
  @override
  _VideoScreenState createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  bool isDark = false;
  List<String> categories = [];
  int selectedCategoryIndex = 0;
  VideoBloc? _videoBloc;

  @override
  void initState() {
    _videoBloc = BlocProvider.of<VideoBloc>(context)..add(GetVideoDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppThemeData.darkBackgroundColor
          : AppThemeData.lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppThemeData.darkBackgroundColor
            : AppThemeData.lightBackgroundColor,
        title: Container(
          child: Text(
            helper.getTranslated(context, AppTags.prediction),
            style: Theme.of(context).textTheme.headline3,
          ),
        ),
        actions: [
          IconButton(
              icon: Image.asset("assets/images/home_screen/search_icon.png", height: 30,
                color: isDark ? AppThemeData.textColorDark.withOpacity(0.7) : AppThemeData.textColorLight.withOpacity(0.7),
              ),
              onPressed: () {
                Navigator.pushNamed(context, SearchScreen.route);
              }),
        ],
      ),
      body: BlocListener<VideoBloc, VideoState>(
        bloc: _videoBloc,
        listener: (context, state) {
          if (state is VideoErrorState) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ));
          } else if (state is VideoContentLoadedSuccessState) {
            _mainContentUI(state.videoContent);
          }
        },
        child: BlocBuilder<VideoBloc, VideoState>(
          builder: (context, state) {
            if (state is VideoErrorState) {
              return Center(
                child: LoadingIndicator(),
              );
            }
            return getViewsAsPerState(state);
          },
        ),
      ),
    );
  }

  getViewsAsPerState(VideoState state) {
    if (state is VideoContentLoadingState) {
      return Center(
        child: LoadingIndicator(),
      );
    } else if (state is VideoContentLoadedSuccessState) {
      return RefreshIndicator(
          child: _mainContentUI(state.videoContent),
          onRefresh: () async {
            BlocProvider.of<VideoBloc>(context).add(GetVideoDataEvent());
          });
    }
  }

  Widget _mainContentUI(VideoContent videoContent) {
    //add categoryList
    if (videoContent.data != null) {
      categories = [];
      for (var i = 0; i < videoContent.data!.length; i++) {
        String catTitle = videoContent.data![i].catTitle!;
        categories.add(catTitle);
      }
    }

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListView(
        children: [
          //categories
          Container(
            height: 50,
            child: Card(
              color: Utils().getCardBackgroundColor(context),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppThemeData.cardBorderRadius),
              ),
              shadowColor: AppThemeData.shadowColor,
              elevation: 3,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: categories.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        this.selectedCategoryIndex = index;
                      });
                    },
                    child: VideoScreenCatagoryListRow(
                        name: categories[index],
                        isSelected: selectedCategoryIndex == index),
                  );
                },
              ),
            ),
          ),

          _buildUI(videoContent, selectedCategoryIndex),
        ],
      ),
    );
  }

  _buildUI(VideoContent videoContent, int index) {
    Size size = MediaQuery.of(context).size;
    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    //final double itemHeight = 120.0;
    final double itemWidth = size.width / 2;
    List<Post>? sliders = videoContent.data![index].sliders;
    List<Post>? articles = videoContent.data![index].articles;
    List<Post>? trendingPosts = videoContent.data![index].trendingPosts;
    List<String>? tags = videoContent.data![index].tags;

    return CustomScrollView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      slivers: [
        //slider list
        SliverVisibility(
          visible: sliders == null
              ? false
              : sliders.length == 0
                  ? false
                  : true,
          sliver: SliverToBoxAdapter(
            child: Container(
              height: 270,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: sliders != null ? sliders.length : 0,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => InkWell(
                  child: VideoSliderListRow(
                    isDark: isDark,
                    posts: sliders != null ? sliders[index] : null,
                  ),
                ),
              ),
            ),
          ),
        ),

        //article list
        SliverVisibility(
          visible: articles == null
              ? false
              : articles.length == 0
                  ? false
                  : true,
          sliver: SliverToBoxAdapter(
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: articles!.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) => WidgetAnimator(
                child: InkWell(
                  child: VideoArticleListRow(
                    isDark: isDark,
                    post: articles != null ? articles[index] : null,
                  ),
                ),
              ),
            ),
          ),
        ),

        //trending
        SliverVisibility(
          visible: trendingPosts == null
              ? false
              : trendingPosts.length == 0
                  ? false
                  : true,
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8.0),
              child: Container(
                height: AppThemeData.newsCardHeight + 60,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            helper.getTranslated(context, AppTags.trending),
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, TrendingScreen.route);
                            },
                            style: ButtonStyle(backgroundColor:
                                MaterialStateProperty.resolveWith<Color>(
                                    (Set<MaterialState> states) {
                              if (states.contains(MaterialState.pressed))
                                return Colors.green;
                              return isDark
                                  ? AppThemeData.cardBackgroundColorDark
                                  : Colors.black;
                            })),
                            child: Text(
                              helper.getTranslated(context, AppTags.more),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline1!
                                  .copyWith(
                                      color: isDark
                                          ? AppThemeData.textColorDark
                                          : Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: AppThemeData.newsCardHeight,
                      child: ListView.builder(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        //itemCount: homeContent.data!.trendingPosts!.length,
                        itemCount:
                            trendingPosts != null ? trendingPosts.length : 0,
                        itemBuilder: (context, index) => InkWell(
                          child: VideoTrendingRow(
                            isDark: isDark,
                            trendingPost: trendingPosts != null
                                ? trendingPosts[index]
                                : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        //tags
        SliverVisibility(
          visible: tags!.length > 0,
          sliver: SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8.0),
              child: Container(
                height: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            helper.getTranslated(context, AppTags.tags),
                            style: Theme.of(context).textTheme.headline3,
                          ),
                          Text(
                            helper.getTranslated(context, AppTags.following),
                            style: Theme.of(context).textTheme.headline1,
                          )
                        ],
                      ),
                    ),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 3,
                      childAspectRatio: (itemWidth / 100),
                      controller: ScrollController(keepScrollOffset: false),
                      children: List.generate(tags.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints.tightFor(width: 40, height: 20),
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.pressed))
                                      return Colors.green;
                                    //generate a random color
                                    return Color((math.Random().nextDouble() *
                                                0xFFFFFF)
                                            .toInt())
                                        .withOpacity(1.0);
                                  },
                                ),
                              ),
                              child: Text(tags[i]),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        //banner ads
        SliverToBoxAdapter(
          child: //Banner ad
              Padding(
            padding: const EdgeInsets.only(top: 10),
            child: AdsUtils.showBannerAds(),
          ),
        )
      ],
    );
  }
}
