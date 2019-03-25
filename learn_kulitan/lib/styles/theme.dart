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
const writingHeaderProgressBGColor = whiteColor;

const customCardDefaultColor = whiteColor;
const customCardShadowColor = Color(0x21000000);
const customButtonDefaultColor = whiteColor;
const customButtonShadowColor = Color(0x22000000);

const cardQuizColor1 = whiteColor;
const cardQuizColor2 = lightBlueColor;
const cardQuizColor3 = blueColor;
const cardChoicesColor = whiteColor;
const cardChoicesRightColor = blueGreenColor;
const cardChoicesWrongColor = accentColor;

const writingGuideColor = accentColor;
const writingDrawColor = grayColor;
const writingKulitanColor = snowColor;

// Spacings
const homeHorizontalScreenPadding = 32.0;
const homeVerticalScreenPadding = 32.0;
const quizHorizontalScreenPadding = 32.0;
const quizVerticalScreenPadding = quizHorizontalScreenPadding - quizChoiceButtonElevation;
const writingHorizontalScreenPadding = 32.0;
const writingVerticalScreenPadding = 32.0;
const headerHorizontalPadding = 5.0;
const headerVerticalPadding = 10.0;
const cardQuizHorizontalPadding = 26.0;
const cardQuizVerticalPadding = 20.0;
const cardQuizStackBottomPadding = quizVerticalScreenPadding;
const cardWritingHorizontalPadding = 26.0;
const cardWritingVerticalPadding = 20.0;
const choiceSpacing = 14.0;
const quizChoiceButtonElevation = 10.0;

// Sizes
const homeTitleHeight = 110.0;
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
const quizCardSwipeDownCurve = Curves.easeInOut;  // 0.5 -> 0.5 curves only
const quizCardAutoSwipeDownCurve = Curves.decelerate;
const quizCardSwipeLeftCurve = Curves.fastOutSlowIn;
const quizCardForwardCurve = Curves.fastOutSlowIn;

// Durations
const linearProgressBarChangeDuration = 1000;
const showAnswerChoiceDuration = 250;
const resetQuizDuration = 750;
const quizChoicePressDuration = 250;
const resetChoicesDuration = resetQuizDuration ~/ 2;
const swipeDownSnapDuration = 250;
const autoSwipeDownDuration = 500;
const revealAnswerOffset = 0;
const swipeLeftSnapDuration = 250;
const forwardQuizCardsDuration = resetQuizDuration;
const updateQuizCardProgressOffset = 250;
const quizCardsForwardDuration = 500;
const showAnswerToEnableSwipeDuration = 0;  // linearProgressBarChangeDuration

