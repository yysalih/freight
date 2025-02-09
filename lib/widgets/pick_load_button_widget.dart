import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/controllers/offer_controller.dart';
import 'package:kamyon/repos/load_repository.dart';
import 'package:kamyon/widgets/search_card_widget.dart';

import '../constants/app_constants.dart';
import '../constants/languages.dart';
import '../constants/providers.dart';
import '../controllers/main_controller.dart';
import '../models/load_model.dart';
import '../models/truck_model.dart';
import '../repos/truck_repository.dart';

class PickLoadButton extends ConsumerWidget {
  const PickLoadButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey _menuKey = GlobalKey();

    final loadsProvider = ref.watch(loadsStreamProvider(FirebaseAuth.instance.currentUser!.uid));

    final width = MediaQuery.of(context).size.width;
    final language = ref.watch(languageStateProvider);

    final mainState = ref.watch(mainController);

    final mainNotifier = ref.watch(mainController.notifier);
    final offerNotifier = ref.watch(offerController.notifier);

    return loadsProvider.when(
      data: (loads) => PopupMenuButton(
        color: kBlack,
        key: _menuKey,
        child: searchCardWidget(width, hasTitle: false,
          halfLength: false,
          title: languages[language]!["pick_load"]!,
          hint: mainState.load.originName!.isNotEmpty ? mainState.load.originName! : languages[language]!["pick_load"]!,
          onPressed: () {
            final dynamic popupMenu = _menuKey.currentState;
            popupMenu.showButtonMenu();
          },),
        onSelected: (value) {
          mainNotifier.changeLoad(value: value);
          offerNotifier.changeLoad(value: value);
        },
        itemBuilder: (context) => <PopupMenuEntry<LoadModel>>[
          for(int i = 0; i < loads.length; i++) PopupMenuItem<LoadModel>(

            value: loads[i],
            child: Text("${loads[i].originName!} - ${loads[i].destinationName!}", style: kCustomTextStyle,),
          ),
        ],
      ),
      loading: () => const SizedBox(),
      error: (error, stackTrace) => const SizedBox(),
    );
  }
}

