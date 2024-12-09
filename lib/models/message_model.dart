import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class MessageModel implements BaseModel<MessageModel> {

  final String? uid;
  final String? from;
  final String? to;
  final String? chatUid;
  final String? message;
  final DateTime? date;
  final String? type;
  final bool? seen;


  MessageModel({this.uid, this.from,
    this.chatUid, this.to, this.message, this.date,
    this.type, this.seen
  });

  @override
  MessageModel fromJson(Map<String, dynamic> json) => MessageModel(
    to: json["to"] as String?,
    uid: json["uid"] as String?,
    from: json["from"] as String?,
    chatUid: json["chatUid"] as String?,
    message: json["message"] as String?,
    date: DateTime.fromMillisecondsSinceEpoch(int.parse(json["date"])),
    type: json["type"] as String?,
    seen: json['seen'] == 'true' || json['seen'] == "1",

  );
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{

    "to": to,
    "uid": uid,
    "from": from,
    "chatUid": chatUid,
    "message": message,
    "date": date!.millisecondsSinceEpoch,
    "type" : type,
    "seen" : seen,

  };

  String getDbFields() {
    return "to, uid, from, chatUid, messages, date, type, seen";
  }

  String getDbFieldsWithQuestionMark() {
    return "to = ?, uid = ?, from = ?, chatUid = ?, messages = ?, date = ?, type = ?, seen = ?";
  }

  String get questionMarks => "?, ?, ?, ?, ?, ?, ?, ?";

  List getDbFormat() {
    return [
      to,
      uid,
      from,
      chatUid,
      message,
      date,
      type,
      seen
    ];
  }

}