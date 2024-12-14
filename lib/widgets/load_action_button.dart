
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_constants.dart';

Widget loadActionButton(double width, String language,
    {required IconData icon, required String title, required Function() onPressed,
      required String description, required String description2,
    }) {
  return SizedBox(
    width: width * .435, height: 80.h,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        onPressed: onPressed,
        color: kLightBlack,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: kGreen,),
                SizedBox(width: 10.w,),
                Text(title, style: kCustomTextStyle,),

              ],
            ),

            SizedBox(height: 5.h,),
            Text("$description: $description2", style: kCustomTextStyle.copyWith(color: kWhite, fontSize: 13.w),),
          ],
        ),
      ),
    ),
  );
}