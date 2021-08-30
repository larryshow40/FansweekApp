import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/bloc/post_details/details_content_bloc.dart';
import 'package:onoo/src/data/model/common/user_data.dart';
import 'package:onoo/src/data/model/post_details.dart';
import 'package:onoo/src/data/repository.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/author/author_screen.dart';
import 'package:onoo/src/presentation/comment/comment_screen.dart';
import 'package:onoo/src/presentation/post_by_tag_screen.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/utils/ads/admob/interstitial.dart';
import 'package:onoo/src/utils/ads/ads_utils.dart';
import 'package:onoo/src/utils/constants.dart';
import 'package:onoo/src/widgets/loading_indicator.dart';
import 'package:onoo/src/widgets/post_details/related_stories.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import 'video_player_screen.dart';

class PostDetailsScreen extends StatefulWidget {
  static final String route = '/PostDetailsScreen';
  @override
  _PostDetailsScreenState createState() => _PostDetailsScreenState();
}

class _PostDetailsScreenState extends State<PostDetailsScreen> {
  bool isDark = false;
  DetailsContentBloc? _detailsContentBloc;
  bool isVideoPost = false;
  late PostDetails postDetails;
  bool isVideoPlayClicked = false;
  late int postId;
  late String image;

  @override
  void initState() {
    _detailsContentBloc = BlocProvider.of<DetailsContentBloc>(context);
    AdmobInsterstitialAdsUtils().loadAdmobInterstitialAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    printLog("_PostDetailsScreenState");
    final routes = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    postId = routes['postId'];
    image = routes['image'];
    print("image:$image");
    isVideoPost = routes['isVideo'] ?? false;
    isDark = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;

    return SafeArea(
      top: false,
      child: Scaffold(
          backgroundColor: isDark
              ? AppThemeData.darkBackgroundColor
              : AppThemeData.lightBackgroundColor,
          body: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Visibility(
                  visible: !isVideoPlayClicked, child: _setDetailsImage()),
              BlocProvider<DetailsContentBloc>(
                create: (context) =>
                    DetailsContentBloc(repository: Repository())
                      ..add(GetDetailsContentEvent(id: postId),),
                child: BlocListener<DetailsContentBloc, DetailsContentState>(
                  bloc: _detailsContentBloc,
                  listener: (context, state) {
                    if (state is DetailsContentErrorState) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          content: Text(state.message),
                          backgroundColor: Colors.red,
                        ));
                    } else if (state is DetailsContentLoadedSuccessState) {
                      if (state.postDetails.postType == "video") {
                        setState(() {
                          isVideoPost = true;
                          this.postDetails = state.postDetails;
                        });
                      }
                    }
                  },
                  child: BlocBuilder<DetailsContentBloc, DetailsContentState>(
                    builder: (context, state) {
                      if (state is DetailsContentErrorState) {
                        return Center(
                          child: LoadingIndicator(),
                        );
                      }
                      return getViewsAsPerState(state);
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }

  getViewsAsPerState(DetailsContentState state) {
    if (state is DetailsContentLoadedSuccessState) {
      return _buildUI(state.postDetails);
    } else if (state is DetailsContentLoadingState) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: LoadingIndicator(),
        ),
      );
    }
  }

  _getUserImage(CommonUserModel? user) {
    if (user != null && user.image != null) {
      return NetworkImage(user.image!);
    } else {
      return AssetImage(
        "assets/images/logo_round.png",
      );
    }
  }

