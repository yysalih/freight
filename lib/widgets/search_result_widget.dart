import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/models/load_model.dart';

import '../constants/app_constants.dart';

Widget searchResultWidget(double width, double height, String language,
    {required Function() onPressed, required LoadModel load}) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      color: kLightBlack,
      borderRadius: BorderRadius.circular(10),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        onPressed: onPressed,
        color: kLightBlack,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0.h),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("İstanbul TR\n${DateFormat("dd.MM.yyyy").format(load.startDate!)}", style: kCustomTextStyle,),
                  const Icon(Icons.fast_forward_sharp, color: kBlueColor,),

                  Icon(Icons.local_shipping, color: kWhite, size: 30.w,),

                  const Icon(Icons.fast_forward_sharp, color: kBlueColor,),
                  Text("Ankara TR\n${DateFormat("dd.MM.yyyy").format(load.endDate!)}", style: kCustomTextStyle, textAlign: TextAlign.end,),
                ],
              ),
              SizedBox(height: 10.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Steel Road Inc.", style: kCustomTextStyle,),
                      SizedBox(height: 3.h,),
                      Text(languages[language]![load.state!]!, style: kCustomTextStyle.copyWith(
                          color: kBlueColor
                      ),)
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("${load.price} ₺", style: kCustomTextStyle,),
                      SizedBox(height: 3.h,),
                      Text("${languages[language]!["est"]!} ${(load.price! / load.distance!).toStringAsFixed(2)}₺/KM",
                        style: kCustomTextStyle.copyWith(
                          color: kBlueColor, fontSize: 13.w,
                      ),)
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10.h,),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      for(int i = 0; i < 3; i++)
                        Padding(
                          padding: const EdgeInsets.only(right: 5.0),
                          child: Container(
                            height: 20.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: kWhite,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Center(
                                child: Text(["Fast", "Reliable", "Heavy"][i], style: kCustomTextStyle.copyWith(fontSize: 11.w, color: kLightBlack),),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                  Text("${load.distance!} KM", style: kCustomTextStyle,),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}