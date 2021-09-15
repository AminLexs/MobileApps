import 'package:flutter/material.dart';
import 'dart:convert';

enum Locale { ru, en }

class LocaleModel extends ChangeNotifier {
  BuildContext _context;
  var _selectedLocale;
  Map<String, dynamic> _localisedValues = new Map<String, dynamic>();

  LocaleModel(BuildContext context) {
    _context = context;
    setLocale(Locale.en);
  }

  get locale => _selectedLocale;

  void setLocale(Locale locale) async {
    _selectedLocale = locale;

    String jsonContent = await DefaultAssetBundle.of(_context)
        .loadString("assets/locale/${locale.toString()}.json");

    _localisedValues = json.decode(jsonContent);

    notifyListeners();
  }

  getString(String key) => _localisedValues[key] ?? "$key not found";
}
