import 'package:flutter/material.dart';

const String appName = "Kamyon";
const String appFont = "Poppins";

const Color kGreen = Color(0xFF7BC74D);
const Color kBlack = Color(0xFF222831);
const Color kLightBlack = Color(0xFF393E46);
const Color kWhite = Color(0xff7eeeeee);
const Color kLightGreen = Color(0xFFC4DAD2);
const Color kHintColor= Color(0xFFC7C8CC);
const Color kBlueColor= Colors.blueAccent;


const TextStyle kTitleTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20, fontFamily: appFont);
const TextStyle kCustomTextStyle = TextStyle(fontSize: 17, fontFamily: appFont, color: kWhite);

const InputDecoration kInputDecoration = InputDecoration(
  border: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  focusedBorder: InputBorder.none,
  focusedErrorBorder: InputBorder.none,
);

Uri url = Uri.parse('https://coral-lemur-335530.hostingersite.com/get.php');
