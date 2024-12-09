import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location/location.dart';

class LocationState {
  final bool serviceEnabled;
  final PermissionStatus permissionGranted;
  final LocationData locationData;

  LocationState({required this.serviceEnabled,
    required this.permissionGranted,
    required this.locationData
  });

  LocationState copyWith({bool? serviceEnabled,
    PermissionStatus? permissionGranted,
    LocationData? locationData,
  })
  {
    return LocationState(
      serviceEnabled: serviceEnabled ?? this.serviceEnabled,
      permissionGranted: permissionGranted ?? this.permissionGranted,
      locationData: locationData ?? this.locationData,
    );
  }
}

class LocationController extends StateNotifier<LocationState> {
  LocationController(super.state);
  Location location = Location();
  late LocationData locationData = LocationData.fromMap({});
  bool serviceEnabled = false;
  PermissionStatus permissionGranted = PermissionStatus.granted;


  getLocation() async {

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    state = state.copyWith(serviceEnabled: _serviceEnabled);
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    state = state.copyWith(permissionGranted: _permissionGranted);
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      state = state.copyWith(permissionGranted: _permissionGranted);
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    state = state.copyWith(locationData: _locationData);
  }

  getContinuousLocation() async {



    serviceEnabled = await location.serviceEnabled();
    //state = state.copyWith(serviceEnabled: _serviceEnabled);
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    //state = state.copyWith(permissionGranted: _permissionGranted);
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      //state = state.copyWith(permissionGranted: _permissionGranted);
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.enableBackgroundMode(enable: true);

    location.onLocationChanged.listen((LocationData currentLocation) {
      locationData = currentLocation;
      state = state.copyWith(locationData: currentLocation);
    });
  }



}

final locationController = StateNotifierProvider<LocationController, LocationState>(
    (ref) => LocationController(LocationState(
      serviceEnabled: false,
      permissionGranted: PermissionStatus.granted,
      locationData: LocationData.fromMap({})

    ))
);