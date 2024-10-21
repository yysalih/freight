import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/controllers/load_controller.dart';
import 'package:kamyon/controllers/profile_controller.dart';
import 'package:kamyon/models/user_model.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../widgets/app_alert_dialogs_widget.dart';

class ContactsView extends ConsumerWidget {
  final UserModel currentUser;
  const ContactsView({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final profileNotifier = ref.watch(profileController.notifier);
    final loadNotifier = ref.watch(loadController.notifier);

    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          color: kWhite,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(languages[language]!["contacts"]!,
          style: const TextStyle(color: kWhite),),

        actions: [
          IconButton(
            color: kWhite,
            icon: const Icon(Icons.add),
            onPressed: () {
              showInputDialog(context: context,
                  title: languages[language]!["phone"]!,
                  hint: "+90 553 088 28 98",
                  actionButtonText: languages[language]!["save"]!,
                  onPressed: () {
                    loadNotifier.addNewPhoneNumberToUser(currentUser: currentUser);
                    Navigator.pop(context);
                  },
                  controller: loadNotifier.phoneController);
              },
          ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: currentUser.contactNumbers.length - 1,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(currentUser.contactNumbers[index], style: kCustomTextStyle,),
                IconButton(
                  onPressed: () {
                    profileNotifier.deleteContact(currentUser, context: context, contactToDelete: currentUser.contactNumbers[index]);
                  },
                  icon: const Icon(Icons.delete, color: kWhite,),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}
