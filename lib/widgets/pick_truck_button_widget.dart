import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/controllers/offer_controller.dart';
import 'package:kamyon/widgets/search_card_widget.dart';

import '../constants/app_constants.dart';
import '../constants/languages.dart';
import '../constants/providers.dart';
import '../controllers/main_controller.dart';
import '../models/truck_model.dart';
import '../repos/truck_repository.dart';

class PickTruckButton extends ConsumerWidget {
  const PickTruckButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final GlobalKey _menuKey = GlobalKey();

    final trucksProvider = ref.watch(trucksStreamProvider(FirebaseAuth.instance.currentUser!.uid));

    final width = MediaQuery.of(context).size.width;
    final language = ref.watch(languageStateProvider);

    final mainState = ref.watch(mainController);

    final mainNotifier = ref.watch(mainController.notifier);
    final offerNotifier = ref.watch(offerController.notifier);

    return trucksProvider.when(
      data: (trucks) => PopupMenuButton(
        color: kBlack,
        key: _menuKey,
        child: searchCardWidget(width, hasTitle: false,
          halfLength: false,
          title: languages[language]!["pick_truck"]!,
          hint: mainState.truck.name!.isNotEmpty ?
          mainState.truck.name!
              : languages[language]!["pick_truck"]!, onPressed: () {
            final dynamic popupMenu = _menuKey.currentState;
            popupMenu.showButtonMenu();
          },),
        onSelected: (value) {
          mainNotifier.changeTruck(value: value);
          offerNotifier.changeTruck(value: value);
        },
        itemBuilder: (context) => <PopupMenuEntry<TruckModel>>[
          for(int i = 0; i < trucks.length; i++) PopupMenuItem<TruckModel>(

            value: trucks[i],
            child: Text(trucks[i].name!, style: kCustomTextStyle,),
          ),
        ],
      ),
      loading: () => const SizedBox(),
      error: (error, stackTrace) => const SizedBox(),
    );
  }
}

