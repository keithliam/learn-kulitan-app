import 'package:flutter/material.dart';
import 'dart:async';
import '../../styles/theme.dart';
import '../../components/buttons/IconButtonNew.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/CircularProgressBar.dart';
import '../../components/misc/GameLogicManager.dart';
import '../../components/animations/Loader.dart';
import './components.dart';

class ReadingPage extends StatefulWidget {
  @override
  ReadingPageState createState() => ReadingPageState();
}

class ReadingPageState extends State<ReadingPage> {
  final GameLogicManager _gameLogicManager = GameLogicManager();
  bool _isLoading = true;
  int _overallProgressCount = 0;
  Size _screenSize;
  List<Map<String, dynamic>> _cards = [
    {
      'kulitan': 'pie',
      'answer': 'pí',
      'progress': 0,
      'stackNumber': 1,
    },
    {
      'kulitan': 'du',
      'answer': 'du',
      'progress': 0,
      'stackNumber': 2,
    },
    {
      'kulitan': 'No',
      'answer': 'ngo',
      'progress': 0,
      'stackNumber': 3,
    }
  ];
  List<Map<String, dynamic>> _choices = [
    {
      'text': 'pí',
      'type': ChoiceButton.right,
      'onTap': null,
    },
    {
      'text': 'da',
      'type': ChoiceButton.wrong,
      'onTap': null,
    },
    {
      'text': 'ro',
      'type': ChoiceButton.wrong,
      'onTap': null,
    },
    {
      'text': 'su',
      'type': ChoiceButton.wrong,
      'onTap': null,
    },
  ];

  bool _disableChoices = false;
  int _presses = 0;

  GlobalKey _pageKey = GlobalKey();
  GlobalKey _quizCardsKey = GlobalKey();
  double _quizCardWidth = 100.0;
  double _heightToQuizCardTop = 200.0;
  double _quizCardStackHeight = 100.0;
  double _heightToCardStackBottom = 500.0;
  bool _disableSwipe = false;

  final _resetChoicesController = StreamController.broadcast();
  final _showAnswerChoiceController = StreamController.broadcast();
  final _flipStreamController = StreamController.broadcast();

  set overallProgressCount(int n) => setState(() => _overallProgressCount = n);
  set choices(List<Map<String, dynamic>> choices) => setState(() => _choices = choices);
  set disableSwipe(bool i) => setState(() => _disableSwipe = i);
  set disableChoices(bool i) => setState(() => _disableChoices = i);
  void setCard(Map<String, dynamic> card, int i) => setState(() => _cards[i] = card);
  void setCardStackNo(int i, int sNum) => setState(() => _cards[i]['stackNumber'] = sNum);
  void setChoice(Map<String, dynamic> choice, int i) => setState(() => _choices[i] = choice);
  void shuffleChoices() => setState(() => _choices.shuffle());
  void flipCard() => _flipStreamController.sink.add(null);
  void showAnswer() => _showAnswerChoiceController.sink.add(null);
  void resetChoices() => _resetChoicesController.sink.add(null);
  void incOverallProgressCount() => setState(() => _overallProgressCount++);
  void decOverallProgressCount() => setState(() => _overallProgressCount--);
  void incCurrCardProgress() => setState(() => _cards[0]['progress']++);
  void decCurrCardProgress() => setState(() => _cards[0]['progress']--);
  get cards => _cards;
  get choices => _choices;
  get overallProgressCount => _overallProgressCount;

  void _pressAlert() {
    setState(() {
      _presses++;
      _disableSwipe = true;
    });
  }

  void _pressStopAlert() {
    if(_presses > 0)
      setState(() => _presses--);
  }

  void _swipingCard() {
    setState(() => _disableChoices = true);
  }

  void _swipingCardDone() {
    setState(() => _disableChoices = false);
  }

  void _startGame() async {
    await _gameLogicManager.init(this);
    setState(() => _isLoading = false);
  }

