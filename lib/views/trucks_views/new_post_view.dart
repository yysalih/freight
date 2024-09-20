import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/widgets/custom_button_widget.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../widgets/input_field_widget.dart';
import '../../widgets/search_card_widget.dart';

class NewPostView extends ConsumerWidget {
  const NewPostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBlack,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          color: kWhite,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(languages[language]!["post_your_car"]!,
          style: const TextStyle(color: kWhite),),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: width,
                decoration: BoxDecoration(
                  color: kLightBlack,
                  borderRadius: BorderRadius.circular(10.h)
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.h, vertical: 25.h),
                  child: Row(
                    children: [
                      Icon(Icons.local_shipping, color: kBlueColor, size: 40.h,),
                      SizedBox(width: 20.w,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Mercedes Benz", style: kTitleTextStyle.copyWith(color: kWhite),),
                          SizedBox(height: 5.h,),
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
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  searchCardWidget(width, title: languages[language]!["origin"]!, hint: "Ankara, TR"),
                  searchCardWidget(width, title: languages[language]!["target"]!, hint: "İstanbul, TR"),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  searchCardWidget(width, title: languages[language]!["start_date"]!, hint: languages[language]!["pick_a_date"]!),
                  searchCardWidget(width, title: languages[language]!["end_date"]!, hint: languages[language]!["pick_a_date"]!),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  customInputField(title: languages[language]!["price"]!, hintText: languages[language]!["enter_price"]!, icon: Icons.monetization_on, onTap: () {
                  },),
                  SizedBox(height: 5.h,),
                  Text("${languages[language]!["per_km"]!} 20 \$", style: kCustomTextStyle,)
                ],
              ),
              searchCardWidget(width, title: languages[language]!["contact_phone"]!,
                hint: languages[language]!["enter_contact_phone"]!, halfLength: false,),
              customInputField(title: languages[language]!["description"]!, hintText: languages[language]!["enter_description"]!,
                  icon: Icons.description, onTap: () {

                  },),
              customButton(title: languages[language]!["confirm"]!, onPressed: () {

              },)
            ],
          ),
        ),
      ),
    );
  }
}
