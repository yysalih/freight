import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/constants/providers.dart';
import 'package:kamyon/models/load_model.dart';
import 'package:kamyon/models/place_model.dart';
import 'package:kamyon/repos/truck_repository.dart';
import 'package:kamyon/repos/user_repository.dart';

import '../constants/app_constants.dart';
import '../controllers/place_controller.dart';
import '../models/truck_post_model.dart';

Widget searchResultWidget(double width, double height, String language,
    {required Function() onPressed, required LoadModel load,}) {
  return Consumer(
    builder: (context, ref, child) {

      final userProvider = ref.watch(userStreamProvider(load.ownerUid));

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
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: width * .3),
                        child: Text(load.originName!,
                          style: kCustomTextStyle, maxLines: 3, overflow: TextOverflow.ellipsis,),
                      ),
                      const Icon(Icons.fast_forward_sharp, color: kWhite,),

                      Icon(Icons.local_shipping, color: kBlueColor, size: 30.w,),

                      const Icon(Icons.fast_forward_sharp, color: kWhite,),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: width * .3),
                        child: Text("${load.destinationName}",

                          style: kCustomTextStyle, maxLines: 3, overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          userProvider.when(
                            data: (owner) => Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(owner.image!),
                                  radius: 15.w,
                                ),
                                SizedBox(width: 7.5.w,),
                                Text(owner.name!, style: kCustomTextStyle,),
                              ],
                            ),
                            loading: () => Container(),
                            error: (error, stackTrace) => Container(),
                          ),
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
                                    child: Text(["${load.length} mt", "${load.weight} kg", "${languages[language]![load.isPartial! ? "partial" : "full"]}"][i], style: kCustomTextStyle.copyWith(fontSize: 11.w, color: kLightBlack),),
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
    },
    child: Container(),
  );
}

Widget smallerSearchResultWidget(double width, double height, String language,
    {required Function() onPressed, required LoadModel load}) {
  return Consumer(
    builder: (context, ref, child) {

      final userProvider = ref.watch(userStreamProvider(load.ownerUid));

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
                    children: [
                      Image.asset("assets/icons/box.png", width: 45.w,),
                      SizedBox(width: 10.w,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(load.originName!, style: kCustomTextStyle,),

                          const Icon(Icons.fast_forward_sharp, color: kWhite,),
                          Text(load.destinationName!, style: kCustomTextStyle, textAlign: TextAlign.end,),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          userProvider.when(
                            data: (owner) => Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(owner.image!),
                                  radius: 15.w,
                                ),
                                SizedBox(width: 7.5.w,),
                                Text(owner.name!, style: kCustomTextStyle,),
                              ],
                            ),
                            loading: () => Container(),
                            error: (error, stackTrace) => Container(),
                          ),
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
                                    child: Text(["${load.length} mt", "${load.weight} kg", "${languages[language]![load.isPartial! ? "partial" : "full"]}"][i], style: kCustomTextStyle.copyWith(fontSize: 11.w, color: kLightBlack),),
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
    },
    child: Container(),
  );
}

Widget extraSmallLoadWidget(double width, double height, String language,
    {required Function() onPressed, required LoadModel load}) {
  return Container(
    width: width * .55, height: height * .32,
    decoration: BoxDecoration(
      color: kLightBlack,
      borderRadius: BorderRadius.circular(10),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        onPressed: onPressed,
        color: kLightBlack,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: kBlueColor,
                  radius: 25,
                  child: Image.asset("assets/icons/box.png", width: 25),
                ),
                SizedBox(width: 10.w,),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width * .325),
                  child: Text("${load.originName!}\n${load.destinationName}",
                    style: kCustomTextStyle.copyWith(fontSize: 15),),
                ),
              ],
            ),
            SizedBox(height: 5.h,),
            Align(
                alignment: Alignment.centerRight,
                child: Text("${load.price!.toStringAsFixed(2)} TL",
                  style: kCustomTextStyle.copyWith(fontSize: 13, fontWeight: FontWeight.bold),)),

          ],
        ),
      ),
    ),
  );
}

