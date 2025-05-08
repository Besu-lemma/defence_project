// lib/screens/notification_screen.dart

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import '../utils/language_strings.dart';
import '../services/notification_service.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allNotifications = NotificationService.notificationHistory;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('notifications')), // translated
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              NotificationService.notificationHistory.clear();
              AwesomeNotifications().cancelAllSchedules();
              AwesomeNotifications().cancelAll();
              (context as Element).markNeedsBuild();
            },
            tooltip: tr('clear_history'), // translated
          ),
        ],
      ),
      body: allNotifications.isEmpty
          ? Center(
              child: Text(tr('no_notifications')), // translated
            )
          : ListView.builder(
              itemCount: allNotifications.length,
              itemBuilder: (context, i) {
                final n = allNotifications[i];
                final time = DateTime.parse(n['time']!);
                final formattedTime =
                    '${time.hour}:${time.minute.toString().padLeft(2, '0')}';

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading:
                        const Icon(Icons.notifications, color: Colors.green),
                    title: Text(n['title']!,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(n['message']!),
                        Text(formattedTime,
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
