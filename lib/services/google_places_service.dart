import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

import '../constants/app_constants.dart';

class GooglePlacesService {

  static Future<List<TemporaryPlaceModel>> searchPlaces(String placeType) async {
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    String url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json"
        "?location=${position.latitude},${position.longitude}"
        "&radius=30000" // 30km radius
        "&type=$placeType"
        "&key=$kApiKey";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List data = json.decode(response.body)["results"];
      return data.map((e) => TemporaryPlaceModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load places");
    }
  }
}

class TemporaryPlaceModel {
  final String? name;
  final String? address;
  final double? lat;
  final double? lng;
  final String? imageUrl;

  TemporaryPlaceModel({this.name, this.address, this.lat, this.lng, this.imageUrl});

  factory TemporaryPlaceModel.fromJson(Map<String, dynamic> json) {
    String? imageRef = json["photos"] != null ? json["photos"][0]["photo_reference"] : null;
    String? imageUrl = imageRef != null
        ? "https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$imageRef&key=$kApiKey"
        : null;

    return TemporaryPlaceModel(
      name: json["name"] ?? "Unknown",
      address: json["vicinity"] ?? "No Address",
      lat: json["geometry"]["location"]["lat"],
      lng: json["geometry"]["location"]["lng"],
      imageUrl: imageUrl,
    );
  }
}
