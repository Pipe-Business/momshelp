import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_tts/flutter_tts.dart';

Future<void> backgroundNotification(
    {required String title, required String content}) async {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  // final DarwinInitializationSettings initializationSettingsDarwin =
  //     DarwinInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,);

  // 텍스트 길어질시 알림 확장시키기
  await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
    'default_channel_id', // 채널 ID
    'Default Channel', // 채널 이름
    channelDescription: 'notifications.',
    importance: Importance.high,
    priority: Priority.high,
    styleInformation: BigTextStyleInformation(
      content,
      contentTitle: "알림",
      summaryText: content.split('\n')[0],
    ),
  );

  NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);

  print("noti $content");
  await _flutterLocalNotificationsPlugin.show(
    0, // 알림 ID
    title,
    content.replaceAll('\n', ''),
    notificationDetails,
    payload: 'Notification Payload', // 페이로드
  );
}
