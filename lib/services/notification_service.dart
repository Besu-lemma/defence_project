// notification_service.dart
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final List<Map<String, String>> notificationHistory = [];

  /// Call this once at app startup (e.g. in main())
  static Future<void> initialize() async {
    await AwesomeNotifications().initialize(
      // set the icon to null if you want to use default app icon
      '@mipmap/ic_launcher',
      [
        NotificationChannel(
          channelKey: 'irrigation_channel',
          channelName: 'Irrigation Alerts',
          channelDescription: 'Notifications about irrigation events',
          importance: NotificationImportance.High,
          channelShowBadge: true,
          defaultColor: Colors.green,
          ledColor: Colors.white,
        ),
      ],
      // Channel groups are optional
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'basic_group',
          channelGroupName: 'Basic group',
        )
      ],
      debug: true,
    );
  }

  /// Call this whenever you want to show & record a notification
  static Future<void> addNotification(String title, String message) async {
    final timestamp = DateTime.now();
    notificationHistory.insert(0, {
      'title': title,
      'message': message,
      'time': timestamp.toIso8601String(),
    });

    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: timestamp.millisecondsSinceEpoch.remainder(100000),
        channelKey: 'irrigation_channel',
        title: title,
        body: message,
        notificationLayout: NotificationLayout.Default,
      ),
    );
  }
}
