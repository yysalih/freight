import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/truck_post_model.dart';

class TruckPostRepository {
  final String _uid;

  TruckPostRepository({String? uid})
      : _uid = uid ?? "";

  Future<TruckPostModel> getTruckPosts() async {
    final response = await http.post(
      appUrl,
      body: {
        'singleQuery': "SELECT * FROM truck_posts WHERE uid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      TruckPostModel truckPostModel = const TruckPostModel().fromJson(data);
      debugPrint('TruckPostModel: $truckPostModel');

      if(data.toString().contains("error")) {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Error: ${response.reasonPhrase}');
      } else {
        return truckPostModel;
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      return const TruckPostModel();
    }
    return const TruckPostModel();
  }

  Future<List<TruckPostModel>> getCurrentUserTrucksPosts() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM truck_posts WHERE ownerUid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) { // Ensure that data is a List
        List<TruckPostModel> truckPostModels = data.map((e) => const TruckPostModel().fromJson(e as Map<String, dynamic>)).toList();
        debugPrint('TruckPosts Length: ${truckPostModels.length}');

        return truckPostModels;
      } else {
        debugPrint('Error: Unexpected data format');
        return [];
      }
    }
    else {
      debugPrint('Error: ${response.statusCode} : ${response.reasonPhrase}');
      return [];
    }
  }
}

final truckPostFutureProvider = FutureProvider.autoDispose.family<TruckPostModel, String?>((ref, uid) {
  // get repository from the provider below
  final truckPostRepository = ref.watch(truckPostRepositoryProvider(uid));

  // call method that returns a Stream<User>
  return truckPostRepository.getTruckPosts();
});

final truckPostsFutureProvider = FutureProvider.autoDispose.family<List<TruckPostModel>, String?>((ref, uid) {
  // get repository from the provider below
  final truckPostRepository = ref.watch(truckPostRepositoryProvider(uid));

  // call method that returns a Stream<User>
  return truckPostRepository.getCurrentUserTrucksPosts();
});

final truckPostRepositoryProvider = Provider.family<TruckPostRepository, String?>((ref, uid) {
  return TruckPostRepository(uid: uid);
});