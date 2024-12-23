import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class ShipmentModel implements BaseModel<ShipmentModel> {

  final String? uid;
  final DateTime? date;
  final String? type;
  final String? fromUid;
  final String? toUid;
  final String? unitUid;
  final String? truckUid;
  final double? price;
  final String? description;
  final String? state;
  final DateTime? lastChangedDate;
  final double? lastLatitude;
  final double? lastLongitude;

  const ShipmentModel({
    this.uid,
    this.date, this.type,
    this.fromUid, this.toUid,
    this.unitUid,
    this.truckUid,
    this.price,
    this.description,
    this.state,
    this.lastChangedDate,
    this.lastLatitude,
    this.lastLongitude,
  });

  @override
  ShipmentModel fromJson(Map<String, dynamic> json) => ShipmentModel(
    uid: json["uid"] as String?,
    date: DateTime.fromMillisecondsSinceEpoch(int.parse(json["date"])),
    type: json["type"] as String?,
    toUid: json["toUid"] as String?,
    fromUid: json["fromUid"] as String?,
    unitUid: json["unitUid"] as String?,
    price: double.parse(json["price"]),
    description: json["description"] as String?,
    state: json["state"] as String?,
    lastChangedDate: DateTime.fromMillisecondsSinceEpoch(int.parse(json["lastChangedDate"])),
    lastLatitude: double.parse(json["lastLatitude"]),
    lastLongitude: double.parse(json["lastLongitude"]),
  );
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "uid": uid,
    "date": date!.millisecondsSinceEpoch,
    "type": type,
    "toUid": toUid,
    "fromUid": fromUid,
    "unitUid": unitUid,
    "truckUid": truckUid,
    "price" : price,
    "description" : description,
    "state" : state,
    "lastChangedDate": lastChangedDate!.millisecondsSinceEpoch,
    "lastLatitude" : lastLatitude,
    "lastLongitude" : lastLongitude,

  };

  String getDbFields() {
    return "uid, date, type, toUid, fromUid, unitUid, truckUid, price, description, state, lastChangedDate, lastLatitude, lastLongitude";
  }

  String getDbFieldsWithQuestionMark() {
    return "uid = ?, date = ?, type = ?, toUid = ?, fromUid = ?, unitUid = ?, truckUid = ?, price = ?, description = ?, state = ?, lastChangedDate = ?, lastLatitude = ?, lastLongitude = ?";
  }

  String get questionMarks => "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";

  List getDbFormat() {
    return [
      uid,
      date,
      type,
      toUid,
      fromUid,
      unitUid,
      truckUid,
      price,
      description,
      state,
      lastChangedDate,
      lastLatitude,
      lastLongitude,
    ];
  }

  List get allMessages => type!.split(";");
}