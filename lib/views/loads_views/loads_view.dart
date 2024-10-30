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
import 'package:kamyon/views/loads_views/search_view.dart';
import 'package:kamyon/widgets/file_card_widget.dart';
import 'package:kamyon/widgets/input_field_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/place_controller.dart';
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

    return Stack(
      children: [
        FlutterMap(
          options: const MapOptions(
            initialCenter: LatLng(51.509364, -0.128928),
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
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: !mainState.isTruckPostExpanded
                    ? Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: mainState.isLoadExpanded ? width * .9 : width * .44,
                      height: mainState.isLoadExpanded ? 85.h : 85.h,
                      child: customRichInputField(
                        title: "",
                        hintText: languages[language]!["enter_load"]!,
                        icon: Icons.card_membership,
                        controller: loadNotifier.descriptionController,
                        hasTitle: false,
                        maxLines: mainState.isLoadExpanded ? 3 : 3,
                        bottom: mainState.isLoadExpanded ? 30.h : 30.h,
                        onTap: () {
                          mainNotifier.changeExpansions(isTruckPostExpanded: false, isLoadExpanded: true);
                        },
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: mainState.isLoadExpanded ?
                      MainInputPostWidgets(isLoad: true, controller: loadNotifier.priceController, onPressed: () async {
                        loadNotifier.switchAppPlaceModels(
                            origin: placeState.origin,
                            destination: placeState.destination
                        );

                        await placeNotifier.createPlace(context, appPlaceModel: placeState.origin,);
                        await placeNotifier.createPlace(context, appPlaceModel: placeState.destination,);

                        loadNotifier.createLoad(context, errorTitle: languages[language]!["problem_creating_new_load"]!,
                            successTitle: languages[language]!["new_load_created"]!, fromMainView: true);

                        loadNotifier.clear();

                        truckNotifier.clear();
                        placeNotifier.clear();

                        mainNotifier.changeExpansions(isTruckPostExpanded: false, isLoadExpanded: false);
                        FocusScope.of(context).unfocus();

                      },)
                          : const SizedBox(),
                    )
                  ],
                )
                    : const SizedBox(),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: !mainState.isLoadExpanded
                    ? Column(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: mainState.isTruckPostExpanded ? width * .9 : width * .44,
                      height: mainState.isTruckPostExpanded ? 75.h : 75.h,
                      child: customRichInputField(
                        title: "",
                        hintText: languages[language]!["enter_truck_post"]!,
                        icon: Icons.local_shipping,
                        controller: truckNotifier.descriptionController,
                        hasTitle: false,
                        maxLines: mainState.isTruckPostExpanded ? 3 : 3,
                        bottom: mainState.isTruckPostExpanded ? 30.h : 30.h,
                        onTap: () {
                          mainNotifier.changeExpansions(isTruckPostExpanded: true, isLoadExpanded: false);
                        },
                      ),
                    ),
                    AnimatedSize(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: mainState.isTruckPostExpanded ?
                      MainInputPostWidgets(isLoad: false, controller: truckNotifier.priceController, onPressed: () async {

                        truckNotifier.switchAppPlaceModels(
                          origin: placeState.origin,
                          destination: placeState.destination,
                        );

                        await placeNotifier.createPlace(context, appPlaceModel: placeState.origin,);
                        await placeNotifier.createPlace(context, appPlaceModel: placeState.destination,);

                        await truckNotifier.createTruckPost(context, truckUid: mainState.truck.uid!,fromMainView: true,
                            errorTitle: languages[language]!["problem_creating_new_truck_post"]!,
                            successTitle: languages[language]!["new_truck_post_created"]!);

                        loadNotifier.clear();

                        truckNotifier.clear();
                        placeNotifier.clear();

                        mainNotifier.changeExpansions(isTruckPostExpanded: false, isLoadExpanded: false);
                        FocusScope.of(context).unfocus();

                      },)
                          : const SizedBox(),
                    )
                  ],
                )
                    : const SizedBox(),
              ),

            ],
          ),
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
                      
                      hasTitle: false, borderRadius: 20, controller: mainNotifier.searchController, onChanged: (value) {
                        mainNotifier.changeSearchString(value: value);
                      }, onTap: () {

                      },),
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
