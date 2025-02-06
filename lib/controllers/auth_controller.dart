import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/constants/snackbars.dart';
import 'package:kamyon/controllers/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/providers.dart';
import '../models/user_model.dart';
import '../services/authentication_service.dart';
import '../views/auth_views/fill_out_view.dart';
import '../views/main_view.dart';


class AuthState {
  final bool isRegister;
  final bool isCarrier;
  final bool isBroker;
  final UserModel currentUser;

  AuthState({required this.isRegister, this.isCarrier = true, this.isBroker = false , required this.currentUser});

  AuthState copyWith({
    bool? isRegister,
    bool? isCarrier,
    bool? isBroker,
    UserModel? currentUser,
  }) {
    return AuthState(isRegister: isRegister ?? this.isRegister, isBroker: isBroker ?? this.isBroker,
        isCarrier: isCarrier ?? this.isCarrier, currentUser: currentUser ?? this.currentUser);
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(super.state);

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordAgainController = TextEditingController();

  User? get currentUser => FirebaseAuth.instance.currentUser;

  switchRegister() {
    state = state.copyWith(isRegister: !state.isRegister);
  }
  switchCarrier() {
    state = state.copyWith(isCarrier: !state.isCarrier);
  }

  switchBroker() {
    state = state.copyWith(isBroker: !state.isBroker);
  }


  Future<bool> checkIfUserExists() async {
    final response = await http.post(
      appUrl,
      body: {
        'singleQuery': "SELECT * FROM users WHERE uid = '${currentUser!.uid}'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      debugPrint(data.runtimeType.toString());

      if(data.toString().contains("error")) {
        return false;
      } else {
        return true;
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      return false;
    }
  }

  createUser(ProfileState profileState, {required BuildContext context, required String errorTitle}) async {

    UserModel userModel = UserModel(
      isCarrier: state.isCarrier,
      isBroker: state.isBroker,
      name: nameController.text,
      image: currentUser!.photoURL ?? profileState.image,
      uid: currentUser!.uid,
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
      lastname: surnameController.text,
      token: "",
      point: 0.0,
      contacts: "${phoneController.text};",
      idBack: "", idFront: "", licenseBack: "", licenseFront: "", psiko: "", registration: "", src: ""
    );

    final response = await http.post(
      appUrl,
      body: {

        'executeQuery': "INSERT INTO users (${userModel.getDbFields()}) VALUES (${userModel.questionMarks})",
        "params": jsonEncode(userModel.getDbFormat()),
      },
    );
    if (response.statusCode == 200) {
      debugPrint(response.body);
      var data = jsonDecode(response.body);
      debugPrint('Response: $data');
      Navigator.push(context, routeToView(const MainView()));

    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      showSnackbar(title: errorTitle, context: context);
    }
  }

  getCurrentUser() async {
    final response = await http.post(
      appUrl,
      body: {
        'singleQuery': "SELECT * FROM users WHERE uid = '${FirebaseAuth.instance.currentUser!.uid}'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      UserModel userModel = UserModel().fromJson(data);
      debugPrint('UserModel: ${userModel.toJson().toString()}');

      if(data.toString().contains("error")) {
        return false;
      } else {
        state = state.copyWith(currentUser: userModel);
        return true;
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      return false;
    }
  }

  editUser({required BuildContext context, required String image, required ProfileState profileState,
    required String errorTitle, required String succesTitle}) async {


    UserModel userModel = UserModel(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        isCarrier: profileState.carrierCheck,
        isBroker: profileState.brokerCheck,
        image: image,
        uid: currentUser!.uid,
        password: state.currentUser.password,
        lastname: state.currentUser.lastname,
        token: state.currentUser.token,
        point: state.currentUser.point,
        contacts: state.currentUser.contacts,
        idBack: state.currentUser.idBack, idFront: state.currentUser.idFront,
        licenseBack: state.currentUser.licenseBack,
        licenseFront: state.currentUser.licenseFront, psiko: state.currentUser.psiko,
        registration: state.currentUser.registration, src: state.currentUser.src
    );

    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': """
        UPDATE users 
        SET 
          name = ?,
          isBroker = ?,
          isCarrier = ?,
          email = ?,
          phone = ?
        WHERE 
          uid = '${currentUser!.uid}'
      """,
        "params": jsonEncode([
          userModel.name,
          userModel.isBroker,
          userModel.isCarrier,
          userModel.email,
          userModel.phone
        ]),
      },
    );

    if (response.statusCode == 200) {
      debugPrint(response.body);
      var data = jsonDecode(response.body);
      debugPrint('Response: $data');

      if (!data.toString().contains("error")) {
        state = state.copyWith(currentUser: userModel);
        Navigator.push(context, routeToView(const MainView()));
        showSnackbar(title: succesTitle, context: context);

      } else {
        showSnackbar(title: errorTitle, context: context);
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
      showSnackbar(title: errorTitle, context: context);
    }
  }

  handleSignIn(AuthController authNotifier, {required BuildContext context}) async {

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
  }

  handleSignInWithApple(AuthController authNotifier, {required BuildContext context}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserCredential? userCredential = await Authentication.signInWithApple();

    if(userCredential.user != null) {
      final user = userCredential.user!;
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
  }

  handleSignInWithEmail(AuthController authNotifier, {required BuildContext context}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user =  state.isRegister ?
    await Authentication.signUp(email: authNotifier.emailController.text,
        password: authNotifier.passwordController.text)
        :
    await Authentication.signIn(email: authNotifier.emailController.text,
        password: authNotifier.passwordController.text);

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
  }

  handleSignInAnonymous(AuthController authNotifier, {required BuildContext context}) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserCredential? userCredential = await Authentication.signInAnonymously();

    if(userCredential.user != null) {
      final user = userCredential.user!;
      prefs.setString("uid", user.uid);

      bool isUserExists = await authNotifier.checkIfUserExists();

      if(isUserExists) {
        Navigator.push(context,
            routeToView(const MainView()));
      }
      else {

        Navigator.push(context, routeToView(const MainView()));
      }

    }
  }

}

final authController = StateNotifierProvider<AuthController, AuthState>(
      (ref) => AuthController(AuthState(isRegister: false, isCarrier: true, isBroker: false, currentUser: UserModel()),),);