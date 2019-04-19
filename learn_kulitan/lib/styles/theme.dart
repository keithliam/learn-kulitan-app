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

const transcribeDividerColor = snowColor;
const transcribeCursorColor = accentColor;

const informationDividerColor = accentColor;
const informationDividerShadowColor = customButtonShadowColor;

const backToStartFABColor = whiteColor;
const backToStartFABShadowColor = customButtonShadowColor;
final backToStartFABPressedColor = Color.lerp(whiteColor, grayColor, 0.2);
const backToStartFABIconColor = accentColor;

const keyboardStrokeColor = whiteColor;
const keyboardStrokeShadowColor = accentColor;
const keyboardPressColor = whiteColor;
const keyboardMainPressColor = whiteColor;
const keyboardKeyHintColor = accentColor;

const linksColor = accentColor;

// Opacities
const keyboardPressOpacity = 0.25;
const keyboardMainPressOpacity = 0.6;

// Spacings
const homeHorizontalScreenPadding = 32.0;
const homeVerticalScreenPadding = 32.0;
const quizHorizontalScreenPadding = 32.0;
const quizVerticalScreenPadding = quizHorizontalScreenPadding - quizChoiceButtonElevation;
const writingHorizontalScreenPadding = 32.0;
const writingVerticalScreenPadding = 32.0;
const informationHorizontalScreenPadding = 32.0;
const informationVerticalScreenPadding = 32.0;
const transcribeHorizontalScreenPadding = 32.0;
const transcribeVerticalScreenPadding = 25.0;
const headerHorizontalPadding = 5.0;
const headerVerticalPadding = 10.0;
const cardQuizHorizontalPadding = 26.0;
const cardQuizVerticalPadding = 20.0;
const cardQuizStackBottomPadding = quizVerticalScreenPadding;
const cardWritingHorizontalPadding = 26.0;
const cardWritingVerticalPadding = 20.0;
const choiceSpacing = 14.0;
const quizChoiceButtonElevation = 10.0;
const cardTranscribeHorizontalPadding = 26.0;
const cardTranscribeVerticalPadding = 26.0;
const keyboardPadding = 15.0;
const keyboardKeyPadding = 5.0;
const keyHintTopOffset = 20.0;
const keyHintPadding = 5.0;
const kulitanCursorTopPadding = 5.0;
const informationSubtitleBottomPadding = 15.0;
const informationCreditsHorizontalPadding = informationHorizontalScreenPadding - 10.0;
const informationCreditsVerticalPadding = 10.0;
const imageTopPadding = 30.0;
const imageCaptionTopPadding = 10.0;
const imageCaptionHorizontalPadding = 30.0;
const paragraphTopPadding = 20.0;

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
const transcribeRelativeFontSize = 1.0;
const keyboardDividerHeight = 8.0;
const keyboardKeyMiddleZoneHeight = 50.0;
const keyHintSizeRatio = 1.0;
const keyHintASizeRatio = 0.4;
const transcribeCursorWidth = 4.0;
const kulitanCursorHeight = transcribeCursorWidth;
const toastFontSize = 16.0;
const historyFABThreshold = 0.05;
const informationFABThreshold = 0.15;

