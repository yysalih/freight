import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/truck_model.dart';

class TruckRepository {
  final String _uid;

  TruckRepository({String? uid})
      : _uid = uid ?? "";

  Future<TruckModel> getTruck() async {
    final response = await http.post(
      appUrl,
      body: {
        'singleQuery': "SELECT * FROM trucks WHERE uid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      TruckModel truckModel = TruckModel().fromJson(data);
      debugPrint('TruckModel: $truckModel');

      if(data.toString().contains("error")) {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Error: ${response.reasonPhrase}');
      } else {
        return truckModel;
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      return TruckModel();
    }
    return TruckModel();
  }

  Future<List<TruckModel>> getCurrentUserTrucks() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM trucks WHERE ownerUid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) { // Ensure that data is a List
        List<TruckModel> loads = data.map((e) => TruckModel().fromJson(e as Map<String, dynamic>)).toList();
        debugPrint('Trucks Length: ${loads.length}');

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

final truckFutureProvider = FutureProvider.autoDispose.family<TruckModel, String?>((ref, uid) {
  // get repository from the provider below
  final truckRepository = ref.watch(truckRepositoryProvider(uid));

  // call method that returns a Stream<User>
  return truckRepository.getTruck();
});

final trucksFutureProvider = FutureProvider.autoDispose.family<List<TruckModel>, String?>((ref, uid) {
  // get repository from the provider below
  final truckRepository = ref.watch(truckRepositoryProvider(uid));

  // call method that returns a Stream<User>
  return truckRepository.getCurrentUserTrucks();
});

final truckRepositoryProvider = Provider.family<TruckRepository, String?>((ref, uid) {
  return TruckRepository(uid: uid);
});