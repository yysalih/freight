import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/providers.dart';
import 'package:kamyon/views/trucks_views/new_post_view.dart';

import '../constants/app_constants.dart';
import '../constants/languages.dart';
import '../models/truck_model.dart';

Widget truckCardWidget(String language, {required BuildContext context, required double width, required TruckModel truck,
  required List<String> tags, required Function() onTap}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 15.0.h),
    child: Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: kLightBlack,
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.local_shipping, color: kBlueColor, size: 35.w,),
                      SizedBox(width: 10.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(truck.name!, style: kTitleTextStyle.copyWith(color: kWhite),),
                          SizedBox(
                            width: width * .75,
                            child: Text(truck.description!, style: kCustomTextStyle.copyWith(color: kWhite, fontSize: 13.w),),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  Row(
                    children: [
                      for(int i = 0; i < tags.length; i++)
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
                                child: Text(tags[i], style: kCustomTextStyle.copyWith(fontSize: 11.w, color: kLightBlack),),
                              ),
                            ),
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.h,),
          Container(
            width: width, height: 35.h,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
              color: kLightBlack,
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(10)),
              child: MaterialButton(
                onPressed: () {
                  Navigator.push(context, routeToView(NewPostView(truckUid: truck.uid!, truckPostUid: "", toEdit: false,)));
                },
                color: kBlueColor,
                child: Row(
                  children: [
                    const Icon(Icons.add, color: kWhite,),
                    SizedBox(width: 5.w,),
                    Text(languages[language]!["new_post_with_vehicle"]!, style: kCustomTextStyle.copyWith(
                      fontSize: 13.w
                    ),)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}