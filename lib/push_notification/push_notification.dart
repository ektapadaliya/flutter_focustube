// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:focus_tube_flutter/api/api_functions.dart';
import 'package:focus_tube_flutter/go_route_navigation.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title// description
  playSound: true,
  sound: RawResourceAndroidNotificationSound('alert'),
);

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //debugPrint('Handling a background message ${message.data}');
}

class PushNotificationsManager {
  // static const webPUSHApiKey =
  //     "BMZZsTc14GMm9xI6cQVBqCnHKdBVXqJ92YezTpv-peEFaVTU07h92s2c9monX8isXESuPGVWDliOa2eLytgpm00";
  // singleton
  static final PushNotificationsManager _singleton =
      PushNotificationsManager._internal();
  factory PushNotificationsManager() => _singleton;

  PushNotificationsManager._internal();

  static PushNotificationsManager get shared => _singleton;

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  String? token;

  var androidSettings = const AndroidInitializationSettings(
    '@drawable/ic_state_name',
  );
  var macSettings = const DarwinNotificationDetails();
  var iOSSettings = const DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  Future<void> firebaseCloudMessaging_Listeners() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) await iOS_Permission();

    // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications',
      playSound: true, // title// description
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('alert'),
    );

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (defaultTargetPlatform == TargetPlatform.android) {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }

    await flutterLocalNotificationsPlugin.initialize(
      settings: InitializationSettings(
        android: androidSettings,
        iOS: iOSSettings,
      ),
      onDidReceiveBackgroundNotificationResponse: _onLocalNotificationTap,
      onDidReceiveNotificationResponse: ((value) {
        if (value.payload != null) {
          _onLocalNotificationTap(value);
        }
      }),
    );

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: false,
          badge: true,
          sound: true,
        );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    _firebaseMessaging
        .getToken(/* vapidKey: kIsWeb ? webPUSHApiKey : null */)
        .then((token) async {
          if (token != null) {
            debugPrint('PUSH TOKEN : $token');
            ApiFunctions.instance.setDeviceToken(token);
          }
        });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      var data = message.data;
      List<DarwinNotificationAttachment>? attachments;

      if (notification?.apple?.imageUrl != null) {
        final String filePath = await _downloadAndSaveFile(
          notification!.apple!.imageUrl!,
          'attachment',
        );

        attachments = [DarwinNotificationAttachment(filePath)];
      }
      BigPictureStyleInformation? bigPictureStyle;

      if (android?.imageUrl != null) {
        final String largeIconPath = await _downloadAndSaveFile(
          android!.imageUrl!,
          'largeIcon',
        );
        final String bigPicturePath = await _downloadAndSaveFile(
          android.imageUrl!,
          'bigPicture',
        );

        bigPictureStyle = BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          largeIcon: FilePathAndroidBitmap(largeIconPath),
          contentTitle: notification?.title,
          summaryText: notification?.body,
        );
      }
      if (notification != null) {
        flutterLocalNotificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              attachments: attachments,
            ),
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              sound: channel.sound,
              playSound: true,
              icon: '@drawable/ic_state_name',
              styleInformation: bigPictureStyle,
            ),
          ),
          payload: jsonEncode(message.data),
        );
      }
    });
  }

  iOS_Permission() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
  }

  static void _onLocalNotificationTap(NotificationResponse value) async {
    if (value.payload != null) {
      Map<String, dynamic> dic = jsonDecode(value.payload!);
      openApp(dic);
    }
  }

  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getTemporaryDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}

void openApp(Map<String, dynamic> message) async {
  var context = navigationKey.currentContext;

  bool isCurrentRoute(AppNavigationModel model) {
    final String? currentFullPath = context != null
        ? GoRouter.of(context).state.fullPath
        : router.state.fullPath;

    if (currentFullPath == null) return false;

    final String currentRoute = currentFullPath.split("?").first;

    return model.path == currentRoute;
  }

  if (message['type'] == "video" && message.containsKey("video_id")) {
    if (context != null && !isCurrentRoute(videoDetail)) {
      videoDetail.go(context, id: message["video_id"]);
    }
  }
}
