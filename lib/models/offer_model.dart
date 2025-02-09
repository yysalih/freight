import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class OfferModel implements BaseModel<OfferModel> {

  final String? uid;
  final int? date;
  final String? type;
  final String? loadOwnerUid;
  final String? carrierUid;
  final String? unitUid;
  final String? truckUid;
  final double? price;
  final String? description;
  final String? state;


  const OfferModel({
    this.uid,
    this.date, this.type,
    this.loadOwnerUid, this.carrierUid,
    this.unitUid,
    this.truckUid,
    this.price,
    this.description,
    this.state,
  });

  @override
  OfferModel fromJson(Map<String, dynamic> json) => OfferModel(
    uid: json["uid"] as String?,
    date: int.parse(json["date"]),
    type: json["type"] as String?,
    carrierUid: json["toUid"] as String?,
    loadOwnerUid: json["fromUid"] as String?,
    unitUid: json["unitUid"] as String?,
    truckUid: json["truckUid"] as String?,
    price: double.parse(json["price"]),
    description: json["description"] as String?,
    state: json["state"] as String?,
  );
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "uid": uid,
    "date": date,
    "type": type,
    "toUid": carrierUid,
    "fromUid": loadOwnerUid,
    "unitUid": unitUid,
    "truckUid": truckUid,
    "price" : price,
    "description" : description,
    "state" : state,
  };

  String getDbFields() {
    return "uid, date, type, toUid, fromUid, unitUid, truckUid, price, description, state";
  }

  String getDbFieldsWithQuestionMark() {
    return "uid = ?, date = ?, type = ?, toUid = ?, fromUid = ?, unitUid = ?, truckUid = ?, price = ?, description = ?, state = ?";
  }

  String get questionMarks => "?, ?, ?, ?, ?, ?, ?, ?, ?, ?";

  List getDbFormat() {
    return [
      uid,
      date,
      type,
      carrierUid,
      loadOwnerUid,
      unitUid,
      truckUid,
      price,
      description,
      state
    ];
  }


}