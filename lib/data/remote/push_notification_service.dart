import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      //Called when app is in the foreground
        onMessage: (Map<String, dynamic> message) async {
      print('onMessage: $message');
    },
        //Called when app has benn closed completely and it's opened
        onLaunch: (Map<String, dynamic> message) async {
      print('onLaunch: $message');
    },
        //Called when app is in the background and it's opened
        onResume: (Map<String, dynamic> message) async {
      print('onResume: $message');
    });
  }
}
