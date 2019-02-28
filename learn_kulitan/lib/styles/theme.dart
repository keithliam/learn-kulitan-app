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

const backgroundColor = primaryColor;
const headerNavigationColor = whiteColor;
const circularProgressTextColor = whiteColor;
const circularProgressForegroundColor = accentColor;
const circularProgressBackgroundColor = whiteColor;
const linearProgressForegroundColor = accentColor;
const linearProgressBackgroundColor = snowColor;

const customCardShadowColor = Color(0x21000000);
const customButtonDefaultColor = whiteColor;
const customButtonShadowColor = Color(0x22000000);
const iconButtonDefaultColor = whiteColor;

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
const cardQuizStackBottomPadding = verticalScreenPadding;
const choiceSpacing = 14.0;
const quizChoiceButtonElevation = 10.0;

// Sizes
const headerIconSize = 32.0;
const quizChoiceButtonHeight = 62.0;
const quizCardStackTopSpace = 32.0;

// Sensitivity
const swipeDownSensitivity = 1.0;
const swipeLeftSensitivity = 1.0;
const swipeLeftThreshold = 0.25;
const swipeLeftMax = 350.0;

// Velocities
const quizCardMoveUpVelocity = 1.0;
const quizCardMoveLeftVelocity = 1.0;
const quizCardRotateVelocity = 1.0;

// Curves
const customButtonPressCurve = Curves.easeOutQuart;
const progressBarCurve = Curves.fastOutSlowIn;
const quizCardSwipeUpCurve = Curves.easeInOut;  // 0.5 -> 0.5 curves only
const quizCardAutoSwipeUpCurve = Curves.decelerate;
const quizCardSwipeLeftCurve = Curves.fastOutSlowIn;

// Durations
const swipeUpSnapDuration = 250;
const autoSwipeUpDuration = 500;
const revealAnswerOffset = 250;
const swipeLeftSnapDuration = 250;
const updateQuizCardProgressOffset = 250;

// Progress Totals
const maxQuizCharacterProgress = 10;

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
  height: 0.8,
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