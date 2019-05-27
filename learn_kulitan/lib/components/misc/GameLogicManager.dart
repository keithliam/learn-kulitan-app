import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import '../../db/GameData.dart';
import '../../routes/reading/components.dart' show ChoiceButton;
import '../../styles/theme.dart';

class GameLogicManager {
  GameLogicManager({ this.isQuiz: true });
  static final GameData _gameData = GameData();
  static final Map<String, dynamic> defaults = {
    'batch': 1,
    'progress': 2,
  };

  final bool isQuiz;
  bool _isTutorial = false;
  int _tutorialNo = 0;

  dynamic _state;

  Map<String, int> _glyphProgresses = {};
  List<String> _choicePool = [];
  List<String> _glyphPool = [];
  int _batchNumber = 0;

  get isTutorial => _isTutorial;

  void init(dynamic _pageState) {
    _state = _pageState;
    _isTutorial = _gameData.getTutorial(isQuiz ? 'reading' : 'writing');
    _state.isTutorial = _isTutorial;
    if (!_isTutorial || !isQuiz) _initGame();
    else _initTutorial();
  }

  void finishTutorial() async {
    _state.isTutorial = false;
    _isTutorial = false;
    if (isQuiz) {
      _pushTutorial();
      _state.unflipCard();
      await Future.delayed(const Duration(milliseconds: autoSwipeDownDuration ~/ 2.0));
      _state.startGame();
      _state.resetChoices();
      await Future.delayed(const Duration(milliseconds: resetQuizDuration));
      _state.enableAllChoices();
    } else {
      _pushTutorial();
    }
  }

  void _initTutorial() {
    _initData(progress: defaults['progress'], batch: defaults['batch']);
    if (isQuiz) _state.disableChoices = true;
  }

