import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/controllers/place_controller.dart';
import 'package:kamyon/models/place_model.dart';
import 'package:kamyon/widgets/input_field_widget.dart';
import 'package:uuid/uuid.dart';

import '../../constants/app_constants.dart';
import '../../constants/languages.dart';
import '../../constants/providers.dart';

class SearchPlaceView extends ConsumerStatefulWidget {
  final bool isOrigin;
  const SearchPlaceView({super.key, required this.isOrigin});

  @override
  ConsumerState<SearchPlaceView> createState() => _SearchPlaceViewState();
}

class _SearchPlaceViewState extends ConsumerState<SearchPlaceView> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final placeNotifier = ref.read(placeController.notifier);
    placeNotifier.searchController.clear();

    placeNotifier.searchController.addListener(() {
      _onChanged();
    },);
  }

  _onChanged() {
    final placeNotifier = ref.read(placeController.notifier);
    //
    // setState(() {
    //   placeNotifier.sessionToken = placeNotifier.uuid.v4();
    // });
    placeNotifier.fetchPlaceDetails(placeNotifier.searchController.text);
   // placeNotifier.getSuggestion(placeNotifier.searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageStateProvider);
    final placeNotifier = ref.watch(placeController.notifier);
    final placeState = ref.watch(placeController);

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: kBlack,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          color: kWhite,
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(languages[language]!["search_places"]!,
          style: const TextStyle(color: kWhite),),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: 1 == 1 ?
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: customInputField(title: "", hintText: languages[language]!["search_places"]!,
                    icon: Icons.map, controller: placeNotifier.searchController,
                    onTap: () {

                    },
                  ),
                )
                : TextField(
              controller: placeNotifier.searchController,
              decoration: InputDecoration(
                hintText: "Search your location here",
                hintStyle: kCustomTextStyle,
                contentPadding: EdgeInsets.all(10),
                focusColor: Colors.white,
                floatingLabelBehavior: FloatingLabelBehavior.never,
                prefixIcon: const Icon(Icons.map, color: kWhite,),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.cancel, color: kWhite,),
                  onPressed: () {
                    placeNotifier.searchController.clear();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: placeState.placeList.length,

              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 10.0.h),
                  child: Column(
                    children: [
                      SizedBox(
                        width: width,
                        child: MaterialButton(
                          height: 50.h,
                          onPressed: () {
                            AppPlaceModel appPlaceModel = AppPlaceModel(
                              name: placeState.placeList[index]["name"],
                              latitude: placeState.placeList[index]["geometry"]["location"]["lat"],
                              longitude: placeState.placeList[index]["geometry"]["location"]["lng"],
                              uid: const Uuid().v4(),
                              address: placeState.placeList[index]["formatted_address"]
                            );
                            placeNotifier.setPlaceModels(origin: widget.isOrigin ? appPlaceModel : placeState.origin,
                              destination: !widget.isOrigin ? appPlaceModel : placeState.destination,);
                            Navigator.pop(context);
                          },
                          child: Text("${placeState.placeList[index]["name"]}\n\n${placeState.placeList[index]["formatted_address"]}",
                            textAlign: TextAlign.start,
                            style: kCustomTextStyle,),
                        ),
                      ),
                      SizedBox(height: 10.h,),
                      Container(
                        width: width * .9,
                        height: .75,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
