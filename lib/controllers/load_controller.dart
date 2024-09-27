import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamyon/models/place_model.dart';
import 'package:kamyon/views/loads_views/loads_view.dart';
import 'package:kamyon/views/my_loads_views/my_loads_view.dart';
import 'package:kamyon/views/trucks_views/my_trucks_view.dart';

class LoadState {

  final AppPlaceModel origin;
  final AppPlaceModel destination;
  final String truckType;
  final bool isPartial;
  final bool isPalletized;
  final String contact;
  final DateTime startDate;
  final DateTime endDate;
  final TimeOfDay startHour;
  final TimeOfDay endHour;

  LoadState({
    required this.origin, required this.destination, required this.truckType, required this.isPartial, required this.isPalletized,
    required this.contact, required this.startDate, required this.endDate, required this.startHour, required this.endHour
  });

  LoadState copyWith({
    AppPlaceModel? origin,
    AppPlaceModel? destination,
    String? truckType,
    bool? isPartial,
    bool? isPalletized,
    String? contact,
    DateTime? startDate,
    DateTime? endDate,
    TimeOfDay? startHour,
    TimeOfDay? endHour,
  }) {
    return LoadState(
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      truckType: truckType ?? this.truckType,
      isPartial: isPartial ?? this.isPartial,
      isPalletized: isPalletized ?? this.isPalletized,
      contact: contact ?? this.contact,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startHour: startHour ?? this.startHour,
      endHour: endHour ?? this.endHour,
    );
  }
}

class LoadController extends StateNotifier<LoadState> {
  LoadController(super.state);

  final lengthController = TextEditingController();
  final weightController = TextEditingController();
  final volumeController = TextEditingController();
  final phoneController = TextEditingController();
  final priceController = TextEditingController();


  switchBools({required bool isPartial, required bool isPalletized}) => state = state.copyWith(isPalletized: isPalletized, isPartial: isPartial);
  switchStrings({required String truckType, required String contact}) => state = state.copyWith(truckType: truckType, contact: contact);
  switchDateTimes({required DateTime startDate, required DateTime endDate}) => state = state.copyWith(startDate: startDate, endDate: endDate);
  switchTimeOfDays({required TimeOfDay startHour, required TimeOfDay endHour}) => state = state.copyWith(startHour: startHour, endHour: endHour);
  switchAppPlaceModels({required AppPlaceModel origin, required AppPlaceModel destination}) => state = state.copyWith(origin: origin, destination: destination);


}

final loadController = StateNotifierProvider<LoadController, LoadState>(
      (ref) => LoadController(LoadState(
        origin: AppPlaceModel(),
        destination: AppPlaceModel(),
        truckType: "",
        isPartial: false,
        isPalletized: false,
        contact: "",
        startDate: DateTime.now(),
        endDate: DateTime.now(),
        startHour: TimeOfDay.now(),
        endHour: TimeOfDay.now(),
      ),),);