import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kamyon/constants/providers.dart';
import 'package:kamyon/main.dart';
import 'package:kamyon/models/load_model.dart';
import 'package:kamyon/models/truck_post_model.dart';
import 'package:kamyon/repos/place_repository.dart';
import 'package:kamyon/views/loads_views/load_inner_view.dart';
import 'package:kamyon/views/trucks_views/new_post_view.dart';
import 'package:kamyon/views/trucks_views/truck_post_inner_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

Marker loadMarker(LoadModel load, {required BuildContext context}) {
  return Marker(
    point: LatLng(load.originLat!, load.originLong!),
    width: 40.w, height: 40.h,
    child: GestureDetector(
      onTap: () => Navigator.push(context, routeToView(LoadInnerView(uid: load.uid!))),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        child: Image.asset("assets/icons/box.png", width: 25.w,),
      ),
    ),
  );
}

Marker truckPostMarker(TruckPostModel truckPost, {required BuildContext context}) {
  return Marker(
    point: LatLng(truckPost.originLat!, truckPost.originLong!),
    width: 40.w, height: 40.h,
    child: GestureDetector(
      onTap: () => Navigator.push(context, routeToView(TruckPostInnerView(uid: truckPost.uid!,))),
      child: CircleAvatar(
        radius: 25,
        backgroundColor: Colors.white,
        child: Image.asset("assets/icons/truck.png", width: 25.w,),
      ),
    ),
  );
}


Widget emptyFlutterMap(LatLng initial) {
  return FlutterMap(
    options: MapOptions(
      initialCenter: initial,//LatLng(41.0082376, 28.9783589),
      initialZoom: 9.2,
    ),
    children: [
      TileLayer(
        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
        userAgentPackageName: 'com.kamyon',
        maxNativeZoom: 19,
      ),
      RichAttributionWidget(
        attributions: [
          TextSourceAttribution(
            'OpenStreetMap contributors',
            onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
          ),
          // Also add images...
        ],
      ),
      MarkerLayer(markers: [
        Marker(
            point: initial,
            child: Icon(Icons.my_location, color: Colors.red, size: 30.w,)
        )
      ])
    ],
  );
}