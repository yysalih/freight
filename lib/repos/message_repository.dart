import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kamyon/models/message_model.dart';
import '../constants/app_constants.dart';

class MessageRepository {
  final String _uid;

  MessageRepository({String? uid})
      : _uid = uid ?? "";

  Future<MessageModel> getMessage() async {
    final response = await http.post(
      appUrl,
      body: {
        'singleQuery': "SELECT * FROM messages WHERE uid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      MessageModel messageModel = MessageModel().fromJson(data);
      debugPrint('MessageModel: $messageModel');

      if(data.toString().contains("error")) {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Error: ${response.reasonPhrase}');
      } else {
        return messageModel;
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      return MessageModel();
    }
    return MessageModel();
  }

  Future<List<MessageModel>> getCurrentUserChats() async {
    String fromUid = _uid.split("kamyon").first;
    String toUid = _uid.split("kamyon").last;

    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM loads WHERE from = '$fromUid' AND to = '$toUid' ORDER BY date",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        List<MessageModel> chats = data.map((e) => MessageModel().fromJson(e as Map<String, dynamic>)).toList();
        debugPrint('Messages Length: ${chats.length}');

        return chats;
      } else {
        debugPrint('Error: Unexpected data format');
        return [];
      }
    }
    else {
      debugPrint('Error: ${response.statusCode} : ${response.reasonPhrase}');
      return [];
    }
  }

}

final messageFutureProvider = FutureProvider.autoDispose.family<MessageModel, String?>((ref, uid) {
  final messageRepository = ref.watch(messageRepositoryProvider(uid));
  return messageRepository.getMessage();
});

final messagesFutureProvider = FutureProvider.autoDispose.family<List<MessageModel>, String?>((ref, uid) {
  final messageRepository = ref.watch(messageRepositoryProvider(uid));
  return messageRepository.getCurrentUserChats();
});


final messageRepositoryProvider = Provider.family<MessageRepository, String?>((ref, uid) {
  return MessageRepository(uid: uid);
});