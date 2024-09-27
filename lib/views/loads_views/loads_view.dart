import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/constants/providers.dart';
import 'package:kamyon/views/loads_views/search_view.dart';
import 'package:kamyon/widgets/file_card_widget.dart';
import 'package:kamyon/widgets/input_field_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';


class LoadsView extends ConsumerWidget {
  const LoadsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        FlutterMap(
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
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: width,
            height: height * .3,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              color: kBlack
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 15.0.h, left: 15.w, right: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  customInputField(title: languages[language]!["search"]!,
                      hintText: languages[language]!["search"]!, icon: Icons.search,
                      
                      hasTitle: false, borderRadius: 20, onTap: () {
                    Navigator.push(context, routeToView(const SearchView()));
                    }, controller: TextEditingController()),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(languages[language]!["discover"]!, style: kCustomTextStyle,),
                      SizedBox(height: 5.h,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          fileCardWidget3(title: languages[language]!["find_load"]!, image: "box",
                              color: kLightBlack, onPressed: () {}),
                          fileCardWidget3(title: languages[language]!["rest"]!, image: "parking",
                              color: kLightBlack, onPressed: () {}),
                          fileCardWidget3(title: languages[language]!["fuel"]!, image: "fuel",
                              color: kLightBlack, onPressed: () {}),
                        ],
                      ),
                    ],
                  ),
                  Container()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
