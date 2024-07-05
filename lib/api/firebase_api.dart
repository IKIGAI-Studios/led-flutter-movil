import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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

  // Send a notification to a specific device
  Future<void> changeLEDstatus(
    bool status,
  ) async {
    // Validate if the server key is present
    if (dotenv.env['SERVER_KEY'] == null) {
      // ignore: avoid_print
      return print('SERVER_KEY not found in .env file');
    }
    final String serverKey = dotenv.env['SERVER_KEY'] ?? '';

    final Uri fcmUrl = Uri.parse('https://fcm.googleapis.com/fcm/send');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverKey',
    };

    final requestBody = jsonEncode({
      'notification': {
        'title': 'LED status changed',
        'body': status ? 'LED is now ON' : 'LED is now OFF',
      },
      'priority': 'high',
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'status': 'done',
      },
      'to': '/led/actions',
    });

    final response =
        await http.post(fcmUrl, headers: headers, body: requestBody);

    if (response.statusCode == 200) {
      // ignore: avoid_print
      print('Notificación enviada correctamente');
    } else {
      // ignore: avoid_print
      print('Error al enviar notificación: ${response.body}');
    }
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
