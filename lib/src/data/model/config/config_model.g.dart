// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigDataAdapter extends TypeAdapter<ConfigData> {
  @override
  final int typeId = 0;

  @override
  ConfigData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConfigData(
      success: fields[0] as bool?,
      message: fields[1] as String?,
      data: fields[2] as Data?,
    );
  }

  @override
  void write(BinaryWriter writer, ConfigData obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.success)
      ..writeByte(1)
      ..write(obj.message)
      ..writeByte(2)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataAdapter extends TypeAdapter<Data> {
  @override
  final int typeId = 1;

  @override
  Data read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Data(
      appConfig: fields[0] as AppConfig?,
      adsConfig: fields[1] as AdsConfig?,
      androidVersionInfo: fields[2] as AndroidVersionInfo?,
      iosVersionInfo: fields[3] as IosVersionInfo?,
      languages: (fields[4] as List?)?.cast<Languages>(),
    );
  }

  @override
  void write(BinaryWriter writer, Data obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.appConfig)
      ..writeByte(1)
      ..write(obj.adsConfig)
      ..writeByte(2)
      ..write(obj.androidVersionInfo)
      ..writeByte(3)
      ..write(obj.iosVersionInfo)
      ..writeByte(4)
      ..write(obj.languages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppConfigAdapter extends TypeAdapter<AppConfig> {
  @override
  final int typeId = 2;

  @override
  AppConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppConfig(
      mandatoryLogin: fields[0] as String?,
      logoUrl: fields[1] as String?,
      privacyPolicyUrl: fields[2] as String?,
      termsNConditionUrl: fields[3] as String?,
      supportUrl: fields[4] as String?,
      appIntro: fields[5] as AppIntro?,
    );
  }

  @override
  void write(BinaryWriter writer, AppConfig obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.mandatoryLogin)
      ..writeByte(1)
      ..write(obj.logoUrl)
      ..writeByte(2)
      ..write(obj.privacyPolicyUrl)
      ..writeByte(3)
      ..write(obj.termsNConditionUrl)
      ..writeByte(4)
      ..write(obj.supportUrl)
      ..writeByte(5)
      ..write(obj.appIntro);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppIntroAdapter extends TypeAdapter<AppIntro> {
  @override
  final int typeId = 3;

  @override
  AppIntro read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AppIntro(
      introSkippable: fields[0] as String?,
      intro: (fields[1] as List?)?.cast<Intro>(),
    );
  }

  @override
  void write(BinaryWriter writer, AppIntro obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.introSkippable)
      ..writeByte(1)
      ..write(obj.intro);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppIntroAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IntroAdapter extends TypeAdapter<Intro> {
  @override
  final int typeId = 4;

  @override
  Intro read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Intro(
      id: fields[0] as int?,
      language: fields[1] as String?,
      disk: fields[2] as String?,
      title: fields[3] as String?,
      description: fields[4] as String?,
      image: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Intro obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.language)
      ..writeByte(2)
      ..write(obj.disk)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IntroAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AdsConfigAdapter extends TypeAdapter<AdsConfig> {
  @override
  final int typeId = 5;

  @override
  AdsConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdsConfig(
      adsEnable: fields[0] as String?,
      mobileAdsNetwork: fields[1] as String?,
      admobAppId: fields[2] as String?,
      admobBannerAdsId: fields[3] as String?,
      admobInterstitialAdsId: fields[4] as String?,
      admobNativeAdsId: fields[5] as String?,
      fanNativeAdsPlacementId: fields[6] as String?,
      fanBannerAdsPlacementId: fields[7] as String?,
      fanInterstitialAdsPlacementId: fields[8] as String?,
      startappAppId: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AdsConfig obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.adsEnable)
      ..writeByte(1)
      ..write(obj.mobileAdsNetwork)
      ..writeByte(2)
      ..write(obj.admobAppId)
      ..writeByte(3)
      ..write(obj.admobBannerAdsId)
      ..writeByte(4)
      ..write(obj.admobInterstitialAdsId)
      ..writeByte(5)
      ..write(obj.admobNativeAdsId)
      ..writeByte(6)
      ..write(obj.fanNativeAdsPlacementId)
      ..writeByte(7)
      ..write(obj.fanBannerAdsPlacementId)
      ..writeByte(8)
      ..write(obj.fanInterstitialAdsPlacementId)
      ..writeByte(9)
      ..write(obj.startappAppId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdsConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AndroidVersionInfoAdapter extends TypeAdapter<AndroidVersionInfo> {
  @override
  final int typeId = 6;

  @override
  AndroidVersionInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AndroidVersionInfo(
      latestApkVersion: fields[0] as String?,
      latestApkCode: fields[1] as String?,
      apkFileUrl: fields[2] as String?,
      whatsNewOnLatestApk: fields[3] as String?,
      apkUpdateSkipableStatus: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AndroidVersionInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.latestApkVersion)
      ..writeByte(1)
      ..write(obj.latestApkCode)
      ..writeByte(2)
      ..write(obj.apkFileUrl)
      ..writeByte(3)
      ..write(obj.whatsNewOnLatestApk)
      ..writeByte(4)
      ..write(obj.apkUpdateSkipableStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AndroidVersionInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IosVersionInfoAdapter extends TypeAdapter<IosVersionInfo> {
  @override
  final int typeId = 7;

  @override
  IosVersionInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IosVersionInfo(
      latestIpaVersion: fields[0] as String?,
      latestIpaCode: fields[1] as String?,
      ipaFileUrl: fields[2] as String?,
      whatsNewOnLatestIpa: fields[3] as String?,
      iosUpdateSkipableStatus: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IosVersionInfo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.latestIpaVersion)
      ..writeByte(1)
      ..write(obj.latestIpaCode)
      ..writeByte(2)
      ..write(obj.ipaFileUrl)
      ..writeByte(3)
      ..write(obj.whatsNewOnLatestIpa)
      ..writeByte(4)
      ..write(obj.iosUpdateSkipableStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IosVersionInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LanguagesAdapter extends TypeAdapter<Languages> {
  @override
  final int typeId = 8;

  @override
  Languages read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Languages(
      id: fields[0] as int?,
      name: fields[1] as String?,
      code: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Languages obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.code);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LanguagesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
