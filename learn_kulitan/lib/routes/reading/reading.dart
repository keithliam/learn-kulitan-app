import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../../styles/theme.dart';
import '../../components/buttons/IconButtonNew.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/CircularProgressBar.dart';
import './components.dart';

class ReadingPage extends StatefulWidget {
  ReadingPage({
    @required this.screenHeight,
  });

  final double screenHeight;

  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  int _overallProgressCount;
  List<Map<String, dynamic>> _cards = [
    {
      'kulitan': 'pieN',
      'answer': 'píng',
      'progress': maxQuizCharacterProgress - 1,
      'stackNumber': 1,
    },
    {
      'kulitan': 'du',
      'answer': 'du',
      'progress': maxQuizCharacterProgress,
      'stackNumber': 2,
    },
    {
      'kulitan': 'pieN',
      'answer': 'píng',
      'progress': 5,
      'stackNumber': 3,
    }
  ];
  List<Map<String, dynamic>> _choices = [
    {
      'text': 'píng',
      'type': ChoiceButton.right,
      'onTap': null,
    },
    {
      'text': 'dang',
      'type': ChoiceButton.wrong,
      'onTap': null,
    },
    {
      'text': 'rong',
      'type': ChoiceButton.wrong,
      'onTap': null,
    },
    {
      'text': 'sung',
      'type': ChoiceButton.wrong,
      'onTap': null,
    },
  ];

  bool _disableChoices = false;
  int _presses = 0;

  GlobalKey _quizCardsKey = GlobalKey();
  double _quizCardWidth = 100.0;
  double _heightToQuizCardTop = 100.0;
  double _quizCardStackHeight = 100.0;
  double _heightToCardStackBottom = 200.0;

  final _resetChoicesController = StreamController.broadcast();
  final _showAnswerChoiceController = StreamController.broadcast();
  final _flipStreamController = StreamController.broadcast();
  final _disableSwipeStreamController = StreamController.broadcast();
  final _forwardCardStreamController = StreamController.broadcast();

  void _pressAlert() {
    _disableSwipeStreamController.sink.add(true);
    setState(() => _presses++);
  }

  void _pressStopAlert() {
    _disableSwipeStreamController.sink.add(false);
    if(_presses > 0)
      setState(() => _presses--);
  }

  void _swipingCard() {
    setState(() => _disableChoices = true);
  }

  void _swipingCardDone() {
    setState(() => _disableChoices = false);
  }

  void _correctAnswer() async {
    setState(() => _disableChoices = true);
    await Future.delayed(Duration(milliseconds: showAnswerChoiceDuration + revealAnswerOffset));
    _flipStreamController.sink.add(null);
    await Future.delayed(Duration(milliseconds: autoSwipeDownDuration));
    _showAnswerChoiceController.sink.add(null);
    await Future.delayed(Duration(milliseconds: updateQuizCardProgressOffset));
    setState(() => _cards[0]['progress'] = _cards[0]['progress'] < maxQuizCharacterProgress? _cards[0]['progress'] + 1 : _cards[0]['progress']);
    if(_cards[0]['progress'] == maxQuizCharacterProgress)
      setState(() => _overallProgressCount++);
      // TODO : updateDatabase;
    await Future.delayed(Duration(milliseconds: linearProgressBarChangeDuration));
    _disableSwipeStreamController.sink.add(false);
    // TODO: updateDatabase;
    // TODO: remove card from DB
    // TODO: clear saved choices in DB
  }
  void _wrongAnswer() async {
    setState(() => _disableChoices = true);
    await Future.delayed(Duration(milliseconds: showAnswerChoiceDuration + revealAnswerOffset));
    _flipStreamController.sink.add(null);
    await Future.delayed(Duration(milliseconds: autoSwipeDownDuration + revealAnswerOffset));
    _showAnswerChoiceController.sink.add(null);
    await Future.delayed(Duration(milliseconds: showAnswerChoiceDuration));
    if(_cards[0]['progress'] == maxQuizCharacterProgress)
      setState(() => _overallProgressCount--);
      // TODO: updateDatabase;
    setState(() => _cards[0]['progress'] = _cards[0]['progress'] > 0? _cards[0]['progress'] - 1 : _cards[0]['progress']);
    await Future.delayed(Duration(milliseconds: linearProgressBarChangeDuration));
    _disableSwipeStreamController.sink.add(false);
    // TODO: updateDatabase;
    // TODO: clear saved choices in DB
    // TODO: remove card from DB
  }
  void _revealAnswer({int delay: 0}) async {
    setState(() => _disableChoices = true);
    await Future.delayed(Duration(milliseconds: delay + revealAnswerOffset));
    _showAnswerChoiceController.sink.add(null);
    // TODO: remove card from DB
    // TODO: clear saved choices in DB
  }
  void _swipedLeft() async {
    _forwardCardStreamController.sink.add(null);
    setState(() {
      _cards[0] = _cards[1];
      _cards[1] = _cards[2];
      _cards[2] = {
        'kulitan': 'pieN',
        'answer': 'píng',
        'progress': 9,
        'stackNumber': 4,
      };
    });
    setState(() {
      _cards[0]['stackNumber'] = 1;
      _cards[1]['stackNumber'] = 2;
      _cards[2]['stackNumber'] = 3;
    });
    _resetChoicesController.sink.add(null);
    await Future.delayed(Duration(milliseconds: resetChoicesDuration));
    _getNewChoices();
    // TODO: add new card to DB
    // TODO: save choices to DB
    await Future.delayed(Duration(milliseconds: resetChoicesDuration));
    _disableSwipeStreamController.sink.add(false);
    setState(() => _disableChoices = false);
  }
  