  @override
  void initState() {
    super.initState();
    _startGame();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getQuizCardsSize());
  }

  @override
  void dispose() {
    _resetChoicesController.close();
    _showAnswerChoiceController.close();
    _flipStreamController.close();
    super.dispose();
  }

  void _getQuizCardsSize() {
    final RenderBox _screenBox = _pageKey.currentContext.findRenderObject();
    final RenderBox _cardBox = _quizCardsKey.currentContext.findRenderObject();
    double _cardWidth = _cardBox.size.width - (quizHorizontalScreenPadding * 2);

    final _cardStackBottomPadding = _screenSize.aspectRatio < 0.5 ? cardQuizStackBottomPadding : 13.0;
    final _buttonElevation = _screenSize.aspectRatio < 0.5 ? quizChoiceButtonElevation : 7.0;
    final _buttonHeight = _screenSize.aspectRatio < 0.5 ? quizChoiceButtonHeight : 45.0;
    final _choiceSpacing = MediaQuery.of(context).size.aspectRatio < 0.5 ? choiceSpacing : 7.0;

    setState(() {
      _quizCardWidth = _cardWidth;
      _heightToCardStackBottom = _screenBox.size.height - quizVerticalScreenPadding - ((_buttonHeight + _buttonElevation) * 2) - _choiceSpacing - _cardStackBottomPadding;
      _heightToQuizCardTop = _heightToCardStackBottom - _quizCardWidth - quizCardStackTopSpace;
      _quizCardStackHeight = _heightToCardStackBottom - _heightToQuizCardTop + _cardStackBottomPadding;
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;

    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding, headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: IconButtonNew(
          icon: Icons.arrow_back_ios,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: () => Navigator.pop(context),
        ),
        middle: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            'Glyphs Learned',
            style: textQuizHeader,
            textAlign: TextAlign.center,
          ),
        ),
        right: IconButtonNew(
          icon: Icons.settings,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: null,
        ),
      ),
    );
    
    Widget _progressBar = Expanded(
      child: Padding(
        padding: MediaQuery.of(context).size.aspectRatio < 0.5 ? const EdgeInsets.symmetric(
          horizontal: quizHorizontalScreenPadding,
          vertical: 15.0,
        ) : const EdgeInsets.only(bottom: 7.0),
        child: CircularProgressBar(
          numerator: _overallProgressCount,
          denominator: totalGlyphCount,
        ),
      ),
    );

    Widget _buttonChoices = Padding(
      padding: const EdgeInsets.fromLTRB(quizHorizontalScreenPadding, 0.0, quizHorizontalScreenPadding, quizVerticalScreenPadding),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ChoiceButton(
                  text: _choices[0]['text'],
                  type: _choices[0]['type'],
                  onTap: _choices[0]['onTap'],
                  disable: _disableChoices,
                  resetStream: _resetChoicesController.stream,
                  showAnswerStream: _showAnswerChoiceController.stream,
                  presses: _presses,
                  pressAlert: _pressAlert,
                  pressStopAlert: _pressStopAlert,
                ),
              ),
              Container(
                width: choiceSpacing,
              ),
              Expanded(
                child: ChoiceButton(
                  text: _choices[1]['text'],
                  type: _choices[1]['type'],
                  onTap: _choices[1]['onTap'],
                  disable: _disableChoices,
                  resetStream: _resetChoicesController.stream,
                  showAnswerStream: _showAnswerChoiceController.stream,
                  presses: _presses,
                  pressAlert: _pressAlert,
                  pressStopAlert: _pressStopAlert,
                ),
              ),
            ],
          ),
          Container(
            height: MediaQuery.of(context).size.aspectRatio < 0.5 ? choiceSpacing : 7.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: ChoiceButton(
                  text: _choices[2]['text'],
                  type: _choices[2]['type'],
                  onTap: _choices[2]['onTap'],
                  disable: _disableChoices,
                  resetStream: _resetChoicesController.stream,
                  showAnswerStream: _showAnswerChoiceController.stream,
                  presses: _presses,
                  pressAlert: _pressAlert,
                  pressStopAlert: _pressStopAlert,
                ),
              ),
              Container(
                width: choiceSpacing,
              ),
              Expanded(
                child: ChoiceButton(
                  text: _choices[3]['text'],
                  type: _choices[3]['type'],
                  onTap: _choices[3]['onTap'],
                  disable: _disableChoices,
                  resetStream: _resetChoicesController.stream,
                  showAnswerStream: _showAnswerChoiceController.stream,
                  presses: _presses,
                  pressAlert: _pressAlert,
                  pressStopAlert: _pressStopAlert,
                ),
              ),
            ],
          ),
        ],
      ),
    );
    Widget _quizCards = Container(
      height: _heightToCardStackBottom, // TODO: Problem
      child: Stack(
        key: _quizCardsKey,
        children: <Widget>[
          AnimatedQuizCard(
            kulitan: _cards[2]['kulitan'],
            answer: _cards[2]['answer'],
            progress: _cards[2]['progress'] / maxQuizGlyphProgress,
            stackNumber: _cards[2]['stackNumber'],
            stackWidth: _quizCardWidth,
            heightToStackTop: _heightToQuizCardTop, // TODO: Problem
            flipStream: _flipStreamController.stream,
            revealAnswer: _gameLogicManager.revealAnswer,
            swipedLeft: _gameLogicManager.swipedLeft,
            swipingCard: _swipingCard,
            swipingCardDone: _swipingCardDone,
          ),
          AnimatedQuizCard(
            kulitan: _cards[1]['kulitan'],
            answer: _cards[1]['answer'],
            progress: _cards[1]['progress'] / maxQuizGlyphProgress,
            stackNumber: _cards[1]['stackNumber'],
            stackWidth: _quizCardWidth,
            heightToStackTop: _heightToQuizCardTop,
            flipStream: _flipStreamController.stream,
            revealAnswer: _gameLogicManager.revealAnswer,
            swipedLeft: _gameLogicManager.swipedLeft,
            swipingCard: _swipingCard,
            swipingCardDone: _swipingCardDone,
          ),
          AnimatedQuizCard(
            kulitan: _cards[0]['kulitan'],
            answer: _cards[0]['answer'],
            progress: _cards[0]['progress'] / maxQuizGlyphProgress,
            stackNumber: _cards[0]['stackNumber'],
            stackWidth: _quizCardWidth,
            heightToStackTop: _heightToQuizCardTop,
            flipStream: _flipStreamController.stream,
            revealAnswer: _gameLogicManager.revealAnswer,
            swipedLeft: _gameLogicManager.swipedLeft,
            swipingCard: _swipingCard,
            swipingCardDone: _swipingCardDone,
            disableSwipe: _disableSwipe,
          ),
        ],
      ),
    );

    return Material(
      color: backgroundColor,
      child: SafeArea(
        child: Loader(
          isVisible: _isLoading,
          child: Stack(
            key: _pageKey,
            children: <Widget>[
              Column(
                children: <Widget>[
                  _header,
                  _progressBar,
                  Container(
                    height: _quizCardStackHeight,
                  ),
                  _buttonChoices,
                ],
              ),
              _quizCards,
            ],
          ),
        ),
      ),
    );
  }
}
