import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class MessageModel implements BaseModel<MessageModel> {

  final String? uid;
  final String? fromUid;
  final String? toUid;
  final String? chatUid;
  final String? message;
  final DateTime? date;
  final String? type;
  final bool? seen;


  MessageModel({this.uid, this.fromUid,
    this.chatUid, this.toUid, this.message, this.date,
    this.type, this.seen
  });

  @override
  MessageModel fromJson(Map<String, dynamic> json) => MessageModel(
    toUid: json["toUid"] as String?,
    uid: json["uid"] as String?,
    fromUid: json["fromUid"] as String?,
    chatUid: json["chatUid"] as String?,
    message: json["message"] as String?,
    date: DateTime.fromMillisecondsSinceEpoch(int.parse(json["date"])),
    type: json["type"] as String?,
    seen: json['seen'] == 'true' || json['seen'] == "1",

  );
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{

    "toUid": toUid,
    "uid": uid,
    "fromUid": fromUid,
    "chatUid": chatUid,
    "message": message,
    "date": date!.millisecondsSinceEpoch,
    "type" : type,
    "seen" : seen,

  };

  String getDbFields() {
    return "toUid, uid, fromUid, chatUid, messages, date, type, seen";
  }

  String getDbFieldsWithQuestionMark() {
    return "toUid = ?, uid = ?, fromUid = ?, chatUid = ?, messages = ?, date = ?, type = ?, seen = ?";
  }

  String get questionMarks => "?, ?, ?, ?, ?, ?, ?, ?";

  List getDbFormat() {
    return [
      toUid,
      uid,
      fromUid,
      chatUid,
      message,
      date!.millisecondsSinceEpoch,
      type,
      seen
    ];
  }

}