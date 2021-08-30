import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onoo/src/data/model/config/config_model.dart';
import 'package:onoo/src/preferences/database_config.dart';

// ignore: must_be_immutable
class AdmobBannerAdUtils extends StatelessWidget {
  ConfigData? _configData;

  final BannerAdListener _listener = BannerAdListener(
    onAdLoaded: (ad) {},
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
    },
    onAdOpened: (ad) {},
    onAdClosed: (ad) {},
    onAdImpression: (ad) {},
  );

  @override
  Widget build(BuildContext context) {
    _configData = DatabaseConfig().getConfigData();
    bool isAdsEnabled = DatabaseConfig().isAdsEnable();

    final BannerAd _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: _configData != null ? _configData!.data!.adsConfig != null ? _configData!.data!.adsConfig!.admobBannerAdsId != null ? _configData!.data!.adsConfig!.admobBannerAdsId! : "" : "" : "",
        listener: _listener,
        request: AdRequest());

    if (_configData != null && _configData!.data != null) {
      if (_configData!.data!.adsConfig != null) {
        if (isAdsEnabled) {
          _bannerAd.load();
        }
      }
    }

    return Visibility(
      visible: isAdsEnabled,
      child: Container(
        alignment: Alignment.center,
        child: AdWidget(ad: _bannerAd),
        width: _bannerAd.size.width.toDouble(),
        height: _bannerAd.size.height.toDouble(),
      ),
    );
  }
}
