import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/models/chat_model.dart';
import 'package:kamyon/repos/message_repository.dart';
import 'package:kamyon/repos/user_repository.dart';
import 'package:kamyon/views/chat_views/message_view.dart';
import 'package:kamyon/widgets/warning_info_widget.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../repos/chat_repository.dart';

class ChatsView extends ConsumerWidget {
  const ChatsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final chatsProvider = ref.watch(chatsStreamProvider(FirebaseAuth.instance.currentUser!.uid));

    return !isUserAnonymous() ? Padding(
      padding: EdgeInsets.only(top: 10.h, right: 15.w, left: 15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(languages[language]!["chats"]!,
            style: kTitleTextStyle.copyWith(color: kWhite),),
          chatsProvider.when(
            data: (chats) {

              if(chats.isEmpty) {
                return const NoChatsFoundWidget();
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: chats.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: ChatCardWidget(chat: chats[index],),
                  ),
                ),
              );
            },
            loading: () => const NoChatsFoundWidget(),
            error: (error, stackTrace) => const NoChatsFoundWidget(),
          ),
        ],
      ),
    ) : const NoAccountFound();
  }
}

class ChatCardWidget extends ConsumerWidget {
  final ChatModel chat;
  const ChatCardWidget({super.key, required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = MediaQuery.of(context).size.width;


    final toUserProvider = ref.watch(userFutureProvider(chat.toUid));
    debugPrint("${chat.messages}");
    final lastMessageProvider = ref.watch(messageFutureProvider(chat.allMessages.last));

    return toUserProvider.when(
      data: (user) => Column(
        children: [
          MaterialButton(

            onPressed: () {
              Navigator.push(context, routeToView(MessageView(chatModel: chat)));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(user.image!),
                    radius: 20.h,
                  ),
                  SizedBox(width: 10.w,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name!, style: kCustomTextStyle,),
                      lastMessageProvider.when(
                        data: (message) => Text(message.message!, style: kCustomTextStyle,),
                        loading: () => Container(),
                        error: (error, stackTrace) => Container(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
          padding: EdgeInsets.only(top: 5),
            child: Container(
              width: width * .9,
              height: 1,
              color: kLightBlack,
            ),
          ),
        ],
      ),
      loading: () => Container(),
      error: (error, stackTrace) => Container(),
    );
  }
}

