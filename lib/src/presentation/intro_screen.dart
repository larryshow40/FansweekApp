import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
import 'package:onoo/app_theme_data.dart';
import 'package:onoo/src/data/helper/localization_helper.dart' as helper;
import 'package:onoo/src/data/model/config/config_model.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/preferences/theme_provider.dart';
import 'package:onoo/src/presentation/sign_up/sign_up.dart';
import 'package:onoo/src/utils/app_tags.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class IntroScreen extends StatefulWidget {
  static final String route = '/IntroScreen';

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool isDark = false;
  bool isSkipable = true;
  final List<Slide> slides = [];
  List<Widget> tabs = [];

  @override
  void initState() {
    isSkipable = DatabaseConfig().getIntroData()!.introSkippable == "true";
    super.initState();
  }

  @override
  void didChangeDependencies() {
    List<Intro>? introList = DatabaseConfig().getIntroData()!.intro;
    if (introList != null) {
      for (var i = 0; i < introList.length; i++) {
        Slide slide = Slide(
          title: introList[i].title,
          description: introList[i].description,
          marginTitle: EdgeInsets.only(top: 100.0, bottom: 30.0),
          maxLineTextDescription: 2,
          styleTitle: Theme.of(context).textTheme.headline4,
          marginDescription: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
          styleDescription: Theme.of(context).textTheme.headline2,
          foregroundImageFit: BoxFit.fitWidth,
        );
        slide.pathImage = introList[i].image;
        slides.add(slide);
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? AppThemeData.darkBackgroundColor : AppThemeData.lightBackgroundColor,
      body: IntroSlider(
        colorActiveDot: isDark ? AppThemeData.textColorDark : AppThemeData.textColorLight,
        showSkipBtn: this.isSkipable,
        slides: slides,
        backgroundColorAllSlides: isDark ? AppThemeData.darkBackgroundColor : AppThemeData.lightBackgroundColor,
        skipButtonStyle: introCustomButtonStyle(),
        doneButtonStyle: introCustomButtonStyle(),
        nextButtonStyle: introCustomButtonStyle(),
        listCustomTabs:this.renderListCustomTabs(),
        renderSkipBtn: this.renderIntroBtn(helper.getTranslated(context, AppTags.skipButton),),
        renderPrevBtn: this.renderIntroBtn(helper.getTranslated(context, AppTags.preButton)),
        renderDoneBtn: this.renderIntroBtn(helper.getTranslated(context, AppTags.doneButton)),
        renderNextBtn: this.renderIntroBtn(helper.getTranslated(context, AppTags.nextButton)),

        onDonePress: () async {
          _introCompleted();
        },
        onSkipPress: () async {
          _introCompleted();
        },
      ),
    );
  }


    Widget renderIntroBtn(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Text(text,style: TextStyle(color:isDark ? AppThemeData.textColorDark :AppThemeData.textColorLight),),
    );
  }

  ButtonStyle introCustomButtonStyle() {
    return ButtonStyle(
      shape: MaterialStateProperty.all<OutlinedBorder>(StadiumBorder()),
      backgroundColor: MaterialStateProperty.all<Color>(isDark ? AppThemeData.introBtnColorDark : AppThemeData.introBtnColorlight),
      overlayColor: MaterialStateProperty.all<Color>(isDark ? AppThemeData.introBtnColorDark : AppThemeData.introBtnColorlight),
    );
  }

  void _introCompleted() {
    AppConfig? appConfig = DatabaseConfig().getConfigData()!.data!.appConfig!;
    bool isLoggedIn = DatabaseConfig().isUserLoggedIn();
    DatabaseConfig().saveFirstOpenStatus(false);

    if (appConfig.mandatoryLogin == "true" && !isLoggedIn) {
      print("-------Mandatory login enabled and user is not loggedIn");
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, SignupScreen.route);
      });
    } else {
      print("-------Mandatory login disabled");
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, HomeScreen.route);
      });
    }
  }

  List<Widget> renderListCustomTabs() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<Widget> tabs = [];
    for (var i = 0; i < slides.length; i++) {
      Slide currentSlide = slides[i];
      tabs.add(Container(
        width: double.infinity,
        height: double.infinity,
        child: Container(
          margin: EdgeInsets.only(bottom: height * 0.12, top: height * 0.1,left: 10.0,right: 10.0),
          child: Center(
            child: Container(
              height: height,
              width: width,
              child: ListView(
                children: [
                  Container(
                    height: height * 0.35,
                    width: width * 0.45,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: currentSlide.pathImage != null ? NetworkImage(currentSlide.pathImage!,scale: 1.2) : AssetImage("assets/images/logo_round.png") as ImageProvider),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 5,
                            offset: Offset(0, 1),
                          )
                        ]),
                  ),
                  Container(
                    child: Text(
                      currentSlide.title ?? "",
                      style: currentSlide.styleTitle,
                      textAlign: TextAlign.center,
                    ),
                    margin: EdgeInsets.only(top: 60.0),
                  ),
                  Container(
                    child: Text(
                      currentSlide.description ?? "",
                      style: currentSlide.styleDescription,
                      textAlign: TextAlign.center,
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    margin: EdgeInsets.only(top: 15.0, bottom: 100.0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ));
    }
    return tabs;
  }
}
