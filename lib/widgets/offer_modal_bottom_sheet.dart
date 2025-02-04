import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/widgets/pick_truck_button_widget.dart';
import '../constants/app_constants.dart';
import '../constants/languages.dart';
import '../constants/providers.dart';
import '../controllers/offer_controller.dart';
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
                Text(languages[language]!["pick_truck"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                SizedBox(height: 3.h,),
                const PickTruckButton(),
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
            },)
          ],
        ),
      ),
    );
  }
}