import 'package:sqflite/sqflite.dart';
import 'dart:math';
import '../../db/DatabaseHelper.dart';
import '../../routes/reading/components.dart' show ChoiceButton;
import '../../styles/theme.dart';

class GameLogicManager {
  GameLogicManager({ this.isQuiz: true });

  final bool isQuiz;

  Database _db;
  dynamic _state;

  Map<String, int> _glyphProgresses = {};
  List<String> _choicePool = [];
  List<String> _glyphPool = [];
  int _batchNumber = 0;

  Future<void> init(dynamic _pageState) async {
    _state = _pageState;
    _db = await DatabaseHelper.instance.database;
    await _pullInitData();
  }

  Future<void> _pullInitData() async {
    final Map<String, dynamic> _gameData = (await _db.query('Page', where: 'name = "${isQuiz? 'reading' : 'writing'}"'))[0];
    _batchNumber = _gameData['current_batch'];
    _state.overallProgressCount = _gameData['overall_progress'];
    await _fillUpPool();
    if(_gameData['current_batch'] == 0) {
      _getNewCards();
      if(isQuiz) _getNewChoices();
    } else {
      await _pullCards();
      if(isQuiz) await _pullChoices();
      if(_glyphPool.length < quizCardPoolMinCount)
        _getNewCards(index: (isQuiz? 3 : 2));
    }
    _pushCards();
    if(isQuiz) _pushChoices();
  }
  Future<void> _pullCards() async {
    final Map<String, dynamic> _pulledCards = (await _db.query('Current${isQuiz? 'Quiz' : 'Draw'}', where: 'type = "cards"'))[0];
    final int _cardOneProgress = await _getGlyphProgress(_pulledCards['one']);
    final int _cardTwoProgress = await _getGlyphProgress(_pulledCards['two']);
    _state.setCard({
      'kulitan': kulitanGlyphs[_pulledCards['one']],
      'answer': _pulledCards['one'],
      'progress': _cardOneProgress,
      'stackNumber': 1,
    }, 0);
    _state.setCard({
      'kulitan': kulitanGlyphs[_pulledCards['two']],
      'answer': _pulledCards['two'],
      'progress': _cardTwoProgress,
      'stackNumber': 2,
    }, 1);
    if(isQuiz) {
      if(_pulledCards['three'] != null) {
        final int _cardThreeProgress = await _getGlyphProgress(_pulledCards['three']);
        _state.setCard({
          'kulitan': kulitanGlyphs[_pulledCards['three']],
          'answer': _pulledCards['three'],
          'progress': _cardThreeProgress,
          'stackNumber': 3,
        }, 2);
      } else {
        _getNewCards(index: 2);
      }
    }
  }
  Future<void> _pullChoices() async {
    final Map<String, dynamic> _pulledChoices = (await _db.query('CurrentQuiz', where: 'type = "choices"'))[0];
    if(_pulledChoices['one'] != null)
      _state.choices = [
        {
          'text': _pulledChoices['one'],
          'type': _pulledChoices['one'] == _state.cards[0]['answer']? ChoiceButton.right :ChoiceButton.wrong,
          'onTap': _pulledChoices['one'] == _state.cards[0]['answer']? correctAnswer : wrongAnswer,
        },
        {
          'text': _pulledChoices['two'],
          'type': _pulledChoices['two'] == _state.cards[0]['answer']? ChoiceButton.right :ChoiceButton.wrong,
          'onTap': _pulledChoices['two'] == _state.cards[0]['answer']? correctAnswer : wrongAnswer,
        },
        {
          'text': _pulledChoices['three'],
          'type': _pulledChoices['three'] == _state.cards[0]['answer']? ChoiceButton.right :ChoiceButton.wrong,
          'onTap': _pulledChoices['three'] == _state.cards[0]['answer']? correctAnswer : wrongAnswer,
        },
        {
          'text': _pulledChoices['four'],
          'type': _pulledChoices['four'] == _state.cards[0]['answer']? ChoiceButton.right :ChoiceButton.wrong,
          'onTap': _pulledChoices['four'] == _state.cards[0]['answer']? correctAnswer : wrongAnswer,
        },
      ];
    else
      _getNewChoices();
    if(_state.cards[0]['progress'] >= (isQuiz? maxQuizGlyphProgress : maxWritingGlyphProgress))
      _state.disableSwipe = true;
  }

