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
const writingShadowColor = snowColor;

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
const writingCardTouchRadius = 40.0;
const writingDrawPointIdleWidth = 18.0;
const writingDrawPointTouchWidth = 36.0;
const writingGuideCircleRadius = 0.05069;
const writingGuideCircleStrokeWidth = 0.01597;
const writingGuideLineStrokeWidth = 0.02291;

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
const drawTouchPointScaleUpCurve = Curves.easeOutBack;
const drawTouchPointScaleDownCurve = Curves.easeInBack;
const drawTouchPointOpacityUpCurve = Curves.fastOutSlowIn;
const drawTouchPointOpacityDownCurve = Curves.decelerate;
const drawShadowOffsetChangeCurve = Curves.easeOutBack;
const drawGuidesOpacityUpCurve = Curves.fastOutSlowIn;
const drawGuidesOpacityDownCurve = Curves.decelerate;
const writingCardPanLeftCurve = Curves.easeInOutCubic;
const writingTextOpacityChangeCurve = drawGuidesOpacityUpCurve;

// Durations
const linearProgressBarChangeDuration = 1000;
const showAnswerChoiceDuration = 250;
const resetQuizDuration = 750;
const quizChoicePressDuration = 250;
const resetChoicesDuration = resetQuizDuration ~/ 2;
const swipeDownSnapDuration = 250;
const autoSwipeDownDuration = 400;
const revealAnswerOffset = 0;
const swipeLeftSnapDuration = 250;
const forwardQuizCardsDuration = resetQuizDuration;
const updateQuizCardProgressOffset = 0;
const quizCardsForwardDuration = 500;
const showAnswerToEnableSwipeDuration = 0;  // linearProgressBarChangeDuration
const drawTouchPointScaleDuration = 250;
const nextDrawPathDelay = 250;
const drawShadowOffsetChangeDuration = 400;
const drawGuidesOpacityChangeDelay = 500;
const drawGuidesOpacityChangeDuration = 250;
const writingNextCardDelay = 500;
const writingNextCardDuration = 750;
const writingInitDelay = 750;
const writingInitOpacityDuration = 750;
const writingTextOpacityChangeDelay = 1000;

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
  'ngo': 'ngo',
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

// Drawing Paths
const Map<String, List<List<double>>> kulitanPaths = {
  'ng': [
    [0.16319, 0.31221, 0.375, 0.37277, 0.41597, 0.6368, 0.30763, 0.80754],
    [0.3595, 0.53124, 0.35138, 0.39305, 0.50208, 0.32985, 0.51597 , 0.56319, 0.53055, 0.40624, 0.61388, 0.40485, 0.63263 , 0.52291, 0.66805, 0.74513, 0.83333, 0.70069, 0.83611 , 0.52013, 0.83541, 0.38681, 0.73472, 0.24722, 0.65138 , 0.21181],
  ],
};
const Map<String, List<Map<String, dynamic>>> kulitanGuides = {
  'ng': [
    {
      'labelOffset': Offset(0.11944, 0.60416),
      'path': [
        Offset(0.10138, 0.39861),
        Offset(0.24166, 0.43541),
        Offset(0.32777, 0.60555),
        Offset(0.18889, 0.80972),
      ],
    },
    {
      'labelOffset': Offset(0.59305, 0.83194),
      'path': [
        Offset(0.40416, 0.7375),
        Offset(0.42916, 0.63333),
        Offset(0.5243, 0.61458),
        Offset(0.52708, 0.75902),
        Offset(0.5375, 0.64375),
        Offset(0.63263, 0.65486),
        Offset(0.6625, 0.75138),
        Offset(0.70347, 0.88125),
        Offset(0.97638, 0.71527),
        Offset(0.92916, 0.44791),
        Offset(0.88472, 0.2),
        Offset(0.69861, 0.10833),
        Offset(0.69861, 0.10833),
      ],
    }
  ],
};

int _getSumOfLengths() {
  int sum = 0;
  for(List<String> _arr in kulitanBatches)
    sum += _arr.length;
  return sum;
}

// Limits
const maxQuizGlyphProgress = 1;
const maxWritingGlyphProgress = 3;
final totalGlyphCount = _getSumOfLengths();
const quizCardPoolMinCount = 5;
const drawCardPoolMinCount = 5;

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
  fontSize: 100.0,
  fontWeight: FontWeight.bold,
  color: accentColor,
  height: 0.9,
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