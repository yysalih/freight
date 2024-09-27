import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class TruckModel implements BaseModel<TruckModel> {

  final String? uid;
  final String? name;
  final String? ownerUid;
  final String? trailerUid;
  final String? description;
  final String? city;
  final double? length;
  final double? weight;
  final String? type;
  final bool? isPartial;


  TruckModel({this.uid, this.name, this.description,
    this.city, this.length,
    this.ownerUid, this.isPartial,
    this.weight, this.type, this.trailerUid
  });

  @override
  TruckModel fromJson(Map<String, dynamic> json) => TruckModel(
    length: json["length"] as double?,
    ownerUid: json["ownerUid"] as String?,
    trailerUid: json["trailerUid"] as String?,
    description: json["description"] as String?,
    uid: json["uid"] as String?,
    name: json["name"] as String?,
    city: json["city"] as String?,
    isPartial: json["isPartial"] as bool?,
    type: json["type"] as String?,
    weight: json["weight"] as double?,
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "length": length,
    "description": description,
    "ownerUid": ownerUid,
    "trailerUid": trailerUid,
    "uid": uid,
    "name": name,
    "city": city,
    "isPartial": isPartial,
    "type": type,
    "weight": weight,
  };

  String getDbFields() {
    return "trailerUid, length, description, ownerUid, uid, name, city, isPartial, type, weight";
  }

  String getDbFieldsWithQuestionMark() {
    return "trailerUid = ?, length = ?, description = ?, ownerUid = ?, uid = ?, name = ?, city = ?, isPartial = ?, type = ?, weight = ?";
  }
  String get questionMarks => "?, ?, ?, ?, ?, ? ,?, ?, ?, ?";

  List getDbFormat() {
    return [
      length,
      description,
      ownerUid,
      trailerUid,
      uid,
      name,
      city,
      isPartial,
      type,
      weight,
    ];
  }

}