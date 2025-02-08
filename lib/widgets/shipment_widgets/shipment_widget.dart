import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kamyon/controllers/shipment_controller.dart';
import 'package:kamyon/models/base_unit_model.dart';
import 'package:kamyon/repos/load_repository.dart';
import 'package:kamyon/repos/truck_repository.dart';
import 'package:kamyon/widgets/load_info_widget.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../models/shipment_model.dart';
import '../../repos/user_repository.dart';
import '../../views/shipment_views/shipment_inner_view.dart';

Widget shipmentWidget(ShipmentModel shipment, {required String language, required BuildContext context}) {
  return Consumer(
    builder: (context, ref, child) {
      final shipmentNotifier = ref.watch(shipmentController.notifier);
      final shipmentOwnerProvider = ref.watch(userFutureProvider(shipment.loadOwnerUid));
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: MaterialButton(
            color: kLightBlack,
            onPressed: () {
              Navigator.push(context, routeToView(ShipmentInnerView(shipmentUid: shipment.uid!)));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: kBlueColor,
                        radius: 25,
                        child: Image.asset("assets/icons/${shipment.type == "load" ? "box" : "truck"}.png", width: 25,),
                      ),
                      SizedBox(width: 10.w,),
                      shipmentOwnerProvider.when(
                        data: (shipmentOwner) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(shipment.type == "load" ?
                            "${shipmentOwner.name}'in ${languages[language]!["load"]!}"
                              : "${shipmentOwner.name}'in ${languages[language]!["oftruck"]!}",
                              style: kCustomTextStyle,),
                            Text("${shipment.price!} TL", style: kCustomTextStyle,),
                            Text("${languages[language]![shipment.state!]}", style: kCustomTextStyle.copyWith(
                              fontSize: 15, color: Colors.blue,
                            ),),
                          ],
                        ),
                        loading: () => Container(),
                        error: (error, stackTrace) => Container(),
                      ),

                    ],
                  ),

                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(DateFormat('dd.MM.yyyy').format(shipment.date!), style: kCustomTextStyle,),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
