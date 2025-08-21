import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'notification_service.dart';
import '../router.dart';
import 'package:go_router/go_router.dart';

class FirebaseService {
  static FirebaseMessaging? _messaging;
  
  static FirebaseMessaging get messaging => _messaging!;
  static Stream<String> get onTokenRefresh => messaging.onTokenRefresh;

  static Future<void> initialize() async {
    _messaging = FirebaseMessaging.instance;
    
    // Request permission
    await _requestPermission();
    
    // Handle messages
    _handleMessages();
    
    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    
    debugPrint('Firebase Service initialized');
  }

  static Future<void> _requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');
  }

  static void _handleMessages() {
    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Received foreground message: ${message.data}');
      _handleForegroundMessage(message);
    });

    // Background/terminated app opened via notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('App opened via notification: ${message.data}');
      _handleNotificationTap(message);
    });

    // App launched via notification (terminated state)
    _checkInitialMessage();
  }

  static void _handleForegroundMessage(RemoteMessage message) {
    // Show local notification for foreground messages
    NotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: message.notification?.title ?? message.data['title'] ?? 'New Notification',
      body: message.notification?.body ?? message.data['body'] ?? 'You have a new notification',
      payload: message.data['order_id']?.toString(),
    );
  }

  static void _handleNotificationTap(RemoteMessage message) {
    final orderId = message.data['order_id']?.toString();
    if (orderId != null) {
      // Navigate to order detail
      AppRouter.router.go('/order/$orderId');
    }
  }

  static Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint('App launched via notification: ${initialMessage.data}');
      _handleNotificationTap(initialMessage);
    }
  }

  static Future<String?> getToken() async {
    try {
      String? token = await messaging.getToken();
      debugPrint('FCM Token: $token');
      return token;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  static Future<void> deleteToken() async {
    try {
      await messaging.deleteToken();
      debugPrint('FCM Token deleted');
    } catch (e) {
      debugPrint('Error deleting FCM token: $e');
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {
      await messaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await messaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }
}

// Background message handler (must be top-level function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Background message received: ${message.data}');
  // Background messages automatically show system notification
  // Custom handling can be added here if needed
}