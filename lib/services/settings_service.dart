import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _notificationsKey = 'notifications_enabled';
  static const String _offlineModeKey = 'offline_mode';
  static const String _languageKey = 'language';
  static const String _textSizeKey = 'text_size';

  late SharedPreferences _prefs;
  bool _initialized = false;

  // Initialize SharedPreferences
  Future<void> init() async {
    if (!_initialized) {
      _prefs = await SharedPreferences.getInstance();
      _initialized = true;
    }
  }

  // Notifications
  bool get notificationsEnabled => _prefs.getBool(_notificationsKey) ?? true;
  
  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(_notificationsKey, value);
  }

  // Offline Mode
  bool get offlineMode => _prefs.getBool(_offlineModeKey) ?? false;
  
  Future<void> setOfflineMode(bool value) async {
    await _prefs.setBool(_offlineModeKey, value);
  }

  // Language
  String get language => _prefs.getString(_languageKey) ?? 'EN';
  
  Future<void> setLanguage(String value) async {
    await _prefs.setString(_languageKey, value);
  }

  // Text Size
  String get textSize => _prefs.getString(_textSizeKey) ?? 'Medium';
  
  Future<void> setTextSize(String value) async {
    await _prefs.setString(_textSizeKey, value);
  }

  // Clear all settings (for logout)
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
