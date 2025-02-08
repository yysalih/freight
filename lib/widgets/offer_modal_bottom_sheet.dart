import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/repos/load_repository.dart';
import 'package:kamyon/widgets/pick_load_button_widget.dart';
import 'package:kamyon/widgets/pick_truck_button_widget.dart';
import '../constants/app_constants.dart';
import '../constants/languages.dart';
import '../constants/providers.dart';
import '../controllers/offer_controller.dart';
import '../repos/truck_posts_repository.dart';
import '../services/notification_service.dart';
import 'custom_button_widget.dart';
import 'input_field_widget.dart';

class OfferModalBottomSheet extends ConsumerWidget {
  final String toUid;
  final String unitUid;
  final String type;
  const OfferModalBottomSheet({super.key, required this.toUid, required this.unitUid, required this.type,});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final offerNotifier = ref.watch(offerController.notifier);

    final language = ref.watch(languageStateProvider);



    return Container(
      decoration: const BoxDecoration(
        color: kBlack,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(languages[language]![type == "load" ? "pick_truck" : "pick_load"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                SizedBox(height: 3.h,),
                type == "load" ? const PickTruckButton() : const PickLoadButton(),
              ],
            ),
            SizedBox(height: 10.h,),
            customInputField(title: languages[language]!["price"]!,
              hintText: languages[language]!["enter_price"]!,
              icon: Icons.monetization_on, onTap: () {
            }, controller: offerNotifier.priceController, onChanged: (value) {

            },),
            SizedBox(height: 20.h,),
            customInputField(title: languages[language]!["description"]!,
              hintText: languages[language]!["enter_description"]!,
              icon: Icons.description, onTap: () {

              }, controller: offerNotifier.descriptionController, onChanged: (value) {

              },),
            SizedBox(height: 20.h,),

            customButton(title: languages[language]!["confirm"]!, onPressed: () async {
              offerNotifier.createOffer(context, type: type, unitUid: unitUid, toUid: toUid,
                  errorTitle: languages[language]!["error_creating_offer"]!,
                  successTitle: languages[language]!["success_creating_offer"]!);

              if(type == "load") {
                final loadProvider = ref.read(loadFutureProvider(unitUid));
                loadProvider.when(
                  data: (load) {
                    NotificationService.sendPushMessage(
                        title: language == "tr" ? "${load.originName} - ${load.destinationName} ${languages[language]!["offer_accepted_load_title"]!}"
                        : "${languages[language]!["offer_accepted_load_title"]!} ${load.originName} - ${load.destinationName} ",
                        body: languages[language]!["offer_accepted_body"]!,
                        token: toUid, type: "offer_load",
                        uid: unitUid);
                  },
                  error: (error, stackTrace) {}, loading: () {},
                );
              }
              else {
                final truckPostProvider = ref.read(truckPostFutureProvider(unitUid));
                truckPostProvider.when(
                  data: (truckPost) {
                    NotificationService.sendPushMessage(
                        title: language == "tr" ? "${truckPost.originName} - ${truckPost.destinationName} ${languages[language]!["offer_accepted_truck_title"]!}"
                            : "${languages[language]!["offer_accepted_truck_title"]!} ${truckPost.originName} - ${truckPost.destinationName} ",
                        body: languages[language]!["offer_accepted_body"]!,
                        token: toUid, type: "offer_truck",
                        uid: unitUid);
                  },
                  error: (error, stackTrace) {}, loading: () {},
                );
              }


            },)
          ],
        ),
      ),
    );
  }
}