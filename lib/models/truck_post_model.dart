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
  final int? startDate;
  final int? endDate;
  final String? contact;
  final double? price;
  final String? state;
  final int? createdDate;
  final double? originLat;
  final double? originLong;
  final double? destinationLat;
  final double? destinationLong;
  final double? distance;
  final String? originName;
  final String? originAddress;
  final String? destinationName;
  final String? destinationAddress;


  const TruckPostModel({this.uid, this.origin, this.description,
    this.ownerUid,
    this.destination, this.startDate,
    this.endDate, this.truckUid,
    this.contact, this.price, this.state, this.createdDate,
    this.originLat, this.destinationLat, this.destinationLong, this.originLong,
    this.distance, this.originName, this.originAddress,
    this.destinationName, this.destinationAddress,
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
    createdDate: int.parse(json["createdDate"]),
    startDate: int.parse(json["startDate"]),
    endDate: int.parse(json["endDate"]),
    destinationLat: double.parse(json["destinationLat"]),
    destinationLong: double.parse(json["destinationLong"]),
    originLat: double.parse(json["originLat"]),
    originLong: double.parse(json["originLong"]),
    distance: double.parse(json["distance"]),
    originName : json["originName"] as String?,
    originAddress : json["originAddress"] as String?,
    destinationName : json["destinationName"] as String?,
    destinationAddress : json["destinationAddress"] as String?,
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
    "createdDate": createdDate,
    "startDate": startDate,
    "endDate": endDate,
    "originLat" : originLat,
    "destinationLat" : destinationLat,
    "destinationLong" : destinationLong,
    "originLong" : originLong,
    "distance" : distance,
    "originName" : originName,
    "originAddress" : originAddress,
    "destinationName" : destinationName,
    "destinationAddress" : destinationAddress,
  };

  String getDbFields() {
    return "truckUid, ownerUid, description, uid, origin, state, contact, destination, price, createdDate, startDate, endDate, originLat, destinationLat, originLong, destinationLong, distance, originName, originAddress, destinationName, destinationAddress";
  }

  String getDbFieldsWithQuestionMark() {
    return "truckUid = ?, ownerUid = ?, description = ?, uid = ?, origin = ?, state = ?, contact = ?, destination = ?, price = ?, createdDate = ?, startDate = ?, endDate = ?, originLat = ?, destinationLat = ?, originLong = ?, destinationLong = ?, distance = ?, originName = ?, originAddress = ?, destinationName = ?, destinationAddress = ?";
  }

  String get questionMarks => "?, ?, ?, ?, ?, ? ,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";

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
      createdDate,
      startDate,
      endDate,
      originLat,
      destinationLat,
      originLong,
      destinationLong,
      distance,
      originName,
      originAddress,
      destinationName,
      destinationAddress
    ];
  }
}