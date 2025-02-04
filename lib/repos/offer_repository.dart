import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kamyon/models/offer_model.dart';
import '../constants/app_constants.dart';

class OfferRepository {
  final String _uid;

  OfferRepository({String? uid})
      : _uid = uid ?? "";

  Future<OfferModel> getOffer() async {
    final response = await http.post(
      appUrl,
      body: {
        'singleQuery': "SELECT * FROM offers WHERE uid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      OfferModel offerModel = const OfferModel().fromJson(data);
      debugPrint('OfferModel: $offerModel');

      if(data.toString().contains("error")) {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Error: ${response.reasonPhrase}');
      } else {
        return offerModel;
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      return const OfferModel();
    }
    return const OfferModel();
  }

  Stream<OfferModel> getOfferStream() async* {
    while (true) {
      try {
        final response = await http.post(
          appUrl,
          body: {
            'singleQuery': "SELECT * FROM offers WHERE uid = '$_uid'",
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (!data.toString().contains("error")) {
            yield const OfferModel().fromJson(data);
          } else {
            debugPrint('Error: ${response.statusCode}');
          }
        } else {
          debugPrint('Error: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Error fetching offer: $e');
      }

      // Wait before fetching the next update
      await Future.delayed(const Duration(seconds: 2));
    }
  }


  Future<List<OfferModel>> getCurrentUserOffers() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM offers WHERE fromUid = '$_uid' OR toUid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        List<OfferModel> offers = data.map((e) => const OfferModel().fromJson(e as Map<String, dynamic>)).toList();
        debugPrint('Offers Length: ${offers.length}');

        return offers;
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

  Stream<List<OfferModel>> getUnitOffersStream() async* {
    while (true) {
      try {
        final response = await http.post(
          appUrl,
          body: {
            'multiQuery': "SELECT * FROM offers WHERE unitUid = '$_uid'",
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data is List) {
            List<OfferModel> offers = data.map((e) => const OfferModel().fromJson(e as Map<String, dynamic>)).toList();
            yield offers;
          } else {
            debugPrint('Error: Unexpected data format');
            yield [];
          }
        } else {
          debugPrint('Error: ${response.statusCode} : ${response.reasonPhrase}');
          yield [];
        }
      } catch (e) {
        debugPrint('Error fetching offers: $e');
        yield [];
      }

      // Add a delay to avoid rapid polling
      await Future.delayed(const Duration(seconds: 1));
    }
  }


  Future<List<OfferModel>> getAvailableOffers() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM offers",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        List<OfferModel> offers = data.map((e) => const OfferModel().fromJson(e as Map<String, dynamic>)).toList();
        debugPrint('Offers Length: ${offers.length}');

        return offers;
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

final offerFutureProvider = FutureProvider.autoDispose.family<OfferModel, String?>((ref, uid) {
  final offerRepository = ref.watch(offerRepositoryProvider(uid));
  return offerRepository.getOffer();
});

final offersFutureProvider = FutureProvider.autoDispose.family<List<OfferModel>, String?>((ref, uid) {
  final offerRepository = ref.watch(offerRepositoryProvider(uid));
  return offerRepository.getCurrentUserOffers();
});

final availableOffersFutureProvider = FutureProvider.autoDispose.family<List<OfferModel>, String?>((ref, uid) {
  final offerRepository = ref.watch(offerRepositoryProvider(uid));
  return offerRepository.getAvailableOffers();
});

final offerStreamProvider = StreamProvider.autoDispose.family<OfferModel, String?>((ref, uid) {
  final offerRepository = ref.watch(offerRepositoryProvider(uid));
  return offerRepository.getOfferStream();
});

final offersStreamProvider = StreamProvider.autoDispose.family<List<OfferModel>, String?>((ref, uid) {
  final offerRepository = ref.watch(offerRepositoryProvider(uid));
  return offerRepository.getUnitOffersStream();
});

final offerRepositoryProvider = Provider.family<OfferRepository, String?>((ref, uid) {
  return OfferRepository(uid: uid);
});