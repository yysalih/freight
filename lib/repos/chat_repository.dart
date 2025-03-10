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

  Stream<ChatModel> getChatStream() async* {
    while (true) {
      try {
        final response = await http.post(
          appUrl,
          body: {
            'singleQuery': "SELECT * FROM chats WHERE uid = '$_uid'",
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (!data.toString().contains("error")) {
            yield ChatModel().fromJson(data);
          } else {
            debugPrint('Error: ${response.statusCode}');
          }
        } else {
          debugPrint('Error: ${response.statusCode}');
        }
      } catch (e) {
        debugPrint('Error fetching chat: $e');
      }

      // Wait before fetching the next update
      await Future.delayed(const Duration(seconds: 2));
    }
  }


  Future<List<ChatModel>> getCurrentUserChats() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM chats WHERE fromUid = '$_uid' OR toUid = '$_uid'",
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

  Stream<List<ChatModel>> getCurrentUserChatsStream() async* {
    while (true) {
      try {
        final response = await http.post(
          appUrl,
          body: {
            'multiQuery': "SELECT * FROM chats WHERE fromUid = '$_uid' OR toUid = '$_uid'",
          },
        );

        if (response.statusCode == 200) {
          var data = jsonDecode(response.body);
          if (data is List) {
            List<ChatModel> chats = data.map((e) => ChatModel().fromJson(e as Map<String, dynamic>)).toList();
            yield chats;
          } else {
            debugPrint('Error: Unexpected data format');
            yield [];
          }
        } else {
          debugPrint('Error: ${response.statusCode} : ${response.reasonPhrase}');
          yield [];
        }
      } catch (e) {
        debugPrint('Error fetching chats: $e');
        yield [];
      }

      // Add a delay to avoid rapid polling
      await Future.delayed(const Duration(seconds: 2));
    }
  }


  Future<List<ChatModel>> getAvailableChats() async {
    final response = await http.post(
      appUrl,
      body: {
        'multiQuery': "SELECT * FROM chats",
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

final chatStreamProvider = StreamProvider.autoDispose.family<ChatModel, String?>((ref, uid) {
  final chatRepository = ref.watch(chatRepositoryProvider(uid));
  return chatRepository.getChatStream();
});

final chatsStreamProvider = StreamProvider.autoDispose.family<List<ChatModel>, String?>((ref, uid) {
  final chatRepository = ref.watch(chatRepositoryProvider(uid));
  return chatRepository.getCurrentUserChatsStream();
});

final chatRepositoryProvider = Provider.family<ChatRepository, String?>((ref, uid) {
  return ChatRepository(uid: uid);
});