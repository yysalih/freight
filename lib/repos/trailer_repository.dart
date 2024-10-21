import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/trailer_model.dart';

class TrailerRepository {
  final String _uid;

  TrailerRepository({String? uid})
      : _uid = uid ?? "";

  Future<TrailerModel> getTrailer() async {
    final response = await http.post(
      appUrl,
      body: {
        'singleQuery': "SELECT * FROM trailers WHERE uid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      TrailerModel trailerModel = TrailerModel().fromJson(data);
      debugPrint('TrailerModel: $trailerModel');

      if(data.toString().contains("error")) {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Error: ${response.reasonPhrase}');
      } else {
        return trailerModel;
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      return TrailerModel();
    }
    return TrailerModel();
  }

  Future<List<TrailerModel>> getCurrentUserTrailers() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM trailers WHERE ownerUid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) { // Ensure that data is a List
        List<TrailerModel> loads = data.map((e) => TrailerModel().fromJson(e as Map<String, dynamic>)).toList();
        debugPrint('TrailerModel Length: ${loads.length}');

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

final trailerFutureProvider = FutureProvider.autoDispose.family<TrailerModel, String?>((ref, uid) {
  // get repository from the provider below
  final trailerRepository = ref.watch(trailerRepositoryProvider(uid));

  // call method that returns a Stream<User>
  return trailerRepository.getTrailer();
});

final trailersFutureProvider = FutureProvider.autoDispose.family<List<TrailerModel>, String?>((ref, uid) {
  // get repository from the provider below
  final trailerRepository = ref.watch(trailerRepositoryProvider(uid));

  // call method that returns a Stream<User>
  return trailerRepository.getCurrentUserTrailers();
});

final trailerRepositoryProvider = Provider.family<TrailerRepository, String?>((ref, uid) {
  return TrailerRepository(uid: uid);
});