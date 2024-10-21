import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:kamyon/constants/snackbars.dart';
import 'package:kamyon/controllers/profile_controller.dart';

import '../constants/providers.dart';
import '../models/user_model.dart';
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

  final url = Uri.parse('https://coral-lemur-335530.hostingersite.com/get.php');

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
      url,
      body: {
        'singleQuery': "SELECT * FROM users WHERE uid = '${currentUser!.uid}'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      debugPrint(data.runtimeType.toString());
      //UserModel userModel = UserModel().fromJson(data);
      //debugPrint('UserModel: $userModel');
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

  createUser({required BuildContext context, required String errorTitle}) async {

    UserModel userModel = UserModel(
      isCarrier: state.isCarrier,
      isBroker: state.isBroker,
      name: nameController.text,
      image: currentUser!.photoURL,
      uid: currentUser!.uid,
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
      lastname: surnameController.text,
      token: "",
      point: 0.1,
      contacts: "${phoneController.text};",
      idBack: "", idFront: "", licenseBack: "", licenseFront: "", psiko: "", registration: "", src: ""
    );

    final response = await http.post(
      url,
      body: {
        //'executeQuery': "INSERT INTO users (token, image, lastname, uid, name, email, point, isBroker, isCarrier, src, registration, psiko, licenseFront, licenseBack, idFront, idBack, password, phone) VALUES (?, ?, ?, ?, ?, ? ,?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
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
      url,
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

    // Update UserModel with the required fields
    UserModel userModel = UserModel(
        name: nameController.text,
        email: emailController.text,
        phone: phoneController.text,
        isCarrier: profileState.carrierCheck,
        isBroker: profileState.brokerCheck,
        image: image,
        // These fields are not being updated but may still be in the model
        uid: currentUser!.uid, // Required for the WHERE clause
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

    // Create the SQL update query, updating only the necessary fields
    final response = await http.post(
      url,
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

    // Handle the response
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

}

final authController = StateNotifierProvider<AuthController, AuthState>(
      (ref) => AuthController(AuthState(isRegister: false, isCarrier: true, isBroker: false, currentUser: UserModel()),),);