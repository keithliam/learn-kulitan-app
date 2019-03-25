import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../styles/theme.dart';
import '../../components/buttons/IconButtonNew.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/LinearProgressBar.dart';
import '../../components/misc/CustomCard.dart';
import '../../db/DatabaseHelper.dart';
import './components.dart';

class WritingPage extends StatefulWidget {
  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> { 
  Database _db;
  int _overallProgressCount = 0;
  String _currentText = 'nga';
  int _batchNumber;
  List<String> _glyphPool = [];
  List<String> _choicePool = [];
  Map<String, int> _glyphProgresses = {};
  List<Map<String, dynamic>> _cards = [
    {
      'kulitan': 'ng',
      'answer': 'nga',
      'progress': 0.8,
      'cardNumber': 1,
    },
    {
      'kulitan': 'du',
      'answer': 'du',
      'progress': 0.5,
      'cardNumber': 2,
    },
  ];

  GlobalKey _pageKey = GlobalKey();
  GlobalKey _writingCardsKey = GlobalKey();
  double _quizCardWidth = 100.0;
  double _heightToQuizCardTop = 200.0;
  double _writingCardStackHeight = 100.0;
  double _heightToCardStackBottom = 500.0;

  @override
  void initState() {
    super.initState();   
    // WidgetsBinding.instance.addPostFrameCallback((_) => _getQuizCardsSize()); 
  }

  void _getQuizCardsSize() {
    final RenderBox _screenBox = _pageKey.currentContext.findRenderObject();
    final RenderBox _cardBox = _writingCardsKey.currentContext.findRenderObject();
    double _cardWidth = _cardBox.size.width - (quizHorizontalScreenPadding * 2);
    setState(() {
      _quizCardWidth = _cardWidth;
      _heightToCardStackBottom = _screenBox.size.height - quizVerticalScreenPadding - ((quizChoiceButtonHeight + quizChoiceButtonElevation) * 2) - choiceSpacing - cardQuizStackBottomPadding;
      _heightToQuizCardTop = _heightToCardStackBottom - _quizCardWidth - quizCardStackTopSpace;
      _writingCardStackHeight = _heightToCardStackBottom - _heightToQuizCardTop + cardQuizStackBottomPadding;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding, headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: IconButtonNew(
          icon: Icons.arrow_back_ios,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: () => Navigator.pushNamed(context, '/'),
        ),
        middle: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(headerHorizontalPadding, headerIconSize / 2, headerHorizontalPadding, 5.0),
              child: LinearProgressBar(
                progress: 0.4,
                color: writingHeaderProgressBGColor,
              ),
            ),
            Text(
              'GLYPHS LEARNED',
              style: textWritingProgressBar
            )
          ],
        ),
        right: IconButtonNew(
          icon: Icons.settings,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: null,
        ),
      ),
    );
    
    Widget _text = Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: quizHorizontalScreenPadding,
          vertical: 15.0,
        ),
        child: Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              _currentText,
              style: textWriting,
            ),
          ),
        ),
      ),
    );

    Widget _writingCards = AnimatedWritingCard(
      kulitan: _cards[0]['kulitan'],
      progress: _cards[0]['progress'],
      cardNumber: _cards[0]['cardNumber'],
    );

    return Material(
      color: backgroundColor,
      child: SafeArea(
        child: Column(
          key: _pageKey,
          children: <Widget>[
            _header,
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: writingHorizontalScreenPadding, right: writingHorizontalScreenPadding, bottom: writingVerticalScreenPadding),
                child: Column(
                  children: <Widget>[
                    _text,
                    _writingCards,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}