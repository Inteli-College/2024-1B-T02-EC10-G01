import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:asky/main.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


@pragma('vm:entry-point')
Future<void> handleBackgroundMessage(RemoteMessage message) async {


}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState?.pushNamed(
      '/',
      arguments: int.parse(message.data['data']),
    );
    
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    const _secureStorage = FlutterSecureStorage();
    await _secureStorage.write(
      key: "mobile_token", value: fCMToken, aOptions: _getAndroidOptions()
      );
    initPushNotifications();
  }
}