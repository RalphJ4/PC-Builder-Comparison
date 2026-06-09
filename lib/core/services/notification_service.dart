import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    if (!kIsWeb) {
      await _fcm.requestPermission(alert: true, badge: true, sound: true);
    }
    try {
      if (!kIsWeb) {
        await _fcm.subscribeToTopic('price_alerts_ph');
      }
    } catch (_) {}

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings, iOS: iosSettings),
    );

    FirebaseMessaging.onMessage.listen(_showLocalNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);
  }

  void _showLocalNotification(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    final isSale = message.data['type'] == 'sale';
    final androidDetails = AndroidNotificationDetails(
      'price_alerts',
      'Price Alerts',
      channelDescription: 'Notifications for price drops and hikes',
      color: isSale ? const Color(0xFF00D97E) : const Color(0xFFFF8C42),
      importance: Importance.high,
      priority: Priority.high,
    );

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(android: androidDetails),
    );
  }

  void _handleNotificationTap(RemoteMessage message) {}

  Future<String?> getFcmToken() => _fcm.getToken();
}
