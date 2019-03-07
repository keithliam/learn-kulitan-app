import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:math';
import '../../styles/theme.dart';
import '../../components/buttons/IconButtonNew.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/CircularProgressBar.dart';
import '../../db/DatabaseHelper.dart';
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
  Database _db;
  int _overallProgressCount = 0;
  int _batchNumber;
  List<String> _syllaPool = [];
  List<String> _choicePool = [];
  Map<String, int> _syllaProgresses = {};
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
    if(_cards[0]['progress'] != maxQuizSyllableProgress)
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

  void _pushSyllaProgress() async {
    await _db.update('Syllable', {
      'progress_count_reading': _cards[0]['progress'],
    }, where: 'name = "${_cards[0]['answer']}"');
  }

  void _pushOverallProgress() async {
    await _db.update('Page', {
      'overall_progress': _overallProgressCount,
    }, where: 'name = "reading"');
  }

  void _pushRemovedCardChoices() async {
    await _db.update('CurrentQuiz', {
      'one': _cards[1]['answer'],
      'two': _cards[2]['answer'],
      'three': null,
      'four': null,
    }, where: 'type = "cards"');
    await _db.update('CurrentQuiz', {
      'one': null,
      'two': null,
      'three': null,
      'four': null,
    }, where: 'type = "choices"');
  }

  void _addToSyllaPool() {
    if(_syllaPool.indexOf(_cards[0]['answer']) < 0)
      _syllaPool.add(_cards[0]['answer']);
  }

  void _removeFromSyllaPool() => _syllaPool.remove(_cards[0]['answer']);

  void _pushBatchNumber() async {
    await _db.update('Page', {
      'current_batch': _batchNumber
    }, where: 'name = "reading"');
  }

  void _addNextBatch() {
    setState(() => _batchNumber++);
    setState(() {
      _choicePool.addAll(kulitanBatches[_batchNumber - 1]);
      _syllaPool = kulitanBatches[_batchNumber - 1].toList();
    });
  }

  void _addNextBatchIfSyllasDone() {
    if(_syllaPool.length < quizCardPoolMinCount && _overallProgressCount < totalSyllableCount) {
      bool isDone = true;
      for(String _syllable in _syllaPool)
        if(_syllaProgresses[_syllable] < maxQuizSyllableProgress) {
          isDone = false;
          break;
        }
      if(isDone) {
        _addNextBatch();
        _getNewCards(count: 1);
        _pushBatchNumber();
      }
    }
  }

  void _correctAnswer() async {
    _disableSwipeStreamController.sink.add(true);
    if(_batchNumber == 0) {
      setState(() => _batchNumber = 1);
      _pushBatchNumber();
    }
    setState(() => _disableChoices = true);
    await Future.delayed(const Duration(milliseconds: showAnswerChoiceDuration + revealAnswerOffset));
    _flipStreamController.sink.add(null);
    await Future.delayed(const Duration(milliseconds: autoSwipeDownDuration));
    _showAnswerChoiceController.sink.add(null);
    await Future.delayed(const Duration(milliseconds: updateQuizCardProgressOffset));
    bool _isFullProgress = false;
    if(_cards[0]['progress'] == maxQuizSyllableProgress - 1) {
      setState(() => _overallProgressCount+= 1);
      _pushOverallProgress();
      _removeFromSyllaPool();
      _isFullProgress = true;
    } else if(_cards[0]['progress'] == maxQuizSyllableProgress) {
      _removeFromSyllaPool();
    }
    if(_cards[0]['progress'] < maxQuizSyllableProgress) {
      setState(() {
        _cards[0]['progress']++;
        _syllaProgresses[_cards[0]['answer']]++;
      });
      _pushSyllaProgress();
    }
    if(_isFullProgress)
      _addNextBatchIfSyllasDone();
    await Future.delayed(const Duration(milliseconds: showAnswerToEnableSwipeDuration));
    _disableSwipeStreamController.sink.add(false);
    _pushRemovedCardChoices();
  }
  void _wrongAnswer() async {
    _disableSwipeStreamController.sink.add(true);
    if(_batchNumber == 0) {
      setState(() => _batchNumber = 1);
      _pushBatchNumber();
    }
    setState(() => _disableChoices = true);
    await Future.delayed(const Duration(milliseconds: showAnswerChoiceDuration + revealAnswerOffset));
    _flipStreamController.sink.add(null);
    await Future.delayed(const Duration(milliseconds: autoSwipeDownDuration + revealAnswerOffset));
    _showAnswerChoiceController.sink.add(null);
    await Future.delayed(const Duration(milliseconds: showAnswerChoiceDuration));
    if(_cards[0]['progress'] == maxQuizSyllableProgress) {
      setState(() => _overallProgressCount--);
      _pushOverallProgress();
      _addToSyllaPool();
    }
    if(_cards[0]['progress'] > 0) {
      setState(() {
        _cards[0]['progress']--;
        _syllaProgresses[_cards[0]['answer']]--;
      });
      _pushSyllaProgress();
    }
    await Future.delayed(const Duration(milliseconds: showAnswerToEnableSwipeDuration));
    _disableSwipeStreamController.sink.add(false);
    _pushRemovedCardChoices();
  }
  void _revealAnswer({int delay: 0}) async {
    setState(() => _disableChoices = true);
    await Future.delayed(Duration(milliseconds: delay + revealAnswerOffset));
    _showAnswerChoiceController.sink.add(null);
    _pushRemovedCardChoices();
  }
  void _swipedLeft() async {
    _forwardCardStreamController.sink.add(null);
    setState(() {
      _cards[0] = _cards[1];
      _cards[1] = _cards[2];
    });
    _getNewCards(count: 2);
    setState(() {
      _cards[0]['stackNumber'] = 1;
      _cards[1]['stackNumber'] = 2;
      _cards[2]['stackNumber'] = 3;
    });
    _resetChoicesController.sink.add(null);
    await Future.delayed(const Duration(milliseconds: resetChoicesDuration));
    _getNewChoices();
    _pushCardsChoices();
    await Future.delayed(const Duration(milliseconds: resetChoicesDuration));
    if(_cards[0]['progress'] < maxQuizSyllableProgress)
      _disableSwipeStreamController.sink.add(false);
    else
      _disableSwipeStreamController.sink.add(true);
    setState(() => _disableChoices = false);
  }
  
  void _getNewChoices() {
    setState(() {
      _choices[0] = {
        'text': _cards[0]['answer'],
        'type': ChoiceButton.right,
        'onTap': _correctAnswer,
      };
    });
    String _roman = '';
    Random _random = Random();
    int _count = 0;
    while(_count < 3) {
      _roman = _choicePool[_random.nextInt(_choicePool.length)];
      if(_roman == _choices[0]['text'] || (_count > 0 && _roman == _choices[1]['text']) || (_count > 1 && _roman == _choices[2]['text']))
        continue;  
      _choices[++_count] = {
        'text': _roman,
        'type': ChoiceButton.wrong,
        'onTap': _wrongAnswer,
      };
    }
    _choices.shuffle();
  }

  void _getNewCards({int count = 0}) {
    Random _random = Random();
    String _randomSylla;
    if(_syllaPool.length < quizCardPoolMinCount) {
      final _keyList = _syllaProgresses.keys.toList();
      do {
        _randomSylla = _keyList[_random.nextInt(_keyList.length)];
        if(_syllaProgresses[_randomSylla] == maxQuizSyllableProgress && _syllaPool.indexOf(_randomSylla) < 0)
          _syllaPool.add(_randomSylla);
      } while(_syllaPool.length < quizCardPoolMinCount);
    }
    while(count < 3) {
      _randomSylla = _syllaPool[_random.nextInt(_syllaPool.length)];
      if((count >= 1 && _randomSylla == _cards[0]['answer']) || (count >= 2 && _randomSylla == _cards[1]['answer']) || (count == 3 && _randomSylla == _cards[2]['answer']))
        continue;
      setState(() => _cards[count] = {
        'kulitan': kulitanSyllables[_randomSylla],
        'answer': _randomSylla,
        'progress': _syllaProgresses[_randomSylla],
        'stackNumber': count + 1,
      });
      count++;
    }
  }

  Future<void> _fillUpPool() async {
    final List<Map<String, dynamic>> _pulledProgressList = await _db.query('Syllable', columns: ['name', 'progress_count_reading']);
    final int _actualBatch = _batchNumber == 0? 1 : _batchNumber;
    for(Map<String, dynamic> _syllable in _pulledProgressList)
      _syllaProgresses[_syllable['name']] = _syllable['progress_count_reading'];
    setState(() {
      for(int i = 0; i < _actualBatch; i++) {
        _choicePool.addAll(kulitanBatches[i]); 
        for(int j = 0; j < kulitanBatches[i].length; j++)
          if(_syllaProgresses[kulitanBatches[i][j]] < maxQuizSyllableProgress)
            _syllaPool.add(kulitanBatches[i][j]);
      }
    });
  }

  Future<void> _initializeCardsChoices() async {
    _getNewCards();
    _getNewChoices();
  }

  void _pushCardsChoices({bool isTwo: false}) async {
    await _db.update('CurrentQuiz', {
      'one': _cards[0]['answer'],
      'two': _cards[1]['answer'],
      'three': isTwo? null : _cards[2]['answer'],
      'four': null,
    }, where: 'type = "cards"');
    await _db.update('CurrentQuiz', {
      'one': isTwo? null : _choices[0]['text'],
      'two': isTwo? null : _choices[1]['text'],
      'three': isTwo? null : _choices[2]['text'],
      'four': isTwo? null : _choices[3]['text'],
    }, where: 'type = "choices"');
  }

  Future<int> _getSyllaProgress(String syllable) async {
    return (await _db.query('Syllable', where: 'name = "$syllable"'))[0]['progress_count_reading'];
  }

  Future<void> _pullCardsChoices() async {
    final Map<String, dynamic> _pulledCards = (await _db.query('CurrentQuiz', where: 'type = "cards"'))[0];
    final Map<String, dynamic> _pulledChoices = (await _db.query('CurrentQuiz', where: 'type = "choices"'))[0];
    final int _cardOneProgress = await _getSyllaProgress(_pulledCards['one']);
    final int _cardTwoProgress = await _getSyllaProgress(_pulledCards['two']);
    setState(() {
      _cards[0]['kulitan'] = kulitanSyllables[_pulledCards['one']];
      _cards[0]['answer'] = _pulledCards['one'];
      _cards[0]['progress'] = _cardOneProgress;
      _cards[0]['stackNumber'] = 1;
      _cards[1]['kulitan'] = kulitanSyllables[_pulledCards['two']];
      _cards[1]['answer'] = _pulledCards['two'];
      _cards[1]['progress'] = _cardTwoProgress;
      _cards[1]['stackNumber'] = 2;
    });
    if(_pulledCards['three'] != null) {
      final int _cardThreeProgress = await _getSyllaProgress(_pulledCards['three']);
      setState(() {
        _cards[2]['kulitan'] = kulitanSyllables[_pulledCards['three']];
        _cards[2]['answer'] = _pulledCards['three'];
        _cards[2]['progress'] = _cardThreeProgress;
        _cards[2]['stackNumber'] = 3;
      });
    } else {
      _getNewCards(count: 2);
    }
    if(_pulledChoices['one'] != null)
      setState(() {
        _choices[0]['text'] = _pulledChoices['one'];
        _choices[0]['type'] = _pulledChoices['one'] == _cards[0]['answer']? ChoiceButton.right :ChoiceButton.wrong;
        _choices[0]['onTap'] = _pulledChoices['one'] == _cards[0]['answer']? _correctAnswer : _wrongAnswer;
        _choices[1]['text'] = _pulledChoices['two'];
        _choices[1]['type'] = _pulledChoices['two'] == _cards[0]['answer']? ChoiceButton.right :ChoiceButton.wrong;
        _choices[1]['onTap'] = _pulledChoices['two'] == _cards[0]['answer']? _correctAnswer : _wrongAnswer;
        _choices[2]['text'] = _pulledChoices['three'];
        _choices[2]['type'] = _pulledChoices['three'] == _cards[0]['answer']? ChoiceButton.right :ChoiceButton.wrong;
        _choices[2]['onTap'] = _pulledChoices['three'] == _cards[0]['answer']? _correctAnswer : _wrongAnswer;
        _choices[3]['text'] = _pulledChoices['four'];
        _choices[3]['type'] = _pulledChoices['four'] == _cards[0]['answer']? ChoiceButton.right :ChoiceButton.wrong;
        _choices[3]['onTap'] = _pulledChoices['four'] == _cards[0]['answer']? _correctAnswer : _wrongAnswer;
      });
    else
      _getNewChoices();
    if(_cards[0]['progress'] == maxQuizSyllableProgress)
      _disableSwipeStreamController.sink.add(true);
    if(_syllaPool.length < quizCardPoolMinCount)
      _getNewCards(count: 3);
  }

  void _pullData() async {
    Database _database = await DatabaseHelper.instance.database;
    Map<String, dynamic> _quizData = (await _database.query('Page', where: 'name = "reading"'))[0];
    setState(() {
      _batchNumber = _quizData['current_batch'];
      _db = _database;
      _overallProgressCount = _quizData['overall_progress'];
    });
    await _fillUpPool();
    if(_quizData['current_batch'] == 0)
      await _initializeCardsChoices();
    else
      await _pullCardsChoices();
    _pushCardsChoices();
  }

  @override
  void initState() {
    super.initState();
    _pullData();
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
          'Syllables\nLearned',
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
          denominator: totalSyllableCount,
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
            progress: _cards[2]['progress'] / maxQuizSyllableProgress,
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
            progress: _cards[1]['progress'] / maxQuizSyllableProgress,
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
            progress: _cards[0]['progress'] / maxQuizSyllableProgress,
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