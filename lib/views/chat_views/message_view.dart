import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/controllers/chat_controller.dart';
import 'package:kamyon/models/chat_model.dart';
import 'package:kamyon/repos/chat_repository.dart';
import 'package:kamyon/repos/message_repository.dart';
import 'package:kamyon/repos/user_repository.dart';
import 'package:kamyon/widgets/input_field_widget.dart';
import 'package:kamyon/widgets/warning_info_widget.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';

class MessageView extends ConsumerWidget {
  final ChatModel chatModel;
  const MessageView({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);


    final chatProvider = ref.watch(chatStreamProvider(chatModel.uid));
    final chatUserProvider = ref.watch(userFutureProvider(chatModel.toUid));

    final chatNotifier = ref.watch(chatController.notifier);

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          color: kWhite,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: chatUserProvider.when(
          data: (user) => Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20.h,
                backgroundImage: CachedNetworkImageProvider(user.image!),
              ),
              SizedBox(width: 10.w,),
              Text(user.name!, style: kCustomTextStyle,),
            ],
          ),
          loading: () => Container(),
          error: (error, stackTrace) => Container(),
        )
      ),
      body: chatProvider.when(
        data: (chat) => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //MessageStreamWidget(chatModel: chat,),
            Expanded(
              child: ListView.builder(
                itemCount: chatModel.allMessages.length,
                itemBuilder: (context, index) => MessageBubbleWidget(messageUid: chatModel.allMessages[index],),
              ),
            ),
            Container(
              width: width, height: height * .085,
              color: kLightBlack,
              child: Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: SizedBox(
                        width: width * .75, height: 45,
                        child: TextField(
                          style: kCustomTextStyle,
                          controller: chatNotifier.messageController,
                          decoration: kInputDecorationWithNoBorder.copyWith(

                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        chatNotifier.createMessage(context, to: chatModel.toUid!, errorTitle: languages[language]!["error_creating_chat"]!,
                            chatUid: chatModel.uid!);
                      },
                      icon: const Icon(Icons.send, color: Colors.lightBlueAccent,),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        error: (error, stackTrace) => const NoChatsFoundWidget(),
        loading: () => const NoChatsFoundWidget(),
      ),
    );
  }
}

class MessageStreamWidget extends StatelessWidget {
  final ChatModel chatModel;
  const MessageStreamWidget({super.key, required this.chatModel});

  @override
  Widget build(BuildContext context) {
    final messages = chatModel.allMessages;
    return ListView.builder(
      itemCount: chatModel.allMessages.length,
      itemBuilder: (context, index) => MessageBubbleWidget(messageUid: messages[index],),
    );
  }
}

class MessageBubbleWidget extends ConsumerWidget {
  final String messageUid;
  const MessageBubbleWidget({super.key, required this.messageUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final messageProvider = ref.watch(messageFutureProvider(messageUid));

    return messageProvider.when(
      data: (message) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          alignment: message.fromUid == currentUserUid ?
          Alignment.centerRight : Alignment.centerLeft,

          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(10),
              topRight: Radius.circular(1),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10)
            ),
            color: message.fromUid == currentUserUid ? kLightBlack : kBlueColor,
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(message.message!, style: kCustomTextStyle),
          ),
        ),
      ),
      loading: () => Container(),
      error: (error, stackTrace) {
        debugPrint(error.toString());
        debugPrint(stackTrace.toString());
        return Container();
      },
    );
  }
}

