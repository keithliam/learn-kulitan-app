import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../styles/theme.dart';
import '../../components/buttons/IconButtonNew.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/LinearProgressBar.dart';
import '../../db/DatabaseHelper.dart';
import './components.dart';

class WritingPage extends StatefulWidget {
  @override
  _WritingPageState createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> with SingleTickerProviderStateMixin { 
  Database _db;
  int _overallProgressCount = 7;
  String _currentText = 'nga';
  int _batchNumber;
  List<String> _glyphPool = [];
  List<String> _choicePool = [];
  Map<String, int> _glyphProgresses = {};
  List<Map<String, dynamic>> _cards = [
    {
      'kulitan': 'ng',
      'answer': 'nga',
      'progress': 9,
      'cardNumber': 1,
    },
    {
      'kulitan': 'ng',
      'answer': 'nga',
      'progress': 10,
      'cardNumber': 2,
    },
  ];

  AnimationController _panController;
  Animation<double> _panAnimation;

  @override
  void initState() {
    super.initState();   
    _panController = AnimationController(duration: const Duration(milliseconds: writingNextCardDuration), vsync: this);
    final CurvedAnimation _panCurve = CurvedAnimation(parent: _panController, curve: writingCardPanLeftCurve);
    final Tween<double> _panTween = Tween<double>(begin: 0.0, end: 1.0);
    _panAnimation = _panTween.animate(_panCurve)..addListener(() => setState(() {}));
    // WidgetsBinding.instance.addPostFrameCallback((_) => _getQuizCardsSize()); 
  }

  void _animateNextCard() async {

    await Future.delayed(const Duration(milliseconds: writingNextCardDelay));
    _panController.forward();
    await Future.delayed(const Duration(milliseconds: writingNextCardDuration));
    // TODO: get nextCharacter
    _panController.reset();
  }
  
  @override
  void dispose() {
    _panController.dispose();
    super.dispose();
  }

  void _writingDone() async {
    await Future.delayed(const Duration(milliseconds: drawShadowOffsetChangeDuration));
    // bool _isFullProgress = false;
    if(_cards[0]['progress'] == maxWritingGlyphProgress - 1) {
      setState(() => _overallProgressCount++);
      // _pushOverallProgress();
      // _removeFromGlyphPool();
      // _isFullProgress = true;
    } else if(_cards[0]['progress'] == maxQuizGlyphProgress) {
      // _removeFromGlyphPool();
    }
    if(_cards[0]['progress'] < maxQuizGlyphProgress) {
      setState(() {
        _cards[0]['progress']++;
        // _glyphProgresses[_cards[0]['answer']]++;
      });
      // _pushGlyphProgress();
    }
    _animateNextCard();
    // if(_isFullProgress)
    //   _addNextBatchIfGlyphsDone();
    // _pushRemovedCardChoices();
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
                progress: _overallProgressCount / totalGlyphCount,
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

    final double _deviceWidth = MediaQuery.of(context).size.width;

    Widget _mainCard = Positioned(
      left: 0.0 - (_deviceWidth * _panAnimation.value),
      right: 0.0 + (_deviceWidth * _panAnimation.value),
      top: 0.0,
      bottom: 0.0,
      child: WritingCard(
        displayText: _currentText,
        kulitan: _cards[0]['kulitan'],
        progress: _cards[0]['progress'] / maxWritingGlyphProgress,
        cardNumber: _cards[0]['cardNumber'],
        writingDone: _writingDone,
      ),
    );

    Widget _secCard = Positioned(
      left: _deviceWidth - (_deviceWidth * _panAnimation.value),
      right: -_deviceWidth + (_deviceWidth * _panAnimation.value),
      top: 0.0,
      bottom: 0.0,
      child: WritingCard(
        displayText: _cards[1]['answer'],
        kulitan: _cards[1]['kulitan'],
        progress: _cards[1]['progress'] / maxWritingGlyphProgress,
        cardNumber: _cards[1]['cardNumber'],
        writingDone: _writingDone,
      ),
    );

    return Material(
      color: backgroundColor,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _header,
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: <Positioned>[
                  _mainCard,
                  _secCard,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

