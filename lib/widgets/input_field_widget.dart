import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';

Widget customInputField({required String title, required String hintText, required IconData icon,
  bool isSecured = false, bool hasTitle = true, double borderRadius = 10, bool isEnable = true, required Function() onTap}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      !hasTitle ? Container() : Text(title, style: kTitleTextStyle.copyWith(color: kWhite),),
      !hasTitle ? Container() : SizedBox(height: 3.h,),
      ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: kLightBlack,
          child: TextField(
            enabled: isEnable,
            style: kCustomTextStyle,
            onTap: onTap,
            decoration: kInputDecoration.copyWith(
              contentPadding: const EdgeInsets.all(10),
              hintText: hintText,
              hintStyle: const TextStyle(color: kHintColor),
              prefixIcon: Icon(icon, color: kHintColor,)
            ),
          ),
        ),
      ),
    ],
  );
}
