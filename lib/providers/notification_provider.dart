import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firebase_service.dart';

class NotificationProvider with ChangeNotifier {
  bool _notificationsEnabled = true;
  String? _fcmToken;
  
  bool get notificationsEnabled => _notificationsEnabled;
  String? get fcmToken => _fcmToken;

  NotificationProvider() {
    _loadSettings();
    _initializeFCM();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    notifyListeners();
  }

  Future<void> _initializeFCM() async {
    try {
      _fcmToken = await FirebaseService.getToken();
      notifyListeners();
      
      // Listen for token refresh
      FirebaseService.onTokenRefresh.listen((token) {
        _fcmToken = token;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error initializing FCM: $e');
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    _notificationsEnabled = enabled;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', enabled);
    
    notifyListeners();
  }

  Future<void> refreshToken() async {
    try {
      await FirebaseService.deleteToken();
      _fcmToken = await FirebaseService.getToken();
      notifyListeners();
    } catch (e) {
      debugPrint('Error refreshing FCM token: $e');
    }
  }

  Future<void> sendTokenToServer() async {
    if (_fcmToken != null) {
      try {
        // Optional: Send token to backend
        // await ApiService.sendFCMToken(_fcmToken!);
        debugPrint('FCM Token would be sent to server: $_fcmToken');
      } catch (e) {
        debugPrint('Error sending token to server: $e');
      }
    }
  }
}