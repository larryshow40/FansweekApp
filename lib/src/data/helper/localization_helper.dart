import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:onoo/src/localizations.dart';
import 'package:onoo/config.dart';

String getTranslated(BuildContext context, String key) {
  return MyLocalization.of(context).getTranslatedValues(key);
}

Locale setLocal(String languageCode) {
  Box box = Hive.box("languageCode");
  box.put("languageCode", languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  var box = Hive.box("languageCode");
  String? languageCode = box.get("languageCode");
  if (languageCode == null) {
    return _locale("en");
  }
  return _locale(languageCode);
}

_locale(String languageCode) {
  for (Locale locale in Config.supportedLanguageList) {
    if (locale.languageCode == languageCode) {
      return locale;
    }
  }
  return Locale("en", 'US');
}
