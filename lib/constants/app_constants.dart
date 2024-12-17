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

const InputDecoration kInputDecorationWithNoBorder = InputDecoration(
  border: InputBorder.none,
  errorBorder: InputBorder.none,
  disabledBorder: InputBorder.none,
  enabledBorder: InputBorder.none,
  focusedBorder: InputBorder.none,
  focusedErrorBorder: InputBorder.none,
);


Uri appUrl = Uri.parse('https://coral-lemur-335530.hostingersite.com/get.php');

const String kApiKey = "AIzaSyDZg_ZZdVGiLpdwBs3pbnP6sl4JaEquLY8";


const List<String> cities = [
  "Adana",
  "Adıyaman",
  "Afyonkarahisar",
  "Ağrı",
  "Aksaray",
  "Amasya",
  "Ankara",
  "Antalya",
  "Ardahan",
  "Artvin",
  "Aydın",
  "Balıkesir",
  "Bartın",
  "Batman",
  "Bayburt",
  "Bilecik",
  "Bingöl",
  "Bitlis",
  "Bolu",
  "Burdur",
  "Bursa",
  "Çanakkale",
  "Çankırı",
  "Çorum",
  "Denizli",
  "Diyarbakır",
  "Düzce",
  "Edirne",
  "Elazığ",
  "Erzincan",
  "Erzurum",
  "Eskişehir",
  "Gaziantep",
  "Giresun",
  "Gümüşhane",
  "Hakkâri",
  "Hatay",
  "Iğdır",
  "Isparta",
  "İstanbul",
  "İzmir",
  "Kahramanmaraş",
  "Karabük",
  "Karaman",
  "Kars",
  "Kastamonu",
  "Kayseri",
  "Kilis",
  "Kırıkkale",
  "Kırklareli",
  "Kırşehir",
  "Kocaeli",
  "Konya",
  "Kütahya",
  "Malatya",
  "Manisa",
  "Mardin",
  "Mersin",
  "Muğla",
  "Muş",
  "Nevşehir",
  "Niğde",
  "Ordu",
  "Osmaniye",
  "Rize",
  "Sakarya",
  "Samsun",
  "Şanlıurfa",
  "Siirt",
  "Sinop",
  "Sivas",
  "Şırnak",
  "Tekirdağ",
  "Tokat",
  "Trabzon",
  "Tunceli",
  "Uşak",
  "Van",
  "Yalova",
  "Yozgat",
  "Zonguldak",
];