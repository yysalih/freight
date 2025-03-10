import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/controllers/base_notifier.dart';
import 'package:kamyon/controllers/place_controller.dart';
import 'package:kamyon/models/base_state.dart';
import 'package:kamyon/models/trailer_model.dart';
import 'package:kamyon/models/truck_model.dart';
import 'package:http/http.dart' as http;
import 'package:kamyon/models/truck_post_model.dart';
import 'package:kamyon/models/user_model.dart';
import 'package:uuid/uuid.dart';
import '../constants/app_constants.dart';
import '../constants/languages.dart';
import '../constants/snackbars.dart';
import '../models/place_model.dart';
import 'load_controller.dart';
import 'main_controller.dart';

class TruckState implements BaseState {
  final bool showTruckPosts;

  final bool isPartial;
  final bool hasTrailer;
  final String city;
  final String trailerUid;
  @override
  final String truckType;

  final AppPlaceModel origin;
  final AppPlaceModel destination;
  @override
  final String contact;
  final DateTime startDate;
  final DateTime endDate;

  TruckState({
    required this.isPartial, required this.hasTrailer,
    required this.city, required this.trailerUid, required this.truckType,
    required this.origin,
    required this.destination,
    required this.contact,
    required this.startDate,
    required this.endDate,
    required this.showTruckPosts,
  });

  TruckState copyWith({
    bool? isPartial,
    bool? hasTrailer,
    String? city,
    String? trailerUid,
    String? truckType,
    AppPlaceModel? origin,
    AppPlaceModel? destination,
    String? contact,
    DateTime? startDate,
    DateTime? endDate,
    bool? showTruckPosts,
  }) {
    return TruckState(
      isPartial: isPartial ?? this.isPartial,
      city: city ?? this.city,
      hasTrailer: hasTrailer ?? this.hasTrailer,
      trailerUid: trailerUid ?? this.trailerUid,
      truckType: truckType ?? this.truckType,
      origin : origin ?? this.origin,
      destination : destination ?? this.destination,
      contact : contact ?? this.contact,
      startDate : startDate ?? this.startDate,
      endDate : endDate ?? this.endDate,
      showTruckPosts : showTruckPosts ?? this.showTruckPosts,

    );
  }
}

class TruckController extends StateNotifier<TruckState> implements BaseNotifier {
  TruckController(super.state);

  final nameController = TextEditingController();
  final weightController = TextEditingController();
  final lengthController = TextEditingController();
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  final phoneController = TextEditingController();

  final trailerNameController = TextEditingController();
  final trailerWeightController = TextEditingController();
  final trailerLengthController = TextEditingController();


  changeVehicleLimit() {
    state = state.copyWith(isPartial: !state.isPartial);
  }

  changeTrailerMode() {
    state = state.copyWith(hasTrailer: !state.hasTrailer);
  }

  changeTrailerModel({required TrailerModel trailer}) {
    state = state.copyWith(trailerUid: trailer.uid);

    trailerNameController.text = trailer.name!;
    trailerLengthController.text = trailer.length.toString();
    trailerWeightController.text = trailer.weight.toString();
  }

  changeTruckType(String value) {
    state = state.copyWith(truckType: value);
  }

  changeCity(String value) {
    state = state.copyWith(city: value);
  }


  switchStartDateTime({required DateTime startDate}) => state = state.copyWith(startDate: startDate);
  switchEndDateTime({required DateTime endDate}) => state = state.copyWith(endDate: endDate);

  @override
  switchStrings({required String truckType, required String contact}) => state = state.copyWith(truckType: truckType, contact: contact);
  switchAppPlaceModels({required AppPlaceModel origin, required AppPlaceModel destination}) => state = state.copyWith(origin: origin, destination: destination);

  @override
  void addNewPhoneNumberToUser({required UserModel currentUser}) {

  }

