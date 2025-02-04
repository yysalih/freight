import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/models/offer_model.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';
import '../constants/snackbars.dart';
import '../models/truck_model.dart';

class OfferState  {
  final double price;
  final TruckModel truckModel;

  OfferState({required this.price, required this.truckModel});

  OfferState copyWith({
    TruckModel? truckModel,
    double? price,
  }) {
    return OfferState(
      price: price ?? this.price,
      truckModel: truckModel ?? this.truckModel,
    );
  }
}

class OfferController extends StateNotifier<OfferState> {
  OfferController(super.state);

  final descriptionController = TextEditingController();
  final priceController = TextEditingController();

  createOffer(BuildContext context, {required String type, required String unitUid, required String toUid,
    required String errorTitle, required String successTitle}) async {
    String uid = const Uuid().v4();
    OfferModel offerModel = OfferModel(
      price: double.parse(priceController.text),
      date: DateTime.now(),
      description: descriptionController.text,
      fromUid: FirebaseAuth.instance.currentUser!.uid,
      toUid: toUid,
      truckUid: state.truckModel.uid,
      type: type,
      uid: uid,
      unitUid: unitUid,
      state: "sent",
    );

    debugPrint(offerModel.toJson().toString());

    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "INSERT INTO offers (${offerModel.getDbFields()}) VALUES (${offerModel.questionMarks})",
        "params": jsonEncode(offerModel.getDbFormat()),
      },
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var data = jsonDecode(response.body);
      debugPrint('Response: $data');
      Navigator.pop(context);
      showSnackbar(title: successTitle, context: context);

    }
    else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      showSnackbar(title: errorTitle, context: context);

    }
  }

  updateOfferState(BuildContext context, {required String offerUid, required String newState,
    required String errorTitle, required String successTitle}) async {
    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "UPDATE offers SET state = ? WHERE uid = ?",
        "params": jsonEncode([newState, offerUid]),
      },
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var data = jsonDecode(response.body);
      debugPrint('Response: $data');

      if (!data.toString().contains("error")) {
        showSnackbar(title: successTitle, context: context);
      } else {
        debugPrint('Error updating offer state');
        showSnackbar(title: errorTitle, context: context);
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      showSnackbar(title: errorTitle, context: context);
    }
  }


  deleteOffer({
    required String offerUid,
  }) async {
    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "DELETE FROM offers WHERE uid = ?",
        "params": jsonEncode([offerUid]), // Pass the uid of the load to delete
      },
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var data = jsonDecode(response.body);
      debugPrint('Response: $data');
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
    }
  }

  changeTruck({required TruckModel value}) => state = state.copyWith(truckModel: value);

}

final offerController = StateNotifierProvider<OfferController, OfferState>((ref) => OfferController(OfferState(
  truckModel: TruckModel(), price: 0.0,
)),);