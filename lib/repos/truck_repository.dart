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

  Future<TruckModel> getTruckFuture() async {
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
  Stream<TruckModel> getTruckStream() async* {
    while (true) {
      try {
        final response = await http.post(
          appUrl,
          body: {
            'singleQuery': "SELECT * FROM trucks WHERE uid = '$_uid'",
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (!data.toString().contains("error")) {
            yield TruckModel().fromJson(data);
          } else {
            debugPrint('Error: ${response.statusCode}');
          }
        } else {
          debugPrint('Error: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Error fetching truck: $e');
      }

      // Wait before fetching the next update
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  Future<List<TruckModel>> getCurrentUserTrucksFuture() async {
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
  Stream<List<TruckModel>> getCurrentUserTrucksStream() async* {
    while(true) {
      try {
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

            yield loads;
          } else {
            debugPrint('Error: Unexpected data format');
            yield [];
          }
        }
        else {
          debugPrint('Error: ${response.statusCode} : ${response.reasonPhrase}');
          yield [];
        }
      }
      catch(e) {
        debugPrint('Error fetching user: $e');
      }
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}

final truckStreamProvider = StreamProvider.autoDispose.family<TruckModel, String?>((ref, uid) {
  final truckRepository = ref.watch(truckRepositoryProvider(uid));
  return truckRepository.getTruckStream();
});
final truckFutureProvider = FutureProvider.autoDispose.family<TruckModel, String?>((ref, uid) {
  final truckRepository = ref.watch(truckRepositoryProvider(uid));
  return truckRepository.getTruckFuture();
});




final trucksStreamProvider = StreamProvider.autoDispose.family<List<TruckModel>, String?>((ref, uid) {
  final truckRepository = ref.watch(truckRepositoryProvider(uid));
  return truckRepository.getCurrentUserTrucksStream();
});

final trucksFutureProvider = FutureProvider.autoDispose.family<List<TruckModel>, String?>((ref, uid) {
  final truckRepository = ref.watch(truckRepositoryProvider(uid));
  return truckRepository.getCurrentUserTrucksFuture();
});

final truckRepositoryProvider = Provider.family<TruckRepository, String?>((ref, uid) {
  return TruckRepository(uid: uid);
});