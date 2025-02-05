import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:kamyon/models/base_unit_model.dart';
import 'package:kamyon/models/place_model.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class LoadModel extends BaseUnitModel implements BaseModel<LoadModel> {

  @override
  final String? uid;
  final String? origin;
  final String? destination;
  final double? originLat;
  final double? originLong;
  final double? destinationLat;
  final double? destinationLong;
  @override
  final String? ownerUid;
  @override
  final String? description;
  @override
  final double? length;
  @override
  final double? weight;
  final double? volume;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? startHour;
  final String? endHour;
  final String? loadType;
  final String? truckType;
  @override
  final bool? isPartial;
  final bool? isPalletized;
  final String? contact;
  final double? price;
  final double? distance;
  final String? state;
  final DateTime? createdDate;
  final String? originName;
  final String? originAddress;
  final String? destinationName;
  final String? destinationAddress;


  LoadModel({this.uid, this.origin, this.description, this.length,
    this.ownerUid, this.isPartial,
    this.weight, this.loadType,
    this.destination, this.volume, this.startDate,
    this.endDate, this.startHour, this.endHour, this.truckType,
    this.contact, this.price, this.state, this.createdDate, this.distance, this.isPalletized,
    this.originLat, this.destinationLat, this.destinationLong, this.originLong,
    this.originName, this.originAddress,
    this.destinationName, this.destinationAddress,
  });

  @override
  LoadModel fromJson(Map<String, dynamic> json) => LoadModel(
    length: double.parse(json["length"]),
    ownerUid: json["ownerUid"] as String?,
    description: json["description"] as String?,
    uid: json["uid"] as String?,
    origin: json["origin"] as String?,
    isPartial: json['isPartial'] == 'true' || json['isPartial'] == "1",
    isPalletized: json['isPalletized'] == 'true' || json['isPalletized'] == "1",
    loadType: json["loadType"] as String?,
    weight: double.parse(json["weight"]),
    distance: double.parse(json["distance"]),
    destinationLat: double.parse(json["destinationLat"]),
    destinationLong: double.parse(json["destinationLong"]),
    originLat: double.parse(json["originLat"]),
    originLong: double.parse(json["originLong"]),
    state: json["state"] as String?,
    contact: json["contact"] as String?,
    destination: json["destination"] as String?,
    truckType: json["truckType"] as String?,
    startHour: json["startHour"] as String?,
    endHour: json["endHour"] as String?,
    price: double.parse(json["price"]),
    volume: double.parse(json["volume"]),
    createdDate: DateTime.fromMillisecondsSinceEpoch(int.parse(json["createdDate"])),
    startDate: DateTime.fromMillisecondsSinceEpoch(int.parse(json["startDate"])),
    endDate: DateTime.fromMillisecondsSinceEpoch(int.parse(json["endDate"])),
    originName : json["originName"] as String?,
    originAddress : json["originAddress"] as String?,
    destinationName : json["destinationName"] as String?,
    destinationAddress : json["destinationAddress"] as String?,
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
    "distance": distance,
    "isPalletized": isPalletized,
    "originLat" : originLat,
    "destinationLat" : destinationLat,
    "destinationLong" : destinationLong,
    "originLong" : originLong,
    "originName" : originName,
    "originAddress" : originAddress,
    "destinationName" : destinationName,
    "destinationAddress" : destinationAddress,
  };

  String getDbFields() {
    return "length, ownerUid, description, uid, origin, isPartial, loadType, weight, state, contact, destination, truckType, startHour, endHour, price, volume, createdDate, startDate, endDate, distance, isPalletized, originLat, destinationLat, originLong, destinationLong, originName, originAddress, destinationName, destinationAddress";
  }

  String getDbFieldsWithQuestionMark() {
    return "length = ?, ownerUid = ?, description = ?, uid = ?, origin = ?, isPartial = ?, loadType = ?, weight = ?, state = ?, contact = ?, destination = ?, truckType = ?, startHour = ?, endHour = ?, price = ?, volume = ?, createdDate = ?, startDate = ?, endDate = ?, distance = ?, isPalletized = ?, originLat = ?, destinationLat = ?, originLong = ?, destinationLong = ?, originName = ?, originAddress = ?, destinationName = ?, destinationAddress = ?";
  }

  String get questionMarks => "?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";

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
      distance,
      isPalletized,
      originLat,
      destinationLat,
      originLong,
      destinationLong,
      originName,
      originAddress,
      destinationName,
      destinationAddress
    ];
  }

}