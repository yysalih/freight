import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/controllers/place_controller.dart';
import 'package:kamyon/repos/place_repository.dart';
import 'package:kamyon/repos/truck_posts_repository.dart';
import 'package:kamyon/views/trucks_views/new_post_view.dart';
import 'package:kamyon/views/trucks_views/truck_post_inner_view.dart';
import 'package:kamyon/widgets/search_result_widget.dart';
import 'package:kamyon/widgets/truck_card_widget.dart';
import 'package:kamyon/widgets/warning_info_widget.dart';

import '../constants/languages.dart';
import '../constants/providers.dart';
import '../controllers/truck_controller.dart';
import '../repos/trailer_repository.dart';
import '../repos/truck_repository.dart';
import '../views/trucks_views/add_new_truck_view.dart';

class MyTrucksWidget extends ConsumerWidget {
  const MyTrucksWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);
    final width = MediaQuery.of(context).size.width;

    final trucksProvider = ref.watch(trucksStreamProvider(FirebaseAuth.instance.currentUser!.uid));
    final truckNotifier = ref.watch(truckController.notifier);

    return trucksProvider.when(
      data: (trucks) => trucks.isEmpty ?
      const NoLoadsFoundWidget()
          :  Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) {
            final trailerProvider = ref.watch(trailerFutureProvider(trucks[index].trailerUid!));
            return Padding(
              padding: EdgeInsets.only(top: 15.0.h),
              child:
              trucks[index].trailerUid!.isNotEmpty ?
              trailerProvider.when(
                data: (trailer) {

                  return truckCardWidget(language, width: width,
                    truck: trucks[index],
                    tags: ["${trucks[index].length} mt", "${trucks[index].weight} kg", "${languages[language]![trucks[index].isPartial! ? "partial" : "full"]}"],
                    context: context, onTap: () {

                      truckNotifier.nameController.text = trucks[index].name!;
                      truckNotifier.descriptionController.text = trucks[index].description!;
                      truckNotifier.lengthController.text = trucks[index].length.toString();
                      truckNotifier.weightController.text = trucks[index].weight.toString();
                      truckNotifier.changeCity(trucks[index].city!);
                      truckNotifier.changeTruckType(trucks[index].type!);


                      truckNotifier.changeTrailerModel(trailer: trailer);

                      Navigator.push(context, routeToView(AddNewTruckView(toEdit: true, truckUid: trucks[index].uid!)));
                    },);
                },
                loading: () => const NoLoadsFoundWidget(),
                error: (error, stackTrace) {
                  debugPrint("Error: $error");
                  debugPrint("Error: $stackTrace");
                  return const NoLoadsFoundWidget();
                },
              )
                  :
              truckCardWidget(language, width: width,
                truck: trucks[index],
                tags: ["${trucks[index].length} mt", "${trucks[index].weight} kg", "${languages[language]![trucks[index].isPartial! ? "partial" : "full"]}"],
                context: context, onTap: () {

                  truckNotifier.nameController.text = trucks[index].name!;
                  truckNotifier.descriptionController.text = trucks[index].description!;
                  truckNotifier.lengthController.text = trucks[index].length.toString();
                  truckNotifier.weightController.text = trucks[index].weight.toString();
                  truckNotifier.changeCity(trucks[index].city!);
                  truckNotifier.changeTruckType(trucks[index].type!);


                  Navigator.push(context, routeToView(AddNewTruckView(toEdit: true, truckUid: trucks[index].uid!,)));
                },),
            );
          },
          itemCount: trucks.length,
        ),
      ),
      loading: () => Container(),
      error: (error, stackTrace) {
        debugPrint("Error: $error");
        debugPrint("Error: $stackTrace");
        return const NoLoadsFoundWidget();
      },
    );
  }
}

class MyTruckPostsWidget extends ConsumerWidget {
  const MyTruckPostsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final language = ref.watch(languageStateProvider);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final truckPostsProvider = ref.watch(truckPostsStreamProvider(FirebaseAuth.instance.currentUser!.uid));

    final truckNotifier = ref.watch(truckController.notifier);
    final placeNotifier = ref.watch(placeController.notifier);
    final placeState = ref.watch(placeController);


    return truckPostsProvider.when(
      data: (truckPosts) => truckPosts.isEmpty ?
      const NoLoadsFoundWidget()
          :  Expanded(
        child: ListView.builder(
          itemBuilder: (context, index) {
            debugPrint("Places are set for TruckPosts View: ${truckPosts[index].uid}");

            final originProvider = ref.watch(placeFutureProvider(truckPosts[index].origin!));
            final destinationProvider = ref.watch(placeFutureProvider(truckPosts[index].destination!));
            return originProvider.when(
              data: (origin) => destinationProvider.when(
                data: (destination) => Padding(
                    padding: EdgeInsets.only(top: 15.0.h),
                    child: truckPostsWidget(width, height, language, truckPost: truckPosts[index],
                        onPressed: () {
                      placeNotifier.setPlaceModels(origin: origin, destination: destination);
                      debugPrint("Places are set for TruckPosts View");
                      truckNotifier.descriptionController.text = truckPosts[index].description!;
                      truckNotifier.priceController.text = truckPosts[index].price.toString();
                      truckNotifier.switchStartDateTime(startDate: truckPosts[index].startDate!);
                      truckNotifier.switchEndDateTime(endDate: truckPosts[index].endDate!);
                      truckNotifier.switchAppPlaceModels(origin: origin, destination: destination);
                      truckNotifier.switchStrings(truckType: "", contact: truckPosts[index].contact!);

                      Navigator.push(context, routeToView(TruckPostInnerView(uid: truckPosts[index].uid!)));
                    },)
                ),
                loading: () => Container(),
                error: (error, stackTrace) {
                  debugPrint("Error: $error");
                  debugPrint("Error: $stackTrace");
                  return const NoLoadsFoundWidget();
                },
              ),
              loading: () => Container(),
              error: (error, stackTrace) {
                debugPrint("Error: $error");
                debugPrint("Error: $stackTrace");
                return const NoLoadsFoundWidget();
              },
            );
          },
          itemCount: truckPosts.length,
        ),
      ),
      loading: () => Container(),
      error: (error, stackTrace) {
        debugPrint("Error: $error");
        debugPrint("Error: $stackTrace");
        return const NoLoadsFoundWidget();
      },
    );
  }
}


