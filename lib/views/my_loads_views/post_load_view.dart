import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/views/loads_views/search_results_view.dart';
import 'package:kamyon/widgets/custom_button_widget.dart';
import 'package:kamyon/widgets/input_field_widget.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../widgets/search_card_widget.dart';


class PostLoadView extends ConsumerWidget {
  const PostLoadView({super.key});

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
        title: Text(languages[language]!["post_new_load"]!,
          style: const TextStyle(color: kWhite),),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                SizedBox(height: 15.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    searchCardWidget(width, title: languages[language]!["length"]!, hint: "25",
                        hasType: true, type: "mt"),
                    searchCardWidget(width, title: languages[language]!["weight"]!, hint: "1604",
                        hasType: true, type: "kg"),
                    searchCardWidget(width, title: languages[language]!["load_volume"]!, hint: "100",
                        hasType: true, type: "m3"),

                  ],
                ),
                SizedBox(height: 15.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    searchCardWidget(width, title: languages[language]!["start_date"]!, hint: languages[language]!["pick_a_date"]!),
                    searchCardWidget(width, title: languages[language]!["end_date"]!, hint: languages[language]!["pick_a_date"]!),
                  ],
                ),
                SizedBox(height: 15.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    searchCardWidget(width, title: languages[language]!["start_time"]!, hint: languages[language]!["pick_a_time"]!),
                    searchCardWidget(width, title: languages[language]!["end_time"]!, hint: languages[language]!["pick_a_time"]!),
                  ],
                ),
                SizedBox(height: 15.h,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    searchCardWidget(width, title: languages[language]!["vehicle_type"]!,
                        hint: languages[language]!["pick_a_type"]!,),
                    searchCardWidget(width, title: languages[language]!["equipment_limits"]!, hint: "Kısmi",
                        type: ""),
                  ],
                ),

                SizedBox(height: 15.h,),
                searchCardWidget(width, title: languages[language]!["load_type"]!,
                    hint: languages[language]!["bulk_or_palletized"]!, halfLength: false),

                SizedBox(height: 15.h,),
                searchCardWidget(width, title: languages[language]!["contact_phone"]!,
                    hint: languages[language]!["enter_contact_phone"]!, halfLength: false,),
                SizedBox(height: 15.h,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    customInputField(title: languages[language]!["price"]!, hintText: languages[language]!["enter_price"]!, icon: Icons.monetization_on, onTap: () {
                        },),
                    SizedBox(height: 5.h,),
                    Text("${languages[language]!["per_km"]!} 20 \$", style: kCustomTextStyle,)
                  ],
                ),
                SizedBox(height: 20.h,),
                customButton(title: languages[language]!["search"]!, onPressed: () {
                  Navigator.push(context, routeToView(const SearchResultsView()));
                },)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
