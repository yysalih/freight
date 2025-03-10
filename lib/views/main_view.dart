import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/constants/app_constants.dart';
import 'package:kamyon/widgets/app_bottom_bar_widget.dart';
import 'package:kamyon/widgets/app_drawer_widget.dart';

import '../controllers/main_controller.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  ConsumerState<MainView> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {


  @override
  Widget build(BuildContext context) {

    final mainNotifier = ref.watch(mainController.notifier);
    final mainState = ref.watch(mainController);

    return Scaffold(
      backgroundColor: kBlack,
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: mainNotifier.pages[mainState.bottomIndex],
      ),
      bottomNavigationBar: const AppBottomBarWidget(),
      drawer: mainState.bottomIndex == 0 ? const AppDrawerWidget() : null,
    );
  }
}
