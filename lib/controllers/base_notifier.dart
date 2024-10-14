import 'package:flutter/material.dart';

import '../models/user_model.dart';

abstract class BaseNotifier {
  void switchStrings({required String truckType, required String contact});
  void addNewPhoneNumberToUser({required UserModel currentUser});
  TextEditingController get phoneController;
}
