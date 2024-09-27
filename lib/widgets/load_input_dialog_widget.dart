import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../constants/app_constants.dart';
import '../models/user_model.dart';

showInputDialog({required BuildContext context,
  required String title, required String hint, required String actionButtonText,
  required Function() onPressed,
  required TextEditingController controller}) {
  showDialog(context: context, builder: (context) {
    return AlertDialog(
      backgroundColor: kBlack,
      title: Text(title, style: TextStyle(color: kWhite),),
      content: TextField(
        controller: controller,
        style: TextStyle(color: kWhite),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: kWhite)
        ),
      ),
      actions: [
        TextButton(
          onPressed: onPressed,
          child: Text(actionButtonText, style: TextStyle(color: kWhite)),
        )
      ],
    );
  },);
}

showContacts({required BuildContext context, required String title, required UserModel currentUser, required String actionButtonText}) {
  showDialog(context: context, builder: (context) => AlertDialog(
    backgroundColor: kBlack,
    title: Text(title, style: TextStyle(color: kWhite),),
    content: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for(int i = 0; i < currentUser.contactNumbers.length - 1; i++)
          MaterialButton(
            onPressed: () {

            },
            child: Row(
              children: [
                Checkbox(
                  onChanged: (value) {

                  },
                  value: false,
                ),
                Text(currentUser.contactNumbers[i], style: kCustomTextStyle,),
              ],
            ),
          )
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {

        },
        child: Text(actionButtonText, style: TextStyle(color: kWhite)),
      )
    ],
  ),);
}