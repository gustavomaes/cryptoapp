import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  // late SharedPreferences _prefs;
  late Box box;
  Map<String, String> locale = {
    'locale': 'pt_BR',
    'name': 'R\$',
  };

  AppSettings() {
    _startSettings();
  }

  _startSettings() async {
    await _startPreferences();
    await _readLocale();
  }

  _startPreferences() async {
    // _prefs = await SharedPreferences.getInstance();
    box = await Hive.openBox('preferences');
  }

  _readLocale() async {
    final localePrefs = box.get('locale') ?? 'pt_BR';
    final name = box.get('name') ?? 'R\$';
    locale = {'locale': localePrefs, 'name': name};
    notifyListeners();
  }

  setLocale(String newLocale, String newName) async {
    await box.put('locale', newLocale);
    await box.put('name', newName);
    _readLocale();
  }
}
