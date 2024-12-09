import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kamyon/models/chat_model.dart';
import '../constants/app_constants.dart';

class ChatRepository {
  final String _uid;

  ChatRepository({String? uid})
      : _uid = uid ?? "";

  Future<ChatModel> getChat() async {
    final response = await http.post(
      appUrl,
      body: {
        'singleQuery': "SELECT * FROM chats WHERE uid = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      ChatModel chatModel = ChatModel().fromJson(data);
      debugPrint('ChatModel: $chatModel');

      if(data.toString().contains("error")) {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Error: ${response.reasonPhrase}');
      } else {
        return chatModel;
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      return ChatModel();
    }
    return ChatModel();
  }

  Future<List<ChatModel>> getCurrentUserChats() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM loads WHERE from = '$_uid' OR to = '$_uid'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        List<ChatModel> chats = data.map((e) => ChatModel().fromJson(e as Map<String, dynamic>)).toList();
        debugPrint('Chats Length: ${chats.length}');

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

  Future<List<ChatModel>> getAvailableChats() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM loads",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data is List) {
        List<ChatModel> loads = data.map((e) => ChatModel().fromJson(e as Map<String, dynamic>)).toList();
        debugPrint('Chats Length: ${loads.length}');

        return loads;
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

final chatFutureProvider = FutureProvider.autoDispose.family<ChatModel, String?>((ref, uid) {
  final chatRepository = ref.watch(chatRepositoryProvider(uid));
  return chatRepository.getChat();
});

final chatsFutureProvider = FutureProvider.autoDispose.family<List<ChatModel>, String?>((ref, uid) {
  final chatRepository = ref.watch(chatRepositoryProvider(uid));
  return chatRepository.getCurrentUserChats();
});

final availableChatsFutureProvider = FutureProvider.autoDispose.family<List<ChatModel>, String?>((ref, uid) {
  final chatRepository = ref.watch(chatRepositoryProvider(uid));
  return chatRepository.getAvailableChats();
});

final chatRepositoryProvider = Provider.family<ChatRepository, String?>((ref, uid) {
  return ChatRepository(uid: uid);
});