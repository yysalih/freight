import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../widgets/load_action_button.dart';
import '../../widgets/load_info_widget.dart';

class LoadInnerView extends ConsumerWidget {
  const LoadInnerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

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
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
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
                            const Text("İstanbul TR\nOcak 28", style: kCustomTextStyle,),
                            const Icon(Icons.fast_forward_sharp, color: kBlueColor,),

                            Icon(Icons.local_shipping, color: kWhite, size: 30.w,),

                            const Icon(Icons.fast_forward_sharp, color: kBlueColor,),
                            const Text("Ankara TR\nOcak 30", style: kCustomTextStyle, textAlign: TextAlign.end,),
                          ],
                        ),
                        SizedBox(height: 10.h,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Steel Road Inc.", style: kCustomTextStyle,),
                                SizedBox(height: 3.h,),
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
                                const Text("3 gün önce", style: kCustomTextStyle,),
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
                            description2: "2000\$",
                            title: languages[language]!["take_the_job"]!, description: languages[language]!["total"]!),
                        loadActionButton(width, language, icon: Icons.add_ic_call_rounded,
                            description2: "1000 KM",
                            title: languages[language]!["call"]!, description: languages[language]!["distance"]!),
                      ],
                    ),
                    SizedBox(height: 15.h,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(languages[language]!["vehicle_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                        loadInfoWidget(width, height, title: languages[language]!["full_partial"]!,
                            description: languages[language]!["partial"]!),
                        loadInfoWidget(width, height, title: languages[language]!["vehicle_type"]!,
                            description: "Kamyon"),
                        loadInfoWidget(width, height, title: languages[language]!["length"]!,
                            description: "15 MT"),
                        loadInfoWidget(width, height, title: languages[language]!["weight"]!,
                            description: "1200 KG"),

                      ],
                    ),
                    SizedBox(height: 15.h,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(languages[language]!["shipping_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                        loadInfoWidget(width, height, title: languages[language]!["pick_up_date"]!,
                            description: "25 Ocak, 11.00 - 15.00"),
                        loadInfoWidget(width, height, title: languages[language]!["dock_date"]!,
                            description: "27 Ocak, 03.00 - 07.00"),
                        loadInfoWidget(width, height, title: languages[language]!["reference"]!,
                            description: "#1K00F9886"),

                        loadInfoWidget(width, height, title: languages[language]!["description"]!,
                            description: "Hızlı ödeme ve yol masrafı dahil"),
                      ],
                    ),
                    SizedBox(height: 15.h,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(languages[language]!["load_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),

                        loadInfoWidget(width, height, title: languages[language]!["shipping_type"]!,
                            description: "Gıda ve Besin"),
                        loadInfoWidget(width, height, title: languages[language]!["load_type"]!,
                            description: "Paletli"),
                        loadInfoWidget(width, height, title: languages[language]!["load_volume"]!,
                            description: "100 m3"),
                      ],
                    ),
                    SizedBox(height: 15.h,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(languages[language]!["rate_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                        loadInfoWidget(width, height, title: languages[language]!["total"]!,
                            description: "24000 ₺"),
                        loadInfoWidget(width, height, title: languages[language]!["distance"]!,
                            description: "2200 KM"),
                        loadInfoWidget(width, height, title: languages[language]!["per_km"]!,
                            description: "10.9 ₺"),
                      ],
                    ),
                    SizedBox(height: 15.h,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(languages[language]!["company_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                        loadInfoWidget(width, height, title: languages[language]!["company_name"]!,
                            description: "Steel Road Inc."),
                        loadInfoWidget(width, height, title: languages[language]!["phone"]!,
                            description: "+90 352 987 88 76"),
                        loadInfoWidget(width, height, title: languages[language]!["location"]!,
                            description: "Akdeniz Cd. No:31, 06570"),
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
        ),
      ),
    );
  }
}

