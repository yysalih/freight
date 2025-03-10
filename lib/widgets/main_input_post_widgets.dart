import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/controllers/main_controller.dart';
import 'package:kamyon/widgets/pick_truck_button_widget.dart';
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
    final mainNotifier = ref.watch(mainController.notifier);


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SearchPlaceFieldWidget(isOrigin: true, top: 200.h,),
            SizedBox(width: 10.w,),
            SearchPlaceFieldWidget(isOrigin: false, top: 200.h,),
          ],
        ),
        SizedBox(height: 10.h,),

        if(!isLoad) ...[
          const Row(
            children: [
              PickTruckButton(),
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


