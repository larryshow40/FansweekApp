import 'package:onoo/src/data/model/config/config_model.dart';
import 'package:onoo/src/preferences/database_config.dart';

class Language {
  final int id;
  final String flag;
  final String name;
  final String languageCode;

  Language(
      {required this.id,
      required this.flag,
      required this.name,
      required this.languageCode});

  static List<Language> languageList() {
    return <Language>[
      Language(id: 1, flag: "US", name: "English", languageCode: "en"),
      Language(id: 2, flag: "BD", name: "বাংলা", languageCode: "bn"),
      Language(id: 3, flag: "SA", name: "اَلْعَرَبِيَّةُ‎", languageCode: "ar"),
      Language(id: 4, flag: "IN", name: "हिंदी", languageCode: "hi"),
    ];
  }
  List<Languages>? list = DatabaseConfig().getLanguageList();
}
