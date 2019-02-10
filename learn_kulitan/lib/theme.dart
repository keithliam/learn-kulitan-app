import 'package:flutter/material.dart';

// Colors
final primaryColor = Color(0xFFFABF40);
final accentColor = Color(0xFFFF4546);
final grayColor = Color(0xFF626262);
final snowColor = Color(0xFFE5E5E5);
final blueGreenColor = Color(0xFF00FFD8);
final blueColor = Color(0xFFDBF3FF);
final lightBlueColor = Color(0xFFEDFAFF);
final whiteColor = Color(0xFFFFFFFF);

// Kulitan Fonts
final kulitanHome = TextStyle(
  fontFamily: 'Baybayin Pamagkulit',
  fontSize: 30.0,
  color: grayColor,
);
final kulitanQuiz = TextStyle(
  fontFamily: 'Baybayin Pamagkulit',
  fontSize: 110.0,
  color: grayColor,
);
final kulitanWriting = TextStyle(
  fontFamily: 'Baybayin Pamagkulit',
  fontSize: 200.0,
  color: snowColor,
);
final kulitanInfo = TextStyle(
  fontFamily: 'Baybayin Pamagkulit',
  fontSize: 45.0,
  color: whiteColor,
);
final kulitanTranslate = TextStyle(
  fontFamily: 'Baybayin Pamagkulit',
  fontSize: 60.0,
  color: grayColor,
);

// Barlow Fonts
final textHomeTitle = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 75.0,
  fontWeight: FontWeight.bold,
  color: whiteColor,
);
final textHomeSubtitle = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
  color: whiteColor,
);
final textHomeButton = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 40.0,
  fontWeight: FontWeight.w600,
  color: grayColor,
);
final textPageTitle = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  color: whiteColor,
);
final textQuizHeader = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: whiteColor,
);
final textQuizAnswer = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 110.0,
  color: grayColor,
);
final textQuizChoice = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 30.0,
  fontWeight: FontWeight.w600,
  color: grayColor,
);
final textQuizChoiceWrong = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 30.0,
  fontWeight: FontWeight.w600,
  color: whiteColor,
);
final textWriting = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 100.0,
  fontWeight: FontWeight.bold,
  color: whiteColor,
);
final textWritingGuide = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
  color: accentColor,
);
final textInfoCaption = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: grayColor,
);
final textTranslate = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 40.0,
  fontWeight: FontWeight.bold,
  color: grayColor,
);

final appTheme = ThemeData(
  primaryColor: primaryColor,
  primaryColorBrightness: Brightness.light,
  accentColor: accentColor,
  accentColorBrightness: Brightness.dark,
  backgroundColor: primaryColor,
  buttonColor: whiteColor,
  cardColor: whiteColor,
);