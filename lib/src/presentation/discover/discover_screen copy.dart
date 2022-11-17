import 'package:flutter/material.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/model/discover/discover_model.dart';
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/discover/discover_posts_by_cat_screen.dart';
import 'package:onoo/src/presentation/sub_cat_post_screen.dart';
import 'package:onoo/src/utils/utils.dart';
import 'package:onoo/src/utils/ads/ads_utils.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/utils/constants.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:provider/provider.dart';

class DiscoverScreen extends StatefulWidget {
  static final String route = '/DiscoverScreen';
  @override
  _DiscoverScreenState createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  bool isDark = false;
  late Future<DiscoverModel> discoverData;

  @override
  void initState() {
    super.initState();
    discoverData = Repository().getDiscoverData();
  }

  @override
  Widget build(BuildContext context) {
    printLog("_DiscoverScreenState");
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isDark
              ? AppThemeData.darkBackgroundColor
              : AppThemeData.lightBackgroundColor,
          title: Container(
            child: Text(
              helper.getTranslated(context, AppTags.discover),
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          actions: [
            IconButton(
                icon: Image.asset(
                  "assets/images/home_screen/search_icon.png", height: 30,
                  color: isDark ? AppThemeData.textColorDark.withOpacity(0.7) : AppThemeData.textColorLight.withOpacity(0.7),
                ),
                onPressed: () {}),
          ],
        ),
        backgroundColor: isDark
            ? AppThemeData.darkBackgroundColor
            : AppThemeData.lightBackgroundColor,
        body: FutureBuilder<DiscoverModel>(
          future: discoverData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              DiscoverModel data = snapshot.data!;
              return _buildUI(data);
            } else if (snapshot.hasError) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text("Failed to load data."),
                  backgroundColor: Colors.red,
                ));
            }
            return Center(
              child: LoadingIndicator(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUI(DiscoverModel data) {
    Size size = MediaQuery.of(context).size;
    //final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemHeight = 140.0;
    final double itemWidth = size.width / 2;

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppThemeData.wholeScreenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  helper.getTranslated(context, AppTags.recommend),
                  style: Theme.of(context).textTheme.headline3,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: GridView.count(
                  shrinkWrap: true,
                  childAspectRatio: (itemWidth / itemHeight),
                  controller: new ScrollController(keepScrollOffset: false),
                  scrollDirection: Axis.vertical,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  children: List.generate(
                      data.data.recommendedCategories.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        child: Card(
                          color: Utils().getCardBackgroundColor(context),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                AppThemeData.cardBorderRadius),
                          ),
                          elevation: AppThemeData.cardElevation,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DiscoverPostByCatScreen(categoryId: data.data.recommendedCategories[index].id, catType: "recommended", catName: data.data.recommendedCategories[index].categoryName)));
                            },
                            child: Stack(
                              children: [
                                Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppThemeData.cardBorderRadius)),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(
                                            AppThemeData.cardBorderRadius)),
                                    child: FadeInImage.assetNetwork(
                                      fit: BoxFit.cover,
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.asset(
                                          "assets/images/logo_rectangle.png",
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      placeholder: "assets/images/logo_rectangle.png",
                                      image: data.data.recommendedCategories[index].image,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 25),
                                    child: Text(
                                      data.data.recommendedCategories[index]
                                          .categoryName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline2!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Visibility(
                visible: data.data.featuredCategories.length > 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        helper.getTranslated(context, AppTags.featured),
                        style: Theme.of(context).textTheme.headline3,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 0.0),
                      child: GridView.count(
                        shrinkWrap: true,
                        childAspectRatio: (itemWidth / itemHeight),
                        controller:
                            new ScrollController(keepScrollOffset: false),
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        children: List.generate(
                            data.data.featuredCategories.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Container(
                              child: Card(
                                color: Utils().getCardBackgroundColor(context),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppThemeData.cardBorderRadius),
                                ),
                                elevation: AppThemeData.cardElevation,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DiscoverPostByCatScreen(
                                                    categoryId: data.data.featuredCategories[index].id,
                                                    catType: "featured",
                                                    catName: data.data.featuredCategories[index].categoryName)));
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                        height: double.infinity,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.rectangle,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(AppThemeData
                                                  .cardBorderRadius)),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(AppThemeData
                                                  .cardBorderRadius)),
                                          child: FadeInImage.assetNetwork(
                                            fit: BoxFit.cover,
                                            imageErrorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                "assets/images/logo_rectangle.png",
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            placeholder: "assets/images/logo_rectangle.png",
                                            image: data.data.featuredCategories[index].image,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 25),
                                          child: Text(
                                            data.data.featuredCategories[index]
                                                .categoryName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline2!
                                                .copyWith(color: Colors.white),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      helper.getTranslated(context, AppTags.discoverByCategory),
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),

                  Wrap(
                    children:  data.data.discoverByCategories
                        .map((data) =>  Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2.5,
                        child: Column(
                          children: [
                            Text(
                              data
                                  .categoryName,
                              style: Theme.of(context)
                                  .textTheme
                                  .headline3!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  itemCount: data.subCategory.length,
                                  itemBuilder: (context, i) => InkWell(
                                    onTap: () {
                                      //navigate to subcat screen
                                      Navigator.pushNamed(context, SubCatPostsScreen.route, arguments: {
                                        'subCatId': data.subCategory[i].id,
                                        'subCatName': data.subCategory[i].subCategoryName});
                                    },
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.all(3.0),
                                      child: Center(
                                        child: Text(
                                          data.subCategory[i]
                                              .subCategoryName,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline2,
                                        ),
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                    )
                    ).toList(),
                  ),

                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10),
                child: Container(
                    alignment: Alignment.center,
                    child: AdsUtils.showBannerAds()),
              ),
            ],
          ),
        )
      ],
    );
  }
}
