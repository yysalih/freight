import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';

Widget customButton({required String title, Color color = kGreen, required Function() onPressed, bool inProgress = false}) {

  return SizedBox(
    height: 40.h,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: MaterialButton(
        color: color,
        onPressed: onPressed,
        child: inProgress ?
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white
            ))
            : Center(child: Text(title, style: kTitleTextStyle.copyWith(color: Colors.white),),),
      ),
    ),
  );
}
