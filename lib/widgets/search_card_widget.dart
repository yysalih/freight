
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_constants.dart';

Widget searchCardWidget(double width, {required String title, required String hint,
  bool halfLength = true, bool hasType = false, String type = "", required Function() onPressed}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: kTitleTextStyle.copyWith(color: kWhite),),
      SizedBox(height: 5.h,),
      SizedBox(
        width: halfLength ? hasType ? width * .275 : width * .43 : width, height: 40.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: MaterialButton(
            color: kLightBlack,
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(hint, style: kCustomTextStyle.copyWith(color: kHintColor, fontSize: hasType ? 13.w : 13.w),),
                hasType ? Text(type, style: kCustomTextStyle.copyWith(fontSize: 13.w),)
                    : Icon(Icons.arrow_forward_ios, color: kHintColor, size: 13.w,)
              ],
            ),
          ),
        ),
      ),
    ],
  );
}
