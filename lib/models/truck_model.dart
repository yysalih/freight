import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kamyon/models/base_unit_model.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class TruckModel extends BaseUnitModel implements BaseModel<TruckModel> {

  @override
  final String? uid;
  final String? name;
  @override
  final String? ownerUid;
  final String? trailerUid;
  @override
  final String? description;
  final String? city;
  @override
  final double? length;
  @override
  final double? weight;
  final String? type;
  @override
  final bool? isPartial;


  TruckModel({this.uid, this.name, this.description,
    this.city, this.length,
    this.ownerUid, this.isPartial,
    this.weight, this.type, this.trailerUid
  });

  @override
  TruckModel fromJson(Map<String, dynamic> json) => TruckModel(
    trailerUid: json["trailerUid"] as String?,
    length: double.parse(json["length"]),
    ownerUid: json["ownerUid"] as String?,
    description: json["description"] as String?,
    uid: json["uid"] as String?,
    name: json["name"] as String?,
    city: json["city"] as String?,
    isPartial: json["isPartial"] == 1,
    type: json["type"] as String?,
    weight: double.parse(json["weight"]),
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "trailerUid": trailerUid,
    "length": length,
    "ownerUid": ownerUid,
    "description": description,
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
      trailerUid,
      length,
      description,
      ownerUid,
      uid,
      name,
      city,
      isPartial,
      type,
      weight,
    ];
  }

}