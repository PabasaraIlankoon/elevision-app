import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _emergencyKey = 'emergency_number';
  static const String _languageKey = 'app_language';
  static String emergencyNumber = '119';
  static String language = 'en'; // 'en' for English, 'si' for Sinhala

  static Future<String> loadEmergencyNumber() async {
    final prefs = await SharedPreferences.getInstance();
    emergencyNumber = prefs.getString(_emergencyKey) ?? '119';
    return emergencyNumber;
  }

  static Future<void> saveEmergencyNumber(String number) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emergencyKey, number);
    emergencyNumber = number.isEmpty ? '119' : number;
  }

  static Future<String> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString(_languageKey) ?? 'en';
    return language;
  }

  static Future<void> saveLanguage(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, lang);
    language = lang;
  }
}
