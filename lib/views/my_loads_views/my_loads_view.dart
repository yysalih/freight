import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/views/loads_views/load_inner_view.dart';
import 'package:kamyon/views/my_loads_views/post_load_view.dart';

import '../../constants/providers.dart';
import '../../widgets/search_result_widget.dart';

class MyLoadsView extends ConsumerWidget {
  const MyLoadsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBlack,

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15.0.h, left: 15.w, right: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${languages[language]!["my_loads"]}", style: kTitleTextStyle.copyWith(
                    color: kWhite
                  ),),
                  TextButton(
                    child: Text(languages[language]!["new_post"]!, style: kCustomTextStyle.copyWith(
                        color: kBlueColor,
                        fontSize: 13.w),),
                    onPressed: () {
                      Navigator.push(context, routeToView(const PostLoadView()));
                    },
                  )
                ],
              ),
              SizedBox(height: 10.h,),
              searchResultWidget(width, height, language, onPressed: () {
                Navigator.push(context, routeToView(const LoadInnerView()));
              },),
              SizedBox(height: 15.h,),

              searchResultWidget(width, height, language, onPressed: () {
                Navigator.push(context, routeToView(const LoadInnerView()));
              },),
            ],
          ),
        ),
      ),
    );
  }
}

