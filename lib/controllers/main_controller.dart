import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/models/truck_model.dart';
import 'package:kamyon/models/user_model.dart';
import 'package:kamyon/views/loads_views/loads_view.dart';
import 'package:kamyon/views/my_loads_views/my_loads_view.dart';
import 'package:kamyon/views/profile_views/profile_view.dart';
import 'package:kamyon/views/trucks_views/my_trucks_view.dart';
import 'package:http/http.dart' as http;

import '../constants/app_constants.dart';

class MainState {
  final int bottomIndex;
  final String selectedTab;
  final UserModel currentUser;

  final TruckModel truck;

  final bool isLoadExpanded;
  final bool isTruckPostExpanded;

  final String searchString;

  MainState({
    required this.bottomIndex,
    required this.selectedTab,
    required this.currentUser,
    required this.isLoadExpanded,
    required this.isTruckPostExpanded,
    required this.truck,
    required this.searchString,
  });

  MainState copyWith({
    int? bottomIndex,
    String? selectedTab,
    String? searchString,
    UserModel? currentUser,
    bool? isTruckPostExpanded,
    bool? isLoadExpanded,
    TruckModel? truck,
  }) {
    return MainState(
      bottomIndex: bottomIndex ?? this.bottomIndex,
      selectedTab: selectedTab ?? this.selectedTab,
      currentUser: currentUser ?? this.currentUser,
      isLoadExpanded: isLoadExpanded ?? this.isLoadExpanded,
      isTruckPostExpanded: isTruckPostExpanded ?? this.isTruckPostExpanded,
      truck: truck ?? this.truck,
      searchString: searchString ?? this.searchString,
    );
  }
}

class MainController extends StateNotifier<MainState> {
  MainController(super.state);

  final searchController = TextEditingController();


  final List<Widget> pages = [const LoadsView(), const MyLoadsView(), const MyTrucksView(), Container(), const ProfileView()];

  List<Map<String, dynamic>> pageInfo = [
    {"label" : "Yük Listesi", "icon" : Icons.format_list_bulleted_outlined}, //TODO needs to be replaced with language provider - 30/10/2024 15:04
    {"label" : "Yüklerim", "icon" : Icons.card_membership}, //TODO needs to be replaced with language provider - 30/10/2024 15:04
    {"label" : "Araçlarım", "icon" : Icons.local_shipping_outlined}, //TODO needs to be replaced with language provider - 30/10/2024 15:04
    {"label" : "Harita", "icon" : Icons.public_outlined}, //TODO needs to be replaced with language provider - 30/10/2024 15:04
    {"label" : "Profilim", "icon" : Icons.person_4_outlined}, //TODO needs to be replaced with language provider - 30/10/2024 15:04
  ];


  changePage(int index) {
    state = state.copyWith(bottomIndex: index, isLoadExpanded: false, isTruckPostExpanded: false);


  }

  changeExpansions({required bool isTruckPostExpanded, required bool isLoadExpanded}) {
    state = state.copyWith(isTruckPostExpanded: isTruckPostExpanded, isLoadExpanded: isLoadExpanded);
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

  changeTruck({required TruckModel value}) => state = state.copyWith(truck: value);

  changeSearchString({required String value}) => state = state.copyWith(searchString: value);
}

final mainController = StateNotifierProvider<MainController, MainState>(
      (ref) => MainController(MainState(bottomIndex: 0, selectedTab: "", isLoadExpanded: false, isTruckPostExpanded: false,
      currentUser: UserModel(), truck: TruckModel(name: ""), searchString: ""),),);