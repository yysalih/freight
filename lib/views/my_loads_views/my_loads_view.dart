import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/repos/load_repository.dart';
import 'package:kamyon/views/loads_views/load_inner_view.dart';
import 'package:kamyon/views/my_loads_views/post_load_view.dart';
import 'package:http/http.dart' as http;
import '../../constants/providers.dart';
import '../../models/load_model.dart';
import '../../widgets/search_result_widget.dart';
import '../../widgets/warning_info_widget.dart';

class MyLoadsView extends ConsumerWidget {
  const MyLoadsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final loadsProvider = ref.watch(loadsFutureProvider(FirebaseAuth.instance.currentUser!.uid));

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

              loadsProvider.when(
                data: (loads) => loads.isEmpty ?
                const NoLoadsFoundWidget()
                    :  Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => Padding(
                            padding: EdgeInsets.only(top: 15.0.h),
                          child: searchResultWidget(width, height, language, load: loads[index],
                            onPressed: () {
                              Navigator.push(context, routeToView(LoadInnerView(uid: loads[index].uid!)));
                            },
                          ),
                        ),
                    itemCount: loads.length,
                  ),
                ),
                loading: () => const NoLoadsFoundWidget(),
                error: (error, stackTrace) {
                  debugPrint("Error: $error");
                  debugPrint("Error: $stackTrace");
                  return const NoLoadsFoundWidget();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


}

