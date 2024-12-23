import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/controllers/load_controller.dart';
import 'package:kamyon/controllers/main_controller.dart';
import 'package:kamyon/models/place_model.dart';

import '../constants/languages.dart';
import '../controllers/place_controller.dart';
import '../controllers/truck_controller.dart';
import 'input_field_widget.dart';
import 'main_input_post_widgets.dart';

Widget quickLoadWidget(BuildContext context, double width, double height, String language,
    LoadController loadNotifier,
    MainState mainState,
    MainController mainNotifier,
    PlaceState placeState,
    PlaceController placeNotifier,
    TruckController truckNotifier,
    List<AppPlaceModel> placeModels,
    ) {
  return AnimatedSize(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    child: !mainState.isTruckPostExpanded
        ? Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: mainState.isLoadExpanded ? width * .9 : width * .44,
          height: 95.h,
          child: customRichInputField(
            title: "",
            hintText: languages[language]!["enter_load"]!,
            icon: Icons.card_membership,
            controller: loadNotifier.descriptionController,
            hasTitle: false,
            maxLines: 3,
            bottom: 30.h,
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

            bool checkOriginExists = placeNotifier.checkPlaceModel(placeModels, isOrigin: true);
            bool checkDestinationExists = placeNotifier.checkPlaceModel(placeModels, isOrigin: false);

            if(checkOriginExists) {
              await placeNotifier.createPlace(context, appPlaceModel: placeState.origin,);
            }

            if(checkDestinationExists) {
              await placeNotifier.createPlace(context, appPlaceModel: placeState.destination,);
            }

            loadNotifier.createLoad(context, errorTitle: languages[language]!["problem_creating_new_load"]!,
                successTitle: languages[language]!["new_load_created"]!, fromMainView: true);

            loadNotifier.clear();

            truckNotifier.clear();
            placeNotifier.clear();

            mainNotifier.changeExpansions(isTruckPostExpanded: false, isLoadExpanded: false);
            FocusScope.of(context).unfocus();

          },) : const SizedBox(),
        )
      ],
    ) : const SizedBox(),
  );
}


Widget quickTruckWidget(BuildContext context, double width, double height, String language,
    LoadController loadNotifier,
    MainState mainState,
    MainController mainNotifier,
    PlaceState placeState,
    PlaceController placeNotifier,
    TruckController truckNotifier,
    List<AppPlaceModel> placeModels,
    ) {
  return AnimatedSize(
    duration: const Duration(milliseconds: 300),
    curve: Curves.easeInOut,
    child: !mainState.isLoadExpanded
        ? Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: mainState.isTruckPostExpanded ? width * .9 : width * .44,
          height: 95.h,
          child: customRichInputField(
            title: "",
            hintText: languages[language]!["enter_truck_post"]!,
            icon: Icons.local_shipping,
            controller: truckNotifier.descriptionController,
            hasTitle: false,
            maxLines: 3,
            bottom: 30.h,
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

            bool checkOriginExists = placeNotifier.checkPlaceModel(placeModels, isOrigin: true);
            bool checkDestinationExists = placeNotifier.checkPlaceModel(placeModels, isOrigin: false);

            if(checkOriginExists) {
              await placeNotifier.createPlace(context, appPlaceModel: placeState.origin,);
            }

            if(checkDestinationExists) {
              await placeNotifier.createPlace(context, appPlaceModel: placeState.destination,);
            }

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
  );
}