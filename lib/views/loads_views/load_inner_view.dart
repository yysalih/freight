import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kamyon/constants/snackbars.dart';
import 'package:kamyon/controllers/load_controller.dart';
import 'package:kamyon/controllers/place_controller.dart';
import 'package:kamyon/models/place_model.dart';
import 'package:kamyon/repos/load_repository.dart';
import 'package:kamyon/repos/place_repository.dart';
import 'package:kamyon/views/my_loads_views/post_load_view.dart';
import 'package:kamyon/widgets/app_alert_dialogs_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../widgets/load_action_button.dart';
import '../../widgets/load_info_widget.dart';

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

    final placeNotifier = ref.watch(placeController.notifier);


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
            data: (load) => Column(
              children: [
                SizedBox(
                  width: width, height: height * .25,
                  child: FlutterMap(
                    options: const MapOptions(
                      initialCenter: LatLng(51.509364, -0.128928), // Center the map over London
                      initialZoom: 9.2,
                    ),
                    children: [
                      TileLayer( // Display map tiles from any source
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png', // OSMF's Tile Server
                        userAgentPackageName: 'com.kamyon',
                        maxNativeZoom: 19, // Scale tiles when the server doesn't support higher zoom levels
                        // And many more recommended properties!
                      ),
                      RichAttributionWidget( // Include a stylish prebuilt attribution widget that meets all requirments
                        attributions: [
                          TextSourceAttribution(
                            'OpenStreetMap contributors',
                            onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')), // (external)
                          ),
                          // Also add images...
                        ],
                      ),
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
                              Text("İstanbul TR\n${DateFormat("dd.MM.yyyy").format(load.startDate!)}",
                                style: kCustomTextStyle,),
                              const Icon(Icons.fast_forward_sharp, color: kBlueColor,),

                              Icon(Icons.local_shipping, color: kWhite, size: 30.w,),

                              const Icon(Icons.fast_forward_sharp, color: kBlueColor,),
                              Text("Ankara TR\n${DateFormat("dd.MM.yyyy").format(load.endDate!)}",
                                style: kCustomTextStyle, textAlign: TextAlign.end,),
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
                                                child: Text(["Fast", "Reliable", "Heavy"][i], style: kCustomTextStyle.copyWith(fontSize: 11.w, color: kLightBlack),),
                                              ),
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
                      SizedBox(height: 15.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          loadActionButton(width, language, icon: Icons.monetization_on_rounded,
                              description2: "${load.price}\$",
                              title: languages[language]!["take_the_job"]!, description: languages[language]!["total"]!),
                          loadActionButton(width, language, icon: Icons.add_ic_call_rounded,
                              description2: "${load.distance} KM",
                              title: languages[language]!["call"]!, description: languages[language]!["distance"]!),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(languages[language]!["user_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                          loadInfoWidget(width, height, title: languages[language]!["user_name"]!,
                              description: "Steel Road Inc."),
                          loadInfoWidget(width, height, title: languages[language]!["phone"]!,
                              description: load.contact!),
                          //loadInfoWidget(width, height, title: languages[language]!["location"]!, description: "Akdeniz Cd. No:31, 06570"),
                          loadInfoWidget(width, height, title: languages[language]!["rating"]!,
                              description: "Akdeniz Cd. No:31, 06570"),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15.h,),

              ],
            ),
            error: (error, stackTrace) => Container(),
            loading: () => Container(),
          ),
        ),
      ),
    );
  }
}

