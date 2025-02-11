import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_constants.dart';
import '../controllers/auth_controller.dart';

Widget fileCardWidget({required String title, required String image,
  required Color color, required Function() onPressed, }) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(title, style: kCustomTextStyle,),
      SizedBox(height: 3.h,),
      SizedBox(
        height: 125, width: 125,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: MaterialButton(
            onPressed: onPressed,
            color: color,
            child: Image.asset("assets/icons/$image.png", width: 60.w,),
          ),
        ),
      ),
    ],
  );
}

Widget fileCardWidget2({required String title, required IconData icon,
  required Color color, required bool isUploaded, required Function() onPressed}) {
  return SizedBox(
    height: 50,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        onPressed: onPressed,
        color: color,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(icon, color: kWhite,),
                SizedBox(width: 5.w,),
                Text(title, style: kCustomTextStyle,),
              ],
            ),
            if(isUploaded) const Icon(Icons.done, color: Colors.green, size: 20,),
          ],
        )
      ),
    ),
  );
}

Widget fileCardWidget3({required String title, required String image, required Color color, required Function() onPressed}) {
  return SizedBox(
    height: 100.h, width: 100.w,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        onPressed: onPressed,
        color: color,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/$image.png", width: 50.w,),
            SizedBox(height: 4.h,),
            Text(title, style: kCustomTextStyle.copyWith(fontSize: 13.w),),

          ],
        ),
      ),
    ),
  );
}