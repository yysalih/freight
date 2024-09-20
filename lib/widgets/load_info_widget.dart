import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_constants.dart';

Widget loadInfoWidget(double width, double height, {required String title, required String description}) {
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
            title == "Değerlendirme" ? Row(
              children: [
                const Text("5.0", style: kCustomTextStyle,),
                SizedBox(width: 5.w,),
                for(int i = 0; i < 5; i++)
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