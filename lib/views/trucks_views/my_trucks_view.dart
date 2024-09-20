import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/views/trucks_views/add_new_truck_view.dart';

import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../widgets/truck_card_widget.dart';

class MyTrucksView extends ConsumerWidget {
  const MyTrucksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.only(top: 10.h, right: 15.w, left: 15.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(languages[language]!["my_vehicles"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
              TextButton(
                child: Text(languages[language]!["new_vehicle"]!, style: kCustomTextStyle.copyWith(fontSize: 13.w,
                  color: kBlueColor),),
                onPressed: () {
                  Navigator.push(context, routeToView(const AddNewTruckView()));
                },
              )
            ],
          ),
          SizedBox(height: 10.h,),
          truckCardWidget(language, width: width, description: "A big monster with several functions and capabilities",
              truckName: "Mercedes Benz", tags: ["Fast", "Heavy", "Reliable",], context: context),
          truckCardWidget(language, width: width, description: "Might have a little limit on distance than the other",
              truckName: "MAN TGX", tags: ["Fast", "Medium",], context: context),
        ],
      ),
    );
  }
}

