import 'package:sqflite/sqflite.dart';
import 'dart:math';
import '../../db/DatabaseHelper.dart';
import '../../routes/reading/components.dart' show ChoiceButton;
import '../../routes/reading/reading.dart' show ReadingPageState;
import '../../styles/theme.dart';

class GameLogicManager {
  GameLogicManager({ this.isQuiz: true });

  final bool isQuiz;

  Database _db;
  ReadingPageState _quizState;

  Map<String, int> _glyphProgresses = {};
  List<String> _choicePool = [];
  List<String> _glyphPool = [];
  int _batchNumber;

  Future<void> init(ReadingPageState _state) async {
    _quizState = _state;
    _db = await DatabaseHelper.instance.database;
    await _pullInitData();
  }

  Future<void> _pullInitData() async {
    final Map<String, dynamic> _quizData = (await _db.query('Page', where: 'name = "${isQuiz? 'reading' : 'writing'}"'))[0];
    _batchNumber = _quizData['current_batch'];
    _quizState.overallProgressCount = _quizData['overall_progress'];
    await _fillUpPool();
    if(_quizData['current_batch'] == 0)
      await _initializeCardsChoices();
    else
      await _pullCardsChoices();
    _pushCardsChoices();
  }
  Future<void> _pullCardsChoices() async {
    final Map<String, dynamic> _pulledCards = (await _db.query('CurrentQuiz', where: 'type = "cards"'))[0];
    final Map<String, dynamic> _pulledChoices = (await _db.query('CurrentQuiz', where: 'type = "choices"'))[0];
    final int _cardOneProgress = await _getGlyphProgress(_pulledCards['one']);
    final int _cardTwoProgress = await _getGlyphProgress(_pulledCards['two']);
    _quizState.setCard({
      'kulitan': kulitanGlyphs[_pulledCards['one']],
      'answer': _pulledCards['one'],
      'progress': _cardOneProgress,
      'stackNumber': 1,
    }, 0);
    _quizState.setCard({
      'kulitan': kulitanGlyphs[_pulledCards['two']],
      'answer': _pulledCards['two'],
      'progress': _cardTwoProgress,
      'stackNumber': 2,
    }, 1);
    if(_pulledCards['three'] != null) {
      final int _cardThreeProgress = await _getGlyphProgress(_pulledCards['three']);
      _quizState.setCard({
        'kulitan': kulitanGlyphs[_pulledCards['three']],
        'answer': _pulledCards['three'],
        'progress': _cardThreeProgress,
        'stackNumber': 3,
      }, 2);
    } else {
      _getNewCards(count: 2);
    }
    if(_pulledChoices['one'] != null)
      _quizState.choices = [
        {
          'text': _pulledChoices['one'],
          'type': _pulledChoices['one'] == _quizState.cards[0]['answer']? ChoiceButton.right :ChoiceButton.wrong,
          'onTap': _pulledChoices['one'] == _quizState.cards[0]['answer']? correctAnswer : wrongAnswer,
        },
        {
          'text': _pulledChoices['two'],
          'type': _pulledChoices['two'] == _quizState.cards[0]['answer']? ChoiceButton.right :ChoiceButton.wrong,
          'onTap': _pulledChoices['two'] == _quizState.cards[0]['answer']? correctAnswer : wrongAnswer,
        },
        {
          'text': _pulledChoices['three'],
          'type': _pulledChoices['three'] == _quizState.cards[0]['answer']? ChoiceButton.right :ChoiceButton.wrong,
          'onTap': _pulledChoices['three'] == _quizState.cards[0]['answer']? correctAnswer : wrongAnswer,
        },
        {
          'text': _pulledChoices['four'],
          'type': _pulledChoices['four'] == _quizState.cards[0]['answer']? ChoiceButton.right :ChoiceButton.wrong,
          'onTap': _pulledChoices['four'] == _quizState.cards[0]['answer']? correctAnswer : wrongAnswer,
        },
      ];
    else
      _getNewChoices();
    if(_quizState.cards[0]['progress'] >= maxQuizGlyphProgress)
      _quizState.disableSwipe = true;
    if(_glyphPool.length < quizCardPoolMinCount)
      _getNewCards(count: 3);
  }

