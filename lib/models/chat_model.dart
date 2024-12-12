import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class ChatModel implements BaseModel<ChatModel> {

  final String? uid;
  final String? fromUid;
  final String? toUid;
  final int? lastCount;
  final String? messages;


  ChatModel({this.uid, this.fromUid,
    this.lastCount, this.toUid, this.messages
  });

  @override
  ChatModel fromJson(Map<String, dynamic> json) => ChatModel(
    toUid: json["toUid"] as String?,
    uid: json["uid"] as String?,
    fromUid: json["fromUid"] as String?,
    lastCount: json["lastCount"] == null ? 0 : int.parse(json["lastCount"].toString()),
    messages: json["contacts"] as String?,
  );
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{

    "toUid": toUid,
    "uid": uid,
    "fromUid": fromUid,
    "lastCount": lastCount,
    "messages": messages,
  };

  String getDbFields() {
    return "toUid, uid, fromUid, lastCount, messages";
  }

  String getDbFieldsWithQuestionMark() {
    return "toUid = ?, uid = ?, fromUid = ?, lastCount = ?, messages = ?";
  }

  String get questionMarks => "?, ?, ?, ?, ?";

  List getDbFormat() {
    return [
      toUid,
      uid,
      fromUid,
      lastCount,
      messages
    ];
  }

  List get allMessages => messages!.split(";");
}