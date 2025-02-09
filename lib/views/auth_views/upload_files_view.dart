import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/providers.dart';
import 'package:kamyon/controllers/profile_controller.dart';
import 'package:kamyon/views/main_view.dart';
import 'package:kamyon/widgets/file_card_widget.dart';
import 'package:kamyon/widgets/pick_city_modal_bottom_sheet.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../controllers/auth_controller.dart';
import '../../widgets/custom_button_widget.dart';

class UploadFilesView extends ConsumerWidget {
  final bool toEdit;
  const UploadFilesView({super.key, this.toEdit = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);
    final authNotifier = ref.watch(authController.notifier);
    final authState = ref.watch(authController);

    final profileState = ref.watch(profileController);

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
                  Text(languages[language]!["upload_necessary_files"]!, style: kTitleTextStyle.copyWith(
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
                      fileCardWidget(title: languages[language]!["id_front"]!,
                        image: "id", color: kLightBlack, onPressed: () async {
                          if(toEdit) {
                            await authNotifier.showPicker(context, language: language, type: "idFront");
                            await authNotifier.updateFilesState(
                                idFront: authState.image,
                                idBack: authState.idBack,
                                licenseFront: authState.licenseFront,
                                licenseBack: authState.licenseBack,
                                psiko: authState.psiko,
                                src: authState.src,
                                registration: authState.registration);
                            //showModalBottomSheet(context: context, builder: (context) => const FileOptionsModalBottomSheet());
                          }
                        },),
                      SizedBox(width: 20.w,),
                      fileCardWidget(title: languages[language]!["id_back"]!,
                        image: "id", color: kLightBlack, onPressed: () async {
                          if(toEdit) {
                            await authNotifier.showPicker(context, language: language, type: "idBack");
                            await authNotifier.updateFilesState(
                                idFront: authState.idFront,
                                idBack: authState.image,
                                licenseFront: authState.licenseFront,
                                licenseBack: authState.licenseBack,
                                psiko: authState.psiko,
                                src: authState.src,
                                registration: authState.registration);
                          }
                        },),
                    ],
                  ),

                  authState.isCarrier ? Padding(
                    padding: EdgeInsets.only(top: 20.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        fileCardWidget(title: languages[language]!["license_front"]!,
                          image: "license", color: kLightBlack, onPressed: () async {
                          if(toEdit) {
                            await authNotifier.showPicker(context, language: language, type: "licenseFront");
                            await authNotifier.updateFilesState(
                                idFront: authState.idFront,
                                idBack: authState.idBack,
                                licenseFront: authState.image,
                                licenseBack: authState.licenseBack,
                                psiko: authState.psiko,
                                src: authState.src,
                                registration: authState.registration);
                          }
                          },),
                        SizedBox(width: 20.w,),
                        fileCardWidget(title: languages[language]!["license_back"]!,
                          image: "license", color: kLightBlack, onPressed: () async {
                          if(toEdit) {
                            await authNotifier.showPicker(context, language: language, type: "licenseBack");
                            await authNotifier.updateFilesState(
                                idFront: authState.idFront,
                                idBack: authState.idBack,
                                licenseFront: authState.licenseFront,
                                licenseBack: authState.image,
                                psiko: authState.psiko,
                                src: authState.src,
                                registration: authState.registration);
                          }
                          },),
                      ],
                    ),
                  ) : const SizedBox(),
                  SizedBox(height: 20.h,),
                  authState.isCarrier ? Column(
                    children: [
                      fileCardWidget2(title: languages[language]!["psiko"]!,
                          icon: Icons.file_present_sharp, color: kLightBlack, onPressed: () {
                            if(toEdit) {
                              showModalBottomSheet(context: context, builder: (context) => const FileOptionsModalBottomSheet(
                                type: "psiko",
                              ));
                            }
                          }),
                      SizedBox(height: 20.h,),
                      fileCardWidget2(title: languages[language]!["src"]!,
                          icon: Icons.file_present_sharp, color: kLightBlack, onPressed: () {
                            if(toEdit) {
                              showModalBottomSheet(context: context, builder: (context) => const FileOptionsModalBottomSheet());
                            }
                          }),
                    ],
                  ) : Column(
                    children: [
                      fileCardWidget2(title: languages[language]!["registration"]!,
                          icon: Icons.file_present_sharp, color: kLightBlack, onPressed: () {
                            if(toEdit) {
                              showModalBottomSheet(context: context, builder: (context) => const FileOptionsModalBottomSheet());
                            }
                          }),
                      SizedBox(height: 20.h,),
                      Row(
                        children: [
                          Checkbox(
                            value: authState.isBroker,
                            onChanged: (value) => authNotifier.switchBroker(),
                          ),
                          SizedBox(width: 5.w,),
                          Text(languages[language]!["i_am_a_broker"]!, style: kCustomTextStyle,)
                        ],
                      ),
                    ],
                  )
                ],
              ),
              customButton(title: languages[language]!["confirm"]!, color: kGreen, onPressed: () {
                if(toEdit) {
                  Navigator.pop(context);
                } else {
                  authNotifier.createUser(profileState, context: context, errorTitle: languages[language]!["problem_signing_up"]!);
                }
              },),
            ],
          ),
        ),
      ),
    );
  }
}

