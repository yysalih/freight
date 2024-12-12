import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/constants/providers.dart';
import 'package:kamyon/models/chat_model.dart';
import 'package:kamyon/views/chat_views/message_view.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

import '../constants/app_constants.dart';
import '../constants/snackbars.dart';
import '../models/message_model.dart';

class ChatState {

}

class ChatController extends StateNotifier<ChatState> {
  ChatController(super.state);

  final messageController = TextEditingController();
  final scrollController = ScrollController();

  createChat(BuildContext context, {required String to, required String errorTitle}) async {
    String uid = "${FirebaseAuth.instance.currentUser!.uid}channel$to";


    final checkResponse = await http.post(
      appUrl,
      body: {
        'singleQuery': "SELECT * FROM chats WHERE uid = '$uid'",
      },
    );

    if (checkResponse.statusCode == 200) {
      var data = jsonDecode(checkResponse.body);
      if (!data.toString().contains("error")) {
        // Chat already exists
        debugPrint('Chat exists: $data');
        Navigator.push(
          context,
          routeToView(MessageView(chatModel: ChatModel().fromJson(data),)),
        );
        return;
      }
    } else {
      debugPrint('Error checking chat: ${checkResponse.statusCode}');
      debugPrint('Error: ${checkResponse.reasonPhrase}');
      showSnackbar(title: errorTitle, context: context);
      return;
    }

    ChatModel chatModel = ChatModel(
      uid: uid,
      fromUid: FirebaseAuth.instance.currentUser!.uid,
      lastCount: 0,
      messages: "first;",
      toUid: to,
    );

    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "INSERT INTO chats (${chatModel.getDbFields()}) VALUES (${chatModel.questionMarks})",
        "params": jsonEncode(chatModel.getDbFormat()),
      },
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var data = jsonDecode(response.body);
      debugPrint('Response: $data');
      Navigator.push(
        context,
        routeToView(MessageView(chatModel: ChatModel().fromJson(data),),),
      );

    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      showSnackbar(title: errorTitle, context: context);
    }
  }

  createMessage(BuildContext context, {required String to, required String errorTitle, required String chatUid}) async {

    String uid = const Uuid().v4();


    MessageModel messageModel = MessageModel(
      uid: uid,
      fromUid: FirebaseAuth.instance.currentUser!.uid,
      date: DateTime.now(),
      chatUid: chatUid,
      message: messageController.text,
      seen: false,
      type: "message",
      toUid: to,
    );

    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "INSERT INTO messages (${messageModel.getDbFields()}) VALUES (${messageModel.questionMarks})",
        "params": jsonEncode(messageModel.getDbFormat()),
      },
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var data = jsonDecode(response.body);
      debugPrint('Response: $data');


    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      showSnackbar(title: errorTitle, context: context);
    }

    messageController.clear();
    scrollToLast();
  }

  scrollToLast() {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

}

final chatController = StateNotifierProvider((ref) => ChatController(ChatState(

),),);