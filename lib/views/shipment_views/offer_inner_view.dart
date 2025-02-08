import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/controllers/load_controller.dart';
import 'package:kamyon/controllers/offer_controller.dart';
import 'package:kamyon/controllers/shipment_controller.dart';
import 'package:kamyon/repos/offer_repository.dart';
import 'package:kamyon/repos/user_repository.dart';
import 'package:kamyon/widgets/warning_info_widget.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../constants/snackbars.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/truck_controller.dart';
import '../../repos/load_repository.dart';
import '../../repos/place_repository.dart';
import '../../repos/truck_posts_repository.dart';
import '../../repos/truck_repository.dart';
import '../../services/notification_service.dart';
import '../../widgets/app_alert_dialogs_widget.dart';
import '../../widgets/custom_button_widget.dart';
import '../../widgets/load_info_widget.dart';
import '../../widgets/search_result_widget.dart';
import '../loads_views/load_inner_view.dart';

class OfferInnerView extends ConsumerWidget {
  final String offerUid;
  const OfferInnerView({super.key, required this.offerUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final offerProvider = ref.watch(offerStreamProvider(offerUid));
    final offerNotifier = ref.watch(offerController.notifier);
    final loadNotifier = ref.watch(loadController.notifier);
    final truckNotifier = ref.watch(truckController.notifier);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final chatNotifier = ref.watch(chatController.notifier);
    final shipmentNotifier = ref.watch(shipmentController.notifier);


    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          color: kWhite,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(languages[language]!["offer_details"]!,
          style: const TextStyle(color: kWhite),),
        actions: [
          offerProvider.when(
            data: (offer) {


              return offer.loadOwnerUid == FirebaseAuth.instance.currentUser!.uid ?
              IconButton(
                onPressed: () {
                  showDeleteDialog(context: context, title: languages[language]!["delete_offer_title"]!,
                    content: languages[language]!["delete_offer_content"]!,
                    onPressed: () {
                      offerNotifier.deleteOffer(offerUid: offer.uid!,);
                      Navigator.pop(context);
                      showSnackbar(context: context, title: languages[language]!["offer_deleted_succesfully"]!);
                    },);

                },
                icon: const Icon(Icons.delete, color: kWhite,),
              ) : Container();

            },
            loading: () => Container(),
            error: (error, stackTrace) => Container(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: offerProvider.when(
            data: (offer) {
              final truckProvider = ref.watch(truckFutureProvider(offer.truckUid));
              final loadProvider = ref.watch(loadFutureProvider(offer.unitUid));
              final offerOwnerProvider = ref.watch(userFutureProvider(offer.loadOwnerUid));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(languages[language]!["who_sent"]!, style: kTitleTextStyle.copyWith(
                          color: kWhite
                      ),),
                      const SizedBox(height: 5,),
                      Container(
                        decoration: BoxDecoration(
                            color: kLightBlack,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: offerOwnerProvider.when(
                            data: (offerOwner) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 30.w,
                                      backgroundColor: kBlack,
                                      backgroundImage: CachedNetworkImageProvider(offerOwner.image!),
                                    ),
                                    const SizedBox(width: 15,),
                                    Text("${offerOwner.name}\n${offerOwner.email}", style: kCustomTextStyle,),
                                  ],
                                ),
                                IconButton(
                                  splashColor: kLightBlack,
                                  splashRadius: 30,
                                  onPressed: () {
                                    chatNotifier.createChat(context, to: offer.loadOwnerUid!,
                                        errorTitle: languages[language]!["error_creating_chat"]!);
                                  },
                                  icon: const Icon(Icons.chat_bubble, color: kWhite,),
                                ),
                              ],
                            ),
                            loading: () => Container(),
                            error: (error, stackTrace) => Container(),

                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(languages[language]!["offer_details"]!, style: kTitleTextStyle.copyWith(
                          color: kWhite
                      ),),
                      const SizedBox(height: 5,),
                      loadInfoWidget(width, height, title: languages[language]!["price"]!,
                          description: "${offer.price} ₺", descriptionFontSize: 20),
                      SizedBox(height: 20.h,),
                      if(offer.type == "load") truckProvider.when(
                        data: (truck) => Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Container(
                            width: width,
                            decoration: BoxDecoration(
                                color: kLightBlack,
                                borderRadius: BorderRadius.circular(10.h)
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.0.h, vertical: 25.h),
                              child: Row(
                                children: [
                                  Icon(Icons.local_shipping, color: kBlueColor, size: 40.h,),
                                  SizedBox(width: 20.w,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(truck.name!, style: kTitleTextStyle.copyWith(color: kWhite),),
                                      SizedBox(height: 5.h,),
                                      Row(
                                        children: [
                                          for(int i = 0; i < 3; i++)
                                            Padding(
                                              padding: const EdgeInsets.only(right: 5.0),
                                              child: Container(
                                                height: 20.h,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: kWhite,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                  child: Center(
                                                    child: Text(["${truck.length} mt", "${truck.weight} kg", "${languages[language]![truck.isPartial! ? "partial" : "full"]}"][i],
                                                      style: kCustomTextStyle.copyWith(fontSize: 11.w, color: kLightBlack),),
                                                  ),
                                                ),
                                              ),
                                            )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        error: (error, stackTrace) {
                          debugPrint(error.toString());
                          debugPrint(stackTrace.toString());
                          return Container();
                        },
                        loading: () => Container(),
                      ) else loadProvider.when(
                        data: (load) {

                          return Padding(
                            padding: EdgeInsets.only(top: 15.0.h),
                            child: searchResultWidget(width, height, language, load: load,

                              onPressed: () {
                                Navigator.push(context, routeToView(LoadInnerView(uid: load.uid!)));
                              },
                            ),
                          );
                        },

                        loading: () => Container(),
                        error: (error, stackTrace) => Container(),
                      ),
                      const SizedBox(height: 10,),
                      loadInfoWidget(width, height, title: languages[language]!["description"]!,
                          description: offer.description!,
                          multiLineDescription: true, descriptionFontSize: 15),
                    ],
                  ),

                  if(offer.state == "rejected") Row(
                    children: [
                      const Icon(Icons.close, color: Colors.redAccent,),
                      SizedBox(width: 5.w,),
                      Text(languages[language]!["you_have_rejected_this_offer"]!, style: kCustomTextStyle.copyWith(
                        color: Colors.redAccent
                      ),),
                    ],
                  ) else if(offer.state == "accepted") Row(
                    children: [
                      const Icon(Icons.done, color: Colors.green,),
                      SizedBox(width: 5.w,),
                      Text(languages[language]!["you_have_accepted_this_offer"]!, style: kCustomTextStyle.copyWith(
                          color: Colors.green
                      ),),
                    ],
                  )  else Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * .42,
                        child: customButton(title: languages[language]!["confirm"]!, color: kGreen, onPressed: () async {
                          await offerNotifier.updateOfferState(context, offerUid: offerUid,
                              newState: "accepted",
                              errorTitle: languages[language]!["error_accept_offer"]!,
                              successTitle: languages[language]!["success_accept_offer"]!);

                          if(offer.type == "load") {
                            await loadNotifier.updateLoadState(context, loadUid: offer.unitUid!, newState: "accepted",);
                            //TODO send notification to carrier
                            final loadProvider = ref.read(loadFutureProvider(offer.unitUid!));
                            loadProvider.when(
                                data: (load) {
                                  NotificationService.sendPushMessage(
                                      title: language == "tr" ? "${load.originName} - ${load.destinationName} ${languages[language]!["offer_accepted_load_title"]!}"
                                          : "${languages[language]!["offer_accepted_load_title"]!} ${load.originName} - ${load.destinationName} ",
                                      body: languages[language]!["offer_accepted_body"]!,
                                      token: offer.carrierUid!, type: "offer_load",
                                      uid: offer.unitUid!);
                                },
                                error: (error, stackTrace) {}, loading: () {});

                          }
                          else {
                            await truckNotifier.updateTruckPostState(context, truckPostUid: offer.unitUid!, newState: "accepted",);
                            //TODO send notification to load owner
                            final truckPostProvider = ref.read(truckPostFutureProvider(offer.unitUid!));
                            truckPostProvider.when(
                              data: (truckPost) {
                                NotificationService.sendPushMessage(
                                    title: language == "tr" ? "${truckPost.originName} - ${truckPost.destinationName} ${languages[language]!["offer_accepted_truck_title"]!}"
                                        : "${languages[language]!["offer_accepted_truck_title"]!} ${truckPost.originName} - ${truckPost.destinationName} ",
                                    body: languages[language]!["offer_accepted_body"]!,
                                    token: offer.loadOwnerUid!, type: "offer_truck",
                                    uid: offer.unitUid!);
                              },
                              error: (error, stackTrace) {}, loading: () {},
                            );
                          }

                          await shipmentNotifier.createShipment(context,
                              type: "load", unitUid: offer.unitUid!, toUid: offer.carrierUid!,
                              price: offer.price!, truckUid: offer.truckUid!,
                              errorTitle: languages[language]!["success_creating_shipment"]!,
                              successTitle: languages[language]!["error_creating_offer"]!);

                        },),
                      ),
                      SizedBox(
                        width: width * .42,
                        child: customButton(title: languages[language]!["reject"]!, color: Colors.redAccent,
                          onPressed: () {
                            offerNotifier.updateOfferState(context, offerUid: offerUid,
                                newState: "rejected",
                                errorTitle: languages[language]!["error_reject_offer"]!,
                                successTitle: languages[language]!["success_reject_offer"]!);
                            //loadNotifier.updateLoadState(context, loadUid: offer.unitUid!, newState: "accepted",);

                          },),
                      ),
                    ],
                  ),
                ],
              );
            },
            loading: () => loadingWidget(),
            error: (error, stackTrace) => const NoOfferFound(),
          ),
        ),
      ),
    );
  }
}
