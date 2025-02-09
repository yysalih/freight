import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/controllers/load_controller.dart';
import 'package:kamyon/controllers/offer_controller.dart';
import 'package:kamyon/controllers/shipment_controller.dart';
import 'package:kamyon/repos/offer_repository.dart';
import 'package:kamyon/repos/user_repository.dart';
import 'package:kamyon/widgets/shipment_widgets/shipment_state_modal_bottom_sheet.dart';
import 'package:kamyon/widgets/warning_info_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../constants/snackbars.dart';
import '../../controllers/chat_controller.dart';
import '../../models/load_model.dart';
import '../../repos/load_repository.dart';
import '../../repos/place_repository.dart';
import '../../repos/shipment_repository.dart';
import '../../repos/truck_repository.dart';
import '../../services/notification_service.dart';
import '../../widgets/app_alert_dialogs_widget.dart';
import '../../widgets/custom_button_widget.dart';
import '../../widgets/load_info_widget.dart';
import '../../widgets/map_markers_widget.dart';
import '../../widgets/search_result_widget.dart';
import '../loads_views/load_inner_view.dart';

class ShipmentInnerView extends ConsumerWidget {
  final String shipmentUid;
  const ShipmentInnerView({super.key, required this.shipmentUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final shipmentProvider = ref.watch(shipmentStreamProvider(shipmentUid));
    final shipmentNotifier = ref.watch(shipmentController.notifier);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final chatNotifier = ref.watch(chatController.notifier);


    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          color: kWhite,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(languages[language]!["shipment_details"]!,
          style: const TextStyle(color: kWhite),),

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: shipmentProvider.when(
            data: (shipment) {

              final truckProvider = ref.watch(truckStreamProvider(shipment.truckUid));
              final carrierProvider = ref.watch(userStreamProvider(shipment.carrierUid));
              final loadOwnerProvider = ref.watch(userStreamProvider(shipment.loadOwnerUid));
              final loadProvider = ref.watch(loadStreamProvider(shipment.unitUid));
              return loadProvider.when(
                data: (load) {
                  return carrierProvider.when(
                    data: (carrier) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width, height: height * .25,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: LatLng(shipment.lastLatitudeOfFreight!, shipment.lastLongitudeOfFreight!),
                              initialZoom: 9.2,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.kamyon',
                                maxNativeZoom: 19,
                              ),
                              RichAttributionWidget(
                                attributions: [
                                  TextSourceAttribution(
                                    'OpenStreetMap contributors',
                                    onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                                  ),
                                ],
                              ),
                              MarkerLayer(
                                markers: [
                                  shipmentMarker(shipment, context: context),
                                ],
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(15.w),
                          child: Column(
                            children: [
                              if(FirebaseAuth.instance.currentUser!.uid == shipment.carrierUid) ...[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(languages[language]!["update_shipment_state"]!, style: kTitleTextStyle.copyWith(
                                        color: kWhite
                                    ),),
                                    const SizedBox(height: 5,),
                                    Container(
                                        width: width, height: 40.h,
                                        decoration: BoxDecoration(
                                            color: kLightBlack,
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: MaterialButton(
                                            onPressed: () {
                                              if(shipment.state != "completed") {
                                                showModalBottomSheet(context: context, builder: (context) =>
                                                    ShipmentStateModalBottomSheet(shipmentUid: shipmentUid),);
                                              }
                                            },
                                            color: kLightBlack,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(languages[language]![shipment.state!]!,
                                                  style: kCustomTextStyle,),
                                                Icon(Icons.arrow_downward, color: kWhite,)
                                              ],
                                            ),
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10.h,),
                              ],
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(languages[language]!["carrier"]!, style: kTitleTextStyle.copyWith(
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
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              CircleAvatar(
                                                radius: 30.w,
                                                backgroundColor: kBlack,
                                                backgroundImage: CachedNetworkImageProvider(carrier.image!),
                                              ),
                                              const SizedBox(width: 15,),
                                              ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: width * .45),
                                                  child: Text("${carrier.name}\n${carrier.email}",
                                                    style: kCustomTextStyle,)),
                                            ],
                                          ),
                                          if(carrier.uid != FirebaseAuth.instance.currentUser!.uid) Row(
                                            children: [
                                              IconButton(
                                                splashColor: kBlueColor,
                                                splashRadius: 30,
                                                onPressed: () {
                                                  launchUrlString("tel://${carrier.phone!}");
                                                },
                                                icon: const Icon(Icons.call, color: kWhite,),
                                              ),
                                              IconButton(
                                                splashColor: kBlueColor,
                                                splashRadius: 30,
                                                onPressed: () {
                                                  chatNotifier.createChat(context, to: shipment.loadOwnerUid!,
                                                      errorTitle: languages[language]!["error_creating_chat"]!);
                                                },
                                                icon: const Icon(Icons.chat_bubble, color: kWhite,),
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(languages[language]!["load_owner"]!, style: kTitleTextStyle.copyWith(
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
                                      child: loadOwnerProvider.when(
                                        data: (loadOwner) => Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 30.w,
                                                  backgroundColor: kBlack,
                                                  backgroundImage: CachedNetworkImageProvider(loadOwner.image!),
                                                ),
                                                const SizedBox(width: 15,),
                                                ConstrainedBox(
                                                    constraints: BoxConstraints(maxWidth: width * .45),
                                                    child: Text("${loadOwner.name}\n${loadOwner.email}",
                                                      style: kCustomTextStyle,)),
                                              ],
                                            ),
                                            if(loadOwner.uid != FirebaseAuth.instance.currentUser!.uid) Row(
                                              children: [
                                                IconButton(
                                                  splashColor: kBlueColor,
                                                  splashRadius: 30,
                                                  onPressed: () {
                                                    launchUrlString("tel://${loadOwner.phone!}");
                                                  },
                                                  icon: const Icon(Icons.call, color: kWhite,),
                                                ),
                                                IconButton(
                                                  splashColor: kBlueColor,
                                                  splashRadius: 30,
                                                  onPressed: () {
                                                    chatNotifier.createChat(context, to: shipment.loadOwnerUid!,
                                                        errorTitle: languages[language]!["error_creating_chat"]!);
                                                  },
                                                  icon: const Icon(Icons.chat_bubble, color: kWhite,),
                                                ),
                                              ],
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


                              SizedBox(height: 10.h,),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(languages[language]!["details"]!, style: kTitleTextStyle.copyWith(
                                      color: kWhite
                                  ),),
                                  loadInfoWidget(width, height, title: languages[language]!["state"]!,
                                      description: languages[language]![shipment.state!]!,
                                      multiLineDescription: true, descriptionFontSize: 15),
                                  loadInfoWidget(width, height, title: languages[language]!["price"]!,
                                      description: "${shipment.price} ₺", descriptionFontSize: 20),
                                  SizedBox(height: 20.h,),
                                  truckProvider.when(
                                    data: (truck) => Container(
                                      width: width,
                                      decoration: BoxDecoration(
                                          color: kLightBlack,
                                          borderRadius: BorderRadius.circular(10.h)
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: 10.0.h, vertical: 20.h),
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
                                    error: (error, stackTrace) {
                                      debugPrint(error.toString());
                                      debugPrint(stackTrace.toString());
                                      return Container();
                                    },
                                    loading: () => Container(),
                                  ),
                                  const SizedBox(height: 10,),
                                  Padding(
                                    padding: EdgeInsets.only(top: 15.0.h),
                                    child: searchResultWidget(width, height, language, load: load,
                                      onPressed: () {
                                        Navigator.push(context, routeToView(LoadInnerView(uid: load.uid!)));
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20.h,),

                              if(shipment.state == "canceled") Row(
                                children: [
                                  const Icon(Icons.close, color: Colors.redAccent,),
                                  SizedBox(width: 5.w,),
                                  Text(languages[language]!["this_shipment_is_canceled"]!, style: kCustomTextStyle.copyWith(
                                      color: Colors.redAccent
                                  ),),
                                ],
                              ) else if(shipment.state == "completed") Row(
                                children: [
                                  const Icon(Icons.done, color: Colors.green,),
                                  SizedBox(width: 5.w,),
                                  Text(languages[language]!["this_shipment_is_completed"]!, style: kCustomTextStyle.copyWith(
                                      color: Colors.green
                                  ),),
                                ],
                              )
                              else if(FirebaseAuth.instance.currentUser!.uid != shipment.carrierUid) Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: width * .43,
                                      child: customButton(title: languages[language]!["cancel"]!, onPressed: () {
                                        shipmentNotifier.updateShipmentState(context, shipmentUid: shipmentUid,
                                            newState: "canceled",
                                            errorTitle: languages[language]!["error_cancel_shipment"]!,
                                            successTitle: languages[language]!["success_cancel_shipment"]!);

                                        NotificationService().sendPushMessage(
                                            title: "${load.originName} - ${load.destinationName}",
                                            body: languages[language]!["shipment_canceled_body"]!,
                                            token: carrier.token!, type: "shipment", uid: shipment.uid!);

                                        Navigator.pop(context);

                                      }, color: Colors.redAccent),
                                    ),
                                    SizedBox(
                                      width: width * .43,
                                      child: customButton(title: languages[language]!["complete"]!, onPressed: () {
                                        shipmentNotifier.updateShipmentState(context, shipmentUid: shipmentUid,
                                            newState: "completed",
                                            errorTitle: languages[language]!["error_complete_shipment"]!,
                                            successTitle: languages[language]!["success_complete_shipment"]!);

                                        NotificationService().sendPushMessage(
                                            title: "${load.originName} - ${load.destinationName}",
                                            body: languages[language]!["shipment_completed_body"]!,
                                            token: carrier.token!, type: "shipment", uid: shipment.uid!);


                                        Navigator.pop(context);
                                      }, color: Colors.green),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),

                      ],
                    ),
                    loading: () => Container(),
                    error: (error, stackTrace) => Container(),

                  );
                },

                loading: () => Container(),
                error: (error, stackTrace) => Container(),
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
