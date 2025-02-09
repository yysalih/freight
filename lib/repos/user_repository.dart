import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/user_model.dart';

class UserRepository {
  final String _uid;

  UserRepository({String? uid})
      : _uid = uid ?? "";

  Future<UserModel> getUserFuture() async {
    final response = await http.post(
      appUrl,
      body: {
        'singleQuery': "SELECT * FROM users WHERE uid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      UserModel userModel = UserModel().fromJson(data);


      if(data.toString().contains("error")) {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Error: ${response.reasonPhrase}');
      } else {
        return userModel;
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      return UserModel();
    }
    return UserModel();
  }
  Stream<UserModel> getUserStream() async* {
    while (true) {
      try {
        final response = await http.post(
          appUrl,
          body: {
            'singleQuery': "SELECT * FROM users WHERE uid = '$_uid'",
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (!data.toString().contains("error")) {
            yield UserModel().fromJson(data);
          } else {
            debugPrint('Error: ${response.statusCode}');
          }
        } else {
          debugPrint('Error: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Error fetching user: $e');
      }

      // Wait before fetching the next update
      await Future.delayed(const Duration(seconds: 2));
    }

  }
}

final userStreamProvider = StreamProvider.autoDispose.family<UserModel, String?>((ref, uid) {
  final userRepository = ref.watch(userRepositoryProvider(uid));
  return userRepository.getUserStream();
});

final userFutureProvider = FutureProvider.autoDispose.family<UserModel, String?>((ref, uid) {
  final userRepository = ref.watch(userRepositoryProvider(uid));
  return userRepository.getUserFuture();
});

final userRepositoryProvider = Provider.family<UserRepository, String?>((ref, uid) {
  return UserRepository(uid: uid);
});