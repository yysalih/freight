import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/controllers/place_controller.dart';
import 'package:kamyon/models/place_model.dart';
import 'package:kamyon/repos/place_repository.dart';
import 'package:kamyon/widgets/input_field_widget.dart';
import 'package:kamyon/widgets/warning_info_widget.dart';
import 'package:uuid/uuid.dart';

import '../../constants/app_constants.dart';

class SearchPlaceFieldWidget extends ConsumerStatefulWidget {
  final bool isOrigin;
  final double top;
  const SearchPlaceFieldWidget({super.key, required this.isOrigin, required this.top});

  @override
  ConsumerState<SearchPlaceFieldWidget> createState() => _SearchPlaceViewState();
}

class _SearchPlaceViewState extends ConsumerState<SearchPlaceFieldWidget> {


  @override
  void initState() {
    final placeNotifier = ref.read(placeController.notifier);
    placeNotifier.originSearchController.clear();
    placeNotifier.destinationSearchController.clear();

    final placesProvider = ref.read(placesFutureProvider(""));
    placesProvider.when(
      data: (places) {
        placeNotifier.originSearchController.addListener(() {

          if(places.where((element) => element.name!.toLowerCase()
              .contains(placeNotifier.originSearchController.text.toLowerCase()),).isEmpty) {
            _onChangedOrigin();
          }
        },);

        placeNotifier.destinationSearchController.addListener(() {
          if(places.where((element) => element.name!.toLowerCase()
              .contains(placeNotifier.destinationSearchController.text.toLowerCase()),).isEmpty) {
            _onChangedDestination();
          }

        },);
      },
      loading: () {

      },
      error: (error, stackTrace) {

      },
    );
    super.initState();



  }

  _onChangedOrigin() {
    final placeNotifier = ref.read(placeController.notifier);
    placeNotifier.fetchPlaceDetails(placeNotifier.originSearchController.text);
  }

  _onChangedDestination() {
    final placeNotifier = ref.read(placeController.notifier);
    placeNotifier.fetchPlaceDetails(placeNotifier.destinationSearchController.text);
  }

  final overlayController = OverlayPortalController();


  @override
  Widget build(BuildContext context) {

    final placeNotifier = ref.watch(placeController.notifier);
    final placeState = ref.watch(placeController);

    final width = MediaQuery.of(context).size.width;

    final placesProvider = ref.watch(placesFutureProvider(""));

    return placesProvider.when(
      data: (places) {
        List<AppPlaceModel> filteredDestinationPlaces = places.where((element) => element.name!.toLowerCase()
            .contains(placeNotifier.destinationSearchController.text.toLowerCase()),).toList();

        List<AppPlaceModel> filteredOriginPlaces = places.where((element) => element.name!.toLowerCase()
            .contains(placeNotifier.originSearchController.text.toLowerCase()),).toList();

        List<AppPlaceModel> finalList = widget.isOrigin ? filteredOriginPlaces : filteredDestinationPlaces;

        debugPrint("Filtered Places' Length: ${finalList.length}");


        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child:  SizedBox(
                width: width * .43,
                child: OverlayPortal(
                  controller: overlayController,
                  overlayChildBuilder: (context) => ListView.builder(
                    padding: EdgeInsets.only(top: widget.top,),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredDestinationPlaces.isNotEmpty ? finalList.length : placeState.placeList.length,

                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(top: 10.0.h, right: 10.w, left: 10.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: MaterialButton(
                            color: kBlack,
                            height: 40.h,
                            onPressed: () {
                              AppPlaceModel appPlaceModel = AppPlaceModel(
                                name: finalList.isNotEmpty ? finalList[index].name
                                    : placeState.placeList[index]["name"],
                                latitude: finalList.isNotEmpty ? finalList[index].latitude
                                    : placeState.placeList[index]["geometry"]["location"]["lat"],
                                longitude: finalList.isNotEmpty ? finalList[index].longitude
                                    : placeState.placeList[index]["geometry"]["location"]["lng"],
                                address: finalList.isNotEmpty ? finalList[index].address
                                    : placeState.placeList[index]["formatted_address"],
                                uid: finalList.isNotEmpty ? finalList[index].uid : const Uuid().v4(),
                              );
                              placeNotifier.setPlaceModels(origin: widget.isOrigin ? appPlaceModel : placeState.origin,
                                destination: !widget.isOrigin ? appPlaceModel : placeState.destination,);
                              if(widget.isOrigin) {
                                placeNotifier.originSearchController.text = finalList.isNotEmpty ? finalList[index].name
                                    : placeState.placeList[index]["name"];
                              } else {
                                placeNotifier.destinationSearchController.text = finalList.isNotEmpty ? finalList[index].name
                                    : placeState.placeList[index]["name"];
                              }
                              placeNotifier.clear();
                              overlayController.hide();
                            },
                            child: Text("${finalList.isNotEmpty ? finalList[index].name : placeState.placeList[index]["name"]}\n\n"
                                "${finalList.isNotEmpty ? finalList[index].address : placeState.placeList[index]["formatted_address"]}",
                              textAlign: TextAlign.start,
                              style: kCustomTextStyle,),
                          ),
                        ),
                      );
                    },
                  ),
                  child: customInputField(title: "",
                    hintText: widget.isOrigin ?
                    placeState.origin.name!.isNotEmpty ? placeState.origin.name! : "Ankara, TR"
                        :
                    placeState.destination.name!.isNotEmpty ? placeState.destination.name! : "İstanbul, TR",
                    icon: Icons.map, controller: widget.isOrigin ? placeNotifier.originSearchController :
                    placeNotifier.destinationSearchController
                    , hasIcon: false,
                    onTap: () {
                      overlayController.toggle();
                    }, onChanged: (value) {

                    },
                  ),
                ),
              ),
            ),

          ],
        );
      },
      loading: () => const LoadingWidget(),
      error: (error, stackTrace) => const NoPlaceFound(),
    );
  }
}
