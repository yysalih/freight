import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class OfferModel implements BaseModel<OfferModel> {

  final String? uid;
  final DateTime? date;
  final String? type;
  final String? fromUid;
  final String? toUid;
  final String? unitUid;
  final String? truckUid;
  final double? price;
  final String? description;


  const OfferModel({
    this.uid,
    this.date, this.type,
    this.fromUid, this.toUid,
    this.unitUid,
    this.truckUid,
    this.price,
    this.description
  });

  @override
  OfferModel fromJson(Map<String, dynamic> json) => OfferModel(
    uid: json["uid"] as String?,
    date: DateTime.fromMillisecondsSinceEpoch(int.parse(json["date"])),
    type: json["type"] as String?,
    toUid: json["toUid"] as String?,
    fromUid: json["fromUid"] as String?,
    unitUid: json["unitUid"] as String?,
    price: double.parse(json["price"]),
    description: json["description"] as String?,
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
  };

  String getDbFields() {
    return "uid, date, type, toUid, fromUid, unitUid, truckUid, price, description";
  }

  String getDbFieldsWithQuestionMark() {
    return "uid = ?, date = ?, type = ?, toUid = ?, fromUid = ?, unitUid = ?, truckUid = ?, price = ?, description = ?";
  }

  String get questionMarks => "?, ?, ?, ?, ?, ?, ?, ?, ?";

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
    ];
  }

  List get allMessages => type!.split(";");
}