import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/controllers/place_controller.dart';
import 'package:kamyon/models/place_model.dart';
import 'package:kamyon/widgets/input_field_widget.dart';
import 'package:uuid/uuid.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';

//TODO This view isn't used. Should be replaced with SearchPlaceFieldWidget wherever it's placed.

class SearchPlaceView extends ConsumerStatefulWidget {
  final bool isOrigin;
  const SearchPlaceView({super.key, required this.isOrigin});

  @override
  ConsumerState<SearchPlaceView> createState() => _SearchPlaceViewState();
}

class _SearchPlaceViewState extends ConsumerState<SearchPlaceView> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final placeNotifier = ref.read(placeController.notifier);
    placeNotifier.originSearchController.clear();

    placeNotifier.originSearchController.addListener(() {
      _onChanged();
    },);
  }

  _onChanged() {
    final placeNotifier = ref.read(placeController.notifier);
    //
    // setState(() {
    //   placeNotifier.sessionToken = placeNotifier.uuid.v4();
    // });
    placeNotifier.fetchPlaceDetails(placeNotifier.originSearchController.text);
   // placeNotifier.getSuggestion(placeNotifier.searchController.text);
  }

  final overlayController = OverlayPortalController();


  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageStateProvider);
    final placeNotifier = ref.watch(placeController.notifier);
    final placeState = ref.watch(placeController);

    final width = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: kBlack,

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child:  SizedBox(
              width: width * .43,
              child: OverlayPortal(
                controller: overlayController,
                overlayChildBuilder: (context) => ListView.builder(
                  padding: EdgeInsets.only(top: 65.h,),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: placeState.placeList.length,

                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(top: 10.0.h, right: 10.w, left: 10.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: MaterialButton(
                          color: kLightBlack,
                          height: 60.h,
                          onPressed: () {
                            AppPlaceModel appPlaceModel = AppPlaceModel(
                                name: placeState.placeList[index]["name"],
                                latitude: placeState.placeList[index]["geometry"]["location"]["lat"],
                                longitude: placeState.placeList[index]["geometry"]["location"]["lng"],
                                uid: const Uuid().v4(),
                                address: placeState.placeList[index]["formatted_address"]
                            );
                            placeNotifier.setPlaceModels(origin: widget.isOrigin ? appPlaceModel : placeState.origin,
                              destination: !widget.isOrigin ? appPlaceModel : placeState.destination,);

                            placeNotifier.clear();
                            Navigator.pop(context);
                          },
                          child: Text("${placeState.placeList[index]["name"]}\n\n${placeState.placeList[index]["formatted_address"]}",
                            textAlign: TextAlign.start,
                            style: kCustomTextStyle,),
                        ),
                      ),
                    );
                  },
                ),
                child: customInputField(title: "", hintText: languages[language]!["search_places"]!,
                  icon: Icons.map, controller: placeNotifier.originSearchController,
                  onTap: () {
                    overlayController.toggle();
                  }, onChanged: (value) {

                  },
                ),
              ),
            ),
          ),
          /*Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: placeState.placeList.length,

              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 10.0.h),
                  child: Column(
                    children: [
                      SizedBox(
                        width: width,
                        child: MaterialButton(
                          height: 50.h,
                          onPressed: () {
                            AppPlaceModel appPlaceModel = AppPlaceModel(
                              name: placeState.placeList[index]["name"],
                              latitude: placeState.placeList[index]["geometry"]["location"]["lat"],
                              longitude: placeState.placeList[index]["geometry"]["location"]["lng"],
                              uid: const Uuid().v4(),
                              address: placeState.placeList[index]["formatted_address"]
                            );
                            placeNotifier.setPlaceModels(origin: widget.isOrigin ? appPlaceModel : placeState.origin,
                              destination: !widget.isOrigin ? appPlaceModel : placeState.destination,);
                            Navigator.pop(context);
                          },
                          child: Text("${placeState.placeList[index]["name"]}\n\n${placeState.placeList[index]["formatted_address"]}",
                            textAlign: TextAlign.start,
                            style: kCustomTextStyle,),
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      Container(
                        width: width * .9,
                        height: .75,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              },
            ),
          )*/
        ],
      ),
    );
  }
}
