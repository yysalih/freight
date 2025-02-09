import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:pointycastle/export.dart';
import 'package:basic_utils/basic_utils.dart';


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

  static Future<void> sendPushMessage2({
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

  String _generateJWT() {
    final header = jsonEncode({
      'alg': 'RS256',
      'typ': 'JWT',
    });

    final payload = jsonEncode({
      'iss': kClientEmail,
      'scope': 'https://www.googleapis.com/auth/firebase.messaging',
      'aud': 'https://oauth2.googleapis.com/token',
      'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
      'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
    });

    final encodedHeader = base64Url.encode(utf8.encode(header));
    final encodedPayload = base64Url.encode(utf8.encode(payload));
    final unsignedToken = '$encodedHeader.$encodedPayload';

    // Sign the token using the private key
    const privateKey = kPrivateKey;
    final signature = _signJWT(unsignedToken, privateKey);

    return '$unsignedToken.$signature';
  }

  String _signJWT2(String unsignedToken, String privateKey) {
    // Use a library like `crypto` or `pointycastle` to sign the token
    // This is a simplified example and may not work as-is
    return unsignedToken; // Replace with actual signing logic
  }

  String _signJWT(String unsignedToken, String privateKeyPem) {
    // PEM formatındaki RSA Private Key'i parse et
    final rsaPrivateKey = CryptoUtils.rsaPrivateKeyFromPem(privateKeyPem);

    // RSA SHA-256 ile imzalama işlemi
    final signer = Signer('SHA-256/RSA')
      ..init(true, PrivateKeyParameter<RSAPrivateKey>(rsaPrivateKey));

    final signature = signer.generateSignature(Uint8List.fromList(utf8.encode(unsignedToken))) as RSASignature;
    return base64Url.encode(signature.bytes);
  }

  Future<String> _getAccessToken() async {
    final response = await http.post(
      Uri.parse('https://oauth2.googleapis.com/token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
        'assertion': _generateJWT(),
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      throw Exception('Failed to get access token: ${response.body}');
    }
  }

  Future<void> sendPushMessage({
    required String body,
    required String title,
    required String token,
    required String type,
    required String uid,
  }) async {
    final accessToken = await _getAccessToken();

    final response = await http.post(
      Uri.parse('https://fcm.googleapis.com/v1/projects/$kProjectId/messages:send'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode({
        'message': {
          'token': token,
          'notification': {
            'title': title,
            'body': body,
          },
          'data': <String, dynamic>{
            'click_action': type,
            'uid': uid,
            'id': '1',
            'status': 'done'
          },
        },
      }),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      throw Exception('Failed to send notification: ${response.body}');
    }
  }
}