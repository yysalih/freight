import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/constants/app_constants.dart';

import '../controllers/main_controller.dart';

class AppBottomBarWidget extends ConsumerWidget {
  const AppBottomBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final mainNotifier = ref.watch(mainController.notifier);
    final mainState = ref.watch(mainController);

    return Theme(
      data: Theme.of(context).copyWith(
        // sets the background color of the `BottomNavigationBar`
          canvasColor: kBlack,
          textTheme: Theme
              .of(context)
              .textTheme),
      child: BottomNavigationBar(
        backgroundColor: kBlack,
        currentIndex: mainState.bottomIndex,
        onTap: (value) => mainNotifier.changePage(value),
        unselectedLabelStyle: const TextStyle(color: Colors.black),

        selectedItemColor: kBlueColor,
        unselectedItemColor: kWhite,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          for(int i = 0; i < mainNotifier.pageInfo.length; i++)
            BottomNavigationBarItem(
              icon: Icon(mainNotifier.pageInfo[i]["icon"]),
              label: mainNotifier.pageInfo[i]["label"],
      //mainNotifier.pageInfo[i]["icon"]
            ),
        ],

        selectedLabelStyle: const TextStyle(color: Colors.black),
      ),
    );
  }
}
