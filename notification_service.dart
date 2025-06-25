import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../models/task_model.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
    );

    
    await _plugin.initialize(initSettings);

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'task_channel', 
      'Task Reminders',
      description: 'This channel is used for task reminders.',
      importance: Importance.max,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    
    final androidPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    if (androidPlugin != null) {
      final granted = await androidPlugin.requestNotificationsPermission();
      print("🔐 Android Notification Permission Granted: $granted");
    }

    
    final iosPlugin =
        _plugin
            .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin
            >();
    if (iosPlugin != null) {
      await iosPlugin.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  
  Future<void> showTestNotification() async {
    await _plugin.show(
      999,
      "Test Notification",
      "This is a test notification",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_channel',
          'Task Reminders',
          channelDescription: 'Testing Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  Future<void> scheduleNotification(TaskModel task) async {
  DateTime now = DateTime.now();
  DateTime due = task.dueDate;

  
  if (due.isBefore(now.add(Duration(minutes: 1)))) {
    due = now.add(Duration(minutes: 1));
    print("Adjusted notification time to avoid missed trigger.");
  }

  final tz.TZDateTime scheduledTime = tz.TZDateTime.from(due, tz.local);

  print(" Final scheduled time: $scheduledTime");

  await _plugin.zonedSchedule(
    task.id.hashCode,
    "Task Reminder: ${task.title}",
    task.description,
    scheduledTime,
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'task_channel',
        'Task Reminders',
        channelDescription: 'Reminders for tasks',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}

}
