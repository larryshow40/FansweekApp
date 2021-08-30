import 'dart:math';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:onoo/src/data/model/config/config_model.dart';
import 'package:onoo/src/preferences/database_config.dart';

class AdmobInsterstitialAdsUtils {
  void loadAdmobInterstitialAd() {
    ConfigData? _configData = DatabaseConfig().getConfigData();
    bool isAdsEnabled = DatabaseConfig().isAdsEnable();

    //load ad
    if (isAdsEnabled && Random().nextInt(100).isEven) {
      InterstitialAd.load(
        adUnitId: _configData != null
            ? _configData.data!.adsConfig != null
                ? _configData.data!.adsConfig!.admobInterstitialAdsId != null
                    ? _configData.data!.adsConfig!.admobInterstitialAdsId!
                    : ""
                : ""
            : "",
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            _showInterstitialAd(ad);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ),
      );
    }
  }

  void _showInterstitialAd(InterstitialAd ad) {
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {},
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
      },
      onAdImpression: (ad) {},
    );

    ad.show();
  }
}
