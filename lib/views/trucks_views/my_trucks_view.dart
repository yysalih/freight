import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/repos/truck_repository.dart';
import 'package:kamyon/views/trucks_views/add_new_truck_view.dart';

import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../widgets/truck_card_widget.dart';
import '../../widgets/warning_info_widget.dart';

class MyTrucksView extends ConsumerWidget {
  const MyTrucksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);
    final width = MediaQuery.of(context).size.width;

    final trucksProvider = ref.watch(trucksFutureProvider(FirebaseAuth.instance.currentUser!.uid));

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

          trucksProvider.when(
            data: (trucks) => Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => trucks.isEmpty ?
                const NoLoadsFoundWidget()
                    : Padding(
                  padding: EdgeInsets.only(top: 15.0.h),
                  child: truckCardWidget(language, width: width, description: trucks[index].description!,
                      truckName: trucks[index].name!,
                      tags: ["${trucks[index].length} mt", "${trucks[index].weight} kg", "${languages[language]![trucks[index].isPartial! ? "partial" : "full"]}"],
                      context: context),
                ),
                itemCount: trucks.length,
              ),
            ),
            loading: () => const NoLoadsFoundWidget(),
            error: (error, stackTrace) {
              debugPrint("Error: $error");
              debugPrint("Error: $stackTrace");
              return const NoLoadsFoundWidget();
            },
          ),

        ],
      ),
    );
  }
}