  void _pushCards({bool isTwo: false}) async {
    Map<String, String> _data = {
      'one': _state.cards[0]['answer'],
      'two': _state.cards[1]['answer'],
    };
    if(isQuiz) {
      _data['three'] = isTwo? null : _state.cards[2]['answer'];
      _data['four'] = null;
    }
    await _db.update('Current${isQuiz? 'Quiz' : 'Draw'}', _data, where: 'type = "cards"');
  }
  void _pushChoices({bool isTwo: false}) async {
    await _db.update('CurrentQuiz', {
      'one': isTwo? null : _state.choices[0]['text'],
      'two': isTwo? null : _state.choices[1]['text'],
      'three': isTwo? null : _state.choices[2]['text'],
      'four': isTwo? null : _state.choices[3]['text'],
    }, where: 'type = "choices"');
  }
  void _pushRemovedCards() async {
    Map<String, String> _data = {
      'one': _state.cards[1]['answer'],
      'two': isQuiz? _state.cards[2]['answer'] : null,
    };
    if(isQuiz) {
      _data['three'] = null;
      _data['four'] = null;
    }
    await _db.update('Current${isQuiz? 'Quiz' : 'Draw'}', _data, where: 'type = "cards"');
  }
  void _pushRemovedChoices() async {
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
    }, where: 'name = "${isQuiz? 'reading' : 'writing'}"');
  }
  void _pushOverallProgress() async {
    await _db.update('Page', {
      'overall_progress': _state.overallProgressCount,
    }, where: 'name = "${isQuiz? 'reading' : 'writing'}"');
  }
  void _pushGlyphProgress() async {
    await _db.update('Glyph', {
      'progress_count_${isQuiz? 'reading' : 'writing'}': _state.cards[0]['progress'],
    }, where: 'name = "${_state.cards[0]['answer']}"');
  }

  Future<int> _getGlyphProgress(String glyph) async {
    return (await _db.query('Glyph', where: 'name = "$glyph"'))[0]['progress_count_${isQuiz? 'reading' : 'writing'}'];
  }
  void _getNewCards({int index = 0}) {
    Random _random = Random();
    String _randomGlyph;
    if(_glyphPool.length < (isQuiz? quizCardPoolMinCount : drawCardPoolMinCount)) {
      final _keyList = _glyphProgresses.keys.toList();
      do {
        _randomGlyph = _keyList[_random.nextInt(_keyList.length)];
        if(_glyphProgresses[_randomGlyph] >= (isQuiz? maxQuizGlyphProgress : maxWritingGlyphProgress) && _glyphPool.indexOf(_randomGlyph) < 0)
          _glyphPool.add(_randomGlyph);
      } while(_glyphPool.length < quizCardPoolMinCount);
    }
    while(index < (isQuiz? 3 : 2)) {
      _randomGlyph = _glyphPool[_random.nextInt(_glyphPool.length)];
      if((index >= 1 && _randomGlyph == _state.cards[0]['answer']) || (index >= 2 && _randomGlyph == _state.cards[1]['answer']) || (index == 3 && _randomGlyph == _state.cards[2]['answer']))
        continue;
      _state.setCard({
        'kulitan': kulitanGlyphs[_randomGlyph],
        'answer': _randomGlyph,
        'progress': _glyphProgresses[_randomGlyph],
        'stackNumber': index + 1,
      }, index++);
    }
  }
  void _getNewChoices() {
    _state.setChoice({
      'text': _state.cards[0]['answer'],
      'type': ChoiceButton.right,
      'onTap': correctAnswer,
    }, 0);
    String _roman = '';
    final Random _random = Random();
    int _count = 0;
    while(_count < 3) {
      _roman = _choicePool[_random.nextInt(_choicePool.length)];
      if(_roman == _state.choices[0]['text'] || (_count > 0 && _roman == _state.choices[1]['text']) || (_count > 1 && _roman == _state.choices[2]['text']))
        continue;  
      _count++;
      _state.setChoice({
        'text': _roman,
        'type': ChoiceButton.wrong,
        'onTap': wrongAnswer,
      }, _count);
    }
    _state.shuffleChoices();
  }

  void correctAnswer() async {
    if(_batchNumber == 0) {
      _batchNumber = 1;
      _pushBatchNumber();
    }
    if(isQuiz) {
      _state.disableSwipe = true;
      _state.disableChoices = true;
      await Future.delayed(const Duration(milliseconds: showAnswerChoiceDuration + revealAnswerOffset));
      _state.flipCard();
      await Future.delayed(const Duration(milliseconds: autoSwipeDownDuration));
      _state.showAnswer();
      await Future.delayed(const Duration(milliseconds: updateQuizCardProgressOffset));
    } else {
      await Future.delayed(const Duration(milliseconds: drawShadowOffsetChangeDuration));
    }
    bool _isFullProgress = false;
    if(_state.cards[0]['progress'] == (isQuiz? maxQuizGlyphProgress : maxWritingGlyphProgress) - 1) {
      _state.incOverallProgressCount();
      _pushOverallProgress();
      _removeFromGlyphPool();
      _isFullProgress = true;
    } else if(_state.cards[0]['progress'] == (isQuiz? maxQuizGlyphProgress : maxWritingGlyphProgress)) {
      _removeFromGlyphPool();
    }
    if(_state.cards[0]['progress'] < (isQuiz? maxQuizGlyphProgress : maxWritingGlyphProgress)) {
      _state.incCurrCardProgress();
      _glyphProgresses[_state.cards[0]['answer']]++;
      _pushGlyphProgress();
    }
    if(_isFullProgress)
      _addNextBatchIfGlyphsDone();
    await Future.delayed(const Duration(milliseconds: showAnswerToEnableSwipeDuration));
    if(isQuiz) _state.disableSwipe = false;
    _pushRemovedCards();
    if(isQuiz) _pushRemovedChoices();
    else swipedLeft();
  }
  void wrongAnswer() async {
    _state.disableSwipe = true;
    if(_batchNumber == 0) {
      _batchNumber = 1;
      _pushBatchNumber();
    }
    _state.disableChoices = true;
    await Future.delayed(const Duration(milliseconds: showAnswerChoiceDuration + revealAnswerOffset));
    _state.flipCard();
    await Future.delayed(const Duration(milliseconds: autoSwipeDownDuration + revealAnswerOffset));
    _state.showAnswer();
    await Future.delayed(const Duration(milliseconds: showAnswerChoiceDuration));
    if(_state.cards[0]['progress'] == (isQuiz? maxQuizGlyphProgress : maxWritingGlyphProgress)) {
      _state.decOverallProgressCount();
      _pushOverallProgress();
      _addToGlyphPool();
    }
    if(_state.cards[0]['progress'] > 0) {
      _state.decCurrCardProgress();
      _glyphProgresses[_state.cards[0]['answer']]--;
      _pushGlyphProgress();
    }
    await Future.delayed(const Duration(milliseconds: showAnswerToEnableSwipeDuration));
    _state.disableSwipe = false;
    _pushRemovedCards();
    _pushRemovedChoices();
  }
  void revealAnswer({int delay: 0}) async {
    _state.disableChoices = true;
    await Future.delayed(Duration(milliseconds: delay + revealAnswerOffset));
    _state.showAnswer();
    _pushRemovedCards();
    _pushRemovedChoices();
  }
  void swipedLeft() async {
    if(!isQuiz) {
      await Future.delayed(const Duration(milliseconds: writingNextCardDelay));
      _state.slideCard();
      await Future.delayed(const Duration(milliseconds: forwardQuizCardsDuration));
    } else {
      _state.disableSwipe = true;
    }
    _state.setCard(_state.cards[1], 0);
    if(isQuiz) _state.setCard(_state.cards[2], 1);
    _getNewCards(index: (isQuiz? 2 : 1));
    _state.setCardStackNo(0, 1);
    _state.setCardStackNo(1, 2);
    if(isQuiz) {
      _state.setCardStackNo(2, 3);
      _state.resetChoices();
      await Future.delayed(const Duration(milliseconds: resetChoicesDuration));
      _getNewChoices();
      _pushChoices();
    }
    _pushCards();
    if(isQuiz) {
      await Future.delayed(const Duration(milliseconds: forwardQuizCardsDuration));
      if(_state.cards[0]['progress'] < maxQuizGlyphProgress)
        _state.disableSwipe = false;
      else
        _state.disableSwipe = true;
      _state.disableChoices = false;
    } else {
      _state.resetCard();
    }
  }

  Future<void> _fillUpPool() async {
    final List<Map<String, dynamic>> _pulledProgressList = await _db.query('Glyph', columns: ['name', 'progress_count_${isQuiz? 'reading' : 'writing'}']);
    final int _actualBatch = _batchNumber == 0? 1 : _batchNumber;
    for(Map<String, dynamic> _glyph in _pulledProgressList)
      _glyphProgresses[_glyph['name']] = _glyph['progress_count_${isQuiz? 'reading' : 'writing'}'];
    for(int i = 0; i < _actualBatch; i++) {
      if(isQuiz) _choicePool.addAll(kulitanBatches[i]); 
      for(int j = 0; j < kulitanBatches[i].length; j++)
        if(_glyphProgresses[kulitanBatches[i][j]] < (isQuiz? maxQuizGlyphProgress : maxWritingGlyphProgress))
          _glyphPool.add(kulitanBatches[i][j]);
    }
  }
  void _addNextBatchIfGlyphsDone() {
    if(_glyphPool.length < (isQuiz? quizCardPoolMinCount : drawCardPoolMinCount) && _state.overallProgressCount < totalGlyphCount) {
      bool isDone = true;
      for(String _glyph in _glyphPool)
        if(_glyphProgresses[_glyph] < (isQuiz? maxQuizGlyphProgress : maxWritingGlyphProgress)) {
          isDone = false;
          break;
        }
      if(isDone) {
        _addNextBatch();
        _getNewCards(index: 1);
        _pushBatchNumber();
      }
    }
  }
  void _removeFromGlyphPool() => _glyphPool.remove(_state.cards[0]['answer']);
  void _addToGlyphPool() {
    if(_glyphPool.indexOf(_state.cards[0]['answer']) < 0)
      _glyphPool.add(_state.cards[0]['answer']);
  }
  void _addNextBatch() {
    _batchNumber = _batchNumber + 1;
    _choicePool.addAll(kulitanBatches[_batchNumber - 1]);
    _glyphPool = kulitanBatches[_batchNumber - 1].toList();
  }
}