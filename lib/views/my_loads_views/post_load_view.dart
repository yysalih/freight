import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kamyon/constants/snackbars.dart';
import 'package:kamyon/controllers/auth_controller.dart';
import 'package:kamyon/controllers/load_controller.dart';
import 'package:kamyon/models/place_model.dart';
import 'package:kamyon/repos/user_repository.dart';
import 'package:kamyon/views/loads_views/search_results_view.dart';
import 'package:kamyon/widgets/custom_button_widget.dart';
import 'package:kamyon/widgets/input_field_widget.dart';
import 'package:uuid/uuid.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../controllers/place_controller.dart';
import '../../models/user_model.dart';
import '../../widgets/app_alert_dialogs_widget.dart';
import '../../widgets/search_card_widget.dart';
import '../inner_views/search_place_view.dart';


class PostLoadView extends ConsumerWidget {

  final bool toEdit;

  const PostLoadView({super.key, this.toEdit = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final width = MediaQuery.of(context).size.width;

    final loadNotifier = ref.watch(loadController.notifier);
    final loadState = ref.watch(loadController);

    final placeState = ref.watch(placeController);
    final placeNotifier = ref.watch(placeController.notifier);

    final userProvider = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));


    final GlobalKey _menuKey = GlobalKey();

    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          color: kWhite,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(languages[language]!["post_new_load"]!,
          style: const TextStyle(color: kWhite),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 15.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    searchCardWidget(width, title: languages[language]!["origin"]!,
                      hint: placeState.origin.name!.isNotEmpty ? placeState.origin.name! : "Ankara, TR",
                      onPressed: () {
                        //placeNotifier.clear();
                        Navigator.push(context, routeToView(const SearchPlaceView(isOrigin: true,)));
                    },),
                    searchCardWidget(width, title: languages[language]!["target"]!,
                      hint: placeState.destination.name!.isNotEmpty ? placeState.destination.name! : "İstanbul, TR",
                      onPressed: () {
                        //placeNotifier.clear();
                        Navigator.push(context, routeToView(const SearchPlaceView(isOrigin: false,)));
                    },),
                  ],
                ),
                SizedBox(height: 15.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    searchCardWidget(width, title: languages[language]!["length"]!,
                      hint: loadNotifier.lengthController.text.isEmpty ? "10" : loadNotifier.lengthController.text,
                        hasType: true, type: "mt", onPressed: () {
                      showInputDialog(context: context, title: languages[language]!["length"]!, hint: languages[language]!["enter_length"]!,
                          actionButtonText: languages[language]!["confirm"]!, controller: loadNotifier.lengthController, onPressed: () {
                            Navigator.pop(context);
                          },);
                      },),
                    searchCardWidget(width, title: languages[language]!["weight"]!,
                      hint: loadNotifier.weightController.text.isEmpty ? "100" : loadNotifier.weightController.text,
                      hasType: true, type: "kg", onPressed: () {
                        showInputDialog(context: context, title: languages[language]!["weight"]!, hint: languages[language]!["enter_weight"]!,
                          actionButtonText: languages[language]!["confirm"]!, controller: loadNotifier.weightController, onPressed: () {
                            Navigator.pop(context);
                          },);
                      },),
                    searchCardWidget(width, title: languages[language]!["load_volume"]!,
                      hint: loadNotifier.volumeController.text.isEmpty ? "100" : loadNotifier.volumeController.text,
                        hasType: true, type: "m3", onPressed: () {
                        showInputDialog(context: context, title: languages[language]!["volume"]!, hint: languages[language]!["enter_volume"]!,
                          actionButtonText: languages[language]!["confirm"]!, controller: loadNotifier.volumeController, onPressed: () {
                            Navigator.pop(context);
                          },);
                      },),

                  ],
                ),
                SizedBox(height: 15.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    searchCardWidget(width, title: languages[language]!["start_date"]!,
                      hint: DateTime.now().isAfter(loadState.startDate)
                          ? languages[language]!["pick_a_date"]! : DateFormat('dd.MM.yyyy').format(loadState.startDate),
                      onPressed: () {
                      showDatePicker(context: context, firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),).then((value) {
                          loadNotifier.switchDateTimes(startDate: value!, endDate: loadState.endDate);
                        },);
                    },),
                    searchCardWidget(width, title: languages[language]!["end_date"]!,
                      hint: DateTime.now().isAfter(loadState.endDate)
                          ? languages[language]!["pick_a_date"]! : DateFormat('dd.MM.yyyy').format(loadState.endDate),
                      onPressed: () {
                      showDatePicker(context: context, firstDate: loadState.startDate,
                        lastDate: DateTime.now().add(const Duration(days: 365)),).then((value) {
                          if(value!.isAfter(loadState.startDate)) {
                            loadNotifier.switchDateTimes(startDate: loadState.startDate, endDate: value);
                          } else {
                            showSnackbar(context: context, title: languages[language]!["end_date_must_be_after_than_first_date"]!);
                          }
                      },);
                    },),
                  ],
                ),
                /*SizedBox(height: 15.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    searchCardWidget(width, title: languages[language]!["start_time"]!,
                      hint: loadState.startHour.format(context),
                      onPressed: () {
                      showTimePicker(context: context, initialTime: TimeOfDay.now(),).then((value) {
                        loadNotifier.switchTimeOfDays(startHour: value!, endHour: loadState.endHour);
                      },);
                    },),
                    searchCardWidget(width, title: languages[language]!["end_time"]!,
                      hint: loadState.endHour.format(context),
                      onPressed: () {
                      showTimePicker(context: context, initialTime: TimeOfDay.now(),).then((value) {
                        loadNotifier.switchTimeOfDays(startHour: loadState.startHour, endHour: value!);
                      },);
                    },),
                  ],
                ),*/
                SizedBox(height: 15.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PopupMenuButton(
                      key: _menuKey,
                      onSelected: (value) {
                        loadNotifier.switchStrings(truckType: value, contact: loadState.contact);
                      },
                      child: searchCardWidget(width,
                        title: languages[language]!["vehicle_type"]!,
                        hint: loadState.truckType.isNotEmpty ? languages[language]![loadState.truckType]!
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
                    searchCardWidget(width, title: languages[language]!["equipment_limits"]!,
                      hint: loadState.isPartial ? languages[language]!["partial"]! : languages[language]!["full"]!,
                        type: "", onPressed: () {
                      loadNotifier.switchBools(isPartial: !loadState.isPartial, isPalletized: loadState.isPalletized);
                      },),
                  ],
                ),

                SizedBox(height: 15.h,),


                /*
                searchCardWidget(width, title: languages[language]!["load_type"]!,
                  hint: loadState.isPalletized ? languages[language]!["palletized"]! : languages[language]!["bulk"]!,
                  halfLength: false, onPressed: () {
                    loadNotifier.switchBools(isPartial: loadState.isPartial, isPalletized: !loadState.isPalletized);
                  },),
                SizedBox(height: 15.h,),
                userProvider.when(
                  data: (currentUser) => searchCardWidget(width, title: languages[language]!["contact_phone"]!,
                    hint: loadState.contact.isNotEmpty ? loadState.contact : languages[language]!["enter_contact_phone"]!,

                    halfLength: false, onPressed: () {
                      showContacts<LoadController, LoadState>(context: context,
                        title: languages[language]!["pick_a_phone_number"]!,
                        currentUser: currentUser, notifier: loadNotifier, state: loadState,
                        actionButtonText: languages[language]!["confirm"]!,
                        addNewPhoneText: languages[language]!["add_new_phone_number"]!,);
                    },),
                  loading: () => Container(),
                  error: (error, stackTrace) {
                    debugPrint(error.toString());
                    debugPrint(stackTrace.toString());
                    return Container();
                  },
                ),*/
                SizedBox(height: 15.h,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    customInputField(title: languages[language]!["price"]!, hintText: languages[language]!["enter_price"]!, icon: Icons.monetization_on, onTap: () {
                        }, controller: loadNotifier.priceController, onChanged: (value) {

                    },),
                    SizedBox(height: 5.h,),
                    Text("${languages[language]!["per_km"]!} 20 \$", style: kCustomTextStyle,)
                  ],
                ),
                SizedBox(height: 20.h,),
                customButton(title: languages[language]!["confirm"]!, onPressed: () async {
                  loadNotifier.switchAppPlaceModels(
                    origin: placeState.origin,
                    destination: placeState.destination
                  );

                  await placeNotifier.createPlace(context, appPlaceModel: placeState.origin,);
                  await placeNotifier.createPlace(context, appPlaceModel: placeState.destination,);

                  loadNotifier.createLoad(context, errorTitle: languages[language]!["problem_creating_new_load"]!,
                      successTitle: languages[language]!["new_load_created"]!);
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