  void _nextTutorial() {
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

  void _initGame() {
    final int _progress = _gameData.getOverallProgress(isQuiz ? 'reading' : 'writing');
    final int _batch = _gameData.getBatch(isQuiz ? 'reading' : 'writing');
    _initData(progress: _progress, batch: _batch);
    _pushCards();
    if(isQuiz) {
      _state.disableSwipe = false;
      _state.enableAllChoices();
      _pushChoices();
    }
  }

  void _initData({int progress, int batch}) {
    if (isQuiz) _pullQuizMode();
    _batchNumber = batch;
    _state.overallProgressCount = progress;
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
      _fillUpPool();
    }
    if(batch == 0) {
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
        _pullCards();
        if(isQuiz) _pullChoices();
        if(_glyphPool.length < quizCardPoolMinCount)
          _getNewCards(index: (isQuiz? 3 : 2));
      }
    }
  }
  void _pullQuizMode() {
    _state.mode = _gameData.getReadingMode();
  }
  void _pullCards() {
    Map<String, dynamic> _pulledCards = _gameData.getCards(isQuiz ? 'reading' : 'writing');
    if (!isQuiz && _isTutorial) {
      final int _cardOneProgress = _getGlyphProgress('nga');
      _state.setCard({
        'kulitan': kulitanGlyphs['nga'],
        'answer': 'nga',
        'progress': _cardOneProgress,
        'stackNumber': 1,
      }, 0);
    } else {
      final int _cardOneProgress = _getGlyphProgress(_pulledCards['one']);
      _state.setCard({
        'kulitan': kulitanGlyphs[_pulledCards['one']],
        'answer': _pulledCards['one'],
        'progress': _cardOneProgress,
        'stackNumber': 1,
      }, 0);
    }
    final int _cardTwoProgress = _getGlyphProgress(_pulledCards['two']);
    _state.setCard({
      'kulitan': kulitanGlyphs[_pulledCards['two']],
      'answer': _pulledCards['two'],
      'progress': _cardTwoProgress,
      'stackNumber': 2,
    }, 1);
    if(isQuiz) {
      if(_pulledCards['three'] != null) {
        final int _cardThreeProgress = _getGlyphProgress(_pulledCards['three']);
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
  void _pullChoices() {
    final Map<String, dynamic> _pulledChoices = _gameData.getChoices();
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

  void _pushTutorial() => _gameData.setTutorial(isQuiz ? 'reading' : 'writing', _isTutorial);
  void _pushQuizMode() => _gameData.setMode(_state.mode);
  void _pushCards({bool isTwo: false}) {
    Map<String, String> _data = {
      'one': _state.cards[0]['answer'],
      'two': _state.cards[1]['answer'],
    };
    if(isQuiz) {
      _data['three'] = isTwo? null : _state.cards[2]['answer'];
      _data['four'] = null;
    }
    _gameData.setCards(isQuiz ? 'reading' : 'writing', _data);
  }
  void _pushChoices({bool isTwo: false}) {
    _gameData.setChoices({
      'one': isTwo? null : _state.choices[0]['text'],
      'two': isTwo? null : _state.choices[1]['text'],
      'three': isTwo? null : _state.choices[2]['text'],
      'four': isTwo? null : _state.choices[3]['text'],
    });
  }
  void _pushRemovedCards() {
    Map<String, String> _data = {
      'one': _state.cards[1]['answer'],
      'two': isQuiz? _state.cards[2]['answer'] : null,
    };
    if(isQuiz) {
      _data['three'] = null;
      _data['four'] = null;
    }
    _gameData.setCards(isQuiz ? 'reading' : 'writing', _data);
  }
  void _pushRemovedChoices() {
    _gameData.setChoices({
      'one': null,
      'two': null,
      'three': null,
      'four': null,
    });
  }
  void _pushBatchNumber() {
    _gameData.setBatch(isQuiz ? 'reading' : 'writing', _batchNumber);
  }
  void _pushOverallProgress() {
    _gameData.setOverallProgress(isQuiz ? 'reading' : 'writing', _state.overallProgressCount);
  }
  void _pushGlyphProgress() {
    _gameData.setGlyphProgress(isQuiz ? 'reading' : 'writing', _state.cards[0]['answer'], _state.cards[0]['progress']);
  }

  int _getGlyphProgress(String glyph) {
    return _gameData.getGlyphProgress(isQuiz ? 'reading' : 'writing', glyph);
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
    if (_isFullProgress) {
      final String _unlockedColorScheme = _gameData.checkColorSchemeUnlock();
      final Map<String, dynamic> _glyphsUntilUnlock = _gameData.checkGlyphsUntilUnlock(isQuiz ? 'reading' : 'writing');
      if (_unlockedColorScheme != 'none') _toastMessage('$_unlockedColorScheme color scheme unlocked! Go to Settings to change the color scheme 🎨');
      else if (_glyphsUntilUnlock['number'] > 0) _toastMessage('Finish ${_glyphsUntilUnlock['number']} more glyph${_glyphsUntilUnlock['number'] > 1 ? 's' : ''} to unlock the ${_glyphsUntilUnlock['colorScheme']} color scheme!');
    }
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

  void _fillUpPool() {
    _glyphProgresses = _gameData.getGlyphProgressList(isQuiz ? 'reading' : 'writing');
    final int _actualBatch = _batchNumber == 0? 1 : _batchNumber;
    for(int i = 0; i < _actualBatch; i++) {
      if(isQuiz) _choicePool.addAll(kulitanBatches[i]); 
      for(int j = 0; j < kulitanBatches[i].length; j++)
        if(_glyphProgresses[kulitanBatches[i][j]] < (isQuiz? maxQuizGlyphProgress : maxWritingGlyphProgress))
          _glyphPool.add(kulitanBatches[i][j]);
    }
  }
  void _addNextBatchIfGlyphsDone() {
    if(_state.overallProgressCount < totalGlyphCount) {
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

  void _toastMessage(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIos: 1,
      backgroundColor: _gameData.getColor('toastBackground'),
      textColor: _gameData.getColor('toastForeground'),
      fontSize: toastFontSize,
    );
  }
}