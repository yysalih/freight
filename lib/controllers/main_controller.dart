import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/views/loads_views/loads_view.dart';
import 'package:kamyon/views/my_loads_views/my_loads_view.dart';
import 'package:kamyon/views/trucks_views/my_trucks_view.dart';

class MainState {
  final int bottomIndex;
  final String selectedTab;

  MainState({required this.bottomIndex, required this.selectedTab});

  MainState copyWith({
    int? bottomIndex,
    String? selectedTab,
  }) {
    return MainState(bottomIndex: bottomIndex ?? this.bottomIndex, selectedTab: selectedTab ?? this.selectedTab);
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
}

final mainController = StateNotifierProvider<MainController, MainState>(
      (ref) => MainController(MainState(bottomIndex: 0, selectedTab: ""),),);