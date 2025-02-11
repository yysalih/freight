import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/constants/providers.dart';
import 'package:kamyon/controllers/auth_controller.dart';
import 'package:kamyon/controllers/truck_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class PickCityModalBottomSheet extends ConsumerWidget {
  const PickCityModalBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;

    final truckNotifier = ref.watch(truckController.notifier);
    final truckState = ref.watch(truckController);

    return Container(
      height: height * .85,
      color: kBlack,
      child: ListView.builder(
        itemBuilder: (context, index) => MaterialButton(
          height: 40.h,
          onPressed: () {
            truckNotifier.changeCity(cities[index]);
            Navigator.pop(context);
          },
          child: Row(
            children: [
              truckState.city == cities[index] ? const Icon(Icons.done, color: Colors.green,) : const SizedBox(),
              const SizedBox(width: 5,),
              Text(cities[index], style: kCustomTextStyle,),
            ],
          ),
        ),
        itemCount: cities.length,
      ),
    );
  }
}

class FileOptionsModalBottomSheet extends ConsumerWidget {
  final String type;
  const FileOptionsModalBottomSheet({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;

    final language = ref.watch(languageStateProvider);

    final authNotifier = ref.watch(authController.notifier);
    final authState = ref.watch(authController);

    return Container(

      color: kBlack,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MaterialButton(
            height: 40.h,
            onPressed: () async {
              authNotifier.handleUploadPDF(type);

              await authNotifier.updateFilesState(
                idFront: authState.idFront,
                idBack: authState.idBack,
                licenseFront: authState.licenseFront,
                licenseBack: authState.licenseBack,
                psiko: type == "psiko" ? authState.downloadURL : authState.psiko,
                src: type == "src" ? authState.downloadURL : authState.src,
                registration: type == "registration" ? authState.downloadURL : authState.registration,
              );

            },
            child: Row(
              children: [
                const Icon(Icons.upload, color: kWhite),
                const SizedBox(width: 10,),
                Text(languages[language]!["upload"]!, style: kCustomTextStyle,),
              ],
            ),
          ),

          MaterialButton(
            height: 40.h,
            onPressed: () {
              if(type == "psiko" && authState.psiko.isNotEmpty) {
                launchUrl(Uri.parse(authState.psiko));
              }
              else if(type == "src" && authState.src.isNotEmpty) {
                launchUrl(Uri.parse(authState.src));
              }

              else if (type == "registration" && authState.registration.isNotEmpty) {
                launchUrl(Uri.parse(authState.registration));
              }
            },
            child: Row(
              children: [
                const Icon(Icons.remove_red_eye, color: kWhite),
                const SizedBox(width: 10,),
                Text(languages[language]!["view"]!, style: kCustomTextStyle,),
              ],
            ),
          ),
        ],
      )
    );
  }
}
