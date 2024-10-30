import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/controllers/main_controller.dart';
import 'package:kamyon/controllers/truck_controller.dart';
import 'package:kamyon/models/truck_model.dart';
import 'package:kamyon/repos/truck_repository.dart';
import 'package:kamyon/widgets/search_card_widget.dart';
import 'package:kamyon/widgets/search_place_field_widget.dart';

import '../constants/languages.dart';
import '../constants/providers.dart';
import 'input_field_widget.dart';

class MainInputPostWidgets extends ConsumerWidget{
  final bool isLoad;
  final TextEditingController controller;
  final Function() onPressed;
  const MainInputPostWidgets({super.key, required this.isLoad,
    required this.controller,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final language = ref.watch(languageStateProvider);

    final mainState = ref.watch(mainController);
    final truckState = ref.watch(truckController);

    final mainNotifier = ref.watch(mainController.notifier);
    final truckNotifier = ref.watch(truckController.notifier);

    final GlobalKey _menuKey2 = GlobalKey();


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SearchPlaceFieldWidget(isOrigin: true, top: 200.h,),
            SizedBox(width: 10.w,),
            SearchPlaceFieldWidget(isOrigin: false, top: 200.h,),
          ],
        ),
        SizedBox(height: 10.h,),

        if(!isLoad) ...[
          Row(
            children: [
              Consumer(
                builder: (context, ref, child) {
                  final GlobalKey _menuKey = GlobalKey();

                  final trucksProvider = ref.watch(trucksFutureProvider(FirebaseAuth.instance.currentUser!.uid));

                  return trucksProvider.when(
                    data: (trucks) => PopupMenuButton(
                      color: kBlack,
                      key: _menuKey,
                      child: searchCardWidget(width, hasTitle: false,
                        title: languages[language]!["pick_truck"]!,
                        hint: mainState.truck.name!.isNotEmpty ?
                        mainState.truck.name!
                            : languages[language]!["pick_truck"]!, onPressed: () {
                          final dynamic popupMenu = _menuKey.currentState;
                          popupMenu.showButtonMenu();
                        },),
                      onSelected: (value) {
                        mainNotifier.changeTruck(value: value);
                      },
                      itemBuilder: (context) => <PopupMenuEntry<TruckModel>>[
                        for(int i = 0; i < trucks.length; i++) PopupMenuItem<TruckModel>(

                          value: trucks[i],
                          child: Text(trucks[i].name!, style: kCustomTextStyle,),
                        ),
                      ],
                    ),
                    loading: () => const SizedBox(),
                    error: (error, stackTrace) => const SizedBox(),
                  );
                },
                child: const SizedBox(),
              ),
              SizedBox(width: 10.w,),
              PopupMenuButton(
                key: _menuKey2,
                onSelected: (value) {
                  truckNotifier.changeTruckType(value);
                },
                child: searchCardWidget(width, hasTitle: false,
                  title: languages[language]!["vehicle_type"]!,
                  hint: truckState.truckType.isNotEmpty ? languages[language]![truckState.truckType]!
                      : languages[language]!["pick_a_type"]!, onPressed: () {
                    final dynamic popupMenu = _menuKey2.currentState;
                    popupMenu.showButtonMenu();
                  },),
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'truck',
                    child: Text(languages[language]!["truck"]!),
                  ),
                  PopupMenuItem<String>(
                    value: 'bus',
                    child: Text(languages[language]!["bus"]!),
                  ),
                  PopupMenuItem<String>(
                    value: 'car',
                    child: Text(languages[language]!["car"]!),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10.h,),
        ],

        Row(
          children: [
            SizedBox(
              width: width * .6,
              child: customInputField(
                onChanged: (value) {

                },
                hasTitle: false,
                title: languages[language]!["price"]!,
                hintText: languages[language]!["enter_price"]!,
                icon: Icons.monetization_on,
                controller: controller,
                onTap: () {

                },
              ),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                backgroundColor: kGreen,
                padding: const EdgeInsets.all(7)
              ),
              onPressed: onPressed,
              child: Icon(Icons.done, color: kWhite, size: 30.w,),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: Colors.redAccent,
                  padding: const EdgeInsets.all(7)
              ),
              child: Icon(Icons.close, color: kWhite, size: 30.w,),
              onPressed: () {
                mainNotifier.changeExpansions(isTruckPostExpanded: false, isLoadExpanded: false);
                FocusScope.of(context).unfocus();
              },
            ),
          ],
        ),
      ],
    );
  }
}
