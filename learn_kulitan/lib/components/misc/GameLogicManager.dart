import 'package:sqflite/sqflite.dart';
import 'dart:math';
import '../../db/DatabaseHelper.dart';
import '../../routes/reading/components.dart' show ChoiceButton;
import '../../styles/theme.dart';

class GameLogicManager {
  GameLogicManager({ this.isQuiz: true });

  final bool isQuiz;
  bool _isTutorial = false;
  int _tutorialNo = 0;

  Database _db;
  dynamic _state;

  Map<String, int> _glyphProgresses = {};
  List<String> _choicePool = [];
  List<String> _glyphPool = [];
  int _batchNumber = 0;

  get isTutorial => _isTutorial;

  Future<void> init(dynamic _pageState) async {
    _state = _pageState;
    _db = await DatabaseHelper.instance.database;
    _isTutorial = (await _db.query('Tutorial', where: 'key = "key"', columns: [isQuiz ? 'reading' : 'writing']))[0][isQuiz ? 'reading' : 'writing'] == 'true';
    _state.isTutorial = _isTutorial;
    if (!_isTutorial || !isQuiz) await _initGame();
    else await _initTutorial();
  }

  void finishTutorial() async {
    if (isQuiz) _state.isLoading = true;
    await Future.delayed(const Duration(milliseconds: loaderOpacityDuration));
    _state.isTutorial = false;
    _isTutorial = false;
    if (isQuiz) {
      await _pushTutorial();
      _state.enableAllChoices();
      _state.startGame();
    } else {
      _pushTutorial();
    }
  }

  Future<void> _initTutorial() async {
    final Map<String, dynamic> _gameData = {
      'current_batch': 1,
      'overall_progress': 8,
    };
    await _initData(_gameData);
    if (isQuiz) _state.disableChoices = true;
  }

  void _nextTutorial() async {
    _tutorialNo++;
    if (_tutorialNo == 1) {
      _state.disableSwipe = true;
      _state.disableWrongChoices('ga');
      _state.tutorialNo = 2;
    } else if (_tutorialNo == 2) {
      _state.disableSwipe = true;
      _state.disableWrongChoices('da');
      _state.tutorialNo = 3;
    } else if (_tutorialNo == 3) {
      _state.disableSwipe = true;
      _state.disableCorrectChoice('la');
      _state.tutorialNo = 4;
    } else if (_tutorialNo == 4) {
      _state.tutorialNo = 5;
    }
  }

  void _setFourthTutorialCard() {
    _state.setCard({
      'kulitan': 'l',
      'answer': 'la',
      'progress': _glyphProgresses['la'],
      'stackNumber': 3,
    }, 2);
  }

  Future<void> _initGame() async {
    final Map<String, dynamic> _gameData = (await _db.query('Page', where: 'name = "${isQuiz? 'reading' : 'writing'}"'))[0];
    await _initData(_gameData);
    _pushCards();
    if(isQuiz) {
      _state.disableSwipe = false;
      _state.enableAllChoices();
      _pushChoices();
    }
  }