// Kulitan
const Map<String, String> kulitanGlyphs = {
  'a': 'a',
  'i': 'e',
  'u': 'o',
  'e': 'ee',
  'o': 'oo',
  'á': 'aa',
  'â': 'aa',
  'í': 'ii',
  'î': 'ii',
  'ú': 'uu',
  'û': 'uu',
  'ga': 'g',
  'ka': 'k',
  'ta': 't',
  'da': 'd',
  'na': 'n',
  'la': 'l',
  'ma': 'm',
  'pa': 'p',
  'sa': 's',
  'ba': 'b',
  'nga': 'ng',
  'gá': 'gaa',
  'gâ': 'gaa',
  'ká': 'kaa',
  'kâ': 'kaa',
  'tá': 'taa',
  'tâ': 'taa',
  'dá': 'daa',
  'dâ': 'daa',
  'ná': 'naa',
  'nâ': 'naa',
  'lá': 'laa',
  'lâ': 'laa',
  'má': 'maa',
  'mâ': 'maa',
  'pá': 'paa',
  'pâ': 'paa',
  'sá': 'saa',
  'sâ': 'saa',
  'bá': 'baa',
  'bâ': 'baa',
  'ngá': 'ngaa',
  'ngâ': 'ngaa',
  'gi': 'gi',
  'ki': 'ki',
  'ti': 'ti',
  'di': 'di',
  'ni': 'ni',
  'li': 'li',
  'mi': 'mi',
  'pi': 'pi',
  'si': 'si',
  'bi': 'bi',
  'ngi': 'ngi',
  'gí': 'gii',
  'gî': 'gii',
  'kí': 'kii',
  'kî': 'kii',
  'tí': 'tii',
  'tî': 'tii',
  'dí': 'dii',
  'dî': 'dii',
  'ní': 'nii',
  'nî': 'nii',
  'lí': 'lii',
  'lî': 'lii',
  'mí': 'mii',
  'mî': 'mii',
  'pí': 'pii',
  'pî': 'pii',
  'sí': 'sii',
  'sî': 'sii',
  'bí': 'bii',
  'bî': 'bii',
  'ngí': 'ngii',
  'ngî': 'ngii',
  'gu': 'gu',
  'ku': 'ku',
  'tu': 'tu',
  'du': 'du',
  'nu': 'nu',
  'lu': 'lu',
  'mu': 'mu',
  'pu': 'pu',
  'su': 'su',
  'bu': 'bu',
  'ngu': 'ngu',
  'gú': 'guu',
  'gû': 'guu',
  'kú': 'kuu',
  'kû': 'kuu',
  'tú': 'tuu',
  'tû': 'tuu',
  'dú': 'duu',
  'dû': 'duu',
  'nú': 'nuu',
  'nû': 'nuu',
  'lú': 'luu',
  'lû': 'luu',
  'mú': 'muu',
  'mû': 'muu',
  'pú': 'puu',
  'pû': 'puu',
  'sú': 'suu',
  'sû': 'suu',
  'bú': 'buu',
  'bû': 'buu',
  'ngú': 'nguu',
  'ngû': 'nguu',
  'ge': 'ge',
  'ke': 'ke',
  'te': 'te',
  'de': 'de',
  'ne': 'ne',
  'le': 'le',
  'me': 'me',
  'pe': 'pe',
  'se': 'se',
  'be': 'be',
  'nge': 'nge',
  'go': 'go',
  'ko': 'ko',
  'to': 'to',
  'do': 'do',
  'no': 'no',
  'lo': 'lo',
  'mo': 'mo',
  'po': 'po',
  'so': 'so',
  'bo': 'bo',
  'ngo': 'No',
  'gang': 'gng',
  'kang': 'kng',
  'tang': 'tng',
  'dang': 'dng',
  'nang': 'nng',
  'lang': 'lng',
  'sang': 'sng',
  'mang': 'mng',
  'pang': 'png',
  'bang': 'bng',
  'ngang': 'ngng',
};
const List<List<String>> kulitanBatches = [
  ['ga', 'ka', 'ta', 'da', 'na', 'la', 'ma', 'pa', 'sa', 'ba', 'nga'],
  ['a', 'i', 'u', 'e', 'o'],
  ['gá', 'ká', 'tá', 'dá', 'ná', 'lá', 'má', 'pá', 'sá', 'bá', 'ngá'],
  ['gi', 'ki', 'ti', 'di', 'ni', 'li', 'mi', 'pi', 'si', 'bi', 'ngi'],
  ['gí', 'kí', 'tí', 'dí', 'ní', 'lí', 'mí', 'pí', 'sí', 'bí', 'ngí'],
  ['gu', 'ku', 'tu', 'du', 'nu', 'lu', 'mu', 'pu', 'su', 'bu', 'ngu'],
  ['gú', 'kú', 'tú', 'dú', 'nú', 'lú', 'mú', 'pú', 'sú', 'bú', 'ngú'],
  ['go', 'ko', 'to', 'do', 'no', 'lo', 'mo', 'po', 'so', 'bo', 'ngo'],
  ['gang', 'kang', 'tang', 'dang', 'nang', 'lang', 'mang', 'pang', 'sang', 'bang', 'ngang'],
];

int _getSumOfLengths() {
  int sum = 0;
  for(List<String> _arr in kulitanBatches)
    sum += _arr.length;
  return sum;
}

// Limits
const maxQuizGlyphProgress = 10;
const maxWritingGlyphProgress = 10;
final totalGlyphCount = _getSumOfLengths();
const quizCardPoolMinCount = 5;

// Kulitan Fonts
const kulitanHome = TextStyle(
  fontFamily: 'Kulitan Semi Bold',
  color: grayColor,
  height: 0.68,
);
const kulitanQuiz = TextStyle(
  fontFamily: 'Kulitan Semi Bold',
  fontSize: 150.0,
  color: grayColor,
);
const kulitanWriting = TextStyle(
  fontFamily: 'Kulitan Semi Bold',
  fontSize: 300.0,
  color: writingKulitanColor,
);
const kulitanInfo = TextStyle(
  fontFamily: 'Kulitan Semi Bold',
  fontSize: 45.0,
  color: whiteColor,
);
const kulitanTranslate = TextStyle(
  fontFamily: 'Kulitan Semi Bold',
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
const textWritingProgressBar = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 14.0,
  color: whiteColor,
);
const textWriting = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 100.0,
  fontWeight: FontWeight.bold,
  color: whiteColor,
  height: 0.7,
  shadows: <Shadow>[
    Shadow(color: accentColor, offset: Offset(7.0, 7.0))
  ]
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