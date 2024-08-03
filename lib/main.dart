import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:todo/homepage.dart';
import 'package:todo/notificationHelper.dart';

// void main() {
//   AwesomeNotifications().initialize(
//     null,
//     [
//       NotificationChannel(
//           channelKey: "basic_channel",
//           channelName: 'Basic notification',
//           channelDescription: "channelDescription")
//     ],
//     debug: true,
//   );
//   runApp(const MyApp());
// }
void main() {
  // Initialize awesome_notifications
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: Color(0xFF9D50DD),
        ledColor: Colors.white,
      )
    ],
  );

  // Run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}
