import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/providers.dart';
import 'package:kamyon/views/main_view.dart';
import 'package:kamyon/widgets/file_card_widget.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_button_widget.dart';

class UploadFilesView extends ConsumerWidget {
  const UploadFilesView({super.key});

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
                  Text(languages[appLanguage]!["upload_necessary_files"]!, style: kTitleTextStyle.copyWith(
                      color: kWhite
                  ),),
                  Container()
                ],
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      fileCardWidget(title: languages[appLanguage]!["id_front"]!,
                        image: "id", color: kLightBlack, onPressed: () {},),
                      SizedBox(width: 20.w,),
                      fileCardWidget(title: languages[appLanguage]!["id_back"]!,
                        image: "id", color: kLightBlack, onPressed: () {},),
                    ],
                  ),

                  authState.isCarrier ? Padding(
                    padding: EdgeInsets.only(top: 20.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        fileCardWidget(title: languages[appLanguage]!["license_front"]!,
                          image: "license", color: kLightBlack, onPressed: () {},),
                        SizedBox(width: 20.w,),
                        fileCardWidget(title: languages[appLanguage]!["license_back"]!,
                          image: "license", color: kLightBlack, onPressed: () {},),
                      ],
                    ),
                  ) : const SizedBox(),
                  SizedBox(height: 20.h,),
                  authState.isCarrier ? Column(
                    children: [
                      fileCardWidget2(title: languages[appLanguage]!["psiko"]!,
                          icon: Icons.file_present_sharp, color: kLightBlack, onPressed: () {}),
                      SizedBox(height: 20.h,),
                      fileCardWidget2(title: languages[appLanguage]!["src"]!,
                          icon: Icons.file_present_sharp, color: kLightBlack, onPressed: () {}),
                    ],
                  ) : Column(
                    children: [
                      fileCardWidget2(title: languages[appLanguage]!["registration"]!,
                          icon: Icons.file_present_sharp, color: kLightBlack, onPressed: () {}),
                      SizedBox(height: 20.h,),
                      Row(
                        children: [
                          Checkbox(
                            value: authState.isBroker,
                            onChanged: (value) => authNotifier.switchBroker(),
                          ),
                          SizedBox(width: 5.w,),
                          Text(languages[appLanguage]!["i_am_a_broker"]!, style: kCustomTextStyle,)
                        ],
                      ),
                    ],
                  )
                ],
              ),
              customButton(title: languages[appLanguage]!["confirm"]!, color: kGreen, onPressed: () {
                Navigator.push(context, routeToView(const MainView()));
              },),
            ],
          ),
        ),
      ),
    );
  }
}
