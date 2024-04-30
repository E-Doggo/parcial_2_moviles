import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotification {
  final _firebaseMessage = FirebaseMessaging.instance;

  Future<String?> requestNotifications() async {
    await _firebaseMessage.requestPermission();
    final token = await _firebaseMessage.getToken();
    print("token $token");
  }
}
