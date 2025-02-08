import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/controllers/profile_controller.dart';
import 'package:http/http.dart' as http;


class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission for notifications (iOS)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else {
      debugPrint('User declined or has not accepted permission');
    }


    // Listen for messages when the app is in the foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint('Message also contained a notification: ${message.notification}');
        //_showNotification(context, message);
      }
    });

    // Listen for messages when the app is in the background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('Message opened from background or terminated state!');
      debugPrint('Message data: ${message.data}');
      //TODO navigate to the needed screen
    });

    // Get the token
    String? token = await _firebaseMessaging.getToken();
    debugPrint("FCM Token: $token");

    updateToken(currentUserUid, token: token!);
  }

  void _showInAppNotification(BuildContext context, RemoteMessage message) {
    // Display a SnackBar or custom in-app notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message.notification?.title ?? 'New Notification',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            //_navigateToScreen(context, message);
          },
        ),
      ),
    );
  }

  updateToken(String currentUserUid, {required String token}) async {


    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "UPDATE users SET token = '$token' WHERE uid = '${currentUserUid}'",
      },
    );

    if (response.statusCode == 200) {
      var data = response.body;
      if (data.toString().contains("error")) {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Error: ${response.reasonPhrase}');
      } else {
        debugPrint('Device Token: $token');
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
    }
  }

  static Future<void> sendPushMessage({
    required String body,
    required String title,
    required String token,
    required String type,
    required String uid,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(kFcmUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$kServerKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': body,
              'title': title,
              'sound': 'default', // 🔊 Ensures sound plays
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': type,
              'uid': uid,
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );

      if (response.statusCode == 200) {
        print('✅ Push notification sent successfully!');
      } else {
        print('❌ Failed to send push notification: ${response.body}');
      }
    } catch (e) {
      print("🚨 Error sending push notification: $e");
    }
  }
}