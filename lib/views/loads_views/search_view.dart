import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/views/loads_views/search_results_view.dart';
import 'package:kamyon/widgets/custom_button_widget.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../widgets/search_card_widget.dart';


class SearchView extends ConsumerWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          color: kWhite,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(languages[language]!["find_loads"]!,
          style: const TextStyle(color: kWhite),),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 15.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  searchCardWidget(width, title: languages[language]!["origin"]!, hint: "Ankara, TR"),
                  searchCardWidget(width, title: languages[language]!["target"]!, hint: "İstanbul, TR"),
                ],
              ),
              searchCardWidget(width, title: languages[language]!["vehicle_type"]!,
                  hint: languages[language]!["pick_a_type"]!, halfLength: false),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  searchCardWidget(width, title: languages[language]!["length"]!, hint: "25",
                      hasType: true, type: "mt"),
                  searchCardWidget(width, title: languages[language]!["weight"]!, hint: "1604",
                      hasType: true, type: "kg"),
                  searchCardWidget(width, title: languages[language]!["equipment_limits"]!, hint: "Kısmi",
                      hasType: true, type: ""),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  searchCardWidget(width, title: languages[language]!["start_date"]!, hint: languages[language]!["pick_a_date"]!),
                  searchCardWidget(width, title: languages[language]!["end_date"]!, hint: languages[language]!["pick_a_date"]!),
                ],
              ),
              searchCardWidget(width, title: languages[language]!["max_age"]!,
                  hint: languages[language]!["pick_an_age"]!, halfLength: false,),

              customButton(title: languages[language]!["search"]!, onPressed: () {
                Navigator.push(context, routeToView(const SearchResultsView()));
              },)
            ],
          ),
        ),
      ),
    );
  }
}

