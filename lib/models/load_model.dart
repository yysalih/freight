import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kamyon/models/place_model.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class LoadModel implements BaseModel<LoadModel> {

  final String? uid;
  final String? origin;
  final String? destination;
  final String? ownerUid;
  final String? description;
  final double? length;
  final double? weight;
  final double? volume;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? startHour;
  final String? endHour;
  final String? loadType;
  final String? truckType;
  final bool? isPartial;
  final String? contact;
  final double? price;
  final String? state;
  final DateTime? createdDate;


  LoadModel({this.uid, this.origin, this.description, this.length,
    this.ownerUid, this.isPartial,
    this.weight, this.loadType,
    this.destination, this.volume, this.startDate,
    this.endDate, this.startHour, this.endHour, this.truckType,
    this.contact, this.price, this.state, this.createdDate,
  });

  @override
  LoadModel fromJson(Map<String, dynamic> json) => LoadModel(
    length: json["length"] as double?,
    ownerUid: json["ownerUid"] as String?,
    description: json["description"] as String?,
    uid: json["uid"] as String?,
    origin: json["origin"] as String?,
    isPartial: json["isPartial"] as bool?,
    loadType: json["loadType"] as String?,
    weight: json["weight"] as double?,
    state: json["state"] as String?,
    contact: json["contact"] as String?,
    destination: json["destination"] as String?,
    truckType: json["truckType"] as String?,
    startHour: json["startHour"] as String?,
    endHour: json["endHour"] as String?,
    price: json["price"] as double?,
    volume: json["volume"] as double?,
    createdDate: DateTime.fromMillisecondsSinceEpoch(json["createdDate"]),
    startDate: DateTime.fromMillisecondsSinceEpoch(json["startDate"]),
    endDate: DateTime.fromMillisecondsSinceEpoch(json["endDate"]),
  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "length": length,
    "ownerUid": ownerUid,
    "description": description,
    "uid": uid,
    "origin": origin,
    "isPartial": isPartial,
    "loadType": loadType,
    "weight": weight,
    "state": state,
    "contact": contact,
    "destination": destination,
    "truckType": truckType,
    "startHour": startHour,
    "endHour": endHour,
    "price": price,
    "volume": volume,
    "createdDate": createdDate!.millisecondsSinceEpoch,
    "startDate": startDate!.millisecondsSinceEpoch,
    "endDate": endDate!.millisecondsSinceEpoch,
  };

  String getDbFields() {
    return "length, ownerUid, description, uid, origin, isPartial, loadType, weight, state, contact, destination, truckType, startHour, endHour, price, volume, createdDate, startDate, endDate";
  }

  String getDbFieldsWithQuestionMark() {
    return "length = ?, ownerUid = ?, description = ?, uid = ?, origin = ?, isPartial = ?, loadType = ?, weight = ?, state = ?, contact = ?, destination = ?, truckType = ?, startHour = ?, endHour = ?, price = ?, volume = ?, createdDate = ?, startDate = ?, endDate = ?";
  }

  String get questionMarks => "?, ?, ?, ?, ?, ? ,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";

  List getDbFormat() {
    return [
      length,
      ownerUid,
      description,
      uid,
      origin,
      isPartial,
      loadType,
      weight,
      state,
      contact,
      destination,
      truckType,
      startHour,
      endHour,
      price,
      volume,
      createdDate!.millisecondsSinceEpoch,
      startDate!.millisecondsSinceEpoch,
      endDate!.millisecondsSinceEpoch,
    ];
  }
}