  Widget _setDetailsImage() {
    //top image section
    return Container(
      constraints: BoxConstraints.expand(
        height: 250,
      ),
      alignment: Alignment.topLeft,
      child: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            child: FadeInImage.assetNetwork(
              placeholder: "assets/images/medium_logo_rectangle.png",
              image: image ,
              imageErrorBuilder: (context, error, stackTrace) => Image.asset(
                "assets/images/medium_logo_rectangle.png",
                fit: BoxFit.cover,
              ),
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 10),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.keyboard_arrow_left_outlined,
                  color:isDark ? Colors.white : AppThemeData.textColorLight,
                  size: 40,
                )),
          ),
          Visibility(
            visible: this.isVideoPost,
            child: Center(
              child: IconButton(
                onPressed: () {
                  Map<String, String> videoResolutionsUrls = {
                    "original": postDetails.video!.original!,
                  };
                  if(postDetails.video!.v144p != null){
                    videoResolutionsUrls["v_144p"] = postDetails.video!.v144p!;
                  }
                  if(postDetails.video!.v240p != null){
                    videoResolutionsUrls["v_240p"] = postDetails.video!.v240p!;
                  }
                  if(postDetails.video!.v360p != null){
                    videoResolutionsUrls["v_360p"] = postDetails.video!.v360p!;
                  }
                  if(postDetails.video!.v480p != null){
                    videoResolutionsUrls["v_480p"] = postDetails.video!.v480p!;
                  }
                  if(postDetails.video!.v720p != null){
                    videoResolutionsUrls["v_720p"] = postDetails.video!.v720p!;
                  }
                  if(postDetails.video!.v1080p != null){
                    videoResolutionsUrls["v_1080p"] = postDetails.video!.v1080p!;
                  }
                  printLog("videoResolutionsUrls:${videoResolutionsUrls.length}");
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPlayerScreen(videoResolutionsUrls: videoResolutionsUrls,videoTitle:this.postDetails.title,)));
                },
                icon: Image.asset("assets/images/icons/play.png", color: Colors.white, height: 40, width: 40,),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUI(PostDetails postDetails) {
    this.postDetails = postDetails;
    return Column(
      children: [
        //details section
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // ignore: unnecessary_null_comparison
                postDetails != null ? postDetails.title : "",
                style: Theme.of(context).textTheme.headline4,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, AuthorScreen.route,
                          arguments: {'authorId': postDetails.user.id!});
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundImage: _getUserImage(postDetails.user),
                          radius: 25,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              postDetails.user.firstName! +
                                  " " +
                                  postDetails.user.lastName!,
                              style: Theme.of(context).textTheme.headline2,
                            ),
                            Text(
                              postDetails.created,
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Column(
                      //   children: [
                      //     InkWell(
                      //         onTap: () {},
                      //         child: Image.asset(
                      //             'assets/images/icons/thumb_up.png')),
                      //     Text(
                      //       "900",
                      //       style: Theme.of(context).textTheme.headline1,
                      //     )
                      //   ],
                      // ),
                      // Column(
                      //   children: [
                      //     InkWell(
                      //         onTap: () {},
                      //         child: Image.asset(
                      //             'assets/images/icons/favourite.png')),
                      //     Text(
                      //       helper.getTranslated(context, AppTags.favourite),
                      //       style: Theme.of(context).textTheme.headline1,
                      //     )
                      //   ],
                      // ),
                      InkWell(
                        onTap: (){
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => CommentScreen(
                                postId: postDetails.id,
                                commentsCount:
                                postDetails.commentsCount,
                              )));
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                                child: SvgPicture.asset(isDark ?'assets/images/icons/comment_icon_dark.svg':'assets/images/icons/comment_icon.svg')),
                            Text(
                              postDetails.commentsCount.toString(),
                              style: Theme.of(context).textTheme.headline1,
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          //share
                          Share.share(postDetails.url);
                        },
                        child: Column(
                          children: [
                            Card(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                                child: SvgPicture.asset(isDark ?'assets/images/icons/share_icon_dark.svg': 'assets/images/icons/share_icon.svg')),
                            Text(
                              helper.getTranslated(context, AppTags.share),
                              style: Theme.of(context).textTheme.subtitle2,
                            )
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
              //details
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Html(data: postDetails.content,)
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: postDetails.tags.length,
                    shrinkWrap: true,
                    itemBuilder: (contex, index) {
                      return _tagsListItem(postDetails.tags[index]);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //banner ad
              Container(
                  padding: EdgeInsets.only(bottom: 15),
                  alignment: Alignment.center,
                  child: AdsUtils.showBannerAds()),

              //related stories
              Visibility(
                visible: postDetails.relatedPosts.length > 0,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    helper.getTranslated(context, AppTags.relatedStories),
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
              ),

              Visibility(
                visible: postDetails.relatedPosts.length > 0,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: postDetails.relatedPosts.length,
                  itemBuilder: (context, index) {
                    return RelatedStoriesListRow(
                        isDark: isDark,
                        relatedPosts: postDetails.relatedPosts[index]);
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              //related topics
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  helper.getTranslated(context, AppTags.relatedTopics),
                  style: Theme.of(context).textTheme.headline2,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                height: 2,
                color: isDark
                    ? AppThemeData.textColorDark
                    : AppThemeData.textColorLight,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: postDetails.relatedTopic.length,
                itemBuilder: (contex, index) {
                  return _relatedTopicsListRow(postDetails.relatedTopic[index]);
                },
              ),
              //banner ad
              Container(
                  padding: EdgeInsets.only(top: 15),
                  alignment: Alignment.center,
                  child: AdsUtils.showBannerAds()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tagsListItem(String tag) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PostByTagScreen(tag: tag)));
        },
        child: Text(tag),
        style: ButtonStyle(
            //foreground color is text color
            foregroundColor: MaterialStateProperty.all<Color>(
                isDark ? AppThemeData.textColorDark : Colors.black),
            backgroundColor: MaterialStateProperty.all<Color>(isDark
                ? AppThemeData.cardBackgroundColorDark
                : AppThemeData.textColorDark),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    side: BorderSide(
                        color: isDark
                            ? AppThemeData.cardBackgroundColorDark
                            : AppThemeData.textColorDark)))),
      ),
    );
  }

  Widget _relatedTopicsListRow(RelatedTopic relatedTopic) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        PostByTagScreen(tag: relatedTopic.categoryName)));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                relatedTopic.categoryName,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
        ),
        Divider(
          height: 2,
          color:
              isDark ? AppThemeData.textColorDark : AppThemeData.textColorLight,
        ),
      ],
    );
  }
}
