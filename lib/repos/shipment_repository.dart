import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../models/shipment_model.dart';

class ShipmentRepository {
  final String _uid;

  ShipmentRepository({String? uid})
      : _uid = uid ?? "";

  Future<ShipmentModel> getShipment() async {
    final response = await http.post(
      appUrl,
      body: {
        'singleQuery': "SELECT * FROM shipments WHERE uid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ShipmentModel shipmentModel = const ShipmentModel().fromJson(data);
      debugPrint('ShipmentModel: $shipmentModel');

      if(data.toString().contains("error")) {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Error: ${response.reasonPhrase}');
      } else {
        return shipmentModel;
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      return const ShipmentModel();
    }
    return const ShipmentModel();
  }

  Stream<ShipmentModel> getShipmentStream() async* {
    while (true) {
      try {
        final response = await http.post(
          appUrl,
          body: {
            'singleQuery': "SELECT * FROM shipments WHERE uid = '$_uid'",
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (!data.toString().contains("error")) {
            yield const ShipmentModel().fromJson(data);
          } else {
            debugPrint('Error: ${response.statusCode}');
          }
        } else {
          debugPrint('Error: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Error fetching shipment: $e');
      }

      // Wait before fetching the next update
      await Future.delayed(const Duration(seconds: 2));
    }
  }


  Future<List<ShipmentModel>> getCurrentUserShipments() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM shipments WHERE fromUid = '$_uid' OR toUid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        List<ShipmentModel> shipments = data.map((e) => const ShipmentModel().fromJson(e as Map<String, dynamic>)).toList();
        debugPrint('shipments Length: ${shipments.length}');

        return shipments;
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

  Stream<List<ShipmentModel>> getCurrentUsersShipmentsStream() async* {
    while (true) {
      try {
        final response = await http.post(
          appUrl,
          body: {
            'multiQuery': "SELECT * FROM shipments WHERE fromUid = '$_uid' OR toUid = '$_uid'",
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data is List) {
            List<ShipmentModel> shipments = data.map((e) => const ShipmentModel().fromJson(e as Map<String, dynamic>)).toList();
            yield shipments;
          } else {
            debugPrint('Error: Unexpected data format');
            yield [];
          }
        } else {
          debugPrint('Error: ${response.statusCode} : ${response.reasonPhrase}');
          yield [];
        }
      } catch (e) {
        debugPrint('Error fetching shipments: $e');
        yield [];
      }

      // Add a delay to avoid rapid polling
      await Future.delayed(const Duration(seconds: 1));
    }
  }


  Future<List<ShipmentModel>> getAvailableShipments() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM shipments",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        List<ShipmentModel> shipments = data.map((e) => const ShipmentModel().fromJson(e as Map<String, dynamic>)).toList();
        debugPrint('shipments Length: ${shipments.length}');

        return shipments;
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

final shipmentFutureProvider = FutureProvider.autoDispose.family<ShipmentModel, String?>((ref, uid) {
  final shipmentRepository = ref.watch(shipmentRepositoryProvider(uid));
  return shipmentRepository.getShipment();
});

final shipmentsFutureProvider = FutureProvider.autoDispose.family<List<ShipmentModel>, String?>((ref, uid) {
  final shipmentRepository = ref.watch(shipmentRepositoryProvider(uid));
  return shipmentRepository.getCurrentUserShipments();
});

final availableShipmentsFutureProvider = FutureProvider.autoDispose.family<List<ShipmentModel>, String?>((ref, uid) {
  final shipmentRepository = ref.watch(shipmentRepositoryProvider(uid));
  return shipmentRepository.getAvailableShipments();
});

final shipmentStreamProvider = StreamProvider.autoDispose.family<ShipmentModel, String?>((ref, uid) {
  final shipmentRepository = ref.watch(shipmentRepositoryProvider(uid));
  return shipmentRepository.getShipmentStream();
});

final shipmentsStreamProvider = StreamProvider.autoDispose.family<List<ShipmentModel>, String?>((ref, uid) {
  final shipmentRepository = ref.watch(shipmentRepositoryProvider(uid));
  return shipmentRepository.getCurrentUsersShipmentsStream();
});

final shipmentRepositoryProvider = Provider.family<ShipmentRepository, String?>((ref, uid) {
  return ShipmentRepository(uid: uid);
});