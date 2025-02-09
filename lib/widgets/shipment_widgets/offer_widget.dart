import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../controllers/offer_controller.dart';
import '../../models/offer_model.dart';
import '../../repos/user_repository.dart';
import '../../views/shipment_views/offer_inner_view.dart';

Widget offerWidget(OfferModel offer, {required String language, required BuildContext context}) {
  return Consumer(
    builder: (context, ref, child) {
      final offerNotifier = ref.watch(offerController.notifier);
      final offerOwnerProvider = ref.watch(userStreamProvider(offer.loadOwnerUid));
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
              padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                    child: Text(DateFormat('dd.MM.yyyy').format(DateTime.fromMillisecondsSinceEpoch(offer.date!)), style: kCustomTextStyle,),
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