Widget truckPostsWidget(double width, double height, String language,
    {required Function() onPressed, required TruckPostModel truckPost,}) {

  return Consumer(
    builder: (context, ref, child) {

      final truckProvider = ref.watch(truckStreamProvider(truckPost.truckUid));
      final userProvider = ref.watch(userStreamProvider(truckPost.ownerUid));

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
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: width * .25),
                        child: Text(truckPost.originName!//\n${DateFormat("dd.MM.yyyy").format(load.startDate!)}"
                          , style: kCustomTextStyle, overflow: TextOverflow.ellipsis,),
                      ),
                      const Icon(Icons.fast_forward_sharp, color: kWhite,),

                      Icon(Icons.local_shipping, color: kWhite, size: 30.w,),

                      const Icon(Icons.fast_forward_sharp, color: kWhite,),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: width * .25),
                        child: Text(truckPost.destinationName!//\n${DateFormat("dd.MM.yyyy").format(load.startDate!)}"
                          , style: kCustomTextStyle, overflow: TextOverflow.ellipsis, textAlign: TextAlign.end,),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          userProvider.when(
                            data: (owner) => Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(owner.image!),
                                  radius: 15.w,
                                ),
                                SizedBox(width: 7.5.w,),
                                Text(owner.name!, style: kCustomTextStyle,),
                              ],
                            ),
                            loading: () => Container(),
                            error: (error, stackTrace) => Container(),
                          ),
                          SizedBox(height: 3.h,),
                          Text(languages[language]![truckPost.state!]!, style: kCustomTextStyle.copyWith(
                              color: kBlueColor
                          ),)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${truckPost.price} ₺", style: kCustomTextStyle,),
                          SizedBox(height: 3.h,),
                          Text("${languages[language]!["est"]!} ${(truckPost.price! / 1).toStringAsFixed(2)}₺/KM",
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
                      truckProvider.when(
                        data: (truck) => Row(
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
                                      child: Text(["${truck.length} mt", "${truck.weight} kg", "${languages[language]![truck.isPartial! ? "partial" : "full"]}"][i],
                                        style: kCustomTextStyle.copyWith(fontSize: 11.w, color: kBlack,),),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                        loading: () => Container(),
                        error: (error, stackTrace) => Container(),
                      ),
                      Text("${calculateDistance(truckPost.originLat!, truckPost.originLong!,
                          truckPost.destinationLat!, truckPost.destinationLong!).toStringAsFixed(2)} KM",
                        style: kCustomTextStyle,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    child: Container(),
  );
}


Widget smallerTruckPostsWidget(double width, double height, String language,
    {required Function() onPressed, required TruckPostModel truckPost,}) {

  return Consumer(
    builder: (context, ref, child) {

      final truckProvider = ref.watch(truckStreamProvider(truckPost.truckUid));
      final userProvider = ref.watch(userStreamProvider(truckPost.ownerUid));

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
                    children: [
                      Image.asset("assets/icons/truck.png", width: 45.w,),
                      SizedBox(width: 20.w,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: width * .725),
                            child: Text(truckPost.originName!,
                              style: kCustomTextStyle, maxLines: 3, overflow: TextOverflow.ellipsis,),
                          ),
                          const Icon(Icons.fast_forward_sharp, color: kWhite,),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: width * .725),
                            child: Text(truckPost.destinationName!, maxLines: 3,
                              style: kCustomTextStyle, overflow: TextOverflow.ellipsis,),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          userProvider.when(
                            data: (owner) => Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(owner.image!),
                                  radius: 15.w,
                                ),
                                SizedBox(width: 7.5.w,),
                                Text(owner.name!, style: kCustomTextStyle,),
                              ],
                            ),
                            loading: () => Container(),
                            error: (error, stackTrace) => Container(),
                          ),
                          SizedBox(height: 3.h,),
                          Text(languages[language]![truckPost.state!]!, style: kCustomTextStyle.copyWith(
                              color: kBlueColor
                          ),)
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("${truckPost.price} ₺", style: kCustomTextStyle,),
                          SizedBox(height: 3.h,),
                          Text("${languages[language]!["est"]!} ${(truckPost.price! / 1).toStringAsFixed(2)}₺/KM",
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
                      truckProvider.when(
                        data: (truck) => Row(
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
                                      child: Text(["${truck.length} mt", "${truck.weight} kg", "${languages[language]![truck.isPartial! ? "partial" : "full"]}"][i],
                                        style: kCustomTextStyle.copyWith(fontSize: 11.w, color: kBlack,),),
                                    ),
                                  ),
                                ),
                              )
                          ],
                        ),
                        loading: () => Container(),
                        error: (error, stackTrace) => Container(),
                      ),
                      Text("${calculateDistance(truckPost.originLat!, truckPost.originLong!,
                          truckPost.destinationLat!, truckPost.destinationLong!).toStringAsFixed(2)} KM",
                        style: kCustomTextStyle,),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
    child: Container(),
  );
}


Widget extraSmallTruckPostsWidget(double width, double height, String language,
    {required Function() onPressed, required TruckPostModel truckPost,}) {
  return Container(
    width: width * .5, height: height * .32,
    decoration: BoxDecoration(
      color: kLightBlack,
      borderRadius: BorderRadius.circular(10),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: MaterialButton(
        onPressed: onPressed,
        color: kLightBlack,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: kBlueColor,
                  radius: 25,
                  child: Image.asset("assets/icons/truck.png", width: 25),
                ),
                SizedBox(width: 10.w,),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: width * .325),
                  child: Text("${truckPost.originName!}\n${truckPost.destinationName}",
                    style: kCustomTextStyle.copyWith(fontSize: 15),),
                ),
              ],
            ),
            SizedBox(height: 5.h,),
            Align(
                alignment: Alignment.centerRight,
                child: Text("${truckPost.price!.toStringAsFixed(2)} TL",
                  style: kCustomTextStyle.copyWith(fontSize: 12, fontWeight: FontWeight.bold),)),

          ],
        ),
      ),
    ),
  );
}