import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'base_model.dart';

@JsonSerializable()
@immutable
class ChatModel implements BaseModel<ChatModel> {

  final String? uid;
  final String? from;
  final String? to;
  final int? lastCount;
  final String? messages;


  ChatModel({this.uid, this.from,
    this.lastCount, this.to, this.messages
  });

  @override
  ChatModel fromJson(Map<String, dynamic> json) => ChatModel(
    to: json["to"] as String?,
    uid: json["uid"] as String?,
    from: json["from"] as String?,
    lastCount: json["lastCount"] == null ? 0 : int.parse(json["lastCount"].toString()),
    messages: json["contacts"] as String?,
  );
  @override
  Map<String, dynamic> toJson() => <String, dynamic>{

    "to": to,
    "uid": uid,
    "from": from,
    "lastCount": lastCount,
    "messages": messages,
  };

  String getDbFields() {
    return "to, uid, from, lastCount, messages";
  }

  String getDbFieldsWithQuestionMark() {
    return "to = ?, uid = ?, from = ?, lastCount = ?, messages = ?";
  }

  String get questionMarks => "?, ?, ?, ?, ?";

  List getDbFormat() {
    return [
      to,
      uid,
      from,
      lastCount,
      messages
    ];
  }

  List get allMessages => messages!.split(";");
}