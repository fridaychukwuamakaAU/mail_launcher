import 'dart:async';

import 'package:flutter/services.dart';

class MailLauncher {
  static const MethodChannel _channel = const MethodChannel('mail_launcher');

  static Future<void> launch({
    String? to,
    String? subject,
    String? body,
    String? dialogTitle,
  }) =>
      _channel.invokeMethod("launch", {
        "to": to,
        "subject": subject,
        "body": body,
        "dialogTitle": dialogTitle,
      });
}