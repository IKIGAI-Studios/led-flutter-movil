import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  // Instance of Firebase Messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // Initialize notifications
  Future<void> initNotifications() async {
    // Request permission
    await _firebaseMessaging.requestPermission();

    // Fetch the fcm token for the device
    final fcmToken = await _firebaseMessaging.getToken();

    // Print the token
    // ignore: avoid_print
    print('FCM Token: ${fcmToken.toString()}');

    initPushNotifications();
  }

  // Handle notifications (Esto es pal wear asi que no se usa aqui)
  void handleMessage(RemoteMessage? message) {
    // if the message is null, return
    if (message == null) return;

    // Go to home screen
    // navigatorKey.currentState?.pushNamed('/');
    // LA NETA NO SE COMO PA

    // ! Navigate to the notification screen (Creo no funciona esto)
    // navigatorKey.currentState?.pushNamed(
    //   '/notification_screen',
    //   arguments: message,
    // );
  }

  // Handle foreground and background notifications
  Future initPushNotifications() async {
    // Handle notifications when the app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // Attach event listeners for when a notifications opens the app
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
