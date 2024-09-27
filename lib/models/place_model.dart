import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class AppPlaceModel implements BaseModel<AppPlaceModel> {

  final String? uid;
  final String? name;
  final double? latitude;
  final double? longitude;



  AppPlaceModel({this.uid, this.name, this.latitude,this.longitude
  });

  @override
  AppPlaceModel fromJson(Map<String, dynamic> json) => AppPlaceModel(
    latitude: json["latitude"] as double?,
    uid: json["uid"] as String?,
    name: json["name"] as String?,
    longitude: json["longitude"] as double?,
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "latitude": latitude,
    "uid": uid,
    "name": name,
    "longitude": longitude,
  };

  String getDbFields() {
    return "latitude, uid, name, longitude";
  }

  String getDbFieldsWithQuestionMark() {
    return "latitude = ?, uid = ?, name = ?, longitude = ?";
  }
  String get questionMarks => "?, ?, ?, ?";

  List getDbFormat() {
    return [
      latitude,
      uid,
      name,
      longitude,
    ];
  }

}