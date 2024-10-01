import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/controllers/truck_controller.dart';

class PickCityModalBottomSheet extends ConsumerWidget {
  const PickCityModalBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;

    final truckNotifier = ref.watch(truckController.notifier);
    final truckState = ref.watch(truckController);

    return Container(
      height: height * .85,
      color: kBlack,
      child: ListView.builder(
        itemBuilder: (context, index) => MaterialButton(
          height: 40.h,
          onPressed: () {
            truckNotifier.changeCity(cities[index]);
            Navigator.pop(context);
          },
          child: Row(
            children: [
              truckState.city == cities[index] ? const Icon(Icons.done, color: Colors.green,) : const SizedBox(),
              const SizedBox(width: 5,),
              Text(cities[index], style: kCustomTextStyle,),
            ],
          ),
        ),
        itemCount: cities.length,
      ),
    );
  }
}
