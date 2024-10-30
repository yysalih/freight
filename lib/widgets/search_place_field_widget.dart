import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/controllers/place_controller.dart';
import 'package:kamyon/models/place_model.dart';
import 'package:kamyon/widgets/input_field_widget.dart';
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
    // TODO: implement initState
    super.initState();
    final placeNotifier = ref.read(placeController.notifier);
    placeNotifier.originSearchController.clear();
    placeNotifier.destinationSearchController.clear();

    placeNotifier.originSearchController.addListener(() {
      _onChangedOrigin();
    },);
    placeNotifier.destinationSearchController.addListener(() {
      _onChangedDestination();
    },);
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
                itemCount: placeState.placeList.length,

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
                              name: placeState.placeList[index]["name"],
                              latitude: placeState.placeList[index]["geometry"]["location"]["lat"],
                              longitude: placeState.placeList[index]["geometry"]["location"]["lng"],
                              uid: const Uuid().v4(),
                              address: placeState.placeList[index]["formatted_address"]
                          );
                          placeNotifier.setPlaceModels(origin: widget.isOrigin ? appPlaceModel : placeState.origin,
                            destination: !widget.isOrigin ? appPlaceModel : placeState.destination,);
                          if(widget.isOrigin) {
                            placeNotifier.originSearchController.text = placeState.placeList[index]["name"];
                          } else {
                            placeNotifier.destinationSearchController.text = placeState.placeList[index]["name"];
                          }
                          placeNotifier.clear();
                          overlayController.hide();
                        },
                        child: Text("${placeState.placeList[index]["name"]}\n\n${placeState.placeList[index]["formatted_address"]}",
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
  }
}
