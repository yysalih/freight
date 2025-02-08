import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/constants/providers.dart';
import 'package:kamyon/controllers/auth_controller.dart';
import 'package:kamyon/services/serverKey.dart';
import 'package:kamyon/views/auth_views/fill_out_view.dart';
import 'package:kamyon/views/shipment_views/offer_inner_view.dart';
import 'package:kamyon/widgets/custom_button_widget.dart';
import 'package:kamyon/widgets/input_field_widget.dart';
import 'package:kamyon/widgets/offer_modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/authentication_service.dart';
import '../../widgets/pick_city_modal_bottom_sheet.dart';
import '../main_view.dart';

class LoginView extends ConsumerWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLanguage = ref.watch(languageStateProvider);
    final authNotifier = ref.watch(authController.notifier);
    final authState = ref.watch(authController);

    return Scaffold(
      backgroundColor: kBlack,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              customInputField(title: languages[appLanguage]!["email"]!,
                  hintText: languages[appLanguage]!["input_email"]!,
                  icon: Icons.local_post_office_outlined, onTap: () {

                },
                controller: authNotifier.emailController,
                onChanged: (value) {

                },),
              SizedBox(height: 10.h,),
              customInputField(title: languages[appLanguage]!["password"]!,
                hintText: languages[appLanguage]!["input_password"]!,
                icon: Icons.password, onTap: () {

                }, controller: authNotifier.passwordController, onChanged: (value) {

                },),
              authState.isRegister ? Column(
                children: [
                  SizedBox(height: 10.h,),
                  customInputField(title: languages[appLanguage]!["password_again"]!,
                    hintText: languages[appLanguage]!["input_password_again"]!,
                    icon: Icons.password, onTap: () {

                    }, controller: authNotifier.passwordAgainController, onChanged: (value) {

                    },),
                ],
              ) : Container(),
              SizedBox(height: 10.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => authNotifier.switchRegister(),
                    child: Text(authState.isRegister ?
                    languages[appLanguage]!["already_have_account"]!
                    : languages[appLanguage]!["no_account"]!, style: kCustomTextStyle.copyWith(
                      color: kBlueColor, fontSize: 15
                    ),),
                  ),
                  authState.isRegister ? Container()
                      : Text(languages[appLanguage]!["forgot_password"]!, style: kCustomTextStyle.copyWith(
                      color: kBlueColor, fontSize: 15
                  ),),
                ],
              ),
              SizedBox(height: 10.h,),
              FutureBuilder(
                future: Authentication.initializeFirebase(context: context, authNotifier: authNotifier),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return customButton(title: authState.isRegister ?
                    languages[appLanguage]!["sign_up"]! :
                    languages[appLanguage]!["login"]!, color: kGreen, onPressed: () async {
                      authNotifier.handleSignInWithEmail(authNotifier, context: context);
                    },);
                  }
                  return customButton(title: authState.isRegister ?
                  languages[appLanguage]!["sign_up"]! :
                  languages[appLanguage]!["login"]!, color: kGreen, onPressed: () {
                    authNotifier.handleSignInWithEmail(authNotifier, context: context);
                  }, inProgress: true);
                }
              ),
              SizedBox(height: 30.h,),
              Text(languages[appLanguage]!["or"]!, style: kCustomTextStyle.copyWith(color: kWhite),),
              SizedBox(height: 30.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FutureBuilder(
                      future: Authentication.initializeFirebase(context: context, authNotifier: authNotifier),
                      builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ElevatedButton(
                          onPressed: ()  {
                            authNotifier.handleSignIn(authNotifier, context: context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            backgroundColor: kLightBlack, // <-- Button color
                            foregroundColor: kWhite, // <-- Splash color
                          ),
                          child: Image.asset("assets/icons/google.png", width: 30.w,),
                        );
                      };
                      return ElevatedButton(
                          onPressed: () {
                            authNotifier.handleSignIn(authNotifier, context: context);
                          },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: kLightBlack, // <-- Button color
                          foregroundColor: kWhite, // <-- Splash color
                        ),
                        child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white
                        ),
                      ));
                    }
                  ),
                  SizedBox(width: 20.w,),
                  FutureBuilder(
                    future: Authentication.initializeFirebase(context: context, authNotifier: authNotifier),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return ElevatedButton(
                          onPressed: () async {
                            authNotifier.handleSignInWithApple(authNotifier, context: context);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                            backgroundColor: kLightBlack, // <-- Button color
                            foregroundColor: kWhite, // <-- Splash color
                          ),
                          child: Image.asset("assets/icons/apple.png", color: kWhite, width: 30.w,),
                        );
                      }
                      return ElevatedButton(
                        onPressed: () {
                          authNotifier.handleSignInWithApple(authNotifier, context: context);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(20),
                          backgroundColor: kLightBlack, // <-- Button color
                          foregroundColor: kWhite, // <-- Splash color
                        ),
                        child: Image.asset("assets/icons/apple.png", color: kWhite, width: 30.w,),
                      );
                    }
                  ),
                ],
              ),
              SizedBox(height: 30.h,),
              Wrap(

                children: [
                  Text(languages[appLanguage]!["by_continuing"]!, style: kCustomTextStyle,),
                  Text(languages[appLanguage]!["user_agreement"]!, style: kCustomTextStyle.copyWith(
                    color: kBlueColor
                  ),),
                  Text(languages[appLanguage]!["accepted_user_agreement"]!, style: kCustomTextStyle,),
                ],
              ),
              SizedBox(height: 20.h,),
              TextButton(
                child: Text(languages[appLanguage]!["anonymous_login"]!, style: kCustomTextStyle.copyWith(
                  color: kBlueColor
                ),),
                onPressed: () async {
                  // final getKey = get_server_key();
                  // final token = await getKey.server_token();
                  // debugPrint(token.toString());
                  authNotifier.handleSignInAnonymous(authNotifier, context: context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

}
