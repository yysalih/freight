import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/views/loads_views/load_inner_view.dart';

import '../../constants/providers.dart';
import '../../widgets/search_result_widget.dart';

class SearchResultsView extends ConsumerWidget {
  const SearchResultsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: kBlueColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Text(languages[language]!["cancel"]!, style: const TextStyle(color: kWhite),),
        ),
        title: Row(
          children: [
            const Text("Ankara", style: kCustomTextStyle,),
            SizedBox(width: 10.w,),
            const Icon(Icons.fast_forward_rounded, color: Colors.white,),
            SizedBox(width: 10.w,),
            const Text("İstanbul", style: kCustomTextStyle),

          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 15.0.h, left: 15.w, right: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("45 ${languages[language]!["result"]}", style: kCustomTextStyle,),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: kWhite,),
                    onPressed: () {

                    },
                  ),
                ],
              ),
              SizedBox(height: 10.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {

                    },
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list, color: kWhite,),
                        SizedBox(width: 5.w,),
                        Text(languages[language]!["length"]!, style: kCustomTextStyle,),
                      ],
                    ),
                  ),
                  TextButton(
                    child: Text(languages[language]!["edit_search"]!,
                      style: const TextStyle(color: kBlueColor),),
                    onPressed: () {

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

