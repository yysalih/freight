import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/models/user_model.dart';
import 'package:kamyon/views/loads_views/loads_view.dart';
import 'package:kamyon/views/my_loads_views/my_loads_view.dart';
import 'package:kamyon/views/trucks_views/my_trucks_view.dart';
import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';

class MainState {
  final int bottomIndex;
  final String selectedTab;
  final UserModel currentUser;

  MainState({required this.bottomIndex, required this.selectedTab,
    required this.currentUser});

  MainState copyWith({
    int? bottomIndex,
    String? selectedTab,
    UserModel? currentUser
  }) {
    return MainState(bottomIndex: bottomIndex ?? this.bottomIndex,
        selectedTab: selectedTab ?? this.selectedTab,
    currentUser: currentUser ?? this.currentUser);
  }
}

class MainController extends StateNotifier<MainState> {
  MainController(super.state);



  final List<Widget> pages = [const LoadsView(), const MyLoadsView(), const MyTrucksView(), Container(), Container()];

  List<Map<String, dynamic>> pageInfo = [
    {"label" : "Yük Listesi", "icon" : Icons.format_list_bulleted_outlined},
    {"label" : "Yüklerim", "icon" : Icons.card_membership},
    {"label" : "Araçlarım", "icon" : Icons.local_shipping_outlined},
    {"label" : "Harita", "icon" : Icons.public_outlined},
    {"label" : "Profilim", "icon" : Icons.person_4_outlined},
  ];


  changePage(int index) {
    state = state.copyWith(bottomIndex: index);
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
      debugPrint('UserModel: $userModel');

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
}

final mainController = StateNotifierProvider<MainController, MainState>(
      (ref) => MainController(MainState(bottomIndex: 0, selectedTab: "",
      currentUser: UserModel()),),);