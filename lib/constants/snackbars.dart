import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kamyon/constants/app_constants.dart';

showSnackbar({required BuildContext context, required String title}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(title),
    backgroundColor: kBlack,
  ));
}

showWarningSnackbar({required BuildContext context, required String title}){
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(title),
    backgroundColor: kBlueColor,
  ));
}