  void _getNewChoices() {
    setState(() => _choices[0] = {
      'text': _cards[0]['answer'],
      'type': ChoiceButton.right,
      'onTap': _correctAnswer,
    });
    final List<String> _kulitanKeys = kulitanSyllables.keys.toList();
    final int _listLength = _kulitanKeys.length;
    String _roman = '';
    String _lastChar = '';
    Random _random = Random();
    int _count = 0;
    while(_count < 3) {
      _roman = _kulitanKeys[_random.nextInt(_listLength - 1)];
      _lastChar = _roman.substring(_roman.length - 1, _roman.length);
      if(_lastChar == 'â' || _lastChar == 'î' || _lastChar == 'û' || _roman == _choices[0]['text'] || (_count > 0 && _roman == _choices[1]['text']) || (_count > 1 && _roman == _choices[2]['text']))
        continue;  
      _choices[++_count] = {
        'text': _roman,
        'type': ChoiceButton.wrong,
        'onTap': _wrongAnswer,
      };
    }
    _choices.shuffle();
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _overallProgressCount = 78; // TODO: get progressCount from DB
      // TODO: get cards from DB
      // TODO: if DB has 2 cards only, get next
      // TODO: get saved choices from DB
      // TODO: if no saved choices, call _getNewChoices
      _choices[0]['onTap'] = _correctAnswer;  // remove
      _choices[1]['onTap'] = _wrongAnswer;    // remove
      _choices[2]['onTap'] = _wrongAnswer;    // remove
      _choices[3]['onTap'] = _wrongAnswer;    // remove
      _choices.shuffle();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _getQuizCardsSize()); 
  }

  @override
  void dispose() {
    _resetChoicesController.close();
    _showAnswerChoiceController.close();
    _flipStreamController.close();
    _disableSwipeStreamController.close();
    _forwardCardStreamController.close();
    super.dispose();
  }

  void _getQuizCardsSize() {
    final RenderBox _box = _quizCardsKey.currentContext.findRenderObject();
    double _width = _box.size.width - (horizontalScreenPadding * 2);
    setState(() {
      _quizCardWidth = _width;
      _heightToCardStackBottom = widget.screenHeight - verticalScreenPadding - ((quizChoiceButtonHeight + quizChoiceButtonElevation) * 2) - choiceSpacing - cardQuizStackBottomPadding;
      _heightToQuizCardTop = _heightToCardStackBottom - _quizCardWidth - quizCardStackTopSpace;
      _quizCardStackHeight = _heightToCardStackBottom - _heightToQuizCardTop + cardQuizStackBottomPadding;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerPadding, headerPadding, headerPadding, 0.0),
      child: StaticHeader(
        left: IconButtonNew(
          icon: Icons.arrow_back_ios,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: () => Navigator.pushNamed(context, '/'),
        ),
        middle: Text(
          'Characters\nLearned',
          style: textQuizHeader,
          textAlign: TextAlign.center,
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
        padding: EdgeInsets.symmetric(
          horizontal: horizontalScreenPadding,
          vertical: 15.0,
        ),
        child: CircularProgressBar(
          numerator: _overallProgressCount,
          denominator: totalCharacterCount,
        ),
      ),
    );

    Widget _buttonChoices = Padding(
      padding: EdgeInsets.fromLTRB(horizontalScreenPadding, 0.0, horizontalScreenPadding, verticalScreenPadding),
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
            height: choiceSpacing,
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
      height: _heightToCardStackBottom,
      child: Stack(
        key: _quizCardsKey,
        children: <Widget>[
          AnimatedQuizCard(
            kulitan: _cards[2]['kulitan'],
            answer: _cards[2]['answer'],
            progress: _cards[2]['progress'] / maxQuizCharacterProgress,
            stackNumber: _cards[2]['stackNumber'],
            stackWidth: _quizCardWidth,
            heightToStackTop: _heightToQuizCardTop,
            flipStream: _flipStreamController.stream,
            disableSwipeStream: _disableSwipeStreamController.stream,
            forwardCardStream:_forwardCardStreamController.stream,
            revealAnswer: _revealAnswer,
            swipedLeft: _swipedLeft,
            swipingCard: _swipingCard,
            swipingCardDone: _swipingCardDone,
          ),
          AnimatedQuizCard(
            kulitan: _cards[1]['kulitan'],
            answer: _cards[1]['answer'],
            progress: _cards[1]['progress'] / maxQuizCharacterProgress,
            stackNumber: _cards[1]['stackNumber'],
            stackWidth: _quizCardWidth,
            heightToStackTop: _heightToQuizCardTop,
            flipStream: _flipStreamController.stream,
            disableSwipeStream: _disableSwipeStreamController.stream,
            forwardCardStream:_forwardCardStreamController.stream,
            revealAnswer: _revealAnswer,
            swipedLeft: _swipedLeft,
            swipingCard: _swipingCard,
            swipingCardDone: _swipingCardDone,
          ),
          AnimatedQuizCard(
            kulitan: _cards[0]['kulitan'],
            answer: _cards[0]['answer'],
            progress: _cards[0]['progress'] / maxQuizCharacterProgress,
            stackNumber: _cards[0]['stackNumber'],
            stackWidth: _quizCardWidth,
            heightToStackTop: _heightToQuizCardTop,
            flipStream: _flipStreamController.stream,
            disableSwipeStream: _disableSwipeStreamController.stream,
            forwardCardStream:_forwardCardStreamController.stream,
            revealAnswer: _revealAnswer,
            swipedLeft: _swipedLeft,
            swipingCard: _swipingCard,
            swipingCardDone: _swipingCardDone,
          ),
        ],
      ),
    );

    return Material(
      color: backgroundColor,
      child: Stack(
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
    );
  }
}