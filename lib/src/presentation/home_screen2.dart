import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/bloc/home_content/home_content_bloc.dart';
import 'package:onoo/src/data/model/home_content/home_content.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/all_tags_screen.dart';
import 'package:onoo/src/presentation/discover/discover_screen.dart';
import 'dart:math' as math;
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/presentation/post_by_tag_screen.dart';
import 'package:onoo/src/presentation/profile/profile_screen.dart';
import 'package:onoo/src/presentation/search_screen.dart';
import 'package:onoo/src/presentation/trending_screen.dart';
import 'package:onoo/src/presentation/video_screen.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/ads/ads_utils.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:onoo/src/utils/widget_animator.dart';
import 'package:onoo/src/widgets/home_screen/article_row.dart';
import 'package:onoo/src/widgets/home_screen/category_list.dart';
import 'package:onoo/src/widgets/home_screen/slider_item.dart';
import 'package:onoo/src/widgets/home_screen/trending_row.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/widgets/more_widget.dart';
import 'package:provider/provider.dart';

import 'drawer/drawer_screen.dart';

class HomeScreen extends StatefulWidget {
  static final String route = '/HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDark = false;
  int _index = 0;

  List<Widget> _widgetOptions = <Widget>[
    // HomeScreenContent(),
    HomeScreenContent2(),

    // VideoScreen(),
    DiscoverScreen(),
    ProfileScreen(
      isFromDrawer: false,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_index),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            isDark ? AppThemeData.darkBackgroundBottomNavColor : Colors.white,
        onTap: _onItemTapped,
        currentIndex: _index,
        elevation: 5.0,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: _bottomNavIconBuilder(
                  isSelected: _index == 0, logo: "home", isDark: isDark),
              label: helper.getTranslated(context, AppTags.home),
              backgroundColor:
                  isDark ? AppThemeData.darkBackgroundColor : Colors.white),
          BottomNavigationBarItem(
              icon: _bottomNavIconBuilder(
                  isSelected: _index == 1, logo: "video", isDark: isDark),
              label: helper.getTranslated(context, AppTags.home),
              backgroundColor:
                  isDark ? AppThemeData.darkBackgroundColor : Colors.white),
          BottomNavigationBarItem(
              icon: _bottomNavIconBuilder(
                  isSelected: _index == 2, logo: 'discover', isDark: isDark),
              label: helper.getTranslated(context, AppTags.discover),
              backgroundColor:
                  isDark ? AppThemeData.darkBackgroundColor : Colors.white),
          BottomNavigationBarItem(
              icon: _bottomNavIconBuilder(
                  isSelected: _index == 3, logo: "profile", isDark: isDark),
              label: helper.getTranslated(context, AppTags.profile),
              backgroundColor:
                  isDark ? AppThemeData.darkBackgroundColor : Colors.white),
        ],
      ),
    );
  }

  Widget _bottomNavIconBuilder(
      {required bool isSelected, required String logo, required bool isDark}) {
    return Container(
      height: 38.0,
      width: 38.0,
      child: Center(
        child: SvgPicture.asset(
          "assets/images/home_screen/$logo.svg",
          height: 18,
          width: 18,
          color: isDark
              ? AppThemeData.textColorDark
              : isSelected
                  ? AppThemeData.darkBackgroundColor
                  : AppThemeData.textColorDark,
        ),
      ),
      decoration: BoxDecoration(
          color: isDark
              ? isSelected
                  ? AppThemeData.darkBackgroundBottomNavColor
                  : Colors.transparent
              : isSelected
                  ? AppThemeData.lightBackgroundColor
                  : Colors.transparent,
          shape: BoxShape.circle,
          boxShadow: [
            isSelected
                ? BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 4,
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  )
                : BoxShadow(
                    color: Colors.grey.withOpacity(0),
                  )
          ]),
    );
  }
}

