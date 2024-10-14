import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class AppPlaceModel implements BaseModel<AppPlaceModel> {

  final String? uid;
  final String? name;
  final String? address;
  final double? latitude;
  final double? longitude;



  AppPlaceModel({this.uid, this.name, this.latitude,this.longitude, this.address
  });

  @override
  AppPlaceModel fromJson(Map<String, dynamic> json) => AppPlaceModel(
    latitude: double.parse(json["latitude"]),
    uid: json["uid"] as String?,
    name: json["name"] as String?,
    address: json["address"] as String?,
    longitude: double.parse(json["longitude"]),
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "latitude": latitude,
    "uid": uid,
    "name": name,
    "address": address,
    "longitude": longitude,
  };

  String getDbFields() {
    return "latitude, uid, name, longitude, address";
  }

  String getDbFieldsWithQuestionMark() {
    return "latitude = ?, uid = ?, name = ?, longitude = ?, address = ?";
  }
  String get questionMarks => "?, ?, ?, ?, ?";

  List getDbFormat() {
    return [
      latitude,
      uid,
      name,
      longitude,
      address,
    ];
  }

}