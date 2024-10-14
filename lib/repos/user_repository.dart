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

  Future<UserModel> getUser() async {
    final response = await http.post(
      url,
      body: {
        'singleQuery': "SELECT * FROM users WHERE uid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      UserModel userModel = UserModel().fromJson(data);
      debugPrint('UserModel: $userModel');

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
}

final userFutureProvider = FutureProvider.autoDispose.family<UserModel, String?>((ref, uid) {
  // get repository from the provider below
  final userRepository = ref.watch(userRepositoryProvider(uid));

  // call method that returns a Stream<User>
  return userRepository.getUser();
});

final userRepositoryProvider = Provider.family<UserRepository, String?>((ref, uid) {
  return UserRepository(uid: uid);
});