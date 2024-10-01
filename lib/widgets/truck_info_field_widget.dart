import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_constants.dart';

Widget truckInfoField({required double width, required String title, required String suffixIcon, required TextEditingController controller}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20.0),
    child: Container(
      width: width, height: 40.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: kLightBlack
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: kCustomTextStyle,),
            Row(
              children: [
                SizedBox(
                  width: width * .3, height: 20.h,
                  child: TextField(
                    controller: controller,
                    keyboardType: TextInputType.number,
                    style: kCustomTextStyle,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(10),

                    ),
                  ),
                ),
                SizedBox(width: 10.w,),
                Text(suffixIcon, style: kCustomTextStyle,),
              ],
            ),

          ],
        ),
      ),
    ),
  );
}