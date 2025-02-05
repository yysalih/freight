import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/constants/providers.dart';
import 'package:kamyon/controllers/load_controller.dart';
import 'package:kamyon/controllers/location_controller.dart';
import 'package:kamyon/controllers/main_controller.dart';
import 'package:kamyon/controllers/truck_controller.dart';
import 'package:kamyon/models/truck_post_model.dart';
import 'package:kamyon/repos/load_repository.dart';
import 'package:kamyon/repos/truck_posts_repository.dart';
import 'package:kamyon/widgets/input_field_widget.dart';
import 'package:kamyon/widgets/map_markers_widget.dart';
import 'package:kamyon/widgets/quick_create_load_truck_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/place_controller.dart';
import '../../models/load_model.dart';
import '../../repos/place_repository.dart';
import '../../widgets/search_result_widget.dart';


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

    final locationNotifier = ref.watch(locationController.notifier);

    final latLng = LatLng(locationNotifier.locationData.latitude ?? 41.0082376,
        locationNotifier.locationData.longitude ?? 28.9783589);

    final availableLoadsNotifier = ref.watch(availableLoadsFutureProvider(""));
    final availableTruckPostsNotifier = ref.watch(availableTruckPostsFutureProvider(""));

    final placesProvider = ref.watch(placesFutureProvider(""));

    return availableLoadsNotifier.when(
      data: (availableLoads) => availableTruckPostsNotifier.when(
        data: (availableTruckPosts) {

          List<dynamic> combinedList = [...availableLoads, ...availableTruckPosts];

          return Stack(
            children: [
              FlutterMap(
                mapController: mainNotifier.mapController,
                options: MapOptions(
                  initialCenter: latLng,
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


                      Marker(
                          point: latLng,
                          child: Icon(Icons.my_location, color: Colors.red, size: 30.w,)
                      )
                    ],
                  ),
                ],
              ),

              placesProvider.when(
                data: (places) => Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      quickLoadWidget(context, width, height, language, loadNotifier,
                          mainState, mainNotifier, placeState, placeNotifier, truckNotifier, places),

                      quickTruckWidget(context, width, height, language, loadNotifier,
                          mainState, mainNotifier, placeState, placeNotifier, truckNotifier, places),

                    ],
                  ),
                ),
                loading: () => Container(),
                error: (error, stackTrace) => Container(),

              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: width,
                  height: height * ((mainState.itemsOpened && mainNotifier.searchController.text.isNotEmpty)
                      ? .7 : (mainState.filteredItems.isEmpty || mainNotifier.searchController.text.isEmpty) ? .275
                      : .175),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                      color: kBlack
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 15.0.h, left: 15.w, right: 15.w),
                        child: customInputField(title: languages[language]!["search"]!,
                          hintText: languages[language]!["search"]!, icon: Icons.search,

                          hasTitle: false, borderRadius: 20, controller: mainNotifier.searchController, onChanged: (value) {
                            mainNotifier.changeSearchString(value: value);

                            List loadList = availableLoads.where((element) => element.originName!.toLowerCase().contains(value.toLowerCase())
                                || element.originAddress!.toLowerCase().toLowerCase().contains(value.toLowerCase())).toList();

                            List truckPostList = availableTruckPosts.where((element) => element.originName!.contains(value.toLowerCase())
                                || element.originAddress!.toLowerCase().contains(value.toLowerCase())).toList();

                            List<dynamic> combinedList = [...truckPostList, ...loadList];

                            mainNotifier.updateFilteredList(combinedList);
                            debugPrint("Filtered List Length: ${mainState.filteredItems.length}");

                          },
                          onTap: () {

                          },
                        ),
                      ),
                      mainState.filteredItems.isEmpty || mainNotifier.searchController.text.isEmpty
                          ? const SizedBox() : TextButton(
                        child: Text(languages[language]![mainState.itemsOpened ? "hide_results" : "show_results"]!,
                          style: kCustomTextStyle.copyWith(
                              color: Colors.lightBlueAccent
                          ),),
                        onPressed: () {
                          if(mainNotifier.searchController.text.isNotEmpty) {
                            mainNotifier.showSearchItems(value: !mainState.itemsOpened);
                          }
                        },
                      ),
                      SizedBox(height: 10.h,),

                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: height * .15),
                        child: ListView.builder(
                          padding: EdgeInsets.only(right: 10.w),
                          scrollDirection: Axis.horizontal,
                          itemCount: combinedList.length,
                          itemBuilder: (context, index) {
                            final item = combinedList[index];
                            if(item.runtimeType == LoadModel) {
                              final load = item as LoadModel;

                              return Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: extraSmallLoadWidget(width, height, language,
                                  load: load, onPressed: () {
                                    mainNotifier.mapController.move(LatLng(load.originLat!, load.originLong!), 9.2);

                                  },
                                ),
                              );
                            }
                            else {
                              final truckPost = item as TruckPostModel;

                              return Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: extraSmallTruckPostsWidget(width, height, language, truckPost: truckPost, onPressed: () {
                                  mainNotifier.mapController.move(LatLng(truckPost.originLat!, truckPost.originLong!), 9.2);
                                },),
                              );
                            }
                          },
                        ),
                      ),

                      SizedBox(height: 10.h,),
                      Expanded(
                        child: mainState.filteredItems.isEmpty || mainNotifier.searchController.text.isEmpty
                            ? const SizedBox.shrink()
                            : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 10.w),
                          itemCount: mainState.filteredItems.length,
                          itemBuilder: (context, index) {
                            final item = mainState.filteredItems[index];
                            debugPrint("Item Type: ${item.runtimeType}");
                            if(item.runtimeType == LoadModel) {
                              final item0 = item as LoadModel;


                              return Padding(
                                padding: EdgeInsets.only(top: 15.0.h),
                                child: smallerSearchResultWidget(width, height, language, load: item0,
                                  onPressed: () {
                                    mainNotifier.mapController.move(LatLng(item0.originLat!, item0.originLong!), 9.2);
                                  },
                                ),
                              );
                            }

                            final item0 = item as TruckPostModel;
                            return Padding(
                                padding: EdgeInsets.only(top: 15.0.h),
                                child: smallerTruckPostsWidget(width, height, language, truckPost: item0,
                                  onPressed: () {
                                    mainNotifier.mapController.move(LatLng(item0.originLat!, item0.originLong!), 9.2);
                                  },)
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => emptyFlutterMap(latLng),
        error: (error, stackTrace) => emptyFlutterMap(latLng),
      ),
      loading: () => emptyFlutterMap(latLng),
      error: (error, stackTrace) => emptyFlutterMap(latLng),
    );
  }
}


