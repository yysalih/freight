import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kamyon/constants/snackbars.dart';
import 'package:kamyon/controllers/chat_controller.dart';
import 'package:kamyon/controllers/load_controller.dart';
import 'package:kamyon/controllers/place_controller.dart';
import 'package:kamyon/repos/load_repository.dart';
import 'package:kamyon/repos/place_repository.dart';
import 'package:kamyon/repos/user_repository.dart';
import 'package:kamyon/views/shipment_views/offers_view.dart';
import 'package:kamyon/widgets/app_alert_dialogs_widget.dart';
import 'package:kamyon/widgets/map_markers_widget.dart';
import 'package:kamyon/widgets/offer_modal_bottom_sheet.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../widgets/load_action_button.dart';
import '../../widgets/load_info_widget.dart';
import '../../widgets/warning_info_widget.dart';

class LoadInnerView extends ConsumerWidget {
  final String uid;
  const LoadInnerView({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final loadProvider = ref.watch(loadFutureProvider(uid));

    final loadNotifier = ref.watch(loadController.notifier);

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
        title: Text(languages[language]!["load_details"]!,
          style: const TextStyle(color: kWhite),),
        actions: [
          loadProvider.when(
            data: (load) {


              return load.ownerUid == FirebaseAuth.instance.currentUser!.uid ?
              IconButton(
                onPressed: () {
                  showDeleteDialog(context: context, title: languages[language]!["delete_load_title"]!,
                    content: languages[language]!["delete_load_content"]!,
                    onPressed: () {
                      loadNotifier.deleteLoad(loadUid: load.uid!,);
                      Navigator.pop(context);
                      showSnackbar(context: context, title: languages[language]!["load_deleted_succesfully"]!);
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
          child: loadProvider.when(
            data: (load) {
              final ownerUser = ref.watch(userFutureProvider(load.ownerUid!));
              final originProvider = ref.watch(placeFutureProvider(load.origin!));
              final destinationProvider = ref.watch(placeFutureProvider(load.destination!));
              return Column(
                children: [
                  SizedBox(
                    width: width, height: height * .25,
                    child: FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(load.originLat!, load.originLong!),
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
                            loadMarker(load, context: context),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15.0.h, right: 15.w, left: 15.w),
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
                                        "${DateFormat("dd.MM.yyyy").format(load.startDate!)}",
                                      style: kCustomTextStyle, maxLines: 3, overflow: TextOverflow.ellipsis,),
                                  ),
                                  error: (error, stackTrace) => errorText(),
                                  loading: () => Container(),
                                ),
                                //TODO Place name should be added just like in the AddTruckPostView (edit mode)
                                const Icon(Icons.fast_forward_sharp, color: kBlueColor,),

                                Icon(Icons.local_shipping, color: kWhite, size: 30.w,),

                                const Icon(Icons.fast_forward_sharp, color: kBlueColor,),
                                destinationProvider.when(
                                  data: (destination) => ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: width * .3),
                                    child: Text("${destination.name}\n${DateFormat("dd.MM.yyyy").format(load.endDate!)}",

                                      style: kCustomTextStyle, maxLines: 3, overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.end,),
                                  ),
                                  loading: () => Container(),
                                  error: (error, stackTrace) => errorText(),
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
                                                  child: Text(["${load.length} mt", "${load.weight} kg", "${languages[language]![load.isPartial! ? "partial" : "full"]}"][i], style: kCustomTextStyle.copyWith(fontSize: 11.w, color: kLightBlack),),
                                                ), //TODO Tags should be added just like in the AddTruckPostView (edit mode)

                                              ),
                                            ),
                                          )
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(languages[language]!["published_date"]!,
                                      style: kCustomTextStyle,),
                                    Text(DateFormat("dd.MM.yyyy").format(load.createdDate!), style: kCustomTextStyle,),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        if(load.ownerUid == FirebaseAuth.instance.currentUser!.uid) Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(context, routeToView(OffersView(unitUid: load.uid!)));
                              },
                              child: Text(languages[language]!["show_offers"]!, style: kCustomTextStyle.copyWith(
                                color: Colors.blue
                              ),),
                            ),
                          ),
                        ) else SizedBox(height: 15.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            loadActionButton(width, language, icon: Icons.monetization_on_rounded,
                                description2: "${load.price}\$",
                                title: languages[language]!["take_the_job"]!, description: "",
                            onPressed: () {
                              showModalBottomSheet(context: context, builder: (context) =>
                                  OfferModalBottomSheet(
                                    toUid: load.ownerUid!,
                                    type: "load",
                                    unitUid: load.uid!,
                                  ),);
                            },),

                            loadActionButton(width, language, icon: Icons.chat_bubble,
                                description2: languages[language]!["now"]!,
                                title: languages[language]!["chat"]!, description: "",
                            onPressed: () {
                              chatNotifier.createChat(context, to: load.ownerUid!, errorTitle: languages[language]!["error_creating_chat"]!);
                            },),


                            ownerUser.when(
                              data: (owner) => loadActionButton(width, language, icon: Icons.add_ic_call_rounded,
                                description2: "${load.distance} KM",

                                title: languages[language]!["call"]!, description: "",
                                onPressed: () {
                                  launchUrlString("tel://${owner.phone!}");
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
                            Text(languages[language]!["vehicle_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                            loadInfoWidget(width, height, title: languages[language]!["full_partial"]!,
                                description: load.isPartial! ?
                                languages[language]!["partial"]! : languages[language]!["full"]!),
                            /*loadInfoWidget(width, height, title: languages[language]!["vehicle_type"]!,
                              description: languages[language]![load.truckType]!),*/
                            loadInfoWidget(width, height, title: languages[language]!["length"]!,
                                description: "${load.length} MT"),
                            loadInfoWidget(width, height, title: languages[language]!["weight"]!,
                                description: "${load.weight} KG"),

                          ],
                        ),
                        SizedBox(height: 15.h,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(languages[language]!["shipping_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                            loadInfoWidget(width, height, title: languages[language]!["pick_up_date"]!,
                                description: "${DateFormat("dd.MM.yyyy").format(load.startDate!)}, ${load.startHour}"),
                            loadInfoWidget(width, height, title: languages[language]!["dock_date"]!,
                                description: "${DateFormat("dd.MM.yyyy").format(load.endDate!)}, ${load.endHour}"),
                            loadInfoWidget(width, height, title: languages[language]!["reference"]!,
                                description: "#1K00F9886"),

                            loadInfoWidget(width, height, title: languages[language]!["description"]!,
                                description: load.description!),
                          ],
                        ),
                        /*SizedBox(height: 15.h,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(languages[language]!["load_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),

                          loadInfoWidget(width, height, title: languages[language]!["shipping_type"]!,
                              description: load.loadType!),
                          loadInfoWidget(width, height, title: languages[language]!["load_type"]!,
                              description: load.isPalletized! ? languages[language]!["palletized"]! :
                              languages[language]!["bulk"]!),
                          loadInfoWidget(width, height, title: languages[language]!["load_volume"]!,
                              description: "${load.volume} m3"),
                        ],
                      ),*/
                        SizedBox(height: 15.h,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(languages[language]!["rate_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                            loadInfoWidget(width, height, title: languages[language]!["total"]!,
                                description: "${load.price} ₺"),
                            loadInfoWidget(width, height, title: languages[language]!["distance"]!,
                                description: "${load.distance} KM"),
                            loadInfoWidget(width, height, title: languages[language]!["per_km"]!,
                                description: "${(load.price! / load.distance!).toStringAsFixed(2)} ₺"),
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

