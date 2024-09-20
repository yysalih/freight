import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthState {
  final bool isRegister;
  final bool isCarrier;
  final bool isBroker;

  AuthState({required this.isRegister, this.isCarrier = true, this.isBroker = false});

  AuthState copyWith({
    bool? isRegister,
    bool? isCarrier,
    bool? isBroker,
  }) {
    return AuthState(isRegister: isRegister ?? this.isRegister, isBroker: isBroker ?? this.isBroker,
        isCarrier: isCarrier ?? this.isCarrier);
  }
}

class AuthController extends StateNotifier<AuthState> {
  AuthController(super.state);

  switchRegister() {
    state = state.copyWith(isRegister: !state.isRegister);
  }
  switchCarrier() {
    state = state.copyWith(isCarrier: !state.isCarrier);
  }

  switchBroker() {
    state = state.copyWith(isBroker: !state.isBroker);
  }
}

final authController = StateNotifierProvider<AuthController, AuthState>(
      (ref) => AuthController(AuthState(isRegister: false, isCarrier: true, isBroker: false),),);