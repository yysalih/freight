import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/repos/user_repository.dart';

import '../constants/app_constants.dart';

class AppDrawerWidget extends ConsumerWidget {
  const AppDrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProvider = ref.watch(userFutureProvider(currentUserUid));
    return Drawer(
      backgroundColor: kBlack,
      child: ListView(

        children: [
          SizedBox(height: 10.h,),
          userProvider.when(
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
              ],
            ),
            error: (error, stackTrace) => Container(),
            loading: () => Container(),
          ),
          SizedBox(height: 10.h,),
          
        ],
      ),
    );
  }
}
