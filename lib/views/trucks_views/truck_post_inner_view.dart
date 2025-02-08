import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kamyon/constants/snackbars.dart';
import 'package:kamyon/repos/place_repository.dart';
import 'package:kamyon/repos/user_repository.dart';
import 'package:kamyon/widgets/app_alert_dialogs_widget.dart';
import 'package:kamyon/widgets/map_markers_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../controllers/chat_controller.dart';
import '../../controllers/truck_controller.dart';
import '../../repos/truck_posts_repository.dart';
import '../../repos/truck_repository.dart';
import '../../widgets/load_action_button.dart';
import '../../widgets/load_info_widget.dart';
import '../../widgets/offer_modal_bottom_sheet.dart';
import '../shipment_views/offers_view.dart';

class TruckPostInnerView extends ConsumerWidget {
  final String uid;
  const TruckPostInnerView({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final truckPostProvider = ref.watch(truckPostFutureProvider(uid));

    final truckNotifier = ref.watch(truckController.notifier);

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
        title: Text(languages[language]!["truck_post_details"]!,
          style: const TextStyle(color: kWhite),),
        actions: [
          truckPostProvider.when(
            data: (truckPost) {


              return truckPost.ownerUid == FirebaseAuth.instance.currentUser!.uid ?
              IconButton(
                onPressed: () {
                  showDeleteDialog(context: context, title: languages[language]!["delete_truck_post_title"]!,
                    content: languages[language]!["delete_load_content"]!,
                    onPressed: () {
                      truckNotifier.deleteTruckPost(truckPostUid: truckPost.uid!,);
                      Navigator.pop(context);
                      showSnackbar(context: context, title: languages[language]!["truck_post_deleted_succesfully"]!);
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
        child: SingleChildScrollView(
          child: truckPostProvider.when(
            data: (truckPost) {
              final ownerUser = ref.watch(userFutureProvider(truckPost.ownerUid!));
              final originProvider = ref.watch(placeFutureProvider(truckPost.origin!));
              final destinationProvider = ref.watch(placeFutureProvider(truckPost.destination!));

              final truckProvider = ref.watch(truckFutureProvider(truckPost.truckUid));
              return Column(
                children: [
                  SizedBox(
                    width: width, height: height * .25,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(truckPost.originLat!, truckPost.originLong!),
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
                            truckPostMarker(truckPost, context: context),
                          ],
                        )
                      ],
                    ),
                  ),
                  truckProvider.when(
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
                    error: (error, stackTrace) => Container(),
                    loading: () => Container(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 0.0.h, right: 15.w, left: 15.w),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                originProvider.when(
                                  data: (origin) => ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: width * .3),
                                    child: Text("${origin.name!}\n"
                                        "${DateFormat("dd.MM.yyyy").format(truckPost.startDate!)}",
                                      style: kCustomTextStyle, maxLines: 3, overflow: TextOverflow.ellipsis,),
                                  ),
                                  error: (error, stackTrace) => Text("İstanbul TR\n"
                                      "${DateFormat("dd.MM.yyyy").format(truckPost.startDate!)}",
                                    style: kCustomTextStyle,),
                                  loading: () => Text("İstanbul TR\n"
                                      "${DateFormat("dd.MM.yyyy").format(truckPost.startDate!)}",
                                    style: kCustomTextStyle,),
                                ),
                                //TODO Place name should be added just like in the AddTruckPostView (edit mode)
                                const Icon(Icons.fast_forward_sharp, color: kBlueColor,),

                                Icon(Icons.local_shipping, color: kWhite, size: 30.w,),

                                const Icon(Icons.fast_forward_sharp, color: kBlueColor,),
                                destinationProvider.when(
                                  data: (destination) => ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: width * .3),
                                    child: Text("${destination.name}\n${DateFormat("dd.MM.yyyy").format(truckPost.endDate!)}",

                                      style: kCustomTextStyle, maxLines: 3, overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,),
                                  ),
                                  loading: () => Text("Ankara TR\n${DateFormat("dd.MM.yyyy").format(truckPost.endDate!)}",

                                    style: kCustomTextStyle, textAlign: TextAlign.end,),
                                  error: (error, stackTrace) => Text("Ankara TR\n${DateFormat("dd.MM.yyyy").format(truckPost.endDate!)}",

                                    style: kCustomTextStyle, textAlign: TextAlign.end,),
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(languages[language]!["published_date"]!,
                                      style: kCustomTextStyle,),
                                    Text(DateFormat("dd.MM.yyyy").format(truckPost.createdDate!), style: kCustomTextStyle,),
                                  ],
                                ),
                                if(truckPost.ownerUid == FirebaseAuth.instance.currentUser!.uid && truckPost.state == "available")
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5),
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(context, routeToView(OffersView(unitUid: truckPost.uid!)));
                                        },
                                        child: Text(languages[language]!["show_offers"]!, style: kCustomTextStyle.copyWith(
                                            color: Colors.blue
                                        ),),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            loadActionButton(width, language, icon: Icons.monetization_on_rounded,
                              description2: "${truckPost.price}\$",
                              title: languages[language]!["propose"]!, description: "",
                              onPressed: () {
                                if(!isUserAnonymous()) {
                                  showModalBottomSheet(context: context, builder: (context) =>
                                      OfferModalBottomSheet(
                                        toUid: truckPost.ownerUid!,
                                        type: "truckPost",
                                        unitUid: truckPost.uid!,
                                      ),);
                                }
                                else {
                                  showWarningSnackbar(context: context, title: languages[language]!["you_need_a_profile"]!);
                                }
                              },),

                            loadActionButton(width, language, icon: Icons.chat_bubble,
                              description2: languages[language]!["now"]!,
                              title: languages[language]!["chat"]!, description: "",
                              onPressed: () {
                                if(!isUserAnonymous()) {
                                  chatNotifier.createChat(context, to: truckPost.ownerUid!, errorTitle: languages[language]!["error_creating_chat"]!);
                                }
                                else {
                                  showWarningSnackbar(context: context, title: languages[language]!["you_need_a_profile"]!);
                                }
                              },),


                            ownerUser.when(
                              data: (owner) => loadActionButton(width, language, icon: Icons.add_ic_call_rounded,
                                description2: "${truckPost.distance} KM",

                                title: languages[language]!["call"]!, description: "",
                                onPressed: () {
                                  if(!isUserAnonymous()) {
                                    launchUrlString("tel://${owner.phone!}");
                                  }
                                  else {
                                    showWarningSnackbar(context: context, title: languages[language]!["you_need_a_profile"]!);
                                  }
                                },
                              ),
                              error: (error, stackTrace) => Container(),

                              loading: () => Container(),
                            ),
                          ],
                        ),
                        SizedBox(height: 15.h,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(languages[language]!["shipping_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                            loadInfoWidget(width, height, title: languages[language]!["pick_up_date"]!,
                                description: DateFormat("dd.MM.yyyy").format(truckPost.startDate!)),
                            loadInfoWidget(width, height, title: languages[language]!["dock_date"]!,
                                description: DateFormat("dd.MM.yyyy").format(truckPost.endDate!)),
                            loadInfoWidget(width, height, title: languages[language]!["reference"]!,
                                description: "#1K00F9886"),

                            loadInfoWidget(width, height, title: languages[language]!["description"]!,
                                description: truckPost.description!),
                          ],
                        ),

                        SizedBox(height: 15.h,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(languages[language]!["rate_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                            loadInfoWidget(width, height, title: languages[language]!["total"]!,
                                description: "${truckPost.price} ₺"),
                            loadInfoWidget(width, height, title: languages[language]!["distance"]!,
                                description: "${truckPost.distance} KM"),
                            loadInfoWidget(width, height, title: languages[language]!["per_km"]!,
                                description: "${(truckPost.price! / truckPost.distance!).toStringAsFixed(2)} ₺"),
                          ],
                        ),
                        SizedBox(height: 15.h,),
                        ownerUser.when(
                          data: (owner) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(languages[language]!["user_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                              loadInfoWidget(width, height, title: languages[language]!["user_name"]!,
                                  description: owner.name!.toString()),
                              loadInfoWidget(width, height, title: languages[language]!["phone"]!,
                                  description: owner.phone!.toString()),
                              //loadInfoWidget(width, height, title: languages[language]!["location"]!, description: "Akdeniz Cd. No:31, 06570"),
                              loadInfoWidget(width, height, title: languages[language]!["rating"]!,
                                  description: "", language: language, point: owner.point!),
                            ],
                          ),
                          error: (error, stackTrace) => Container(),
                          loading: () => Container(),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: 15.h,),

                ],
              );
            },
            error: (error, stackTrace) => Container(),
            loading: () => Container(),
          ),
        ),
      ),
    );
  }
}

