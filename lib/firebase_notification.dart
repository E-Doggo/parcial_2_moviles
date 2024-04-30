import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotification {
  final _firebaseMessage = FirebaseMessaging.instance;

  Future<String?> getTokenFire() async {
    return await _firebaseMessage.getToken();
  }

  Future<void> requestNotifications() async {
    NotificationSettings settings = await _firebaseMessage.requestPermission();
    String? token = await getTokenFire();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
