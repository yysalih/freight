import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatState {

}

class ChatController extends StateNotifier<ChatState> {
  ChatController(super.state);

  createChat({required String to}) {

  }

}

final chatController = StateNotifierProvider((ref) => ChatController(ChatState(

),),);