  editTruck(BuildContext context, {required String truckUid, required String errorTitle, required String successTitle}) async {

    TruckModel truckModel = TruckModel(
      name: nameController.text,
      uid: const Uuid().v4(),
      ownerUid: FirebaseAuth.instance.currentUser!.uid,
      weight: double.parse(weightController.text),
      length: double.parse(lengthController.text),
      description: descriptionController.text,
      city: state.city,
      isPartial: state.isPartial,
      trailerUid: state.trailerUid,
      type: state.truckType,
    );



    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "UPDATE trucks SET ${truckModel.getDbFieldsWithQuestionMark()} WHERE uid = ?",
        "params": jsonEncode(truckModel.getDbFormat()..add(truckUid)),
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
      appUrl,
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
      appUrl,
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

  createTruckPost(BuildContext context, {required String truckUid, required String errorTitle, required String successTitle, bool fromMainView = false}) async {

    String uid = const Uuid().v4();

    TruckPostModel truckPostModel = TruckPostModel(
      ownerUid: FirebaseAuth.instance.currentUser!.uid,
      uid: uid,
      description: descriptionController.text,
      destination: state.destination.uid,
      origin: state.origin.uid,
      state: "available",
      price: double.parse(priceController.text),
      startDate: state.startDate.millisecondsSinceEpoch,
      endDate: state.endDate.millisecondsSinceEpoch,
      createdDate: DateTime.now().millisecondsSinceEpoch,
      contact: state.contact,
      truckUid: truckUid,
      destinationLat: state.destination.latitude,
      destinationLong: state.destination.longitude,
      originLat: state.origin.latitude,
      originLong: state.origin.longitude,

    );

    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "INSERT INTO truck_posts (${truckPostModel.getDbFields()}) VALUES (${truckPostModel.questionMarks})",
        "params": jsonEncode(truckPostModel.getDbFormat()),
      },
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var data = jsonDecode(response.body);
      debugPrint('Response: $data');
      if(!fromMainView) {
        Navigator.pop(context);
      }
      showSnackbar(title: successTitle, context: context);
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      showSnackbar(title: errorTitle, context: context);

    }
  }

  void deleteTruck({required String truckUid}) async {
    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "DELETE FROM trucks WHERE uid = ?",
        "params": jsonEncode([truckUid]),
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

  void deleteTruckPost({required String truckPostUid}) async {
    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "DELETE FROM truck_posts WHERE uid = ?",
        "params": jsonEncode([truckPostUid]),
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

  switchToTruckPosts() => state = state.copyWith(showTruckPosts: !state.showTruckPosts);

  updateTruckPostState(BuildContext context, {required String truckPostUid, required String newState}) async {
    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "UPDATE truck_posts SET state = ? WHERE uid = ?",
        "params": jsonEncode([newState, truckPostUid]),
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


  handleCreatingTruckPost(TruckController truckNotifier, PlaceState placeState,
      PlaceController placeNotifier, List<AppPlaceModel> placeModels, BuildContext context,
      MainState mainState, String language, LoadController loadNotifier, MainController mainNotifier) async {
    truckNotifier.switchAppPlaceModels(
      origin: placeState.origin,
      destination: placeState.destination,
    );

    bool checkOriginExists = placeNotifier.checkPlaceModel(placeModels, isOrigin: true);
    bool checkDestinationExists = placeNotifier.checkPlaceModel(placeModels, isOrigin: false);

    if(checkOriginExists) {
      await placeNotifier.createPlace(context, appPlaceModel: placeState.origin,);
    }

    if(checkDestinationExists) {
      await placeNotifier.createPlace(context, appPlaceModel: placeState.destination,);
    }

    await truckNotifier.createTruckPost(context, truckUid: mainState.truck.uid!,fromMainView: true,
        errorTitle: languages[language]!["problem_creating_new_truck_post"]!,
        successTitle: languages[language]!["new_truck_post_created"]!);

    loadNotifier.clear();

    truckNotifier.clear();
    placeNotifier.clear();

    mainNotifier.changeExpansions(isTruckPostExpanded: false, isLoadExpanded: false);
    FocusScope.of(context).unfocus();
  }

  clear() {
    priceController.clear();
    descriptionController.clear();
  }
}

final truckController = StateNotifierProvider<TruckController, TruckState>(
      (ref) => TruckController(TruckState(isPartial: false, hasTrailer: false, city: "", trailerUid: "", truckType: "",
          origin: AppPlaceModel(),
          destination: AppPlaceModel(),
          contact: "",
          startDate: DateTime.now(),
          endDate: DateTime.now(),
          showTruckPosts: false,
      ),),);