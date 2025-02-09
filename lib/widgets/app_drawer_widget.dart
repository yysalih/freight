import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/controllers/main_controller.dart';
import 'package:kamyon/controllers/profile_controller.dart';
import 'package:kamyon/repos/user_repository.dart';
import 'package:latlong2/latlong.dart';

import '../constants/app_constants.dart';
import '../constants/providers.dart';
import '../controllers/auth_controller.dart';
import '../controllers/location_controller.dart';
import '../views/auth_views/fill_out_view.dart';
import '../views/auth_views/login_view.dart';

class AppDrawerWidget extends ConsumerWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final language = ref.watch(languageStateProvider);

    final userProvider = ref.watch(userStreamProvider(currentUserUid));

    final authNotifier = ref.watch(authController.notifier);
    final profileNotifier = ref.watch(profileController.notifier);

    final mainNotifier = ref.watch(mainController.notifier);
    final mainState = ref.watch(mainController);

    final locationNotifier = ref.watch(locationController.notifier);

    final latLng = LatLng(locationNotifier.locationData.latitude ?? 41.0082376,
        locationNotifier.locationData.longitude ?? 28.9783589);

    return Drawer(
      backgroundColor: kBlack,
      child: ListView(

        children: [
          SizedBox(height: 10.h,),
          if(!isUserAnonymous()) userProvider.when(
            data: (user) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: kLightBlack,
                  backgroundImage: CachedNetworkImageProvider(user.image!),
                ),
                SizedBox(height: 5.h,),
                Text(user.name!, style: kCustomTextStyle,),
                SizedBox(height: 5.h,),
                Text(user.email!, style: kCustomTextStyle,),
                SizedBox(height: 5.h,),
                TextButton(
                  onPressed: () async {
                    await authNotifier.getCurrentUser();
                    Navigator.push(context, routeToView(const FillOutView(toEdit: true,)));
                  },
                  child: Text(languages[language]!["edit_profile"]!, style: kCustomTextStyle.copyWith(
                    color: Colors.lightBlueAccent
                  ),),
                ),
              ],
            ),
            error: (error, stackTrace) => Container(),
            loading: () => Container(),
          ),
          SizedBox(height: 10.h,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for(int i = 0; i < shortKeyForPlaces.length; i++)
                MaterialButton(
                  onPressed: () {
                    mainNotifier.getSelectedPlaces(placeType: shortKeyForPlaces[i]);
                    mainNotifier.mapController.move(latLng, 11);
                    debugPrint(mainState.placeType);
                    debugPrint(mainState.places.length.toString());
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Image.asset("assets/icons/${shortKeyForPlaces[i]}.png", width: 30,),
                        SizedBox(width: 10.w,),
                        Text(languages[language]![shortKeyForPlaces[i]]!, style: kCustomTextStyle,)
                      ],
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 10.h,),

          TextButton(
            onPressed: () async {
              profileNotifier.logout(context);
              Navigator.pushAndRemoveUntil(context, routeToView(const LoginView()), (route) => false);
            },
            child: Text(languages[language]!["logout"]!, style: kCustomTextStyle.copyWith(
                color: Colors.redAccent
            ),),
          ),
        ],
      ),
    );
  }
}
