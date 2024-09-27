import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/widgets/custom_button_widget.dart';
import 'package:kamyon/widgets/input_field_widget.dart';
import 'package:kamyon/widgets/search_card_widget.dart';

import '../../constants/providers.dart';
import '../../controllers/truck_controller.dart';
import '../../widgets/truck_info_field_widget.dart';

class AddNewTruckView extends ConsumerWidget {
  const AddNewTruckView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final width = MediaQuery.of(context).size.width;

    final truckState = ref.watch(truckController);
    final truckNotifier = ref.watch(truckController.notifier);

    return Scaffold(
      backgroundColor: kBlack,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          color: kWhite,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(languages[language]!["add_new_truck"]!,
         style: const TextStyle(color: kWhite),),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(languages[language]!["equipment_limits"]!, style: kCustomTextStyle,),
                  SizedBox(height: 10.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 30.h, width: width * .45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: MaterialButton(
                            color: truckState.isPartial ? kLightBlack : kGreen,
                            onPressed: () {
                              truckNotifier.changeVehicleLimit();
                            },
                            child: Center(
                              child: Text(languages[language]!["full"]!, style: kCustomTextStyle.copyWith(
                                color: truckState.isPartial ? kWhite : kBlack
                              ),),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30.h, width: width * .45,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: MaterialButton(
                            color: !truckState.isPartial ? kLightBlack : kGreen,
                            onPressed: () {
                              truckNotifier.changeVehicleLimit();
                            },
                            child: Center(
                              child: Text(languages[language]!["partial"]!, style: kCustomTextStyle.copyWith(
                                  color: !truckState.isPartial ? kWhite : kBlack,
                              ),),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Column(
                children: [
                  customInputField(title: languages[language]!["truck_name"]!,
                      hintText: languages[language]!["enter_truck_name"]!, icon: Icons.local_shipping_outlined, onTap: () {

                      }, controller: TextEditingController()),
                  SizedBox(height: 20.h,),
                  customInputField(title: languages[language]!["description"]!,
                      hintText: languages[language]!["enter_truck_description"]!, icon: Icons.local_shipping_outlined, onTap: () {

                    }, controller: TextEditingController()),
                  SizedBox(height: 20.h,),
                  searchCardWidget(width, title: languages[language]!["registered_city"]!,
                      hint: languages[language]!["enter_registered_city"]!, halfLength: false, onPressed: () {

                    },)
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(languages[language]!["truck_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                  SizedBox(height: 3.h,),
                  truckInfoField(width: width, title: languages[language]!["length"]!, suffixIcon: "mt"),
                  truckInfoField(width: width, title: languages[language]!["weight"]!, suffixIcon: "kg"),
                  truckInfoField(width: width, title: languages[language]!["price"]!, suffixIcon: "₺"),
                ],
              ),
              customButton(title: languages[language]!["save"]!, onPressed: () {}),
            ],
          ),
        ),
      ),

    );
  }
}

