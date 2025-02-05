import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/repos/shipment_repository.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../widgets/shipment_widgets/shipment_widget.dart';
import '../../widgets/warning_info_widget.dart';

class ShipmentsView extends ConsumerWidget {
  const ShipmentsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);



    final shipmentsStream = ref.watch(shipmentsStreamProvider(FirebaseAuth.instance.currentUser!.uid));

    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          color: kWhite,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(languages[language]!["active_shipments"]!,
          style: const TextStyle(color: kWhite),),

      ),
      body: SafeArea(
        child: shipmentsStream.when(
          data: (shipments) => ListView.builder(
            itemCount: shipments.length,
            itemBuilder: (context, index) => shipmentWidget(shipments[index], context: context, language: language),
          ),
          error: (error, stackTrace) => const NoOfferFound(),
          loading: () => loadingWidget(),
        ),
      ),
    );
  }
}
