import 'package:flutter/foundation.dart';
import '../services/settings_service.dart';

class SettingsProvider extends ChangeNotifier {
  final SettingsService _settingsService = SettingsService();
  
  bool _initialized = false;
  bool _notificationsEnabled = true;
  bool _offlineMode = false;
  String _language = 'EN';
  String _textSize = 'Medium';

  bool get notificationsEnabled => _notificationsEnabled;
  bool get offlineMode => _offlineMode;
  String get language => _language;
  String get textSize => _textSize;
  bool get initialized => _initialized;

  // Initialize settings from storage
  Future<void> init() async {
    await _settingsService.init();
    _notificationsEnabled = _settingsService.notificationsEnabled;
    _offlineMode = _settingsService.offlineMode;
    _language = _settingsService.language;
    _textSize = _settingsService.textSize;
    _initialized = true;
    notifyListeners();
  }

  // Set notifications
  Future<void> setNotificationsEnabled(bool value) async {
    _notificationsEnabled = value;
    notifyListeners();
    await _settingsService.setNotificationsEnabled(value);
  }

  // Set offline mode
  Future<void> setOfflineMode(bool value) async {
    _offlineMode = value;
    notifyListeners();
    await _settingsService.setOfflineMode(value);
  }

  // Set language
  Future<void> setLanguage(String value) async {
    _language = value;
    notifyListeners();
    await _settingsService.setLanguage(value);
  }

  // Set text size
  Future<void> setTextSize(String value) async {
    _textSize = value;
    notifyListeners();
    await _settingsService.setTextSize(value);
  }

  // Clear settings (for logout)
  Future<void> clearSettings() async {
    await _settingsService.clearAll();
    _notificationsEnabled = true;
    _offlineMode = false;
    _language = 'EN';
    _textSize = 'Medium';
    notifyListeners();
  }
}
