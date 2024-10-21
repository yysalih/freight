import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/repos/trailer_repository.dart';
import 'package:kamyon/repos/truck_repository.dart';
import 'package:kamyon/widgets/app_alert_dialogs_widget.dart';
import 'package:kamyon/widgets/custom_button_widget.dart';
import 'package:kamyon/widgets/input_field_widget.dart';
import 'package:kamyon/widgets/pick_city_modal_bottom_sheet.dart';
import 'package:kamyon/widgets/search_card_widget.dart';

import '../../constants/providers.dart';
import '../../constants/snackbars.dart';
import '../../controllers/truck_controller.dart';
import '../../widgets/truck_info_field_widget.dart';

class AddNewTruckView extends ConsumerWidget {
  final bool toEdit;
  final String truckUid;
  const AddNewTruckView({super.key, required this.truckUid, this.toEdit = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final width = MediaQuery.of(context).size.width;

    final truckState = ref.watch(truckController);
    final truckNotifier = ref.watch(truckController.notifier);

    final GlobalKey _menuKey = GlobalKey();

    final trailersProvider = ref.watch(trailersFutureProvider(FirebaseAuth.instance.currentUser!.uid));

    final truckProvider = ref.watch(truckFutureProvider(truckUid));



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
        title: Text(toEdit ? languages[language]!["edit_truck"]! : languages[language]!["add_new_truck"]!,
         style: const TextStyle(color: kWhite),),
        actions: [
          if(toEdit) truckProvider.when(
            data: (truck) => truck.ownerUid == FirebaseAuth.instance.currentUser!.uid ?
            IconButton(
              onPressed: () {
                showDeleteDialog(context: context, title: languages[language]!["delete_truck_title"]!,
                  content: languages[language]!["delete_truck_content"]!,
                  onPressed: () {
                    truckNotifier.deleteTruck(truckUid: truck.uid!,);
                    Navigator.pop(context);
                    showSnackbar(context: context, title: languages[language]!["truck_deleted_succesfully"]!);
                  },);

              },
              icon: const Icon(Icons.delete, color: kWhite,),
            ) : Container(),

            loading: () => Container(),
            error: (error, stackTrace) => Container(),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /*Column(
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
                SizedBox(height: 15.h,),*/
                Column(
                  children: [
                    customInputField(title: languages[language]!["truck_name"]!,
                        hintText: languages[language]!["enter_truck_name"]!, icon: Icons.local_shipping_outlined, onTap: () {
          
                        }, controller: truckNotifier.nameController),
                    SizedBox(height: 20.h,),
                    /*customInputField(title: languages[language]!["description"]!,
                        hintText: languages[language]!["enter_truck_description"]!, icon: Icons.local_shipping_outlined, onTap: () {
          
                      }, controller: truckNotifier.descriptionController),
                    SizedBox(height: 20.h,),*/
                    searchCardWidget(width, title: languages[language]!["registered_city"]!,
                        hint: truckState.city.isNotEmpty ? truckState.city : languages[language]!["enter_registered_city"]!,
                      halfLength: false, onPressed: () {
                        showModalBottomSheet(context: context, builder: (context) => const PickCityModalBottomSheet(),);
                      },),
                    SizedBox(height: 20.h,),

                    PopupMenuButton(
                      key: _menuKey,
                      onSelected: (value) {
                        truckNotifier.changeTruckType(value);
                      },
                      child: searchCardWidget(width, halfLength: false,
                        title: languages[language]!["vehicle_type"]!,
                        hint: truckState.truckType.isNotEmpty ? languages[language]![truckState.truckType]!
                            : languages[language]!["pick_a_type"]!, onPressed: () {
                          final dynamic popupMenu = _menuKey.currentState;
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
                SizedBox(height: 15.h,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(languages[language]!["truck_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                        Tooltip(
                          showDuration: const Duration(seconds: 4),
                          message: languages[language]!["trailer_tooltip"]!,
                          child: IconButton(
                            onPressed: () {

                            },
                            splashRadius: 20.w,
                            icon: const Icon(Icons.info_outline, color: kWhite,),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h,),
                    truckInfoField(width: width, title: languages[language]!["length"]!, suffixIcon: "mt", controller: truckNotifier.lengthController),
                    truckInfoField(width: width, title: languages[language]!["weight"]!, suffixIcon: "kg", controller: truckNotifier.weightController),
                    //truckInfoField(width: width, title: languages[language]!["price"]!, suffixIcon: "₺", controller: truckNotifier.priceController),
                  ],
                ),
                Row(
                  children: [
                    Checkbox(
                      value: truckState.hasTrailer,
                      checkColor: kWhite, hoverColor: kWhite, focusColor: kWhite,
                      onChanged: (value) => truckNotifier.changeTrailerMode(),
                    ),
                    Text(languages[language]!["my_truck_has_trailer"]!, style: kCustomTextStyle,),
                  ],
                ),
                truckState.hasTrailer ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(languages[language]!["trailer_details"]!, style: kTitleTextStyle.copyWith(color: kWhite),),
                        trailersProvider.when(
                          data: (trailers) {
                            return TextButton(
                              child: Text(languages[language]!["pick_existing_trailers"]!, style: TextStyle(color: kWhite),),
                              onPressed: () {


                                showTrailers(context: context,
                                    title: languages[language]!["pick_existing_trailers"]!,
                                    trailers: trailers,
                                    truckNotifier: truckNotifier, truckState: truckState);
                              },
                            );
                          },
                          error: (error, stackTrace) => Container(),
                          loading: () => Container(),
                        ),

                      ],
                    ),
                    SizedBox(height: 3.h,),

                    truckInfoField(width: width, title: languages[language]!["length"]!, suffixIcon: "mt", controller: truckNotifier.trailerLengthController),
                    truckInfoField(width: width, title: languages[language]!["weight"]!, suffixIcon: "kg", controller: truckNotifier.trailerWeightController),
                    customInputField(title: languages[language]!["trailer_name"]!,
                        hintText: languages[language]!["enter_trailer_name"]!, icon: Icons.local_shipping_outlined, onTap: () {

                        }, controller: truckNotifier.trailerNameController),
                  ],
                ) : Container(),
                SizedBox(height: truckState.hasTrailer ? 15.h : 5.h,),
                customButton(title: languages[language]!["save"]!, onPressed: () {
                  if(!toEdit) {
                    truckNotifier.createTruck(context, errorTitle: languages[language]!["error_creating_truck"]!,
                      successTitle: languages[language]!["success_creating_truck"]!);
                  }
                  else {
                    truckNotifier.editTruck(context, truckUid: truckUid, errorTitle: languages[language]!["error_editing_truck"]!,
                        successTitle: languages[language]!["success_editing_truck"]!);
                  }
                }),
              ],
            ),
          ),
        ),
      ),

    );
  }
}

