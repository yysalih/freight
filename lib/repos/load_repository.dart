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

  Future<LoadModel> getLoadFuture() async {
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
  Stream<LoadModel> getLoadStream() async* {
    while(true) {
      try {
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
            yield loadModel;
          }
        } else {
          debugPrint('Error: ${response.statusCode}');
          debugPrint('Error: ${response.reasonPhrase}');
          yield LoadModel();
        }
        yield LoadModel();
      }
      catch(e) {
        debugPrint('Error fetching load: $e');
      }
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  Future<List<LoadModel>> getCurrentUserLoadsFuture() async {
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
  Stream<List<LoadModel>> getCurrentUserLoadsStream() async* {
    while(true) {
      try {
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
        debugPrint('Error fetching loads: $e');
      }
      await Future.delayed(const Duration(seconds: 2));

    }
  }

  Future<List<LoadModel>> getAvailableLoadsFuture() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM loads WHERE state = 'available'",
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
  Stream<List<LoadModel>> getAvailableLoadsStream() async* {
    while(true) {
      try {
        final response = await http.post(
          appUrl,
          body: {
            'multiQuery': "SELECT * FROM loads WHERE state = 'available'",
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data is List) {
            List<LoadModel> loads = data.map((e) => LoadModel().fromJson(e as Map<String, dynamic>)).toList();
            debugPrint('Loads Length: ${loads.length}');

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
        debugPrint('Error fetching loads: $e');
      }
      await Future.delayed(const Duration(seconds: 2));

    }
  }
}

final loadStreamProvider = StreamProvider.autoDispose.family<LoadModel, String?>((ref, uid) {
  final loadRepository = ref.watch(loadRepositoryProvider(uid));
  return loadRepository.getLoadStream();
});

final loadFutureProvider = FutureProvider.autoDispose.family<LoadModel, String?>((ref, uid) {
  final loadRepository = ref.watch(loadRepositoryProvider(uid));
  return loadRepository.getLoadFuture();
});



final loadsStreamProvider = StreamProvider.autoDispose.family<List<LoadModel>, String?>((ref, uid) {
  final loadRepository = ref.watch(loadRepositoryProvider(uid));
  return loadRepository.getCurrentUserLoadsStream();
});

final loadsFutureProvider = FutureProvider.autoDispose.family<List<LoadModel>, String?>((ref, uid) {
  final loadRepository = ref.watch(loadRepositoryProvider(uid));
  return loadRepository.getCurrentUserLoadsFuture();
});



final availableLoadsStreamProvider = StreamProvider.autoDispose.family<List<LoadModel>, String?>((ref, uid) {
  final loadRepository = ref.watch(loadRepositoryProvider(uid));
  return loadRepository.getAvailableLoadsStream();
});

final availableLsoadsFutureProvider = FutureProvider.autoDispose.family<List<LoadModel>, String?>((ref, uid) {
  final loadRepository = ref.watch(loadRepositoryProvider(uid));
  return loadRepository.getAvailableLoadsFuture();
});




final loadRepositoryProvider = Provider.family<LoadRepository, String?>((ref, uid) {
  return LoadRepository(uid: uid);
});