  void _pushCardsChoices({bool isTwo: false}) async {
    await _db.update('CurrentQuiz', {
      'one': _quizState.cards[0]['answer'],
      'two': _quizState.cards[1]['answer'],
      'three': isTwo? null : _quizState.cards[2]['answer'],
      'four': null,
    }, where: 'type = "cards"');
    await _db.update('CurrentQuiz', {
      'one': isTwo? null : _quizState.choices[0]['text'],
      'two': isTwo? null : _quizState.choices[1]['text'],
      'three': isTwo? null : _quizState.choices[2]['text'],
      'four': isTwo? null : _quizState.choices[3]['text'],
    }, where: 'type = "choices"');
  }
  void _pushRemovedCardChoices() async {
    await _db.update('CurrentQuiz', {
      'one': _quizState.cards[1]['answer'],
      'two': _quizState.cards[2]['answer'],
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
  void _pushBatchNumber() async {
    await _db.update('Page', {
      'current_batch': _batchNumber
    }, where: 'name = "reading"');
  }
  void _pushOverallProgress() async {
    await _db.update('Page', {
      'overall_progress': _quizState.overallProgressCount,
    }, where: 'name = "reading"');
  }
  void _pushGlyphProgress() async {
    await _db.update('Glyph', {
      'progress_count_${isQuiz? 'reading' : 'writing'}': _quizState.cards[0]['progress'],
    }, where: 'name = "${_quizState.cards[0]['answer']}"');
  }

  Future<int> _getGlyphProgress(String glyph) async {
    return (await _db.query('Glyph', where: 'name = "$glyph"'))[0]['progress_count_reading'];
  }
  void _getNewCards({int count = 0}) {
    Random _random = Random();
    String _randomGlyph;
    if(_glyphPool.length < quizCardPoolMinCount) {
      final _keyList = _glyphProgresses.keys.toList();
      do {
        _randomGlyph = _keyList[_random.nextInt(_keyList.length)];
        if(_glyphProgresses[_randomGlyph] >= maxQuizGlyphProgress && _glyphPool.indexOf(_randomGlyph) < 0)
          _glyphPool.add(_randomGlyph);
      } while(_glyphPool.length < quizCardPoolMinCount);
    }
    while(count < 3) {
      _randomGlyph = _glyphPool[_random.nextInt(_glyphPool.length)];
      if((count >= 1 && _randomGlyph == _quizState.cards[0]['answer']) || (count >= 2 && _randomGlyph == _quizState.cards[1]['answer']) || (count == 3 && _randomGlyph == _quizState.cards[2]['answer']))
        continue;
      _quizState.setCard({
        'kulitan': kulitanGlyphs[_randomGlyph],
        'answer': _randomGlyph,
        'progress': _glyphProgresses[_randomGlyph],
        'stackNumber': count + 1,
      }, count++);
    }
  }
  void _getNewChoices() {
    _quizState.setChoice({
      'text': _quizState.cards[0]['answer'],
      'type': ChoiceButton.right,
      'onTap': correctAnswer,
    }, 0);
    String _roman = '';
    final Random _random = Random();
    int _count = 0;
    while(_count < 3) {
      _roman = _choicePool[_random.nextInt(_choicePool.length)];
      if(_roman == _quizState.choices[0]['text'] || (_count > 0 && _roman == _quizState.choices[1]['text']) || (_count > 1 && _roman == _quizState.choices[2]['text']))
        continue;  
      _count++;
      _quizState.setChoice({
        'text': _roman,
        'type': ChoiceButton.wrong,
        'onTap': wrongAnswer,
      }, _count);
    }
    _quizState.shuffleChoices();
  }

  void correctAnswer() async {
    _quizState.disableSwipe = true;
    if(_batchNumber == 0) {
      _batchNumber = 1;
      _pushBatchNumber();
    }
    _quizState.disableChoices = true;
    await Future.delayed(const Duration(milliseconds: showAnswerChoiceDuration + revealAnswerOffset));
    _quizState.flipCard();
    await Future.delayed(const Duration(milliseconds: autoSwipeDownDuration));
    _quizState.showAnswer();
    await Future.delayed(const Duration(milliseconds: updateQuizCardProgressOffset));
    bool _isFullProgress = false;
    if(_quizState.cards[0]['progress'] == maxQuizGlyphProgress - 1) {
      _quizState.incOverallProgressCount();
      _pushOverallProgress();
      _removeFromGlyphPool();
      _isFullProgress = true;
    } else if(_quizState.cards[0]['progress'] == maxQuizGlyphProgress) {
      _removeFromGlyphPool();
    }
    if(_quizState.cards[0]['progress'] < maxQuizGlyphProgress) {
      _quizState.incCurrCardProgress();
      _glyphProgresses[_quizState.cards[0]['answer']]++;
      _pushGlyphProgress();
    }
    if(_isFullProgress)
      _addNextBatchIfGlyphsDone();
    await Future.delayed(const Duration(milliseconds: showAnswerToEnableSwipeDuration));
    _quizState.disableSwipe = false;
    _pushRemovedCardChoices();
  }
  void wrongAnswer() async {
    _quizState.disableSwipe = true;
    if(_batchNumber == 0) {
      _batchNumber = 1;
      _pushBatchNumber();
    }
    _quizState.disableChoices = true;
    await Future.delayed(const Duration(milliseconds: showAnswerChoiceDuration + revealAnswerOffset));
    _quizState.flipCard();
    await Future.delayed(const Duration(milliseconds: autoSwipeDownDuration + revealAnswerOffset));
    _quizState.showAnswer();
    await Future.delayed(const Duration(milliseconds: showAnswerChoiceDuration));
    if(_quizState.cards[0]['progress'] == maxQuizGlyphProgress) {
      _quizState.decOverallProgressCount();
      _pushOverallProgress();
      _addToGlyphPool();
    }
    if(_quizState.cards[0]['progress'] > 0) {
      _quizState.decCurrCardProgress();
      _glyphProgresses[_quizState.cards[0]['answer']]--;
      _pushGlyphProgress();
    }
    await Future.delayed(const Duration(milliseconds: showAnswerToEnableSwipeDuration));
    _quizState.disableSwipe = false;
    _pushRemovedCardChoices();
  }
  void revealAnswer({int delay: 0}) async {
    _quizState.disableChoices = true;
    await Future.delayed(Duration(milliseconds: delay + revealAnswerOffset));
    _quizState.showAnswer();
    _pushRemovedCardChoices();
  }
  void swipedLeft() async {
    _quizState.disableSwipe = true;
    _quizState.setCard(_quizState.cards[1], 0);
    _quizState.setCard(_quizState.cards[2], 1);
    _getNewCards(count: 2);
    _quizState.setCardStackNo(0, 1);
    _quizState.setCardStackNo(1, 2);
    _quizState.setCardStackNo(2, 3);
    _quizState.resetChoices();
    await Future.delayed(const Duration(milliseconds: resetChoicesDuration));
    _getNewChoices();
    _pushCardsChoices();
    await Future.delayed(const Duration(milliseconds: forwardQuizCardsDuration));
    if(_quizState.cards[0]['progress'] < maxQuizGlyphProgress)
      _quizState.disableSwipe = false;
    else
      _quizState.disableSwipe = true;
    _quizState.disableChoices = false;
  }

  Future<void> _initializeCardsChoices() async {
    _getNewCards();
    _getNewChoices();
  }
  Future<void> _fillUpPool() async {
    final List<Map<String, dynamic>> _pulledProgressList = await _db.query('Glyph', columns: ['name', 'progress_count_${isQuiz? 'reading' : 'writing'}']);
    final int _actualBatch = _batchNumber == 0? 1 : _batchNumber;
    for(Map<String, dynamic> _glyph in _pulledProgressList)
      _glyphProgresses[_glyph['name']] = _glyph['progress_count_${isQuiz? 'reading' : 'writing'}'];
    for(int i = 0; i < _actualBatch; i++) {
      _choicePool.addAll(kulitanBatches[i]); 
      for(int j = 0; j < kulitanBatches[i].length; j++)
        if(_glyphProgresses[kulitanBatches[i][j]] < maxQuizGlyphProgress)
          _glyphPool.add(kulitanBatches[i][j]);
    }
  }
  void _addNextBatchIfGlyphsDone() {
    if(_glyphPool.length < quizCardPoolMinCount && _quizState.overallProgressCount < totalGlyphCount) {
      bool isDone = true;
      for(String _glyph in _glyphPool)
        if(_glyphProgresses[_glyph] < maxQuizGlyphProgress) {
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
  void _removeFromGlyphPool() => _glyphPool.remove(_quizState.cards[0]['answer']);
  void _addToGlyphPool() {
    if(_glyphPool.indexOf(_quizState.cards[0]['answer']) < 0)
      _glyphPool.add(_quizState.cards[0]['answer']);
  }
  void _addNextBatch() {
    _batchNumber = _batchNumber + 1;
    _choicePool.addAll(kulitanBatches[_batchNumber - 1]);
    _glyphPool = kulitanBatches[_batchNumber - 1].toList();
  }
}