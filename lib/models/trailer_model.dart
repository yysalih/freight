import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class TruckModel implements BaseModel<TruckModel> {

  final String? uid;
  final String? name;
  final String? ownerUid;
  final double? length;
  final double? weight;


  TruckModel({
    this.uid,
    this.name,
    this.length,
    this.ownerUid,
    this.weight,
  });

  @override
  TruckModel fromJson(Map<String, dynamic> json) => TruckModel(
    length: json["length"] as double?,
    ownerUid: json["ownerUid"] as String?,
    uid: json["uid"] as String?,
    name: json["name"] as String?,
    weight: json["weight"] as double?,
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "length": length,
    "ownerUid": ownerUid,
    "uid": uid,
    "name": name,
    "weight": weight,
  };

  String getDbFields() {
    return "length, ownerUid, uid, name, weight";
  }

  String getDbFieldsWithQuestionMark() {
    return "length = ?, ownerUid = ?, uid = ?, name = ?, weight = ?";
  }

  String get questionMarks => "?, ?, ?, ?, ?";

  List getDbFormat() {
    return [
      length,
      ownerUid,
      uid,
      name,
      weight
    ];
  }
}