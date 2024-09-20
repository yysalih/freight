import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/providers.dart';
import 'package:kamyon/views/auth_views/upload_files_view.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_button_widget.dart';

class PickRoleView extends ConsumerWidget {
  const PickRoleView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLanguage = ref.watch(languageStateProvider);
    final authNotifier = ref.watch(authController.notifier);
    final authState = ref.watch(authController);

    return Scaffold(
      backgroundColor: kBlack,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20.h),
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
                    child: const Icon(Icons.arrow_back_outlined, color: kWhite,),
                  ),
                  Text(languages[appLanguage]!["pick_role"]!, style: kTitleTextStyle.copyWith(
                    color: kWhite
                  ),),
                  Container(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          authNotifier.switchCarrier();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(30),
                          backgroundColor: authState.isCarrier ? kLightBlack : kLightGreen, // <-- Button color
                          foregroundColor: kWhite, // <-- Splash color
                        ),
                        child: Image.asset("assets/icons/shipper.png", width: 60.w,),
                      ),
                      SizedBox(height: 5.h,),
                      Text(languages[appLanguage]!["shipper"]!, style: kCustomTextStyle,)
                    ],
                  ),
                  SizedBox(width: 20.w,),
                  Column(

                    children: [
                      ElevatedButton(
                        onPressed: () {
                          authNotifier.switchCarrier();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(30),
                          backgroundColor: !authState.isCarrier ? kLightBlack : kLightGreen, // <-- Button color
                          foregroundColor: kWhite, // <-- Splash color
                        ),
                        child: Image.asset("assets/icons/truck.png", width: 60.w,),
                      ),
                      SizedBox(height: 5.h,),
                      Text(languages[appLanguage]!["carrier"]!, style: kCustomTextStyle,)
                    ],
                  ),
                ],
              ),
              customButton(title: languages[appLanguage]!["continue"]!, color: kGreen, onPressed: () {
                Navigator.push(context, routeToView(const UploadFilesView()));
              },),
            ],
          ),
        ),
      ),
    );
  }
}
