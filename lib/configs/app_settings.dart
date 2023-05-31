import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppSettings extends ChangeNotifier {
  late SharedPreferences _prefs;
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
    _prefs = await SharedPreferences.getInstance();
  }

  _readLocale() async {
    final localePrefs = _prefs.getString('locale') ?? 'pt_BR';
    final name = _prefs.getString('name') ?? 'R\$';
    locale = {'locale': localePrefs, 'name': name};
    notifyListeners();
  }

  setLocale(String newLocale, String newName) async {
    await _prefs.setString('locale', newLocale);
    await _prefs.setString('name', newName);
    _readLocale();
  }
}
