import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseNotification {
  final _firebaseMessage = FirebaseMessaging.instance;

  Future<String?> getTokenFire() async {
    final token = await _firebaseMessage.getToken();

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", token!);
    return token;
  }

  Future<void> requestNotifications() async {
    NotificationSettings settings = await _firebaseMessage.requestPermission();
    String? token = await getTokenFire();
    print("token: $token");
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Future<void> sendPushMessage() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString("token");
    if (token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      final response = await Dio().post(
        'https://fcm.googleapis.com/fcm/send',
        data: constructFCMPayload(token!),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization':
                'key=AAAAp-lUWb0:APA91bFIM8spfB0I-0fCQYeUGxr-93UK_5vnqwQLjwaLI7PVqkzQ-mfopE-_iy3VBf1fP8AxmOQ4Zqfpp6iyM2k5Yr4A5-OOESjFwVOHvka2jCIj8XPsIskRJ2Lx1W2c2Ravp0qGoycy', // Replace with your server key
          },
        ),
      );

      if (response.statusCode == 200) {
        print('FCM request for device sent!');
      } else {
        print(
            'Failed to send FCM message: ${response.statusCode} - ${response.data}');
      }
    } catch (e) {
      print(e);
    }
  }

  String constructFCMPayload(String token) {
    return jsonEncode({
      'token': token,
      'data': {
        'via': 'FlutterFire Cloud Messaging',
        'count': '1',
      },
      'notification': {
        'title': 'Hello FlutterFire!',
        'body': 'This notification was created via FCM!',
      },
    });
  }
}
