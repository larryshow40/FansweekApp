import 'package:flutter/material.dart';
import 'package:onoo/src/preferences/database_config.dart';
import 'package:onoo/src/utils/ads/admob/banner.dart';
import 'package:onoo/src/utils/ads/admob/interstitial.dart';
import 'package:onoo/src/utils/constants.dart';

class AdsUtils {
  static Widget showBannerAds() {
    printLog("Inside_showBannerAds:${DatabaseConfig().isAdsEnable()}");
    if (DatabaseConfig().isAdsEnable()) {
      String activeAdNetwork = DatabaseConfig().activeAdNetwork();
      if (activeAdNetwork == "admob") {
        return AdmobBannerAdUtils();
      }
    }
    return Container();
  }

  static void showInterstitialAd() {
    if (DatabaseConfig().isAdsEnable()) {
      String activeAdNetwork = DatabaseConfig().activeAdNetwork();
      if (activeAdNetwork == "admob") {
        AdmobInsterstitialAdsUtils().loadAdmobInterstitialAd();
      }
    }
  }
}
