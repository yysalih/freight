import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/constants/providers.dart';
import 'package:kamyon/controllers/load_controller.dart';
import 'package:kamyon/controllers/main_controller.dart';
import 'package:kamyon/controllers/truck_controller.dart';
import 'package:kamyon/models/truck_post_model.dart';
import 'package:kamyon/repos/load_repository.dart';
import 'package:kamyon/repos/truck_posts_repository.dart';
import 'package:kamyon/views/loads_views/search_view.dart';
import 'package:kamyon/widgets/file_card_widget.dart';
import 'package:kamyon/widgets/input_field_widget.dart';
import 'package:kamyon/widgets/map_markers_widget.dart';
import 'package:kamyon/widgets/quick_create_load_truck_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/place_controller.dart';
import '../../models/load_model.dart';
import '../../models/truck_model.dart';
import '../../widgets/main_input_post_widgets.dart';


class LoadsView extends ConsumerWidget {
  const LoadsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final loadNotifier = ref.watch(loadController.notifier);
    final truckNotifier = ref.watch(truckController.notifier);
    final mainNotifier = ref.watch(mainController.notifier);
    final placeNotifier = ref.watch(placeController.notifier);

    final mainState = ref.watch(mainController);
    final placeState = ref.watch(placeController);

    final availableLoadsNotifier = ref.watch(availableLoadsFutureProvider(""));
    final availableTruckPostsNotifier = ref.watch(availableTruckPostsFutureProvider(""));

    return Stack(
      children: [
        availableLoadsNotifier.when(
          data: (availableLoads) => availableTruckPostsNotifier.when(
            data: (availableTruckPosts) => FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(41.0082376, 28.9783589),
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
                    // Also add images...
                  ],
                ),
                MarkerLayer(
                  markers: [
                    for(LoadModel load in availableLoads)
                      loadMarker(load, context: context),

                    for(TruckPostModel truckPost in availableTruckPosts)
                      truckPostMarker(truckPost, context: context),
                  ],
                ),
              ],
            ),
            loading: () => emptyFlutterMap(),
            error: (error, stackTrace) => emptyFlutterMap(),
          ),
          loading: () => emptyFlutterMap(),
          error: (error, stackTrace) => emptyFlutterMap(),
        ),

        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              quickLoadWidget(context, width, height, language, loadNotifier,
                  mainState, mainNotifier, placeState, placeNotifier, truckNotifier),

              quickTruckWidget(context, width, height, language, loadNotifier,
                  mainState, mainNotifier, placeState, placeNotifier, truckNotifier),

            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: width,
            height: height * .11,
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
                      
                      hasTitle: false, borderRadius: 20, controller: mainNotifier.searchController, onChanged: (value) {
                        mainNotifier.changeSearchString(value: value);
                      }, onTap: () {

                      },),
                  /*Column(
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
                  Container()*/
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
