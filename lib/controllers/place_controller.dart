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
  final AppPlaceModel origin;
  final AppPlaceModel destination;

  PlaceState({required this.placeList, required this.origin, required this.destination});

  PlaceState copyWith({List? placeList, AppPlaceModel? origin, AppPlaceModel? destination}) {
    return PlaceState(
      placeList: placeList ?? this.placeList,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
    );
  }
}

class PlaceController extends StateNotifier<PlaceState> {
  PlaceController(super.state);

  final searchController =  TextEditingController();
  var uuid =  const Uuid();
  String sessionToken = '1234567890';


  void getSuggestion(String input) async {


    const String placesApiKey = "AIzaSyDZg_ZZdVGiLpdwBs3pbnP6sl4JaEquLY8";

    try{
      String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String request = '$baseURL?input=$input&key=$placesApiKey&sessiontoken=$sessionToken';
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
    // Define your API key (Replace with your actual key)
    const String apiKey = 'AIzaSyDZg_ZZdVGiLpdwBs3pbnP6sl4JaEquLY8';

    // Define the base URL for the Places API request
    const String baseUrl = 'https://maps.googleapis.com/maps/api/place/findplacefromtext/json';

    // Create the full URL with parameters
    final Uri url = Uri.parse(
      '$baseUrl?fields=formatted_address,name,rating,opening_hours,geometry'
          '&input=${Uri.encodeComponent(placeName)}'
          '&inputtype=textquery'
          '&key=$apiKey',
    );

    try {
      // Send the HTTP GET request
      final response = await http.get(url);

      // Check for successful response
      if (response.statusCode == 200) {
        // Parse the JSON response
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Place details: $data');
        state = state.copyWith(placeList: data['candidates']);

        // Here, you can extract and use specific fields from the response
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
          final place = data['candidates'][0];
          print('Place name: ${place['name']}');
          print('Address: ${place['formatted_address']}');
          print('Rating: ${place['rating']}');
          // Add more data handling as needed
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
      url,
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


  setPlaceModels({required AppPlaceModel origin, required AppPlaceModel destination}) {
    state = state.copyWith(destination: destination, origin: origin);
  }

  //clear() => state = state.copyWith(origin: AppPlaceModel(), destination: AppPlaceModel(), placeList: []);

}

final placeController = StateNotifierProvider<PlaceController, PlaceState>(
  (ref) => PlaceController(PlaceState(placeList: [], origin: AppPlaceModel(name: ""), destination: AppPlaceModel(name: ""))),
);