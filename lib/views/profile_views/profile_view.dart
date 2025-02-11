import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/controllers/auth_controller.dart';
import 'package:kamyon/controllers/location_controller.dart';
import 'package:kamyon/controllers/profile_controller.dart';
import 'package:kamyon/repos/user_repository.dart';
import 'package:kamyon/views/auth_views/fill_out_view.dart';
import 'package:kamyon/views/auth_views/login_view.dart';
import 'package:kamyon/views/auth_views/pick_role_view.dart';
import 'package:kamyon/views/auth_views/upload_files_view.dart';
import 'package:kamyon/views/profile_views/contacts_view.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../widgets/warning_info_widget.dart';
import '../shipment_views/shipments_view.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final width = MediaQuery.of(context).size.width;

    final authNotifier = ref.watch(authController.notifier);

    final userProvider = ref.watch(userStreamProvider(FirebaseAuth.instance.currentUser!.uid));

    final profileNotifier = ref.watch(profileController.notifier);

    final locationNotifier = ref.watch(locationController.notifier);

    return !isUserAnonymous() ? Padding(
      padding: EdgeInsets.only(top: 10.h, right: 15.w, left: 15.w),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(languages[language]!["my_profile"]!,
                  style: kTitleTextStyle.copyWith(color: kWhite),),
                TextButton(
                  child: Text(languages[language]!["edit_profile"]!, style: kCustomTextStyle.copyWith(fontSize: 13.w,
                      color: kBlueColor),),
                  onPressed: () async {
                    await authNotifier.getCurrentUser();
                    Navigator.push(context, routeToView(const FillOutView(toEdit: true,)));
                  },
                )
              ],
            ),
            SizedBox(height: 10.h,),
            userProvider.when(
              data: (user) => Column(
                children: [
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: kLightBlack,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              debugPrint("${locationNotifier.locationData.latitude} , "
                                  "${locationNotifier.locationData.longitude}");
                            },
                            child: Center(
                              child: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(user.image ?? ""),
                                radius: 50.h,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h,),
                          Text(user.name ?? "", style: kCustomTextStyle,),
                          SizedBox(height: 10.h,),
                          Text(user.phone ?? "", style: kCustomTextStyle,),
                          SizedBox(height: 10.h,),
                          Text(user.email ?? "", style: kCustomTextStyle,),
                          SizedBox(height: 10.h,),
                          Text(user.isBroker ?? true ? languages[language]!["broker"]! :
                            user.isCarrier ?? true ? languages[language]!["carrier"]! :
                            languages[language]!["shipper"]!
                            , style: kTitleTextStyle.copyWith(color: Colors.lightBlueAccent),),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 15.h,),
                  Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: kLightBlack,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileButtonWidget(width: width,
                            title: languages[language]!["active_shipments"]!,
                            icon: Icons.local_shipping,
                          onPressed: () {
                            Navigator.push(context, routeToView(ShipmentsView()));
                          },),
                          // ProfileButtonWidget(width: width, title: languages[language]!["contacts"]!, icon: Icons.quick_contacts_dialer_rounded,
                          // onPressed: () {
                          //   Navigator.push(context, routeToView( ContactsView(currentUser: user,)));
                          // },),
                          ProfileButtonWidget(width: width, title: languages[language]!["languages"]!, icon: Icons.language,
                            onPressed: () {
                              showLanguageDialog(context, language, width);
                            },),
                          /*ProfileButtonWidget(width: width, title: languages[language]!["theme"]!, icon: Icons.dark_mode,
                            onPressed: () {

                            },),*/
                          ProfileButtonWidget(width: width, title: languages[language]!["files"]!, icon: Icons.file_present_sharp,
                            onPressed: () {

                              Navigator.push(context, routeToView(const UploadFilesView(toEdit: true,)));
                            },),
                          ProfileButtonWidget(width: width, title: languages[language]!["delete_your_account"]!, icon: Icons.delete_forever,
                            onPressed: () {
                            profileNotifier.deleteAccount(context, language);
                            Navigator.pushAndRemoveUntil(context, routeToView(const LoginView()), (route) => false);

                            },),
                          ProfileButtonWidget(width: width, title: languages[language]!["logout"]!, icon: Icons.logout,
                            onPressed: () {
                              profileNotifier.logout(context);
                              Navigator.pushAndRemoveUntil(context, routeToView(const LoginView()), (route) => false);
                            },),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator(color: kWhite,),),
              error: (error, stackTrace) {
                debugPrint("Error: ${error.toString()}");
                debugPrint("Error: ${stackTrace.toString()}");
                return Container();
              },
            ),
          ],
        ),
      ),
    ) : const NoAccountFound();
  }
}


class ProfileButtonWidget extends StatelessWidget {
  final double width;
  final String title;
  final IconData icon;
  final Function() onPressed;
  const ProfileButtonWidget({super.key, required this.width,
    required this.onPressed,
    required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: MaterialButton(
        onPressed: onPressed,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            children: [
              Icon(icon, color: kWhite,),
              SizedBox(width: 10.w,),
              Text(title, style: kCustomTextStyle,)
            ],
          ),
        ),
      ),
    );
  }
}


showLanguageDialog(BuildContext context, String language, double width) {
  showDialog(context: context, builder: (context) => AlertDialog(
    backgroundColor: kLightBlack,
    title: Text(languages[language]!["switch_language"]!, style: kCustomTextStyle,),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: width,
          child: MaterialButton(
            height: 40.h,
            onPressed: () {

            },
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text("English", style: kCustomTextStyle,),
            ),
          ),
        ),
        SizedBox(
          width: width,
          child: MaterialButton(
            height: 40.h,
            onPressed: () {

            },
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Text("Türkçe", style: kCustomTextStyle,)),
          ),
        ),
      ],
    ),
  ),);
}