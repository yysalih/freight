import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/constants/providers.dart';
import 'package:kamyon/controllers/truck_controller.dart';

import '../../controllers/shipment_controller.dart';

class ShipmentStateModalBottomSheet extends ConsumerWidget {
  final String shipmentUid;
  const ShipmentStateModalBottomSheet({super.key, required this.shipmentUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;

    final language = ref.watch(languageStateProvider);

    final shipmentNotifier = ref.watch(shipmentController.notifier);
    final shipmentState = ref.watch(shipmentController);

    return Container(
      height: height * .85,
      color: kBlack,
      child: ListView.builder(
        itemBuilder: (context, index) => MaterialButton(
          height: 40.h,
          onPressed: () {
            shipmentNotifier.changeShipmentState(shipmentStates[index]);
            shipmentNotifier.updateShipmentState(context, shipmentUid: shipmentUid,
                newState: shipmentStates[index], errorTitle: "", successTitle: "");
            Navigator.pop(context);
          },
          child: Row(
            children: [
              shipmentState.shipmentStatus == shipmentStates[index]
                  ? const Icon(Icons.done, color: Colors.green,) : const SizedBox(),
              const SizedBox(width: 5,),
              Text(languages[language]![shipmentStates[index]]!, style: kCustomTextStyle,),
            ],
          ),
        ),
        itemCount: shipmentStates.length,
      ),
    );
  }
}