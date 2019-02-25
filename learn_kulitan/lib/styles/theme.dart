import 'package:flutter/material.dart';

// Colors
const primaryColor = Color(0xFFFABF40);
const accentColor = Color(0xFFFF4546);
const grayColor = Color(0xFF626262);
const snowColor = Color(0xFFE5E5E5);
const blueGreenColor = Color(0xFF00FFD8);
const blueColor = Color(0xFFDBF3FF);
const lightBlueColor = Color(0xFFEDFAFF);
const whiteColor = Color(0xFFFFFFFF);

const cardQuizColor1 = whiteColor;
const cardQuizColor2 = lightBlueColor;
const cardQuizColor3 = blueColor;
const cardChoicesColor = whiteColor;
const cardChoicesRightColor = blueGreenColor;
const cardChoicesWrongColor = accentColor;

// Spacings
const horizontalScreenPadding = 38.0;
const verticalScreenPadding = 28.0;
const headerPadding = 14.0;
const cardQuizHorizontalPadding = 26.0;
const cardQuizVerticalPadding = 20.0;
const choiceSpacing = 14.0;

// Sizes
const headerIconSize = 32.0;

// Kulitan Fonts
const kulitanHome = TextStyle(
  fontFamily: 'Baybayin Pamagkulit',
  fontSize: 30.0,
  color: grayColor,
  height: 0.68,
);
const kulitanQuiz = TextStyle(
  fontFamily: 'Baybayin Pamagkulit',
  fontSize: 150.0,
  color: grayColor,
);
const kulitanWriting = TextStyle(
  fontFamily: 'Baybayin Pamagkulit',
  fontSize: 200.0,
  color: snowColor,
);
const kulitanInfo = TextStyle(
  fontFamily: 'Baybayin Pamagkulit',
  fontSize: 45.0,
  color: whiteColor,
);
const kulitanTranslate = TextStyle(
  fontFamily: 'Baybayin Pamagkulit',
  fontSize: 60.0,
  color: grayColor,
);

// Barlow Fonts
const textHomeTitle = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 75.0,
  fontWeight: FontWeight.bold,
  color: whiteColor,
  shadows: <Shadow>[
    Shadow(color: accentColor, offset: Offset(5.0, 7.0))
  ]
);
const textHomeSubtitle = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
  color: whiteColor,
  shadows: <Shadow>[
    Shadow(color: accentColor, offset: Offset(4.0, 4.0))
  ]
);
const textHomeButton = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 40.0,
  fontWeight: FontWeight.w600,
  color: grayColor,
);
const textPageTitle = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 50.0,
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  color: whiteColor,
  shadows: <Shadow>[
    Shadow(color: accentColor, offset: Offset(4.0, 4.0))
  ]
);
const textQuizHeader = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 25.0,
  fontWeight: FontWeight.bold,
  color: whiteColor,
);
const textQuizAnswer = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 110.0,
  color: grayColor,
);
const textQuizChoice = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 30.0,
  fontWeight: FontWeight.w600,
  color: grayColor,
);
const textQuizChoiceWrong = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 30.0,
  fontWeight: FontWeight.w600,
  color: whiteColor,
);
const textWriting = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 100.0,
  fontWeight: FontWeight.bold,
  color: whiteColor,
);
const textWritingGuide = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 15.0,
  fontWeight: FontWeight.bold,
  color: accentColor,
);
const textInfoCaption = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: grayColor,
);
const textTranslate = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 40.0,
  fontWeight: FontWeight.bold,
  color: grayColor,
);