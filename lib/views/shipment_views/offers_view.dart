import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:kamyon/controllers/offer_controller.dart';
import 'package:kamyon/models/offer_model.dart';
import 'package:kamyon/repos/offer_repository.dart';
import 'package:kamyon/repos/user_repository.dart';
import 'package:kamyon/views/shipment_views/offer_inner_view.dart';
import 'package:kamyon/widgets/warning_info_widget.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';
import '../../widgets/shipment_widgets/offer_widget.dart';

class OffersView extends ConsumerWidget {
  final String unitUid;
  const OffersView({super.key, required this.unitUid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageStateProvider);

    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final offersStream = ref.watch(offersStreamProvider(unitUid));
    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          color: kWhite,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(languages[language]!["offers"]!,
          style: const TextStyle(color: kWhite),),


      ),

      body: SafeArea(
        child: offersStream.when(
          data: (offers) => ListView.builder(
            itemCount: offers.length,
            itemBuilder: (context, index) => offerWidget(offers[index], context: context, language: language),
          ),
          error: (error, stackTrace) => const NoOfferFound(),
          loading: () => loadingWidget(),
        ),
      ),

    );
  }
}

