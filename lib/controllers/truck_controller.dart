import 'package:flutter_riverpod/flutter_riverpod.dart';

class TruckState {
  final bool isPartial;

  TruckState({required this.isPartial});

  TruckState copyWith({
    bool? isPartial,
  }) {
    return TruckState(isPartial: isPartial ?? this.isPartial);
  }
}

class TruckController extends StateNotifier<TruckState> {
  TruckController(super.state);


  changeVehicleLimit() {
    state = state.copyWith(isPartial: !state.isPartial);
  }
}

final truckController = StateNotifierProvider<TruckController, TruckState>(
      (ref) => TruckController(TruckState(isPartial: false),),);