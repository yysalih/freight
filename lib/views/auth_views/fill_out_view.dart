import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/views/auth_views/pick_role_view.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_button_widget.dart';
import '../../widgets/input_field_widget.dart';

class FillOutView extends ConsumerWidget {
  const FillOutView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLanguage = ref.watch(languageStateProvider);
    ref.watch(authController.notifier);
    ref.watch(authController);

    return Scaffold(
      backgroundColor: kBlack,
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.close, color: kWhite,),
                  ),
                  Text(languages[appLanguage]!["fill_out"]!, style: kTitleTextStyle.copyWith(
                      color: kWhite
                  ),),
                  Container()
                ],
              ),

              Row(
                children: [
                  CircleAvatar(
                    radius: 40.h,
                    backgroundColor: kLightBlack,
                    child: Image.asset("assets/icons/photo.png", width: 50.w,),
                  ),
                  SizedBox(width: 10.w,),
                  TextButton(
                    child: Row(
                      children: [
                        const Icon(Icons.add, color: kWhite,),
                         SizedBox(width: 10.w,),
                        Text(languages[appLanguage]!["add_photo"]!, style: kCustomTextStyle,),
                      ],
                    ),
                    onPressed: () {

                    },
                  ),
                ],
              ),

              Column(
                children: [
                  customInputField(title: languages[appLanguage]!["name"]!,
                    hintText: languages[appLanguage]!["input_name"]!,
                    icon: Icons.person, onTap: () {

                    },),
                  SizedBox(height: 10.h,),
                  customInputField(title: languages[appLanguage]!["surname"]!,
                    hintText: languages[appLanguage]!["input_surname"]!,
                    icon: Icons.person, onTap: () {

                    },),
                  SizedBox(height: 10.h,),
                  customInputField(title: languages[appLanguage]!["email"]!,
                    hintText: languages[appLanguage]!["input_email"]!,
                    icon: Icons.local_post_office, onTap: () {

                    },),
                  SizedBox(height: 10.h,),
                  customInputField(title: languages[appLanguage]!["phone"]!,
                    hintText: languages[appLanguage]!["input_phone"]!,
                    icon: Icons.phone, onTap: () {

                    },),
                ],
              ),

              customButton(title: languages[appLanguage]!["continue"]!, color: kGreen, onPressed: () {
                Navigator.push(context, routeToView(const PickRoleView()));
              },),
            ],
          ),
        ),
      ),
    );
  }
}
