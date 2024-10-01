import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/models/trailer_model.dart';
import 'package:kamyon/models/truck_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';
import '../constants/snackbars.dart';

class TruckState {
  final bool isPartial;
  final bool hasTrailer;
  final String city;
  final String trailerUid;
  final String truckType;

  TruckState({required this.isPartial, required this.hasTrailer,
    required this.city, required this.trailerUid, required this.truckType});

  TruckState copyWith({
    bool? isPartial,
    bool? hasTrailer,
    String? city,
    String? trailerUid,
    String? truckType,
  }) {
    return TruckState(
      isPartial: isPartial ?? this.isPartial,
      city: city ?? this.city,
      hasTrailer: hasTrailer ?? this.hasTrailer,
      trailerUid: trailerUid ?? this.trailerUid,
      truckType: truckType ?? this.truckType,
    );
  }
}

class TruckController extends StateNotifier<TruckState> {
  TruckController(super.state);

  final nameController = TextEditingController();
  final weightController = TextEditingController();
  final lengthController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  final trailerNameController = TextEditingController();
  final trailerWeightController = TextEditingController();
  final trailerLengthController = TextEditingController();


  changeVehicleLimit() {
    state = state.copyWith(isPartial: !state.isPartial);
  }

  changeTrailerMode() {
    state = state.copyWith(hasTrailer: !state.hasTrailer);
  }

  changeTrailerUid(String value) {
    state = state.copyWith(trailerUid: value);
  }

  changeTruckType(String value) {
    state = state.copyWith(truckType: value);
  }

  changeCity(String value) {
    state = state.copyWith(city: value);
  }

  createTruck(BuildContext context, {required String errorTitle, required String successTitle}) async {

    String trailerUid = state.hasTrailer ? const Uuid().v4() : "";

    if(state.hasTrailer) {
      await createTrailer(trailerUid);
    }

    TruckModel truckModel = TruckModel(
      name: nameController.text,
      uid: const Uuid().v4(),
      ownerUid: FirebaseAuth.instance.currentUser!.uid,
      weight: double.parse(weightController.text),
      length: double.parse(lengthController.text),
      description: descriptionController.text,
      city: state.city,
      isPartial: state.isPartial,
      trailerUid: trailerUid,
      type: state.truckType,
    );



    final response = await http.post(
      url,
      body: {
        'executeQuery': "INSERT INTO trucks (${truckModel.getDbFields()}) VALUES (${truckModel.questionMarks})",
        "params": jsonEncode(truckModel.getDbFormat()),
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

  createTrailer(String trailerUid) async {

    TrailerModel trailerModel = TrailerModel(
      length: double.parse(trailerLengthController.text),
      weight: double.parse(trailerWeightController.text),
      ownerUid: FirebaseAuth.instance.currentUser!.uid,
      uid: trailerUid,
      name: trailerNameController.text,
    );

    final response = await http.post(
      url,
      body: {
        'executeQuery': "INSERT INTO trailers (${trailerModel.getDbFields()}) VALUES (${trailerModel.questionMarks})",
        "params": jsonEncode(trailerModel.getDbFormat()),
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
}

final truckController = StateNotifierProvider<TruckController, TruckState>(
      (ref) => TruckController(TruckState(isPartial: false, hasTrailer: false, city: "", trailerUid: "", truckType: ""),),);