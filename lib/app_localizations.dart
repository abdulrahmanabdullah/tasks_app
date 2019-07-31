import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // To access private _AppLocalization class,then we can load and translate
  static const  LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationDelegate();

  Map<String, String> _localizedStrings;

  Future<bool> load() async {
    // Load the language JSON file
    String jsonFile =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonFile);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  //This method well be called from every widget

  String translate(String key) {
    return _localizedStrings[key];
  }

}

class _AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {

  //Make constructor const here cause we not instance any obj of this class.
  // it well be always like that and never change.
  const _AppLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
