import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kamyon/models/place_model.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class TruckPostModel implements BaseModel<TruckPostModel> {

  final String? uid;
  final String? origin;
  final String? destination;
  final String? ownerUid;
  final String? truckUid;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? contact;
  final double? price;
  final String? state;
  final DateTime? createdDate;
  final double? originLat;
  final double? originLong;
  final double? destinationLat;
  final double? destinationLong;
  final double? distance;


  const TruckPostModel({this.uid, this.origin, this.description,
    this.ownerUid,
    this.destination, this.startDate,
    this.endDate, this.truckUid,
    this.contact, this.price, this.state, this.createdDate,
    this.originLat, this.destinationLat, this.destinationLong, this.originLong,
    this.distance
  });

  @override
  TruckPostModel fromJson(Map<String, dynamic> json) => TruckPostModel(
    ownerUid: json["ownerUid"] as String?,
    description: json["description"] as String?,
    uid: json["uid"] as String?,
    origin: json["origin"] as String?,
    truckUid: json["truckUid"] as String?,
    state: json["state"] as String?,
    contact: json["contact"] as String?,
    destination: json["destination"] as String?,
    price: double.parse(json["price"]),
    createdDate: DateTime.fromMillisecondsSinceEpoch(int.parse(json["createdDate"])),
    startDate: DateTime.fromMillisecondsSinceEpoch(int.parse(json["startDate"])),
    endDate: DateTime.fromMillisecondsSinceEpoch(int.parse(json["endDate"])),
    destinationLat: double.parse(json["destinationLat"]),
    destinationLong: double.parse(json["destinationLong"]),
    originLat: double.parse(json["originLat"]),
    originLong: double.parse(json["originLong"]),
    distance: double.parse(json["distance"]),

  );

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "truckUid": truckUid,
    "ownerUid": ownerUid,
    "description": description,
    "uid": uid,
    "origin": origin,
    "state": state,
    "contact": contact,
    "destination": destination,
    "price": price,
    "createdDate": createdDate!.millisecondsSinceEpoch,
    "startDate": startDate!.millisecondsSinceEpoch,
    "endDate": endDate!.millisecondsSinceEpoch,
    "originLat" : originLat,
    "destinationLat" : destinationLat,
    "destinationLong" : destinationLong,
    "originLong" : originLong,
    "distance" : distance,
  };

  String getDbFields() {
    return "truckUid, ownerUid, description, uid, origin, state, contact, destination, price, createdDate, startDate, endDate, originLat, destinationLat, originLong, destinationLong, distance";
  }

  String getDbFieldsWithQuestionMark() {
    return "truckUid = ?, ownerUid = ?, description = ?, uid = ?, origin = ?, state = ?, contact = ?, destination = ?, price = ?, createdDate = ?, startDate = ?, endDate = ?, originLat = ?, destinationLat = ?, originLong = ?, destinationLong = ?, distance = ?";
  }

  String get questionMarks => "?, ?, ?, ?, ?, ? ,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";

  List getDbFormat() {
    return [
      truckUid,
      ownerUid,
      description,
      uid,
      origin,
      state,
      contact,
      destination,
      price,
      createdDate!.millisecondsSinceEpoch,
      startDate!.millisecondsSinceEpoch,
      endDate!.millisecondsSinceEpoch,
      originLat,
      destinationLat,
      originLong,
      destinationLong,
      distance
    ];
  }
}