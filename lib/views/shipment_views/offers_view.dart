import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kamyon/controllers/offer_controller.dart';
import 'package:kamyon/models/offer_model.dart';
import 'package:kamyon/repos/offer_repository.dart';
import 'package:kamyon/repos/user_repository.dart';
import 'package:kamyon/views/shipment_views/offer_inner_view.dart';
import 'package:kamyon/widgets/warning_info_widget.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';

class OffersView extends ConsumerWidget {
  final String unitUid;
  const OffersView({super.key, required this.unitUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final offersStream = ref.watch(offersStreamProvider(unitUid));
    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          color: kWhite,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(languages[language]!["offers"]!,
          style: const TextStyle(color: kWhite),),


      ),

      body: SafeArea(
        child: offersStream.when(
          data: (offers) => ListView.builder(
            itemCount: offers.length,
            itemBuilder: (context, index) => offerWidget(offers[index], context: context, language: language),
          ),
          error: (error, stackTrace) => const NoOfferFound(),
          loading: () => loadingWidget(),
        ),
      ),

    );
  }
}

Widget offerWidget(OfferModel offer, {required String language, required BuildContext context}) {
  return Consumer(
    builder: (context, ref, child) {
      final offerNotifier = ref.watch(offerController.notifier);
      final offerOwnerProvider = ref.watch(userFutureProvider(offer.fromUid));
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: MaterialButton(
            color: kLightBlack,
            onPressed: () {
              Navigator.push(context, routeToView(OfferInnerView(offerUid: offer.uid!)));
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  offerOwnerProvider.when(
                    data: (offerOwner) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CircleAvatar(
                              backgroundImage: CachedNetworkImageProvider(offerOwner.image!),
                              radius: 25,
                            ),
                            SizedBox(width: 10.w,),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(offerOwner.name!, style: kTitleTextStyle.copyWith(color: kWhite),),
                                Text("${offer.price!} TL", style: kCustomTextStyle,),
                                Text("${languages[language]![offer.state!]}", style: kCustomTextStyle.copyWith(
                                  fontSize: 15, color: Colors.blue,
                                ),),
                              ],
                            ),

                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            offerNotifier.deleteOffer(offerUid: offer.uid!);
                          },
                          icon: const Icon(Icons.delete, size: 25, color: Colors.redAccent,),
                        )
                      ],
                    ),
                    error: (error, stackTrace) => Container(),
                    loading: () => Container(),
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(DateFormat('dd.MM.yyyy').format(offer.date!), style: kCustomTextStyle,),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
