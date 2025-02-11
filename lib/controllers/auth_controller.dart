import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/constants/snackbars.dart';
import 'package:kamyon/controllers/profile_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import '../constants/languages.dart';
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

  final File photo;
  final bool isCompleted;
  final String image;

  final String idFront;
  final String idBack;
  final String licenseFront;
  final String licenseBack;
  final String psiko;
  final String src;
  final String registration;

  final String downloadURL;
  final String type;

  AuthState({
    required this.isRegister,
    this.isCarrier = true,
    this.isBroker = false,
    required this.currentUser,
    required this.photo,
    this.isCompleted = false,
    this.image = "",
    this.idFront = "",
    this.idBack = "",
    this.licenseFront = "",
    this.licenseBack = "",
    this.psiko = "",
    this.src = "",
    this.registration = "",
    this.downloadURL = "",
    this.type = "",
  });

  AuthState copyWith({
    bool? isRegister,
    bool? isCarrier,
    bool? isBroker,
    UserModel? currentUser,
    File? photo,
    bool? isCompleted,
    String? image,
    String? idFront,
    String? idBack,
    String? licenseFront,
    String? licenseBack,
    String? psiko,
    String? src,
    String? registration,
    String? downloadURL,
    String? type
  }) {
    return AuthState(
      isRegister: isRegister ?? this.isRegister,
      isBroker: isBroker ?? this.isBroker,
      isCarrier: isCarrier ?? this.isCarrier,
      currentUser: currentUser ?? this.currentUser,
      photo: photo ?? this.photo,
      isCompleted: isCompleted ?? this.isCompleted,
      image: image ?? this.image,
      idFront: idFront ?? this.idFront,
      idBack: idBack ?? this.idBack,
      licenseFront: licenseFront ?? this.licenseFront,
      licenseBack: licenseBack ?? this.licenseBack,
      psiko: psiko ?? this.psiko,
      src: src ?? this.src,
      registration: registration ?? this.registration,
      downloadURL: downloadURL ?? this.downloadURL,
      type: type ?? this.type,
    );
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(super.state);

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  TextEditingController nameController = TextEditingController();
  TextEditingController surnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  bool get isAbleToContinue => nameController.text.isNotEmpty &&
      surnameController.text.isNotEmpty &&
      phoneController.text.isNotEmpty &&
      emailController.text.isNotEmpty;

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

      if (data.toString().contains("error")) {
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

  createUser(ProfileState profileState,
      {required BuildContext context, required String errorTitle}) async {

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String? token = await FirebaseMessaging.instance.getToken();

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
        token: token,
        point: 0.0,
        contacts: "${phoneController.text};",
        lat: position.latitude,
        lng: position.longitude,
        idBack: state.idBack,
        idFront: state.idFront,
        licenseBack: state.licenseBack,
        licenseFront: state.licenseFront,
        psiko: state.psiko,
        registration: state.registration,
        src: state.src);

    final response = await http.post(
      appUrl,
      body: {
        'executeQuery':
            "INSERT INTO users (${userModel.getDbFields()}) VALUES (${userModel.questionMarks})",
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
        'singleQuery':
            "SELECT * FROM users WHERE uid = '${FirebaseAuth.instance.currentUser!.uid}'",
      },
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      UserModel userModel = UserModel().fromJson(data);
      debugPrint('UserModel: ${userModel.toJson().toString()}');

      if (data.toString().contains("error")) {
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

  editUser(
      {required BuildContext context,
      required String image,
      required ProfileState profileState,
      required String errorTitle,
      required String succesTitle}) async {
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
        idBack: state.currentUser.idBack,
        idFront: state.currentUser.idFront,
        licenseBack: state.currentUser.licenseBack,
        licenseFront: state.currentUser.licenseFront,
        psiko: state.currentUser.psiko,
        registration: state.currentUser.registration,
        src: state.currentUser.src,
        lat: state.currentUser.lat,
        lng: state.currentUser.lng);

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

  handleSignIn(AuthController authNotifier,
      {required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = await Authentication.signInWithGoogle(context: context);

    if (user != null) {
      prefs.setString("uid", user.uid);

      bool isUserExists = await authNotifier.checkIfUserExists();

      if (isUserExists) {
        Navigator.push(context, routeToView(const MainView()));
      } else {
        //await authWatch.createNewUser(user.uid, user);
        Navigator.push(context, routeToView(const FillOutView()));
      }
    }
  }

  handleSignInWithApple(AuthController authNotifier,
      {required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserCredential? userCredential = await Authentication.signInWithApple();

    if (userCredential.user != null) {
      final user = userCredential.user!;
      prefs.setString("uid", user.uid);

      bool isUserExists = await authNotifier.checkIfUserExists();

      if (isUserExists) {
        Navigator.push(context, routeToView(const MainView()));
      } else {
        //await authWatch.createNewUser(user.uid, user);
        Navigator.push(context, routeToView(const FillOutView()));
      }
    }
  }

  handleSignInWithEmail(AuthController authNotifier,
      {required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User? user = state.isRegister
        ? await Authentication.signUp(
            email: authNotifier.emailController.text,
            password: authNotifier.passwordController.text)
        : await Authentication.signIn(
            email: authNotifier.emailController.text,
            password: authNotifier.passwordController.text);

    if (user != null) {
      prefs.setString("uid", user.uid);

      bool isUserExists = await authNotifier.checkIfUserExists();

      if (isUserExists) {
        Navigator.push(context, routeToView(const MainView()));
      } else {
        //await authWatch.createNewUser(user.uid, user);
        Navigator.push(context, routeToView(const FillOutView()));
      }
    }
  }

  handleSignInAnonymous(AuthController authNotifier,
      {required BuildContext context}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    UserCredential? userCredential = await Authentication.signInAnonymously();

    if (userCredential.user != null) {
      final user = userCredential.user!;
      prefs.setString("uid", user.uid);

      bool isUserExists = await authNotifier.checkIfUserExists();

      if (isUserExists) {
        Navigator.push(context, routeToView(const MainView()));
      } else {
        Navigator.push(context, routeToView(const MainView()));
      }
    }
  }

  uploadPDF(PlatformFile file, String type) async {
    try {
      // Get the file path
      String filePath = file.path!;

      // Create a reference to the Firebase Storage location
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('registers/$currentUserUid/$type-${basename(filePath)}');

      // Upload the file
      UploadTask uploadTask = storageReference.putFile(File(filePath));

      // Monitor the upload progress
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress =
            (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
        debugPrint('Upload progress: $progress%');
      });

      // Wait for the upload to complete
      await uploadTask.whenComplete(() => debugPrint('Upload complete'));

      // Get the download URL
      String downloadURL = await storageReference.getDownloadURL();
      state = state.copyWith(downloadURL: downloadURL);
      debugPrint('File uploaded, download URL: $downloadURL');
    } catch (e) {
      debugPrint('Error uploading file: $e');
    }
  }

  Future<PlatformFile?> pickPDF() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      return result.files.first;
    } else {
      debugPrint('No file selected');
      return null;
    }
  }

  handleUploadPDF(String type) async {
    // Pick a PDF file
    PlatformFile? file = await pickPDF();

    if (file != null) {
      // Upload the file to Firebase Storage
      await uploadPDF(file, type);
    }
  }

  Future imgFromCamera(String type, BuildContext context) async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 25);
    if (pickedFile != null) {
      state = state.copyWith(photo: File(pickedFile.path));
      uploadFile(type);
    } else {
      debugPrint('No image selected.');
    }
  }

  Future imgFromGallery(String type, BuildContext context) async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 25);

    if (pickedFile != null) {
      state = state.copyWith(photo: File(pickedFile.path));
      uploadFile(type);
    } else {
      debugPrint('No image selected.');
    }
  }

  Future uploadFile(String type) async {
    final fileName = basename(state.photo.path);

    state = state.copyWith(isCompleted: true);

    final destination = 'registers/$currentUserUid/$type-$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination);
      await ref.putFile(state.photo);
      var pathReference =
          _storage.ref('registers/$currentUserUid/$type-$fileName');

      pathReference.getDownloadURL().then((value) async {
        state = state.copyWith(
          isCompleted: true,
          image: value,

        );
        updateFilesState(
            idFront: type == "idFront" ? value : state.idFront,
            idBack: type == "idBack" ? value : state.idBack,
            licenseFront: type == "licenseFront" ? value : state.licenseFront,
            licenseBack: type == "image" ? value : state.image,
            psiko: type == "psiko" ? value : state.psiko,
            src: type == "src" ? value : state.src,
            registration: type == "registration" ? value : state.registration,
        );

      });
    } catch (e) {
      debugPrint('error occurred: $e');
    }
  }

  showPicker(BuildContext context,
      {required String language, required String type}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: kLightBlack,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(
                    Icons.photo_camera,
                    color: kWhite,
                  ),
                  title: Text(
                    languages[language]!["camera"]!,
                    style: kCustomTextStyle,
                  ),
                  onTap: () {
                    imgFromCamera(type, context);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.image,
                    color: kWhite,
                  ),
                  title: Text(languages[language]!["gallery"]!,
                      style: kCustomTextStyle),
                  onTap: () {
                    imgFromGallery(type, context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  updateFilesState({
    required String idFront,
    required String idBack,
    required String licenseFront,
    required String licenseBack,
    required String psiko,
    required String src,
    required String registration,
  }) =>
      state = state.copyWith(
        idFront: idFront,
        idBack: idBack,
        licenseFront: licenseFront,
        licenseBack: licenseBack,
        psiko: psiko,
        src: src,
        registration: registration,
      );
}

final authController = StateNotifierProvider<AuthController, AuthState>(
  (ref) => AuthController(
    AuthState(
      isRegister: false,
      isCarrier: true,
      isBroker: false,
      currentUser: UserModel(),
      photo: File(""),
      image: "",
      type: "",
    ),
  ),
);