// Sensitivity
const swipeDownSensitivity = 1.0;
const swipeLeftSensitivity = 1.0;
const swipeLeftThreshold = 0.25;
const swipeLeftMax = 350.0;
const keyboardToggleSensitivity = 1.0;

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
const transcribeScrollChangeCurve = Curves.decelerate;
const openKeyboardCurve = Curves.decelerate;
const keyboardToggleCurve = Curves.easeInOut;
const keyboardAnimateToggleCurve = Curves.fastOutSlowIn;
const keyboardPressOpacityCurve = Curves.fastLinearToSlowEaseIn;
const keyHintOpacityCurve = Curves.fastLinearToSlowEaseIn;
const kulitanCursorBlinkCurve = Curves.ease;
const informationPageScrollCurve = Curves.easeInOutCubic;

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
const writingInitDelay = 500;
const writingInitOpacityDuration = 750;
const writingTextOpacityChangeDelay = 750;
const informationPageScrollDuration = 500;
const transcribeScrollChangeDuration = 500;
const keyboardAnimateDuration = 250;
const keyboardPressOpacityDuration = 350;
const keyHintOpacityDuration = 350;
const kulitanCursorBlinkDuration = 1000;
const kulitanCursorBlinkDelay = 500;
const keyDeleteLongPressFrequency = 150;

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
  'g': [
    [0.2625, 0.6375, 0.27638, 0.36736, 0.67083, 0.30277, 0.73888, 0.61041],
  ],
  'k': [
    [0.3125, 0.45139, 0.42222, 0.43264, 0.51389, 0.425, 0.65486, 0.42639],
    [0.22292, 0.65069, 0.3625, 0.61806, 0.57431, 0.59931, 0.77778, 0.61042],
  ],
  't': [
    [0.29028, 0.27361, 0.34653, 0.23194, 0.50972, 0.24306, 0.44306, 0.36667, 0.37292, 0.49583, 0.27708, 0.68472, 0.33056, 0.73542, 0.38264, 0.78472, 0.49306, 0.7, 0.59583, 0.67431, 0.69931, 0.64792, 0.75278, 0.73194, 0.66458, 0.79444],
  ],
  'd': [
    [0.29028, 0.27361, 0.34653, 0.23194, 0.50972, 0.24306, 0.44306, 0.36667, 0.37292, 0.49583, 0.27708, 0.68472, 0.33056, 0.73542, 0.38264, 0.78472, 0.49306, 0.7, 0.59583, 0.67431, 0.69931, 0.64792, 0.75278, 0.73194, 0.66458, 0.79444],
    [0.43681, 0.37917, 0.52778, 0.37778, 0.69028, 0.37222, 0.70972, 0.26111],
  ],
  'n': [
    [0.28681, 0.49444, 0.31458, 0.30972, 0.64236, 0.24931, 0.71319, 0.46875],
    [0.50625, 0.32847, 0.50625, 0.45417, 0.50625, 0.73819, 0.50625, 0.80347],
  ],
  'l': [
    [0.2875, 0.29028, 0.3375, 0.47014, 0.67014, 0.49097, 0.71389, 0.26319],
    [0.50625, 0.42986, 0.50625, 0.55556, 0.50625, 0.73819, 0.50625, 0.80347],
  ],
  'm': [
    [0.27292, 0.24514, 0.34722, 0.26667, 0.37917, 0.37639, 0.3875, 0.48889, 0.39792, 0.63264, 0.42361, 0.75417, 0.47569, 0.74861, 0.53611, 0.74236, 0.55278, 0.67361, 0.57292, 0.47847, 0.59028, 0.30486, 0.63681, 0.23889, 0.72639, 0.21042],
    [0.30972, 0.54444, 0.41667, 0.52431, 0.53403, 0.51389, 0.66875, 0.51667],
  ],
  'p': [
    [0.27292, 0.24514, 0.34722, 0.26667, 0.37917, 0.37639, 0.3875, 0.48889, 0.39792, 0.63264, 0.42361, 0.75417, 0.47569, 0.74861, 0.53611, 0.74236, 0.55, 0.67361, 0.57292, 0.47847, 0.59097, 0.32361, 0.63264, 0.23264, 0.72639, 0.21042],
    [0.56875, 0.51806, 0.60625, 0.51181, 0.64861, 0.50972, 0.67917, 0.51042],
  ],
  's': [
    [0.51528, 0.24931, 0.61458, 0.23403, 0.64167, 0.27778, 0.59514, 0.33681, 0.54861, 0.39583, 0.56111, 0.41597, 0.59792, 0.45625, 0.64444, 0.50694, 0.63958, 0.58403, 0.62986, 0.62431, 0.57292, 0.84722, 0.3875, 0.75278, 0.36389, 0.49931],
  ],
  'b': [
    [0.47708, 0.31458, 0.36181, 0.32986, 0.24583, 0.43472, 0.26042, 0.57847, 0.27778, 0.74583, 0.52639, 0.80833, 0.67569, 0.6875, 0.80625, 0.58194, 0.73958, 0.33333, 0.52431, 0.33194],
  ],
  'ng': [
    [0.16319, 0.31221, 0.375, 0.37277, 0.41597, 0.6368, 0.30763, 0.80754],
    [0.3595, 0.53124, 0.35138, 0.39305, 0.50208, 0.32985, 0.51597 , 0.56319, 0.53055, 0.40624, 0.61388, 0.40485, 0.63263 , 0.52291, 0.66805, 0.74513, 0.83333, 0.70069, 0.83611 , 0.52013, 0.83541, 0.38681, 0.73472, 0.24722, 0.65138 , 0.21181],
  ],
};
const Map<String, List<Map<String, dynamic>>> kulitanGuides = {
  'g': [
    {
      'labelOffset': Offset(0.18541, 0.25208),
      'path': [
        Offset(0.14375, 0.60138),
        Offset(0.18055, 0.26111),
        Offset(0.675, 0.13055),
        Offset(0.83194, 0.50208),
      ],
    }
  ],
  'k': [
    {
      'labelOffset': Offset(0.34931, 0.20069),
      'path': [
        Offset(0.29097, 0.35556),
        Offset(0.40069, 0.33611),
        Offset(0.50417, 0.32361),
        Offset(0.64514, 0.325),
      ],
    },
    {
      'labelOffset': Offset(0.61875, 0.86806),
      'path': [
        Offset(0.21667, 0.75972),
        Offset(0.35625, 0.72708),
        Offset(0.56181, 0.70625),
        Offset(0.76528, 0.71736),
      ],
    }
  ],
  't': [
    {
      'labelOffset': Offset(0.12569, 0.50694),
      'path': [
        Offset(0.19375, 0.39931),
        Offset(0.26528, 0.35903),
        Offset(0.30347, 0.39097),
        Offset(0.26597, 0.46111),
        Offset(0.21667, 0.55347),
        Offset(0.17986, 0.72639),
        Offset(0.23681, 0.79722),
        Offset(0.3, 0.87708),
        Offset(0.42569, 0.87083),
        Offset(0.49722, 0.83056),
        Offset(0.56597, 0.79236),
        Offset(0.61111, 0.87361),
        Offset(0.57292, 0.9125),
      ],
    }
  ],
  'd': [
    {
      'labelOffset': Offset(0.12569, 0.50694),
      'path': [
        Offset(0.19375, 0.39931),
        Offset(0.26528, 0.35903),
        Offset(0.30347, 0.39097),
        Offset(0.26597, 0.46111),
        Offset(0.21667, 0.55347),
        Offset(0.17986, 0.72639),
        Offset(0.23681, 0.79722),
        Offset(0.3, 0.87708),
        Offset(0.42569, 0.87083),
        Offset(0.49722, 0.83056),
        Offset(0.56597, 0.79236),
        Offset(0.61111, 0.87361),
        Offset(0.57292, 0.9125),
      ],
    },
    {
      'labelOffset': Offset(0.775, 0.54583),
      'path': [
        Offset(0.49583, 0.46875),
        Offset(0.68264, 0.45486),
        Offset(0.79167, 0.40069),
        Offset(0.83056, 0.25208),
      ],
    }
  ],
  'n': [
    {
      'labelOffset': Offset(0.19583, 0.18889),
      'path': [
        Offset(0.16319, 0.49097),
        Offset(0.22083, 0.18472),
        Offset(0.65486, 0.10417),
        Offset(0.79583, 0.37778),
      ],
    },
    {
      'labelOffset': Offset(0.27569, 0.64861),
      'path': [
        Offset(0.40139, 0.48681),
        Offset(0.40139, 0.58819),
        Offset(0.40139, 0.72778),
        Offset(0.40139, 0.83889),
      ],
    }
  ],
  'l': [
    {
      'labelOffset': Offset(0.19931, 0.17083),
      'path': [
        Offset(0.32778, 0.15625),
        Offset(0.38056, 0.31597),
        Offset(0.57986, 0.36597),
        Offset(0.65694, 0.14167),
      ],
    },
    {
      'labelOffset': Offset(0.27569, 0.64861),
      'path': [
        Offset(0.40139, 0.50903),
        Offset(0.40139, 0.67361),
        Offset(0.40139, 0.73264),
        Offset(0.40139, 0.83889),
      ],
    }
  ],
  'm': [
    {
      'labelOffset': Offset(0.12292, 0.59097),
      'path': [
        Offset(0.12222, 0.33264),
        Offset(0.29861, 0.37361),
        Offset(0.22847, 0.88958),
        Offset(0.49167, 0.87431),
        Offset(0.76528, 0.85764),
        Offset(0.65556, 0.33333),
        Offset(0.84722, 0.28611),
      ],
    },
    {
      'labelOffset': Offset(0.30903, 0.79861),
      'path': [
        Offset(0.29931, 0.65556),
        Offset(0.45, 0.62986),
        Offset(0.59722, 0.61875),
        Offset(0.69167, 0.62847),
      ],
    }
  ],
  'p': [
    {
      'labelOffset': Offset(0.16319, 0.74722),
      'path': [
        Offset(0.12222, 0.33264),
        Offset(0.33194, 0.30417),
        Offset(0.175, 0.89306),
        Offset(0.49167, 0.87431),
        Offset(0.81528, 0.85486),
        Offset(0.5875, 0.32431),
        Offset(0.84722, 0.28611),
      ],
    },
    {
      'labelOffset': Offset(0.67569, 0.73056),
      'path': [
        Offset(0.64514, 0.59931),
        Offset(0.67778, 0.59514),
        Offset(0.70417, 0.59444),
        Offset(0.74028, 0.59722),
      ],
    }
  ],
  's': [
    {
      'labelOffset': Offset(0.85278, 0.13542),
      'path': [
        Offset(0.48889, 0.14236),
        Offset(0.65417, 0.10903),
        Offset(0.81042, 0.19861),
        Offset(0.7375, 0.3125),
        Offset(0.63889, 0.46667),
        Offset(0.83403, 0.46806),
        Offset(0.71597, 0.73611),
        Offset(0.62292, 0.94792),
        Offset(0.27222, 0.90972),
        Offset(0.24375, 0.47639),
      ],
    }
  ],
  'b': [
    {
      'labelOffset': Offset(0.22014, 0.15),
      'path': [
        Offset(0.45694, 0.20139),
        Offset(0.21528, 0.23681),
        Offset(0.06181, 0.47986),
        Offset(0.18125, 0.69931),
        Offset(0.29028, 0.9),
        Offset(0.61944, 0.90903),
        Offset(0.76944, 0.75556),
        Offset(0.93611, 0.58611),
        Offset(0.8625, 0.23958),
        Offset(0.575, 0.22917),
      ],
    }
  ],
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
const maxQuizGlyphProgress = 5;
const maxWritingGlyphProgress = 1;
final totalGlyphCount = _getSumOfLengths();
const quizCardPoolMinCount = 5;
const drawCardPoolMinCount = 5;

// Kulitan Fonts
const kulitanHome = TextStyle(
  fontFamily: 'Kulitan Semi Bold',
  color: grayColor,
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
const kulitanInfoText = TextStyle(
  fontFamily: 'Kulitan Semi Bold',
  fontSize: 15.0,
  color: whiteColor,
);
const kulitanTranscribe = TextStyle(
  fontFamily: 'Kulitan Semi Bold',
  color: grayColor,
);
const kulitanKeyboard = TextStyle(
  fontFamily: 'Kulitan Semi Bold',
  color: keyboardStrokeColor,
);

// Barlow Fonts
const textHomeTitle = TextStyle(
  height: 0.8,
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
  height: 0.7,
);
const textHomeButtonSub = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 10.0,
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
const textInfoButton = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 30.0,
  fontWeight: FontWeight.w600,
  color: grayColor,
);
const textGuideButton = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 20.0,
  fontWeight: FontWeight.w600,
  color: grayColor,
);
const textInfoCaption = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
  color: grayColor,
);
const textInfoCredits = TextStyle(
  fontFamily: 'Barlow',
  fontStyle: FontStyle.italic,
  color: whiteColor,
);
const textInfoCreditsLink = TextStyle(
  fontFamily: 'Barlow',
  fontWeight: FontWeight.bold,
  fontStyle: FontStyle.italic,
  decorationStyle: TextDecorationStyle.solid,
  color: linksColor,
);
const textInfoImageCaption = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 13.0,
  color: whiteColor,
);
const textInfoImageCaptionItalic = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 13.0,
  fontStyle: FontStyle.italic,
  color: whiteColor,
);
const textInfoImageCaptionKulitan = TextStyle(
  fontFamily: 'Kulitan Semi Bold',
  fontSize: 13.0,
  color: whiteColor,
);
const textInfoImageSubCaption = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 9.0,
  color: whiteColor,
);
const textInfoText = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 15.0,
  color: whiteColor,
);
const textInfoTextItalic = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 15.0,
  fontStyle: FontStyle.italic,
  color: whiteColor,
);
const textInfoLink = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 15.0,
  fontStyle: FontStyle.italic,
  decorationStyle: TextDecorationStyle.solid,
  color: linksColor,
);
const textTranscribe = TextStyle(
  fontFamily: 'Barlow',
  fontSize: 40.0,
  fontWeight: FontWeight.bold,
  color: grayColor,
);