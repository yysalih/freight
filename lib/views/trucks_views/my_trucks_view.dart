import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/controllers/truck_controller.dart';
import 'package:kamyon/repos/trailer_repository.dart';
import 'package:kamyon/repos/truck_repository.dart';
import 'package:kamyon/views/trucks_views/add_new_truck_view.dart';
import 'package:kamyon/widgets/search_result_widget.dart';
import 'package:kamyon/widgets/trucks_view_body_widget.dart';

import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../widgets/truck_card_widget.dart';
import '../../widgets/warning_info_widget.dart';

class MyTrucksView extends ConsumerWidget {
  const MyTrucksView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);


    final truckNotifier = ref.watch(truckController.notifier);
    final truckState = ref.watch(truckController);

    return Padding(
      padding: EdgeInsets.only(top: 10.h, right: 15.w, left: 15.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(languages[language]![truckState.showTruckPosts ? "my_truck_posts" : "my_vehicles"]!,
                    style: kTitleTextStyle.copyWith(color: kWhite),),
                  IconButton(
                    onPressed: () {
                      truckNotifier.switchToTruckPosts();
                    },
                    icon: const Icon(Icons.change_circle_outlined, color: kWhite,),
                  ),
                ],
              ),
              TextButton(
                child: Text(languages[language]!["new_vehicle"]!, style: kCustomTextStyle.copyWith(fontSize: 13.w,
                  color: kBlueColor),),
                onPressed: () {
                  Navigator.push(context, routeToView(const AddNewTruckView(toEdit: false, truckUid: "",)));
                },
              )
            ],
          ),

          truckState.showTruckPosts ?
          const MyTruckPostsWidget() :
          const MyTrucksWidget(),

        ],
      ),
    );
  }
}

