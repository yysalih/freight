import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class UserModel implements BaseModel<UserModel> {

  final String? uid;
  final String? name;
  final String? lastname;
  final String? image;
  final String? email;
  final String? token;
  final String? password;
  final String? phone;
  final bool? isCarrier;
  final String? idFront;
  final String? idBack;
  final String? licenseFront;
  final String? licenseBack;
  final String? psiko;
  final String? src;
  final String? registration;
  final bool? isBroker;
  final double? point;
  final String? contacts;
  final double? lat;
  final double? lng;


  UserModel({this.uid, this.name, this.image,
    this.email, this.token, this.point,
    this.lastname, this.isBroker, this.isCarrier, this.phone,
    this.password, this.idBack, this.idFront, this.licenseBack, this.licenseFront,
    this.psiko, this.registration, this.src, this.contacts,
    this.lat, this.lng
  });

  @override
  UserModel fromJson(Map<String, dynamic> json) => UserModel(
    token: json["token"] as String?,
    lastname: json["lastname"] as String?,
    image: json["image"] as String?,
    uid: json["uid"] as String?,
    name: json["name"] as String?,
    email: json["email"] as String?,
    point: json["point"] == null ? 0.0 : double.parse(json["point"].toString()),
    isBroker: json['isBroker'] == 'true' || json['isBroker'] == "1",
    isCarrier: json['isCarrier'] == 'true' || json['isCarrier'] == "1",
    src: json["src"] as String?,
    registration: json["registration"] as String?,
    psiko: json["psiko"] as String?,
    licenseFront: json["licenseFront"] as String?,
    licenseBack: json["licenseBack"] as String?,
    idFront: json["idFront"] as String?,
    idBack: json["idBack"] as String?,
    password: json["password"] as String?,
    phone: json["phone"] as String?,
    contacts: json["contacts"] as String?,
    lat: double.parse(json["lat"].toString()),
    lng: double.parse(json["lng"].toString()),

  );
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
    "token": token,
    "image": image,
    "lastname": lastname,
    "uid": uid,
    "name": name,
    "email": email,
    "point": point,
    "isBroker": isBroker,
    "isCarrier": isCarrier,
    "src": src,
    "registration": registration,
    "psiko": psiko,
    "licenseFront": licenseFront,
    "licenseBack": licenseBack,
    "idFront": idFront,
    "idBack": idBack,
    "password": password,
    "phone": phone,
    "contacts": contacts,
    "lat" : lat,
    "lng" : lng,
  };

  String getDbFields() {
    return "token, image, lastname, uid, name, email, point, isBroker, isCarrier, src, registration, psiko, licenseFront, licenseBack, idFront, idBack, password, phone, contacts, lat, lng";
  }

  String getDbFieldsWithQuestionMark() {
    return "token = ?, image = ?, lastname = ?, uid = ?, name = ?, email = ?, point = ?, isBroker = ?, isCarrier = ?, src = ?, lat = ?, long = ?"
        "registration = ?, psiko = ?, licenseFront = ?, licenseBack = ?, idFront = ?, idBack = ?, password = ?, phone = ?, contacts = ?, lat = ?, lng = ?";
  }

  String get questionMarks => "?, ?, ?, ?, ?, ? ,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?";

  List getDbFormat() {
    return [
      token,
      image,
      lastname,
      uid,
      name,
      email,
      point,
      isBroker,
      isCarrier,
      src,
      registration,
      psiko,
      licenseFront,
      licenseBack,
      idFront,
      idBack,
      password,
      phone,
      contacts,
      lat,
      lng
    ];
  }

  List get contactNumbers => contacts!.split(";");
}