import 'package:hive/hive.dart';
part 'config_model.g.dart';

@HiveType(typeId: 0)
class ConfigData extends HiveObject {
  @HiveField(0)
  bool? success;
  @HiveField(1)
  String? message;
  @HiveField(2)
  Data? data;

  ConfigData({this.success, this.message, this.data});

  ConfigData.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

@HiveType(typeId: 1)
class Data extends HiveObject {
  @HiveField(0)
  AppConfig? appConfig;
  @HiveField(1)
  AdsConfig? adsConfig;
  @HiveField(2)
  AndroidVersionInfo? androidVersionInfo;
  @HiveField(3)
  IosVersionInfo? iosVersionInfo;
  @HiveField(4)
  List<Languages>? languages = [];

  Data(
      {this.appConfig,
      this.adsConfig,
      this.androidVersionInfo,
      this.iosVersionInfo,
      this.languages});

  Data.fromJson(Map<String, dynamic> json) {
    appConfig = json['app_config'] != null
        ? new AppConfig.fromJson(json['app_config'])
        : null;
    adsConfig = json['ads_config'] != null
        ? new AdsConfig.fromJson(json['ads_config'])
        : null;
    androidVersionInfo = json['android_version_info'] != null
        ? new AndroidVersionInfo.fromJson(json['android_version_info'])
        : null;
    iosVersionInfo = json['ios_version_info'] != null
        ? new IosVersionInfo.fromJson(json['ios_version_info'])
        : null;
    if (json['languages'] != null) {
      languages = [];
      json['languages'].forEach((v) {
        languages!.add(new Languages.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.appConfig != null) {
      data['app_config'] = this.appConfig!.toJson();
    }
    if (this.adsConfig != null) {
      data['ads_config'] = this.adsConfig!.toJson();
    }
    if (this.androidVersionInfo != null) {
      data['android_version_info'] = this.androidVersionInfo!.toJson();
    }
    if (this.iosVersionInfo != null) {
      data['ios_version_info'] = this.iosVersionInfo!.toJson();
    }
    if (this.languages != null) {
      data['languages'] = this.languages!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 2)
class AppConfig extends HiveObject {
  @HiveField(0)
  String? mandatoryLogin;
  @HiveField(1)
  String? logoUrl;
  @HiveField(2)
  String? privacyPolicyUrl;
  @HiveField(3)
  String? termsNConditionUrl;
  @HiveField(4)
  String? supportUrl;
  @HiveField(5)
  AppIntro? appIntro;

  AppConfig(
      {this.mandatoryLogin,
      this.logoUrl,
      this.privacyPolicyUrl,
      this.termsNConditionUrl,
      this.supportUrl,
      this.appIntro});

  AppConfig.fromJson(Map<String, dynamic> json) {
    mandatoryLogin = json['mandatory_login'];
    logoUrl = json['logo_url'];
    privacyPolicyUrl = json['privacy_policy_url'];
    termsNConditionUrl = json['terms_n_condition_url'];
    supportUrl = json['support_url'];
    appIntro = json['app_intro'] != null
        ? new AppIntro.fromJson(json['app_intro'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mandatory_login'] = this.mandatoryLogin;
    data['logo_url'] = this.logoUrl;
    data['privacy_policy_url'] = this.privacyPolicyUrl;
    data['terms_n_condition_url'] = this.termsNConditionUrl;
    data['support_url'] = this.supportUrl;
    if (this.appIntro != null) {
      data['app_intro'] = this.appIntro!.toJson();
    }
    return data;
  }
}

@HiveType(typeId: 3)
class AppIntro extends HiveObject {
  @HiveField(0)
  String? introSkippable;
  //List<Intro?>? intro;
  @HiveField(1)
  List<Intro>? intro = [];

  AppIntro({this.introSkippable, required this.intro});

  AppIntro.fromJson(Map<String, dynamic> json) {
    introSkippable = json['intro_skippable'];
    if (json['intro'] != null) {
      var jsonList = json['intro'] as List;
      List<Intro> _intro = jsonList.map((e) => Intro.fromJson(e)).toList();
      for (Intro object in _intro) {
        intro!.add(object);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['intro_skippable'] = this.introSkippable;
    if (this.intro != null) {
      data['intro'] = this.intro!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

@HiveType(typeId: 4)
class Intro extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? language;
  @HiveField(2)
  String? disk;
  @HiveField(3)
  String? title;
  @HiveField(4)
  String? description;
  @HiveField(5)
  String? image;

  Intro(
      {this.id,
      this.language,
      this.disk,
      this.title,
      this.description,
      this.image});

  Intro.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    language = json['language'];
    disk = json['disk'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['language'] = this.language;
    data['disk'] = this.disk;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    return data;
  }
}

@HiveType(typeId: 5)
class AdsConfig extends HiveObject {
  @HiveField(0)
  String? adsEnable;
  @HiveField(1)
  String? mobileAdsNetwork;
  @HiveField(2)
  String? admobAppId;
  @HiveField(3)
  String? admobBannerAdsId;
  @HiveField(4)
  String? admobInterstitialAdsId;
  @HiveField(5)
  String? admobNativeAdsId;
  @HiveField(6)
  String? fanNativeAdsPlacementId;
  @HiveField(7)
  String? fanBannerAdsPlacementId;
  @HiveField(8)
  String? fanInterstitialAdsPlacementId;
  @HiveField(9)
  String? startappAppId;

  AdsConfig(
      {this.adsEnable,
      this.mobileAdsNetwork,
      this.admobAppId,
      this.admobBannerAdsId,
      this.admobInterstitialAdsId,
      this.admobNativeAdsId,
      this.fanNativeAdsPlacementId,
      this.fanBannerAdsPlacementId,
      this.fanInterstitialAdsPlacementId,
      this.startappAppId});

  AdsConfig.fromJson(Map<String, dynamic> json) {
    adsEnable = json['ads_enable'];
    mobileAdsNetwork = json['mobile_ads_network'];
    admobAppId = json['admob_app_id'];
    admobBannerAdsId = json['admob_banner_ads_id'];
    admobInterstitialAdsId = json['admob_interstitial_ads_id'];
    admobNativeAdsId = json['admob_native_ads_id'];
    fanNativeAdsPlacementId = json['fan_native_ads_placement_id'];
    fanBannerAdsPlacementId = json['fan_banner_ads_placement_id'];
    fanInterstitialAdsPlacementId = json['fan_interstitial_ads_placement_id'];
    startappAppId = json['startapp_app_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ads_enable'] = this.adsEnable;
    data['mobile_ads_network'] = this.mobileAdsNetwork;
    data['admob_app_id'] = this.admobAppId;
    data['admob_banner_ads_id'] = this.admobBannerAdsId;
    data['admob_interstitial_ads_id'] = this.admobInterstitialAdsId;
    data['admob_native_ads_id'] = this.admobNativeAdsId;
    data['fan_native_ads_placement_id'] = this.fanNativeAdsPlacementId;
    data['fan_banner_ads_placement_id'] = this.fanBannerAdsPlacementId;
    data['fan_interstitial_ads_placement_id'] =
        this.fanInterstitialAdsPlacementId;
    data['startapp_app_id'] = this.startappAppId;
    return data;
  }
}

@HiveType(typeId: 6)
class AndroidVersionInfo extends HiveObject {
  @HiveField(0)
  String? latestApkVersion;
  @HiveField(1)
  String? latestApkCode;
  @HiveField(2)
  String? apkFileUrl;
  @HiveField(3)
  String? whatsNewOnLatestApk;
  @HiveField(4)
  String? apkUpdateSkipableStatus;

  AndroidVersionInfo(
      {this.latestApkVersion,
      this.latestApkCode,
      this.apkFileUrl,
      this.whatsNewOnLatestApk,
      this.apkUpdateSkipableStatus});

  AndroidVersionInfo.fromJson(Map<String, dynamic> json) {
    latestApkVersion = json['latest_apk_version'];
    latestApkCode = json['latest_apk_code'];
    apkFileUrl = json['apk_file_url'];
    whatsNewOnLatestApk = json['whats_new_on_latest_apk'];
    apkUpdateSkipableStatus = json['apk_update_skipable_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latest_apk_version'] = this.latestApkVersion;
    data['latest_apk_code'] = this.latestApkCode;
    data['apk_file_url'] = this.apkFileUrl;
    data['whats_new_on_latest_apk'] = this.whatsNewOnLatestApk;
    data['apk_update_skipable_status'] = this.apkUpdateSkipableStatus;
    return data;
  }
}

@HiveType(typeId: 7)
class IosVersionInfo extends HiveObject {
  @HiveField(0)
  String? latestIpaVersion;
  @HiveField(1)
  String? latestIpaCode;
  @HiveField(2)
  String? ipaFileUrl;
  @HiveField(3)
  String? whatsNewOnLatestIpa;
  @HiveField(4)
  String? iosUpdateSkipableStatus;

  IosVersionInfo(
      {this.latestIpaVersion,
      this.latestIpaCode,
      this.ipaFileUrl,
      this.whatsNewOnLatestIpa,
      this.iosUpdateSkipableStatus});

  IosVersionInfo.fromJson(Map<String, dynamic> json) {
    latestIpaVersion = json['latest_ipa_version'];
    latestIpaCode = json['latest_ipa_code'];
    ipaFileUrl = json['ipa_file_url'];
    whatsNewOnLatestIpa = json['whats_new_on_latest_ipa'];
    iosUpdateSkipableStatus = json['ios_update_skipable_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latest_ipa_version'] = this.latestIpaVersion;
    data['latest_ipa_code'] = this.latestIpaCode;
    data['ipa_file_url'] = this.ipaFileUrl;
    data['whats_new_on_latest_ipa'] = this.whatsNewOnLatestIpa;
    data['ios_update_skipable_status'] = this.iosUpdateSkipableStatus;
    return data;
  }
}

@HiveType(typeId: 8)
class Languages {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? name;
  @HiveField(2)
  String? code;

  Languages({this.id, this.name, this.code});

  Languages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    return data;
  }
}