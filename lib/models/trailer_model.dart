import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class TrailerModel implements BaseModel<TrailerModel> {

  final String? uid;
  final String? name;
  final String? ownerUid;
  final double? length;
  final double? weight;


  TrailerModel({
    this.uid,
    this.name,
    this.length,
    this.ownerUid,
    this.weight,
  });

  @override
  TrailerModel fromJson(Map<String, dynamic> json) => TrailerModel(
    length: double.parse(json["length"]),
    ownerUid: json["ownerUid"] as String?,
    uid: json["uid"] as String?,
    name: json["name"] as String?,
    weight: double.parse(json["weight"]),
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
      weight,
    ];
  }
}