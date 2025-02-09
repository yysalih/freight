import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kamyon/controllers/place_controller.dart';
import 'package:kamyon/controllers/truck_controller.dart';
import 'package:kamyon/repos/truck_repository.dart';
import 'package:kamyon/views/inner_views/search_place_view.dart';
import 'package:kamyon/widgets/app_alert_dialogs_widget.dart';
import 'package:kamyon/widgets/custom_button_widget.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../constants/snackbars.dart';
import '../../models/place_model.dart';
import '../../repos/truck_posts_repository.dart';
import '../../repos/user_repository.dart';
import '../../widgets/input_field_widget.dart';
import '../../widgets/search_card_widget.dart';

class NewPostView extends ConsumerWidget {
  final String truckUid;
  final String truckPostUid;
  final bool toEdit;

  const NewPostView({super.key, required this.truckUid, required this.truckPostUid, required this.toEdit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final width = MediaQuery.of(context).size.width;

    final truckProvider = ref.watch(truckStreamProvider(truckUid));
    final truckPostProvider = ref.watch(truckPostStreamProvider(truckPostUid));

    final truckNotifier = ref.watch(truckController.notifier);
    final truckState = ref.watch(truckController);

    final placeState = ref.watch(placeController);
    final placeNotifier = ref.watch(placeController.notifier);

    final userProvider = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));

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
        title: Text(languages[language]!["post_your_car"]!,
          style: const TextStyle(color: kWhite),),
        actions: [
          if(toEdit) truckPostProvider.when(
            data: (truckPost) => truckPost.ownerUid == FirebaseAuth.instance.currentUser!.uid ?
            IconButton(
              onPressed: () {
                showDeleteDialog(context: context, title: languages[language]!["delete_truck_post_title"]!,
                  content: languages[language]!["delete_truck_post_content"]!,
                  onPressed: () {
                    truckNotifier.deleteTruckPost(truckPostUid: truckPost.uid!,);
                    Navigator.pop(context);
                    showSnackbar(context: context, title: languages[language]!["truck_post_deleted_succesfully"]!);
                  },);

              },
              icon: const Icon(Icons.delete, color: kWhite,),
            ) : Container(),

            loading: () => Container(),
            error: (error, stackTrace) {
              debugPrint("Error: ${error.toString()}");
              debugPrint("Error: ${stackTrace.toString()}");
              return Container();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              truckProvider.when(
                data: (truck) => Container(
                  width: width,
                  decoration: BoxDecoration(
                      color: kLightBlack,
                      borderRadius: BorderRadius.circular(10.h)
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0.h, vertical: 25.h),
                    child: Row(
                      children: [
                        Icon(Icons.local_shipping, color: kBlueColor, size: 40.h,),
                        SizedBox(width: 20.w,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(truck.name!, style: kTitleTextStyle.copyWith(color: kWhite),),
                            SizedBox(height: 5.h,),
                            Row(
                              children: [
                                for(int i = 0; i < 3; i++)
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5.0),
                                    child: Container(
                                      height: 20.h,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: kWhite,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 12),
                                        child: Center(
                                          child: Text(["${truck.length} mt", "${truck.weight} kg", "${languages[language]![truck.isPartial! ? "partial" : "full"]}"][i],
                                            style: kCustomTextStyle.copyWith(fontSize: 11.w, color: kLightBlack),),
                                        ),
                                      ),
                                    ),
                                  )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                error: (error, stackTrace) => Container(),
                loading: () => Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  searchCardWidget(width, title: languages[language]!["origin"]!,
                    hint: placeState.origin.name!.isNotEmpty ? placeState.origin.name! : "Ankara, TR",
                    onPressed: () {
                    if(!toEdit) {
                      Navigator.push(context, routeToView(const SearchPlaceView(isOrigin: true,)));
                    }
                  },),
                  searchCardWidget(width, title: languages[language]!["target"]!,
                    hint: placeState.destination.name!.isNotEmpty ? placeState.destination.name! : "İstanbul, TR",
                    onPressed: () {
                    if(!toEdit) {
                      Navigator.push(context, routeToView(const SearchPlaceView(isOrigin: false,)));
                    }

                  },),
                ],
              ),
              /*Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  searchCardWidget(width, title: languages[language]!["start_date"]!,
                    hint: DateTime.now().isAfter(truckState.startDate)
                        ? DateFormat('dd.MM.yyyy').format(DateTime.now())
                        : DateFormat('dd.MM.yyyy').format(truckState.startDate),
                    onPressed: () {
                      if(!toEdit) {
                        showDatePicker(context: context, firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),).then((value) {
                        truckNotifier.switchStartDateTime(startDate: value!);
                      },);
                      }
                    },
                  ),
                  searchCardWidget(width, title: languages[language]!["end_date"]!,
                    hint: DateTime.now().isAfter(truckState.endDate)
                        ? DateFormat('dd.MM.yyyy').format(DateTime.now())
                        : DateFormat('dd.MM.yyyy').format(truckState.endDate),
                    onPressed: () {
                      if(!toEdit) {
                        showDatePicker(context: context, firstDate: truckState.startDate,
                        lastDate: DateTime.now().add(const Duration(days: 365)),).then((value) {
                        if(value!.isAfter(truckState.startDate)) {
                          truckNotifier.switchEndDateTime(endDate: value);
                        } else {
                          showSnackbar(context: context, title: languages[language]!["end_date_must_be_after_than_first_date"]!);
                        }
                      },);
                      }
                    },
                  ),
                ],
              ),*/
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  customInputField(title: languages[language]!["price"]!,
                      hintText: languages[language]!["enter_price"]!, icon: Icons.monetization_on, onTap: () {

                  }, controller: truckNotifier.priceController, onChanged: (value) {

                    },),
                  SizedBox(height: 5.h,),
                  Text("${languages[language]!["per_km"]!} 20 \$", style: kCustomTextStyle,)
                ],
              ),


              customInputField(title: languages[language]!["description"]!, hintText: languages[language]!["enter_description"]!,
                  icon: Icons.description, onTap: () {

                  }, controller: truckNotifier.descriptionController, onChanged: (value) {

                },),

              if(!toEdit) customButton(title: languages[language]!["confirm"]!, onPressed: () async {
                truckNotifier.switchAppPlaceModels(
                  origin: placeState.origin,
                  destination: placeState.destination,
                );

                await placeNotifier.createPlace(context, appPlaceModel: placeState.origin,);
                await placeNotifier.createPlace(context, appPlaceModel: placeState.destination,);

                await truckNotifier.createTruckPost(context, truckUid: truckUid,
                    errorTitle: languages[language]!["problem_creating_new_truck_post"]!,
                    successTitle: languages[language]!["new_truck_post_created"]!);
              },)
            ],
          ),
        ),
      ),
    );
  }
}
