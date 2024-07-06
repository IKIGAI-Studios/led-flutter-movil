import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class FcmApi {
  Future<void> changeLEDstatus(bool status) async {
    if (dotenv.env['SERVER_KEY'] == null) {
      // ignore: avoid_print
      return print('SERVER_KEY not found in .env file');
    }
    final String serverKey = dotenv.env['SERVER_KEY'] ?? '';

    final Uri fcmUrl = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/push-notifications-wear/messages:send');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKey',
    };

    final requestBody = jsonEncode({
      "message": {
        "topic": "led",
        "notification": {
          "title": "LED status changed",
          "body": status ? "LED is ON" : "LED is OFF"
        },
        "android": {"priority": "high", "direct_boot_ok": true},
        "data": {"click_action": "FLUTTER_NOTIFICATION_CLICK", "status": "done"}
      }
    });

    try {
      final response = await http.post(fcmUrl, headers: headers, body: requestBody);
    
      if (response.statusCode == 200) {
        // ignore: avoid_print
        print('Notificación enviada correctamente');
      } else {
        // ignore: avoid_print
        print('Error al enviar notificación: ${response.body}');
      }
    }
    catch(e) {
      // ignore: avoid_print
      print(e);
    }
  }
}
