import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kamyon/constants/languages.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/user_model.dart';
import '../services/authentication_service.dart';
import 'package:http/http.dart' as http;


class ProfileState {
  final File photo;
  final bool isCompleted;
  final String image;

  final bool carrierCheck;
  final bool brokerCheck;
  final bool shipperCheck;

  ProfileState({required this.photo, required this.isCompleted, required this.image,
    required this.carrierCheck, required this.brokerCheck,
    required this.shipperCheck
  });

  ProfileState copyWith({
    File? photo,
    bool? isCompleted,
    bool? brokerCheck,
    bool? carrierCheck,
    bool? shipperCheck,
    String? image,
  }) {
    return ProfileState(
      image: image ?? this.image,
      isCompleted: isCompleted ?? this.isCompleted,
      photo: photo ?? this.photo,
      brokerCheck: brokerCheck ?? this.brokerCheck,
      carrierCheck: carrierCheck ?? this.carrierCheck,
      shipperCheck: shipperCheck ?? this.shipperCheck,
    );
  }
}

class ProfileController extends StateNotifier<ProfileState> {
  ProfileController(super.state);

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("uid");
    await Authentication.signOut(context: context);
  }

  deleteAccount(BuildContext context, String language) async {
    User user = FirebaseAuth.instance.currentUser!;
    String uid = user.uid;

    try {
      await user.delete();
      await deleteUser(uid);
    }
    catch(e) {
      logout(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: kLightBlack,
        content: Text(languages[language]!["may_delete_after_login"]!, style: kCustomTextStyle,),
      ));
    }

  }

  deleteUser(String uid) async {
    String query = 'DELETE FROM users WHERE uid = "$uid"';
    final response = await http.post(appUrl, body: {"executeQuery": query});

    String query1 = 'DELETE FROM loads WHERE ownerUid = "$uid"';
    final response1 = await http.post(appUrl, body: {"executeQuery": query1});

    String query2 = 'DELETE FROM trailers WHERE ownerUid = "$uid"';
    final response2 = await http.post(appUrl, body: {"executeQuery": query2});

    String query3 = 'DELETE FROM truck_posts WHERE ownerUid = "$uid"';
    final response3 = await http.post(appUrl, body: {"executeQuery": query3});

    String query4 = 'DELETE FROM trucks WHERE ownerUid = "$uid"';
    final response4 = await http.post(appUrl, body: {"executeQuery": query4});

    if(response.statusCode == 200) {
      var data = jsonDecode(response.body);
      debugPrint('Response: User Deleted: $data');
    }

    if(response1.statusCode == 200) {
      var data = jsonDecode(response1.body);

      debugPrint('Response: User Loads Deleted: $data');
    }

    if(response2.statusCode == 200) {
      var data = jsonDecode(response2.body);
      debugPrint('Response: User Trailers Deleted: $data');
    }

    if(response3.statusCode == 200) {
      var data = jsonDecode(response3.body);
      debugPrint('Response: User Truck Posts Deleted: $data');
    }

    if(response4.statusCode == 200) {
      var data = jsonDecode(response4.body);
      debugPrint('Response: User Trucks Deleted: $data');
    }
  }


  Future imgFromCamera(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera, imageQuality: 25);
    if (pickedFile != null) {
      state = state.copyWith(
          photo: File(pickedFile.path)
      );
      uploadFile();
    } else {
      debugPrint('No image selected.');
    }
  }

  Future imgFromGallery(BuildContext context) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 25);

    if (pickedFile != null) {
      state = state.copyWith(photo: File(pickedFile.path));
      uploadFile();
    } else {
      debugPrint('No image selected.');
    }

  }

  Future uploadFile() async {

    final fileName = basename(state.photo.path);

    state = state.copyWith(isCompleted: true);

    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination);
      await ref.putFile(state.photo);
      var pathReference = _storage.ref('files/$fileName');

      pathReference.getDownloadURL().then((value) async {

        state = state.copyWith(isCompleted: true, image: value);

      });

    } catch (e) {
      debugPrint('error occured: $e');
    }
  }
  showPicker(BuildContext context, {required String language}) {
    showModalBottomSheet(
        context: context,
        backgroundColor: kLightBlack,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera, color: kWhite,),
                  title: Text(languages[language]!["camera"]!, style: kCustomTextStyle,),
                  onTap: () {
                    imgFromCamera(context);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image, color: kWhite,),
                  title: Text(languages[language]!["gallery"]!, style: kCustomTextStyle),
                  onTap: () {
                    imgFromGallery(context);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  switchBroker() => state = state.copyWith(brokerCheck: true, carrierCheck: false, shipperCheck: false);
  switchCarrier() => state = state.copyWith(carrierCheck: true, brokerCheck: false, shipperCheck: false);
  switchShipper() => state = state.copyWith(shipperCheck: true, carrierCheck: false, brokerCheck: false,);


  changeLanguage(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("language", value);
  }

  deleteContact(UserModel currentUser, {required BuildContext context, required String contactToDelete}) async {
    // Split the contacts into a list, remove the contact to delete, and rejoin the list
    List<String> contactsList = currentUser.contacts!.split(';');
    contactsList.removeWhere((contact) => contact == contactToDelete);  // Remove the contact
    String updatedContacts = contactsList.join(';') + ';';  // Rebuild the contacts string with semicolons

    // Send the updated contacts back to the server
    final response = await http.post(
      appUrl,
      body: {
        'executeQuery': "UPDATE users SET contacts = '$updatedContacts' WHERE uid = '${currentUser.uid}'",
      },
    );

    // Handle the server response
    if (response.statusCode == 200) {
      var data = response.body;
      if (data.toString().contains("error")) {
        debugPrint('Error: ${response.statusCode}');
        debugPrint('Error: ${response.reasonPhrase}');
      } else {
        debugPrint('Contact deleted successfully');
        debugPrint('Updated Contacts: $updatedContacts');
      }
    } else {
      debugPrint('Error: ${response.statusCode}');
      debugPrint('Error: ${response.reasonPhrase}');
    }
  }

}

final profileController = StateNotifierProvider<ProfileController, ProfileState>((ref) => ProfileController(ProfileState(
  image: "",
  isCompleted: false,
  carrierCheck: false,
  photo: File(""),
  brokerCheck: false,
  shipperCheck: false
)),);