import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/controllers/base_notifier.dart';
import 'package:kamyon/controllers/place_controller.dart';
import 'package:kamyon/controllers/truck_controller.dart';
import 'package:kamyon/models/load_model.dart';
import 'package:kamyon/models/place_model.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';
import '../constants/languages.dart';
import '../constants/snackbars.dart';
import '../models/base_state.dart';
import '../models/user_model.dart';
import 'main_controller.dart';

class LoadState implements BaseState{

  final AppPlaceModel origin;
  final AppPlaceModel destination;
  @override
  final String truckType;
  final bool isPartial;
  final bool isPalletized;
  @override
  final String contact;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay startHour;
  final TimeOfDay endHour;

  LoadState({
    required this.origin, required this.destination, required this.truckType, required this.isPartial, required this.isPalletized,
    required this.contact, required this.startDate, required this.endDate, required this.startHour, required this.endHour
  });

  LoadState copyWith({
    AppPlaceModel? origin,
    AppPlaceModel? destination,
    String? truckType,
    bool? isPartial,
    bool? isPalletized,
    String? contact,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startHour,
    TimeOfDay? endHour,
  }) {
    return LoadState(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      truckType: truckType ?? this.truckType,
      isPartial: isPartial ?? this.isPartial,
      isPalletized: isPalletized ?? this.isPalletized,
      contact: contact ?? this.contact,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
    );
  }
}

class LoadController extends StateNotifier<LoadState> implements BaseNotifier{
  LoadController(super.state);

  final descriptionController = TextEditingController();
  final lengthController = TextEditingController();
  final weightController = TextEditingController();
  final volumeController = TextEditingController();
  @override
  final phoneController = TextEditingController();
  final priceController = TextEditingController();


  switchBools({required bool isPartial, required bool isPalletized}) => state = state.copyWith(isPalletized: isPalletized, isPartial: isPartial);
  @override
  switchStrings({required String truckType, required String contact}) => state = state.copyWith(truckType: truckType, contact: contact);
  switchDateTimes({required DateTime startDate, required DateTime endDate}) => state = state.copyWith(startDate: startDate, endDate: endDate);
  switchTimeOfDays({required TimeOfDay startHour, required TimeOfDay endHour}) => state = state.copyWith(startHour: startHour, endHour: endHour);
  switchAppPlaceModels({required AppPlaceModel origin, required AppPlaceModel destination}) => state = state.copyWith(origin: origin, destination: destination);


  @override
  addNewPhoneNumberToUser({required UserModel currentUser}) async {//TODO doesn't work, needs to be fixed - 30/10/2024 15:03
    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "UPDATE users SET contacts = '${currentUser.contacts}${phoneController.text};' WHERE uid = '${currentUser.uid}'",
      },
    );

    if (response.statusCode == 200) {
      var data = response.body;
      if(data.toString().contains("error")) {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Error: ${response.reasonPhrase}');
      }
      else {
        debugPrint('${response.statusCode}');
        debugPrint('${response.reasonPhrase}');
        debugPrint(phoneController.text);
        debugPrint('${currentUser.uid}');

      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
    }

  }

  createLoad(BuildContext context, {required String errorTitle, required String successTitle, bool fromMainView = false}) async {
    LoadModel loadModel = LoadModel(
      isPartial: state.isPartial,
      contact: state.contact,
      uid: const Uuid().v4(),
      description: "",
      createdDate: DateTime.now().millisecondsSinceEpoch,
      endDate: state.endDate.millisecondsSinceEpoch,
      destination: state.destination.uid,
      origin: state.origin.uid,
      endHour: state.endHour.format(context),
      startHour: state.startHour.format(context),
      length: double.parse(lengthController.text.isEmpty ? "0.0" : lengthController.text),
      weight: double.parse(weightController.text.isEmpty ? "0.0" : weightController.text),
      volume: double.parse(volumeController.text.isEmpty ? "0.0" : volumeController.text),
      destinationLat: state.destination.latitude,
      destinationLong: state.destination.longitude,
      originLat: state.origin.latitude,
      originLong: state.origin.longitude,
      price: double.parse(priceController.text),
      loadType: "",
      ownerUid: FirebaseAuth.instance.currentUser!.uid,
      startDate: state.startDate.millisecondsSinceEpoch,
      state: "available",
      truckType: state.truckType,
      distance: 1200.50,
      isPalletized: state.isPalletized,
      destinationAddress: state.destination.address,
      destinationName: state.destination.name,
      originAddress: state.origin.address,
      originName: state.origin.name,
    );
    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "INSERT INTO loads (${loadModel.getDbFields()}) VALUES (${loadModel.questionMarks})",
        "params": jsonEncode(loadModel.getDbFormat()),
      },
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var data = jsonDecode(response.body);
      debugPrint('Response: $data');
      if(!fromMainView) Navigator.pop(context);
      showSnackbar(title: successTitle, context: context);

    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      showSnackbar(title: errorTitle, context: context);
    }
  }

  deleteLoad({
    required String loadUid,
  }) async {
    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "DELETE FROM loads WHERE uid = ?",
        "params": jsonEncode([loadUid]), // Pass the uid of the load to delete
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

  updateLoadState(BuildContext context, {required String loadUid, required String newState}) async {
    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "UPDATE loads SET state = ? WHERE uid = ?",
        "params": jsonEncode([newState, loadUid]),
      },
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var data = jsonDecode(response.body);
      debugPrint('Response: $data');

      if (!data.toString().contains("error")) {
        //showSnackbar(title: successTitle, context: context);
      } else {
        debugPrint('Error updating offer state');
        //showSnackbar(title: errorTitle, context: context);
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      //showSnackbar(title: errorTitle, context: context);
    }
  }

  Future<void> handleCreatingLoad(LoadController loadNotifier, PlaceState placeState,
      PlaceController placeNotifier, List<AppPlaceModel> placeModels, BuildContext context,
      String language, TruckController truckNotifier, MainController mainNotifier) async {
    loadNotifier.switchAppPlaceModels(
        origin: placeState.origin,
        destination: placeState.destination
    );

    bool checkOriginExists = placeNotifier.checkPlaceModel(placeModels, isOrigin: true);
    bool checkDestinationExists = placeNotifier.checkPlaceModel(placeModels, isOrigin: false);

    if(checkOriginExists) {
      await placeNotifier.createPlace(context, appPlaceModel: placeState.origin,);
    }

    if(checkDestinationExists) {
      await placeNotifier.createPlace(context, appPlaceModel: placeState.destination,);
    }

    loadNotifier.createLoad(context, errorTitle: languages[language]!["problem_creating_new_load"]!,
        successTitle: languages[language]!["new_load_created"]!, fromMainView: true);

    loadNotifier.clear();

    truckNotifier.clear();
    placeNotifier.clear();

    mainNotifier.changeExpansions(isTruckPostExpanded: false, isLoadExpanded: false);
    FocusScope.of(context).unfocus();
  }


  clear() {
    state = state.copyWith(origin: AppPlaceModel(), destination: AppPlaceModel());
    priceController.clear();
    descriptionController.clear();
  }



}

final loadController = StateNotifierProvider<LoadController, LoadState>(
      (ref) => LoadController(LoadState(
        origin: AppPlaceModel(),
        destination: AppPlaceModel(),
        truckType: "",
        isPartial: false,
        isPalletized: false,
        contact: "",
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        startHour: TimeOfDay.now(),
        endHour: TimeOfDay.now(),
      ),),);