
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_constants.dart';

Widget loadActionButton(double width, String language,
    {required IconData icon, required String title, required Function() onPressed,
      required String description, required String description2,
    }) {
  return SizedBox(
    width: width * .275, height: 50.h,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        onPressed: onPressed,
        color: kLightBlack,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: kGreen,),
            SizedBox(width: 5.w,),
            Text(title, style: kCustomTextStyle,),

          ],
        ),
      ),
    ),
  );
}