  Future<void> _initData(Map<String, dynamic> gameData) async {
    if (isQuiz) await _pullQuizMode();
    _batchNumber = gameData['current_batch'];
    _state.overallProgressCount = gameData['overall_progress'];
    if (_isTutorial && isQuiz) {
      _glyphProgresses = {
        'nga': isQuiz ? maxQuizGlyphProgress ~/ 2 : maxWritingGlyphProgress ~/ 2,
        'ga': 0,
        'da': (isQuiz ? maxQuizGlyphProgress : maxWritingGlyphProgress) - 1,
        'la': isQuiz ? maxQuizGlyphProgress : maxWritingGlyphProgress,
        'na': 1,
        'ta': 1,
        'ka': 1,
        'sa': 1,
        'ma': 1,
        'pa': 1,
        'ba': 1,
      };
      if (isQuiz) _choicePool.addAll(kulitanBatches[0]);
      _glyphPool.addAll(kulitanBatches[0]);
    } else {
      await _fillUpPool();
    }
    if(gameData['current_batch'] == 0) {
      if (_isTutorial) {
        _state.setCard({
          'kulitan': kulitanGlyphs['nga'],
          'answer': 'nga',
          'progress': _glyphProgresses['nga'],
          'stackNumber': 1,
        }, 0);
        _getNewCards(index: 1);
      } else {
        _getNewCards();
      }
      if(isQuiz) _getNewChoices();
    } else {
      if (_isTutorial && isQuiz) {
        _state.setCard({
          'kulitan': 'ng',
          'answer': 'nga',
          'progress': _glyphProgresses['nga'],
          'stackNumber': 1,
        }, 0);
        _state.setCard({
          'kulitan': 'g',
          'answer': 'ga',
          'progress': _glyphProgresses['ga'],
          'stackNumber': 2,
        }, 1);
        if (isQuiz) {
          _state.setCard({
            'kulitan': 'd',
            'answer': 'da',
            'progress': _glyphProgresses['da'],
            'stackNumber': 3,
          }, 2);
          _state.choices = [
            {
              'text': 'ga',
              'type': ChoiceButton.wrong,
              'onTap': wrongAnswer,
            },
            {
              'text': 'nga',
              'type': ChoiceButton.right,
              'onTap': correctAnswer,
            },
            {
              'text': 'ta',
              'type': ChoiceButton.wrong,
              'onTap': wrongAnswer,
            },
            {
              'text': 'sa',
              'type': ChoiceButton.wrong,
              'onTap': wrongAnswer,
            }
          ];
        }
      } else {
        await _pullCards();
        if(isQuiz) await _pullChoices();
        if(_glyphPool.length < quizCardPoolMinCount)
          _getNewCards(index: (isQuiz? 3 : 2));
      }
    }
  }
  Future<void> _pullQuizMode() async {
    _state.mode = (await _db.query('CurrentQuiz', columns: ['kulitanMode'], where: 'type = "mode"'))[0]['kulitanMode'] == 'true';
  }
  Future<void> _pullCards() async {
    final List<String> _columns = ['one', 'two'];
    if (isQuiz) _columns.add('three');
    Map<String, dynamic> _pulledCards = (await _db.query('Current${isQuiz? 'Quiz' : 'Draw'}', columns: _columns, where: 'type = "cards"'))[0];
    if (!isQuiz && _isTutorial) {
      final int _cardOneProgress = await _getGlyphProgress('nga');
      _state.setCard({
        'kulitan': kulitanGlyphs['nga'],
        'answer': 'nga',
        'progress': _cardOneProgress,
        'stackNumber': 1,
      }, 0);
    } else {
      final int _cardOneProgress = await _getGlyphProgress(_pulledCards['one']);
      _state.setCard({
        'kulitan': kulitanGlyphs[_pulledCards['one']],
        'answer': _pulledCards['one'],
        'progress': _cardOneProgress,
        'stackNumber': 1,
      }, 0);
    }
    final int _cardTwoProgress = await _getGlyphProgress(_pulledCards['two']);
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

  Future<void> _pushTutorial() async => await _db.update('Tutorial', {'${isQuiz? 'reading' : 'writing'}': '${_isTutorial.toString()}'}, where: '${isQuiz? 'reading' : 'writing'} = "${_state.mode}"');
  void _pushQuizMode() async => await _db.update('CurrentQuiz', { 'kulitanMode': _state.mode }, where: 'type = "mode"');
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
    if (isQuiz && _state.modeChanged) {
      _state.changeMode();
      _pushQuizMode();
    }
    if (!isQuiz && _isTutorial) finishTutorial();
    if(_batchNumber == 0) {
      _batchNumber = 1;
      if (!_isTutorial || !isQuiz) _pushBatchNumber();
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
      if (!_isTutorial || !isQuiz) _pushOverallProgress();
      _removeFromGlyphPool();
      _isFullProgress = true;
    } else if(_state.cards[0]['progress'] == (isQuiz? maxQuizGlyphProgress : maxWritingGlyphProgress)) {
      _removeFromGlyphPool();
    }
    if(_state.cards[0]['progress'] < (isQuiz? maxQuizGlyphProgress : maxWritingGlyphProgress)) {
      _state.incCurrCardProgress();
      _glyphProgresses[_state.cards[0]['answer']]++;
      if (!_isTutorial || !isQuiz) _pushGlyphProgress();
    }
    if(_isFullProgress && (!_isTutorial || !isQuiz))
      _addNextBatchIfGlyphsDone();
    await Future.delayed(const Duration(milliseconds: showAnswerToEnableSwipeDuration));
    if(isQuiz) _state.disableSwipe = false;
    if (!_isTutorial || !isQuiz) {
      _pushRemovedCards();
      if(isQuiz) _pushRemovedChoices();
      else swipedLeft();
    }
  }
  void wrongAnswer() async {
    if (isQuiz && _state.modeChanged) {
      _state.changeMode();
      _pushQuizMode();
    }
    _state.disableSwipe = true;
    if(_batchNumber == 0) {
      _batchNumber = 1;
      if (!_isTutorial || !isQuiz) _pushBatchNumber();
    }
    _state.disableChoices = true;
    await Future.delayed(const Duration(milliseconds: showAnswerChoiceDuration + revealAnswerOffset));
    _state.flipCard();
    await Future.delayed(const Duration(milliseconds: autoSwipeDownDuration + revealAnswerOffset));
    _state.showAnswer();
    await Future.delayed(const Duration(milliseconds: showAnswerChoiceDuration));
    if(_state.cards[0]['progress'] == (isQuiz? maxQuizGlyphProgress : maxWritingGlyphProgress)) {
      _state.decOverallProgressCount();
      if (!_isTutorial || !isQuiz) _pushOverallProgress();
      _addToGlyphPool();
    }
    if(_state.cards[0]['progress'] > 0) {
      _state.decCurrCardProgress();
      _glyphProgresses[_state.cards[0]['answer']]--;
      if (!_isTutorial || !isQuiz) _pushGlyphProgress();
    }
    await Future.delayed(const Duration(milliseconds: showAnswerToEnableSwipeDuration));
    _state.disableSwipe = false;
    if (!_isTutorial || !isQuiz) {
      _pushRemovedCards();
      _pushRemovedChoices();
    }
  }
  void revealAnswer({int delay: 0}) async {
    if (isQuiz && _state.modeChanged) {
      _state.changeMode();
      _pushQuizMode();
    }
    _state.disableChoices = true;
    await Future.delayed(Duration(milliseconds: delay + revealAnswerOffset));
    _state.showAnswer();
    if (!_isTutorial) {
      _pushRemovedCards();
      _pushRemovedChoices();
    } else if (isQuiz) {
      _state.tutorialNo = 1;
    }
  }
  void swipedLeft() async {
    if(!isQuiz) {
      await Future.delayed(const Duration(milliseconds: writingNextCardDelay));
      _state.slideCard();
      await Future.delayed(const Duration(milliseconds: forwardQuizCardsDuration));
    } else {
      _state.disableChoices = true;
      _state.disableSwipe = true;
    }
    _state.setCard(_state.cards[1], 0);
    if(isQuiz) _state.setCard(_state.cards[2], 1);
    if (_isTutorial && isQuiz && _tutorialNo == 0) {
      _setFourthTutorialCard();
    } else {
      _getNewCards(index: (isQuiz? 2 : 1));
    }
    _state.setCardStackNo(0, 1);
    _state.setCardStackNo(1, 2);
    if(isQuiz) {
      _state.setCardStackNo(2, 3);
      _state.resetChoices();
      await Future.delayed(const Duration(milliseconds: resetChoicesDuration));
      _getNewChoices();
      if (!_isTutorial || !isQuiz) _pushChoices();
    }
    if (!_isTutorial || !isQuiz) _pushCards();
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
    if (isTutorial && isQuiz) _nextTutorial();
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
        if (!_isTutorial) _pushBatchNumber();
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