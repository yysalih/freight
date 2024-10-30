import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/place_model.dart';

class PlaceRepository {
  final String _uid;

  PlaceRepository({String? uid})
      : _uid = uid ?? "";

  Future<AppPlaceModel> getPlace() async {
    final response = await http.post(
      appUrl,
      body: {
        'singleQuery': "SELECT * FROM places WHERE uid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      AppPlaceModel appPlaceModel = AppPlaceModel().fromJson(data);
      debugPrint('AppPlaceModel: $appPlaceModel');

      if(data.toString().contains("error")) {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Error: ${response.reasonPhrase}');
      } else {
        return appPlaceModel;
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      return AppPlaceModel();
    }
    return AppPlaceModel();
  }

  Future<List<AppPlaceModel>> getPlaces() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM places",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        List<AppPlaceModel> places = data.map((e) => AppPlaceModel().fromJson(e as Map<String, dynamic>)).toList();
        debugPrint('AppPlaceModel Length: ${places.length}');

        return places;
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

final placeFutureProvider = FutureProvider.autoDispose.family<AppPlaceModel, String?>((ref, uid) {
  final placeRepository = ref.watch(placeRepositoryProvider(uid));
  return placeRepository.getPlace();
});

final placesFutureProvider = FutureProvider.autoDispose.family<List<AppPlaceModel>, String?>((ref, uid) {
  final placeRepository = ref.watch(placeRepositoryProvider(uid));
  return placeRepository.getPlaces();
});

final placeRepositoryProvider = Provider.family<PlaceRepository, String?>((ref, uid) {
  return PlaceRepository(uid: uid);
});