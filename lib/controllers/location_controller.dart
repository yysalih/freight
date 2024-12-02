import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationState {

}

class LocationController extends StateNotifier<LocationState> {
  LocationController(super.state);

}

final locationController = StateNotifierProvider<LocationController, LocationState>(
    (ref) => LocationController(LocationState())
);