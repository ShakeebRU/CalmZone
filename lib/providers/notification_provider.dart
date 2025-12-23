import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationProvider with ChangeNotifier {
  // Notification enable/disable state
  final Map<String, bool> _notifications = {
    'water': true,
    'breakfast': true,
    'lunch': true,
    'dinner': true,
    'snacks': true,
    'workout': false,
    'meditation': true,
  };

  // Notification times (water and meals are fixed)
  final Map<String, String> _notificationTimes = {
    'water': 'HOURLY', // fixed hourly reminders
    'breakfast': '08:00', // fixed
    'lunch': '13:00', // fixed
    'dinner': '19:00', // fixed
    'snacks': '15:00', // optional
    'workout': '18:00', // customizable
    'meditation': '21:00', // customizable
  };

  Map<String, bool> get notifications => _notifications;
  Map<String, String> get notificationTimes => _notificationTimes;

  NotificationProvider() {
    _loadNotificationSettings();
  }

  Future<void> _loadNotificationSettings() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in _notifications.keys) {
      _notifications[key] = prefs.getBool('notification_$key') ?? _notifications[key]!;
      // Only restore customizable times; fixed ones keep defaults
      if (_isTimeCustomizable(key)) {
        _notificationTimes[key] =
            prefs.getString('notification_time_$key') ?? _notificationTimes[key]!;
      }
    }
    notifyListeners();
  }

  Future<void> toggleNotification(String key, bool value) async {
    _notifications[key] = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_$key', value);
  }

  Future<void> setNotificationTime(String key, String time) async {
    if (!_isTimeCustomizable(key)) return;
    _notificationTimes[key] = time;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notification_time_$key', time);
  }

  bool _isTimeCustomizable(String key) {
    return key == 'workout' || key == 'meditation' || key == 'snacks';
  }
}

