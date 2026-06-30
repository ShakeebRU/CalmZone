import 'package:flutter/material.dart';

import '../providers/notification_provider.dart';
import 'notification_ids.dart';
import 'notifications_services.dart';

class NotificationScheduler {
  NotificationScheduler._();

  static final NotificationScheduler instance = NotificationScheduler._();

  Future<void> scheduleAll(NotificationProvider provider) async {
    await NotificationService.instance.cancelAll();

    if (provider.notifications['water']!) {
      await NotificationService.instance.scheduleHourlyWater();
    }

    if (provider.notifications['breakfast']!) {
      await NotificationService.instance.scheduleDaily(
        id: NotificationIds.breakfast,
        title: 'Breakfast',
        body: 'Time for breakfast!',
        time: const TimeOfDay(hour: 8, minute: 0),
      );
    }

    if (provider.notifications['lunch']!) {
      await NotificationService.instance.scheduleDaily(
        id: NotificationIds.lunch,
        title: 'Lunch',
        body: 'Time for lunch!',
        time: const TimeOfDay(hour: 13, minute: 0),
      );
    }

    if (provider.notifications['dinner']!) {
      await NotificationService.instance.scheduleDaily(
        id: NotificationIds.dinner,
        title: 'Dinner',
        body: 'Time for dinner!',
        time: const TimeOfDay(hour: 19, minute: 0),
      );
    }

    await _scheduleCustom(
      provider,
      'snacks',
      NotificationIds.snacks,
      'Snack Time',
      'Have a healthy snack.',
    );

    await _scheduleCustom(
      provider,
      'workout',
      NotificationIds.workout,
      'Workout',
      'Time to exercise!',
    );

    await _scheduleCustom(
      provider,
      'meditation',
      NotificationIds.meditation,
      'Meditation',
      'Relax and meditate.',
    );
  }

  Future<void> _scheduleCustom(
    NotificationProvider provider,
    String key,
    int id,
    String title,
    String body,
  ) async {
    if (!provider.notifications[key]!) return;

    final time = provider.notificationTimes[key]!;

    final hour = int.parse(time.split(":")[0]);
    final minute = int.parse(time.split(":")[1]);

    await NotificationService.instance.scheduleDaily(
      id: id,
      title: title,
      body: body,
      time: TimeOfDay(hour: hour, minute: minute),
    );
  }
}
