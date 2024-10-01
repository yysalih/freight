import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/controllers/load_controller.dart';
import 'package:kamyon/controllers/truck_controller.dart';
import 'package:kamyon/models/trailer_model.dart';

import '../constants/app_constants.dart';
import '../models/user_model.dart';

showInputDialog({required BuildContext context,
  required String title, required String hint, required String actionButtonText,
  required Function() onPressed,
  required TextEditingController controller}) {
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      backgroundColor: kBlack,
      title: Text(title, style: const TextStyle(color: kWhite),),
      content: TextField(
        controller: controller,
        style: const TextStyle(color: kWhite),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: kWhite)
        ),
      ),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Text(actionButtonText, style: const TextStyle(color: kWhite)),
        )
      ],
    );
  },);
}

showContacts({required BuildContext context, required String title,
   required UserModel currentUser, required String actionButtonText, required String addNewPhoneText,
  required LoadController loadNotifier, required LoadState loadState}) {
  showDialog(context: context, builder: (context) => AlertDialog(
    backgroundColor: kBlack,
    title: Text(title, style: const TextStyle(color: kWhite),),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for(int i = 0; i < currentUser.contactNumbers.length - 1; i++)
          MaterialButton(
            onPressed: () {
              loadNotifier.switchStrings(truckType: loadState.truckType, contact: currentUser.contactNumbers[i]);
              Navigator.pop(context);
            },
            child: Row(
              children: [
                currentUser.contactNumbers[i] == loadState.contact ? const Icon(Icons.done, color: kGreen,) : Container(),
                SizedBox(width: 10.w,),
                Text(currentUser.contactNumbers[i], style: kCustomTextStyle,),
              ],
            ),
          ),
        TextButton(
          onPressed: () {
            showInputDialog(context: context,
                title: title,
                hint: "+90 553 088 28 98",
                actionButtonText: actionButtonText,
                onPressed: () {
                  loadNotifier.addNewPhoneNumberToUser(currentUser: currentUser);
                  Navigator.pop(context);
                },
                controller: loadNotifier.phoneController);
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Icon(Icons.add, color: kWhite,),
              SizedBox(width: 10.w,),
              Text(addNewPhoneText, style: const TextStyle(color: kWhite),),
            ],
          ),
        ),
      ],
    ),
    actions: [

    ],
  ));
}


showTrailers({required BuildContext context, required String title,
   required List<TrailerModel> trailers, required String actionButtonText, required String pickTrailerText,
  required TruckController truckNotifier, required TruckState truckState}) {
  showDialog(context: context, builder: (context) => AlertDialog(
    backgroundColor: kBlack,
    title: Text(title, style: const TextStyle(color: kWhite),),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for(int i = 0; i < trailers.length; i++)
          MaterialButton(
            onPressed: () {
              truckNotifier.changeTrailerUid(trailers[i].uid!);
              Navigator.pop(context);
            },
            child: Row(
              children: [
                trailers[i].uid == truckState.trailerUid ? const Icon(Icons.done, color: kGreen,) : Container(),
                SizedBox(width: 10.w,),
                Text(trailers[i].name!, style: kCustomTextStyle,),
              ],
            ),
          ),

      ],
    ),
    actions: [

    ],
  ));
}

