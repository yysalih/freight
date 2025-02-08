import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/views/auth_views/login_view.dart';

import '../constants/languages.dart';
import '../constants/providers.dart';
import '../controllers/profile_controller.dart';

class NoLoadsFoundWidget extends ConsumerWidget {
  const NoLoadsFoundWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    return Text(languages[language]!["no_loads_found"]!, style: kCustomTextStyle,);
  }
}

class NoChatsFoundWidget extends ConsumerWidget {
  const NoChatsFoundWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    return Padding(
      padding: EdgeInsets.only(top: 10.0.h),
      child: Text(languages[language]!["no_chats_found"]!, style: kCustomTextStyle,),
    );
  }
}

class NoPlaceFound extends ConsumerWidget {
  const NoPlaceFound({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    return Padding(
      padding: EdgeInsets.only(top: 10.0.h),
      child: Text(languages[language]!["no_places_found"]!, style: kCustomTextStyle,),
    );
  }
}

class NoOfferFound extends ConsumerWidget {
  const NoOfferFound({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    return Padding(
      padding: EdgeInsets.only(top: 10.0.h),
      child: Text(languages[language]!["no_offer_found"]!, style: kCustomTextStyle,),
    );
  }
}

class NoShipmentFound extends ConsumerWidget {
  const NoShipmentFound({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    return Padding(
      padding: EdgeInsets.only(top: 10.0.h),
      child: Text(languages[language]!["no_shipment_found"]!, style: kCustomTextStyle,),
    );
  }
}

class NoAccountFound extends ConsumerWidget {
  const NoAccountFound({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);
    final profileNotifier = ref.watch(profileController.notifier);

    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 10.0.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(languages[language]!["you_need_a_profile"]!, style: kCustomTextStyle,),
            SizedBox(height: 10.h,),
            TextButton(
              child: Text(languages[language]!["sign_up"]!, style: kCustomTextStyle.copyWith(
                color: Colors.lightBlueAccent, fontSize: 20
              ),),
              onPressed: () {
                profileNotifier.logout(context);
                Navigator.pushAndRemoveUntil(context, routeToView(const LoginView()), (route) => false,);
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget loadingWidget() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

Widget errorText() => const Text("Error found.", style: kCustomTextStyle,);


