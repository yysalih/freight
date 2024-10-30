import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';

Widget customInputField({
  required String title,
  required String hintText,
  required IconData icon,
  bool isSecured = false,
  bool hasTitle = true,
  double borderRadius = 10,
  bool isEnable = true,
  bool hasIcon = true,
  required TextEditingController controller,
  required Function() onTap,
  required Function(String value) onChanged,
  }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if(hasTitle) ...[
        Text(title, style: kTitleTextStyle.copyWith(color: kWhite),),
        SizedBox(height: 3.h,),
      ],
      ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: kLightBlack,
          child: TextField(
            controller: controller,
            enabled: isEnable,
            style: kCustomTextStyle,
            onChanged: onChanged,
            onTap: onTap,
            decoration: kInputDecoration.copyWith(
              contentPadding: const EdgeInsets.all(10),
              hintText: hintText,
              hintStyle: const TextStyle(color: kHintColor),
              prefixIcon: hasIcon ? Icon(icon, color: kHintColor,) : null,
            ),
          ),
        ),
      ),
    ],
  );
}


Widget customRichInputField({
  required String title,
  required String hintText,
  required IconData icon,
  bool isSecured = false,
  bool hasTitle = true,
  double borderRadius = 10,
  bool isEnable = true,
  required TextEditingController controller,
  int maxLines = 5,
  double bottom = 70,
  required Function() onTap,
  }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if(hasTitle) ...[
        Text(title, style: kTitleTextStyle.copyWith(color: kWhite),),
        SizedBox(height: 3.h,),
      ],
      ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Material(
          color: kLightBlack,
          child: TextField(
            controller: controller,
            enabled: isEnable,
            style: kCustomTextStyle,
            onTap: onTap,
            decoration: kInputDecoration.copyWith(
              contentPadding: const EdgeInsets.all(10),
              hintText: hintText,
              hintStyle: const TextStyle(color: kHintColor),
              prefixIcon: Padding(
                padding: EdgeInsets.only(bottom: bottom),
                child: Icon(icon, color: kHintColor,),
              ),
            ),
            maxLines: maxLines,
          ),
        ),
      ),
    ],
  );
}
