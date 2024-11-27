import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/load_model.dart';

class LoadRepository {
  final String _uid;

  LoadRepository({String? uid})
      : _uid = uid ?? "";

  Future<LoadModel> getLoad() async {
    final response = await http.post(
      appUrl,
      body: {
        'singleQuery': "SELECT * FROM loads WHERE uid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      LoadModel loadModel = LoadModel().fromJson(data);
      debugPrint('UserModel: $loadModel');

      if(data.toString().contains("error")) {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Error: ${response.reasonPhrase}');
      } else {
        return loadModel;
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      return LoadModel();
    }
    return LoadModel();
  }

  Future<List<LoadModel>> getCurrentUserLoads() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM loads WHERE ownerUid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        List<LoadModel> loads = data.map((e) => LoadModel().fromJson(e as Map<String, dynamic>)).toList();
        debugPrint('Loads Length: ${loads.length}');

        return loads;
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

  Future<List<LoadModel>> getAvailableLoads() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM loads",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        List<LoadModel> loads = data.map((e) => LoadModel().fromJson(e as Map<String, dynamic>)).toList();
        debugPrint('Loads Length: ${loads.length}');

        return loads;
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

final loadFutureProvider = FutureProvider.autoDispose.family<LoadModel, String?>((ref, uid) {
  final loadRepository = ref.watch(loadRepositoryProvider(uid));
  return loadRepository.getLoad();
});

final loadsFutureProvider = FutureProvider.autoDispose.family<List<LoadModel>, String?>((ref, uid) {
  final loadRepository = ref.watch(loadRepositoryProvider(uid));
  return loadRepository.getCurrentUserLoads();
});

final availableLoadsFutureProvider = FutureProvider.autoDispose.family<List<LoadModel>, String?>((ref, uid) {
  final loadRepository = ref.watch(loadRepositoryProvider(uid));
  return loadRepository.getAvailableLoads();
});

final loadRepositoryProvider = Provider.family<LoadRepository, String?>((ref, uid) {
  return LoadRepository(uid: uid);
});