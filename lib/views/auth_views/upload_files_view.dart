import 'package:cached_network_image/cached_network_image.dart';
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
                      Column(
                        children: [
                          fileCardWidget(title: languages[language]!["id_front"]!,
                            image: "id", color: kLightBlack, onPressed: () async {
                              if(true) {
                                await authNotifier.showPicker(context, language: language, type: "idFront");

                                //showModalBottomSheet(context: context, builder: (context) => const FileOptionsModalBottomSheet());
                              }
                            },),
                          if(authState.idFront.isNotEmpty) TextButton(
                            child: Text(languages[language]!["show"]!, style: kCustomTextStyle.copyWith(
                              color: Colors.lightBlueAccent, fontSize: 12
                            ),),
                            onPressed: () {
                              showUploadedFile(authState.idFront.isNotEmpty, authState.idFront, context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(width: 20.w,),
                      Column(
                        children: [
                          fileCardWidget(title: languages[language]!["id_back"]!,
                            image: "id", color: kLightBlack, onPressed: () async {
                              await authNotifier.showPicker(context, language: language, type: "idBack");


                            },),
                          if(authState.idBack.isNotEmpty) TextButton(
                            child: Text(languages[language]!["show"]!, style: kCustomTextStyle.copyWith(
                                color: Colors.lightBlueAccent, fontSize: 12
                            ),),
                            onPressed: () {
                              showUploadedFile(authState.idBack.isNotEmpty, authState.idBack, context);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),

                  authState.isCarrier ? Padding(
                    padding: EdgeInsets.only(top: 10.0.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            fileCardWidget(title: languages[language]!["license_front"]!,
                              image: "license", color: kLightBlack, onPressed: () async {
                                await authNotifier.showPicker(context, language: language, type: "licenseFront");

                              },),
                            if(authState.licenseFront.isNotEmpty) TextButton(
                              child: Text(languages[language]!["show"]!, style: kCustomTextStyle.copyWith(
                                  color: Colors.lightBlueAccent, fontSize: 12
                              ),),
                              onPressed: () {
                                showUploadedFile(authState.licenseFront.isNotEmpty, authState.licenseFront, context);
                              },
                            ),
                          ],
                        ),
                        SizedBox(width: 20.w,),
                        Column(
                          children: [
                            fileCardWidget(title: languages[language]!["license_back"]!,
                              image: "license", color: kLightBlack, onPressed: () async {
                                await authNotifier.showPicker(context, language: language, type: "licenseBack");

                              },),
                            if(authState.licenseBack.isNotEmpty) TextButton(
                              child: Text(languages[language]!["show"]!, style: kCustomTextStyle.copyWith(
                                  color: Colors.lightBlueAccent, fontSize: 12
                              ),),
                              onPressed: () {
                                showUploadedFile(authState.licenseBack.isNotEmpty, authState.licenseBack, context);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ) : const SizedBox(),
                  SizedBox(height: 20.h,),
                  authState.isCarrier ? Column(
                    children: [
                      fileCardWidget2(title: languages[language]!["psiko"]!,
                          icon: Icons.file_present_sharp, color: kLightBlack,
                          isUploaded: authState.psiko.isNotEmpty,
                          onPressed: () {
                            if(true) {
                              showModalBottomSheet(context: context, builder: (context) => const FileOptionsModalBottomSheet(
                                type: "psiko",
                              ));
                            }
                          }),
                      SizedBox(height: 20.h,),
                      fileCardWidget2(title: languages[language]!["src"]!,
                          icon: Icons.file_present_sharp, color: kLightBlack,
                          isUploaded: authState.src.isNotEmpty,
                          onPressed: () {
                            if(true) {
                              showModalBottomSheet(context: context, builder: (context) => const FileOptionsModalBottomSheet(
                                type: "src",
                              ));
                            }
                          }),
                    ],
                  ) : Column(
                    children: [
                      fileCardWidget2(title: languages[language]!["registration"]!,
                          icon: Icons.file_present_sharp, color: kLightBlack,
                          isUploaded: authState.registration.isNotEmpty,
                          onPressed: () {
                            if(true) {
                              showModalBottomSheet(context: context, builder: (context) => const FileOptionsModalBottomSheet(
                                type: "registration",
                              ));
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

  void showUploadedFile(bool stateValueExists, String stateValue, BuildContext context) {
    if(stateValueExists) {
      showDialog(context: context, builder: (context) => AlertDialog(
        backgroundColor: kBlack,
        content: Container(
          width: 200, height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: CachedNetworkImageProvider(stateValue),
              fit: BoxFit.cover
            )
          ),
        ),
      ),);
    }
  }
}

