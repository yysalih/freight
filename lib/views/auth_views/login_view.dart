import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:kamyon/constants/providers.dart';
import 'package:kamyon/controllers/auth_controller.dart';
import 'package:kamyon/views/auth_views/fill_out_view.dart';
import 'package:kamyon/widgets/custom_button_widget.dart';
import 'package:kamyon/widgets/input_field_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/authentication_service.dart';
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

                }, controller: authNotifier.emailController),
              SizedBox(height: 10.h,),
              customInputField(title: languages[appLanguage]!["password"]!,
                hintText: languages[appLanguage]!["input_password"]!,
                icon: Icons.password, onTap: () {

                }, controller: authNotifier.passwordController),
              authState.isRegister ? Column(
                children: [
                  SizedBox(height: 10.h,),
                  customInputField(title: languages[appLanguage]!["password_again"]!,
                    hintText: languages[appLanguage]!["input_password_again"]!,
                    icon: Icons.password, onTap: () {

                    }, controller: authNotifier.passwordAgainController),
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
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      User? user = await Authentication.signInWithGoogle(context: context);

                      if(user != null) {
                        prefs.setString("uid", user.uid);

                        bool isUserExists = await authNotifier.checkIfUserExists();

                        if(isUserExists) {
                          Navigator.push(context,
                              routeToView(const MainView()));
                        }
                        else {
                          //await authWatch.createNewUser(user.uid, user);
                          Navigator.push(context, routeToView(const FillOutView()));
                        }

                      }
                    },);
                  }
                  return customButton(title: authState.isRegister ?
                  languages[appLanguage]!["sign_up"]! :
                  languages[appLanguage]!["login"]!, color: kGreen, onPressed: () {}, inProgress: true);
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
                          onPressed: () async {
                            await authNotifier.checkIfUserExists();
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
                          onPressed: () async {
                            await authNotifier.checkIfUserExists();
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

                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            User? user = await Authentication.signInWithGoogle(context: context);

                            if(user != null) {
                              prefs.setString("uid", user.uid);

                              bool isUserExists = await authNotifier.checkIfUserExists();

                              if(isUserExists) {
                                Navigator.push(context,
                                    routeToView(const MainView()));
                              }
                              else {
                                //await authWatch.createNewUser(user.uid, user);
                                Navigator.push(context, routeToView(const FillOutView()));
                              }

                            }
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
                        onPressed: () async {

                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          User? user = await Authentication.signInWithGoogle(context: context);

                          if(user != null) {
                            prefs.setString("uid", user.uid);

                            bool isUserExists = await authNotifier.checkIfUserExists();

                            if(isUserExists) {
                              Navigator.push(context,
                                  routeToView(const MainView()));
                            }
                            else {
                              //await authWatch.createNewUser(user.uid, user);
                              Navigator.push(context, routeToView(const FillOutView()));
                            }

                          }                        },
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
            ],
          ),
        ),
      ),
    );
  }
}
