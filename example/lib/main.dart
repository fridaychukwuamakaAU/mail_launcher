import 'package:flutter/material.dart';
import 'package:mail_launcher/mail_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Mail launcher example'),
            ),
            body: Center(
              child: ElevatedButton(
                onPressed: () => MailLauncher.launch(
                  to: "to@example.com",
                  subject: "Subject",
                  body: "Body",
                  dialogTitle: "Choose"
                ),
                child: Text("Send"),
              ),
            )),
      );
}
