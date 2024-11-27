import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/languages.dart';

import '../constants/app_constants.dart';

Widget loadInfoWidget(double width, double height, {required String title, required String description, String language = "tr", double point = 5.0}) {
  return Padding(
    padding: EdgeInsets.only(top: 12.h),
    child: Container(
      width: width, height: 40.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kLightBlack,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: kCustomTextStyle.copyWith(fontWeight: FontWeight.bold),),
            title == languages[language]!["rating"] ? Row(
              children: [
                Text(point.toStringAsFixed(1), style: kCustomTextStyle,),
                SizedBox(width: 5.w,),
                for(int i = 0; i < point; i++)
                  Padding(
                    padding: EdgeInsets.only(right: 3.w),
                    child: const Icon(Icons.star, color: Colors.orange,),
                  )
              ],
            ) : Text(description, style: kCustomTextStyle.copyWith(fontSize: 13.w),),
          ],
        ),
      ),
    ),
  );
}