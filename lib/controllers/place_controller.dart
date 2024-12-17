import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';
import '../constants/snackbars.dart';
import '../models/place_model.dart';

class PlaceState {
  final List placeList;
  final List<AppPlaceModel> placeModels;
  final AppPlaceModel origin;
  final AppPlaceModel destination;

  PlaceState({required this.placeList, required this.origin,
    required this.destination, required this.placeModels});

  PlaceState copyWith({List? placeList, AppPlaceModel? origin, AppPlaceModel? destination, List<AppPlaceModel>? placeModels}) {
    return PlaceState(
      placeList: placeList ?? this.placeList,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      placeModels: placeModels ?? this.placeModels,


    );
  }
}

class PlaceController extends StateNotifier<PlaceState> {
  PlaceController(super.state);

  final originSearchController =  TextEditingController();
  final destinationSearchController =  TextEditingController();
  var uuid =  const Uuid();
  String sessionToken = '1234567890';


  void getSuggestion(String input) async {



    try{
      String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request = '$baseURL?input=$input&key=$kApiKey&sessiontoken=$sessionToken';
      var response = await http.get(Uri.parse(request));
      var data = json.decode(response.body);
      if (kDebugMode) {
        debugPrint('mydata');
        debugPrint(data.toString());
      }
      if (response.statusCode == 200) {
        state = state.copyWith(placeList: json.decode(response.body)['predictions']);
      } else {
        throw Exception('Failed to load predictions');
      }
    }catch(e){
      debugPrint(e.toString());
    }

  }

  Future<void> fetchPlaceDetails(String placeName) async {

    const String baseUrl = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json';


    final Uri url = Uri.parse(
      '$baseUrl?fields=formatted_address,name,rating,opening_hours,geometry'
          '&input=${Uri.encodeComponent(placeName)}'
          '&inputtype=textquery'
          '&key=$kApiKey',
    );

    try {

      final response = await http.get(url);


      if (response.statusCode == 200) {

        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Place details: $data');
        state = state.copyWith(placeList: data['candidates']);

        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final place = data['candidates'][0];
          print('Place name: ${place['name']}');
          print('Address: ${place['formatted_address']}');
          print('Rating: ${place['rating']}');

        } else {
          print('No place found for the input.');
        }
      } else {
        print('Failed to load place details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching place details: $e');
    }
  }

  createPlace(BuildContext context, {required AppPlaceModel appPlaceModel}) async {

    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "INSERT INTO places (${appPlaceModel.getDbFields()}) VALUES (${appPlaceModel.questionMarks})",
        "params": jsonEncode(appPlaceModel.getDbFormat()),
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

  bool checkPlaceModel(List<AppPlaceModel> placeModels, {required bool isOrigin}) {

    if(isOrigin) {
      List origins = placeModels.where((element) =>
      element.name == state.origin.name || element.name == state.origin.address || element.uid == state.origin.uid ||
          (element.latitude == state.origin.latitude && element.longitude == state.origin.longitude)
        ,).toList();

      if(origins.isEmpty) {
        return false;
      }
      else {
        return true;
      }
    }

    else {
      List destinations = placeModels.where((element) =>
      element.name == state.destination.name || element.name == state.destination.address || element.uid == state.destination.uid ||
          (element.latitude == state.destination.latitude && element.longitude == state.destination.longitude)
        ,).toList();

      if(destinations.isEmpty) {
        return false;
      }
      else {
        return true;
      }
    }
  }

  setPlaceModels({required AppPlaceModel origin, required AppPlaceModel destination}) {
    state = state.copyWith(destination: destination, origin: origin);
  }

  clear() {
    state = state.copyWith(placeList: [], placeModels: []);
    destinationSearchController.clear();
    originSearchController.clear();
  }

}

final placeController = StateNotifierProvider<PlaceController, PlaceState>(
  (ref) => PlaceController(PlaceState(placeList: [], origin: AppPlaceModel(name: ""),
      destination: AppPlaceModel(name: ""), placeModels: [])),
);