class HomeScreenContent2 extends StatefulWidget {
  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent2> {
  bool isDark = false;
  List<String> categories = [];
  int selectedCategoryIndex = 0;
  HomeContentBloc? _homeContentBloc;

  @override
  void initState() {
    _homeContentBloc = BlocProvider.of<HomeContentBloc>(context)
      ..add(GetHomeContentEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    printLog("_HomeScreenContentState");
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark
          ? AppThemeData.darkBackgroundColor
          : AppThemeData.lightBackgroundColor,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppThemeData.darkBackgroundColor
            : AppThemeData.lightBackgroundColor,
        title: Center(
          child: Container(
            child: isDark
                ? Image.asset(
                    "assets/images/logo_dark.png",
                    height: 30,
                  )
                : Image.asset(
                    'assets/images/logo_light.png',
                    height: 30,
                  ),
          ),
        ),
        actions: [
          IconButton(
              icon: Image.asset(
                "assets/images/home_screen/search_icon.png",
                height: 30,
                color: isDark
                    ? AppThemeData.textColorDark
                    : AppThemeData.textColorLight,
              ),
              onPressed: () {
                Navigator.pushNamed(context, SearchScreen.route);
              }),
        ],
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
              icon: SvgPicture.asset(
                "assets/images/home_screen/menu.svg",
                height: 30,
                color: isDark
                    ? AppThemeData.textColorDark
                    : AppThemeData.textColorLight,
              ),
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              onPressed: () => Scaffold.of(context).openDrawer());
        }),
      ),
      drawer: Container(
          width: MediaQuery.of(context).size.width - 60, child: DrawerScreen()),
      body: BlocListener<HomeContentBloc, HomeContentState>(
        bloc: _homeContentBloc,
        listener: (context, state) {
          if (state is HomeContentErrorState) {
            print(state.message);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ));
          } else if (state is HomeContentCompletedState) {
            _mainContentUI(state.homeContent, context);
          }
        },
        child: BlocBuilder<HomeContentBloc, HomeContentState>(
          builder: (context, state) {
            if (state is HomeContentErrorState) {
              return Center(child: LoadingIndicator());
            }
            return getViwesAsPerState(state, context);
          },
        ),
      ),
    );
  }

  getViwesAsPerState(HomeContentState state, BuildContext context) {
    if (state is HomeContentLoadingState) {
      return Center(
        child: LoadingIndicator(),
      );
    } else if (state is HomeContentCompletedState) {
      return RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<HomeContentBloc>(context).add(GetHomeContentEvent());
        },
        child: _mainContentUI(state.homeContent, context),
      );
    } else if (state is HomeContentErrorState) {
      Utils.showToastMessage(message: state.message);
    }
  }

  Widget _mainContentUI(HomeContent homeContent, BuildContext context) {
    //add categoryList to catagories
    if (homeContent.data != null) {
      categories = [];
      for (var i = 0; i < homeContent.data!.length; i++) {
        String catTitle = homeContent.data![i].catTitle!;
        categories.add(catTitle);
      }
    }

    //categories
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ListView(
        scrollDirection: Axis.vertical,
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
                    child: HomeScreenCategoryListRow(
                        name: categories[index],
                        isSelected: selectedCategoryIndex == index),
                  );
                },
              ),
            ),
          ),
          _buildUi(homeContent, selectedCategoryIndex)
        ],
      ),
    );
  }

  _buildUi(HomeContent homeContent, int index) {
    Size size = MediaQuery.of(context).size;
    final double itemWidth = size.width / 2;
    List<Post>? sliders = homeContent.data![index].sliders;
    List<Post>? articles = homeContent.data![index].articles;
    List<Post>? trendingPosts = homeContent.data![index].trendingPosts;
    List<String>? tags = homeContent.data![index].tags;

    return CustomScrollView(
      key: UniqueKey(),
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      slivers: [
        //sliders
        SliverToBoxAdapter(
          child: Container(
            height: 260,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: sliders == null ? 0 : sliders.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, i) => InkWell(
                      child: SliderListRow(
                        isDark: isDark,
                        posts: sliders != null ? sliders[i] : null,
                      ),
                    )),
          ),
        ),

        //article list
        SliverToBoxAdapter(
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: articles != null ? articles.length : 0,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, i) => WidgetAnimator(
              child: InkWell(
                child: ArticleListRow(
                  isDark: isDark,
                  post: articles != null ? articles[i] : null,
                ),
              ),
            ),
          ),
        ),

        //trending list
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
                height: AppThemeData.newsCardHeight + 60.0,
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
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, TrendingScreen.route);
                            },
                            child: moreWidget(isDark, context),
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
                          child: TrendingRow(
                            isDark: isDark,
                            trendingPosts: trendingPosts != null
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 60,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                helper.getTranslated(context, AppTags.tags),
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              Text(
                                helper.getTranslated(
                                    context, AppTags.following),
                                style: Theme.of(context).textTheme.headline1,
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, AllTagsScreen.route);
                          },
                          child: moreWidget(isDark, context),
                        )
                      ],
                    ),
                    Wrap(
                      children: tags
                          .map((tag) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6.0, vertical: 3.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    print(tag);
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                PostByTagScreen(tag: tag)));
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty
                                        .resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                        if (states
                                            .contains(MaterialState.pressed))
                                          return Colors.green;
                                        //generate a random color
                                        return Color(
                                                (math.Random().nextDouble() *
                                                        0xFFFFFF)
                                                    .toInt())
                                            .withOpacity(1.0);
                                      },
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 12),
                                    child: Text(tag.toString()),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        //banner ads
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: AdsUtils.showBannerAds(),
          ),
        )
      ],
    );
  }
}
