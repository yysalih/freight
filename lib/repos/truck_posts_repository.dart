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

  Future<TruckPostModel> getTruckPostFuture() async {
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
  Stream<TruckPostModel> getTruckPostStream() async* {
    while(true) {
      try {
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
            yield truckPostModel;
          }
        } else {
          debugPrint('Error: ${response.statusCode}');
          debugPrint('Error: ${response.reasonPhrase}');
          yield const TruckPostModel();
        }
        yield const TruckPostModel();
      }
      catch(e) {
        debugPrint('Error fetching truckpost: $e');
      }
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  Future<List<TruckPostModel>> getCurrentUserTrucksPostsFuture() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM truck_posts WHERE ownerUid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
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
  Stream<List<TruckPostModel>> getCurrentUserTrucksPostsStream() async* {
    while(true) {
      try {
        final response = await http.post(
          appUrl,
          body: {
            'multiQuery': "SELECT * FROM truck_posts WHERE ownerUid = '$_uid'",
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data is List) {
            List<TruckPostModel> truckPostModels = data.map((e) => const TruckPostModel().fromJson(e as Map<String, dynamic>)).toList();
            debugPrint('TruckPosts Length: ${truckPostModels.length}');

            yield truckPostModels;
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
        debugPrint('Error fetching truck posts: $e');
      }
    }
  }

  Future<List<TruckPostModel>> getAvailableTrucksPostsFuture() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM truck_posts WHERE state = 'available'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
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
  Stream<List<TruckPostModel>> getAvailableTrucksPostsStream() async* {
    while(true) {
      try {
        final response = await http.post(
          appUrl,
          body: {
            'multiQuery': "SELECT * FROM truck_posts WHERE state = 'available'",
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data is List) {
            List<TruckPostModel> truckPostModels = data.map((e) => const TruckPostModel().fromJson(e as Map<String, dynamic>)).toList();
            debugPrint('TruckPosts Length: ${truckPostModels.length}');

            yield truckPostModels;
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
        debugPrint('Error fetching truck posts: $e');
      }
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}

final truckPostStreamProvider = StreamProvider.autoDispose.family<TruckPostModel, String?>((ref, uid) {
  final truckPostRepository = ref.watch(truckPostRepositoryProvider(uid));
  return truckPostRepository.getTruckPostStream();
});
final truckPostFutureProvider = FutureProvider.autoDispose.family<TruckPostModel, String?>((ref, uid) {
  final truckPostRepository = ref.watch(truckPostRepositoryProvider(uid));
  return truckPostRepository.getTruckPostFuture();
});




final truckPostsStreamProvider = StreamProvider.autoDispose.family<List<TruckPostModel>, String?>((ref, uid) {
  final truckPostRepository = ref.watch(truckPostRepositoryProvider(uid));
  return truckPostRepository.getCurrentUserTrucksPostsStream();
});
final truckPostsFutureProviders = FutureProvider.autoDispose.family<List<TruckPostModel>, String?>((ref, uid) {
  final truckPostRepository = ref.watch(truckPostRepositoryProvider(uid));
  return truckPostRepository.getCurrentUserTrucksPostsFuture();
});




final availableTruckPostsStreamProvider = StreamProvider.autoDispose.family<List<TruckPostModel>, String?>((ref, uid) {
  final truckPostRepository = ref.watch(truckPostRepositoryProvider(uid));
  return truckPostRepository.getAvailableTrucksPostsStream();
});
final availableTruckPostsFutureProviders = FutureProvider.autoDispose.family<List<TruckPostModel>, String?>((ref, uid) {
  final truckPostRepository = ref.watch(truckPostRepositoryProvider(uid));
  return truckPostRepository.getAvailableTrucksPostsFuture();
});

final truckPostRepositoryProvider = Provider.family<TruckPostRepository, String?>((ref, uid) {
  return TruckPostRepository(uid: uid);
});