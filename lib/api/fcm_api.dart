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
      'to': 'led/actions',
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
}
