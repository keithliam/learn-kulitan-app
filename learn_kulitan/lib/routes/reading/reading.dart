import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../styles/theme.dart';
import '../../components/buttons/IconButtonNew.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/CircularProgressBar.dart';
import './components.dart';

class ReadingPage extends StatefulWidget {
  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> with SingleTickerProviderStateMixin {
  int _overallProgressCount;
  double _currentProgress;
  String _answer;
  String _choice1;
  String _choice2;
  String _choice3;
  String _choice4;

  bool _showAnswer = false;
  bool _disableChoices = false;
  bool _resetChoices = false;
  bool _isSwipable = true;
  int _resetDuration = 500;
  int _showAnswerDuration = 250;

  GlobalKey _quizCardsKey = GlobalKey();
  double _quizCardStackHeight = 100.0;
  double _quizCardWidth = 100.0;

  Animation<double> _swipeAnimation;
  AnimationController _swipeController;
  Tween<double> _swipeTween;
  Animation _swipeCurveAnimation;
  Curve _autoSwipeDownCurve = quizCardAutoSwipeDownCurve;
  Curve _swipeDownCurve = quizCardSwipeDownCurve;
  Curve _swipeLeftCurve = quizCardSwipeLeftCurve;
  double _quizCardSwipeDownY = 0.5;
  double _quizCardRotate = 0.5;
  double _quizCardSwipeLeftX = 0.0;
  double _quizCardTransform = 0.0;
  bool _isSwipeDownSnapping = false;
  bool _isSwipeLeftSnapping = false;
  bool _isFlipped = false;
  bool _showBackCard = false;
  bool _hasSeenAnswer = false;

  void _noneListener() => setState(() {});

  void _swipeDownListener() {
    if(_swipeAnimation.value < 0.25 || 0.75 < _swipeAnimation.value)
      setState(() => _showBackCard = true);
  }

  void _animateSwipe(double fromValue, double toValue, {bool isSwipeDown: true}) async {
    Duration _duration;
    if(isSwipeDown) {
      bool _isAuto = fromValue == 0.5 && toValue == 1.0;
      _duration = Duration(milliseconds: _isAuto? autoSwipeDownDuration : swipeDownSnapDuration);
      _swipeTween.animate(
        CurvedAnimation(
          parent: _swipeController,
          curve: _autoSwipeDownCurve,
        )
      )..addListener(_swipeDownListener);
      if(toValue == 0.0 || toValue == 1.0)
        setState(() {
          _isFlipped = true;
          _quizCardRotate = toValue;
        });
    } else {
      _duration = Duration(milliseconds: swipeLeftSnapDuration);
      _swipeTween.animate(
        CurvedAnimation(
          parent: _swipeController,
          curve: quizCardSwipeLeftCurve,
        )
      )..addListener(_noneListener);
    }
    if(isSwipeDown)
      setState(() => _isSwipeDownSnapping = true);
    else
      setState(() => _isSwipeLeftSnapping = true);
    _swipeTween
      ..begin = fromValue
      ..end = toValue;
    _swipeController
      ..value = 0.0
      ..duration = _duration
      ..forward();
    await Future.delayed(_duration);
    if(isSwipeDown)
      setState(() => _isSwipeDownSnapping = false);
    else
      setState(() => _isSwipeLeftSnapping = false);
  }


  void _justPressed() {
    setState(() {
      _isSwipable = false;
      _disableChoices = true;
    });
  }
  void _correctAnswer() async {
    await Future.delayed(Duration(milliseconds: _showAnswerDuration + revealAnswerOffset));
    _animateSwipe(_quizCardRotate, 1.0);
    await Future.delayed(Duration(milliseconds: autoSwipeDownDuration));
    setState(() => _showAnswer = true);
    await Future.delayed(Duration(milliseconds: updateQuizCardProgressOffset));
    setState(() => _currentProgress = _currentProgress < maxQuizCharacterProgress? _currentProgress + 1 : _currentProgress);
    // TODO : reset()
  }
  void _wrongAnswer() async {
    await Future.delayed(Duration(milliseconds: _showAnswerDuration + revealAnswerOffset));
    _animateSwipe(_quizCardRotate, 1.0);
    await Future.delayed(Duration(milliseconds: autoSwipeDownDuration + revealAnswerOffset));
    setState(() => _showAnswer = true);
    await Future.delayed(Duration(milliseconds: _showAnswerDuration));
    setState(() => _currentProgress = _currentProgress > 0? _currentProgress - 1 : _currentProgress);
    // TODO : reset()
  }
  void _revealedAnswer({int delay: 0}) async {
    // TODO : reset()
    setState(() {
      _isFlipped = true;
      _disableChoices = true;
    });
    await Future.delayed(Duration(milliseconds: delay + revealAnswerOffset));
    setState(() => _showAnswer = true);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _overallProgressCount = 78;
      _answer = 'píng';
      List<String> _choices = [
        'píng',
        'pong',
        'ka',
        'ku',
      ]..shuffle();
      _choice1 = _choices[0];
      _choice2 = _choices[1];
      _choice3 = _choices[2];
      _choice4 = _choices[3];
      _currentProgress = 8;
    });
    _swipeController = AnimationController(duration: Duration(milliseconds: swipeDownSnapDuration), vsync: this);
    _swipeCurveAnimation = CurvedAnimation(parent: _swipeController, curve: _swipeDownCurve);
    _swipeTween = Tween<double>(begin: 0.0, end: 1.0);
    _swipeAnimation = _swipeTween.animate(_swipeCurveAnimation)
      ..addListener(_noneListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => _getQuizCardsSize()); 
  }

  void _getQuizCardsSize() {
    final RenderBox _box = _quizCardsKey.currentContext.findRenderObject();
    double _width = _box.size.width - (horizontalScreenPadding * 2);
    setState(() => _quizCardWidth = _width);
  }

  void resetDone() async {
    await Future.delayed(Duration(milliseconds: _resetDuration));
    setState(() {
      _resetChoices = false;
      _disableChoices = false;
      _answer = 'du';
      List<String> _choices = [
        'ru',
        'du',
        'pí',
        'mu',
      ]..shuffle();
      _choice1 = _choices[0];
      _choice2 = _choices[1];
      _choice3 = _choices[2];
      _choice4 = _choices[3];
    });
  }

  double _getRotation(double x) {
    return (2 * x * math.pi)  - math.pi;
  }

  void _swipeAction(details) {
    if(!_isFlipped && _isSwipable) {
      double _swipeValue = _quizCardSwipeDownY + (details.delta.dy * swipeDownSensitivity * 0.002);
      if(0.0 < _swipeValue && _swipeValue < 1.0) {
        double _rotationValue = _swipeDownCurve.transform(_swipeValue);
        setState(() {
          _quizCardSwipeDownY = _swipeValue;
          _quizCardRotate = _rotationValue;
        });
        if(_showBackCard && (0.25 < _rotationValue && _rotationValue < 0.75))
          setState(() => _showBackCard = false);
        else if(!_showBackCard && ((0.0 < _rotationValue && _rotationValue < 0.25) || (0.75 < _rotationValue && _rotationValue < 1.0)))
          setState(() {
            _showBackCard = true;
            _hasSeenAnswer = true;
          });
      }
    } else if(_showAnswer && !_resetChoices ) {
      double _slideValue = _quizCardSwipeLeftX + ((-details.delta.dx * swipeLeftSensitivity) / swipeLeftMax);
      if(_slideValue > 1.0) {
        setState(() {
          _quizCardSwipeLeftX = 1.0;
          _quizCardTransform = 1.0;
          _showAnswer = false;
          _resetChoices = true;
        });
      } else if(_slideValue < 0.0) {
        setState(() {
          _quizCardSwipeLeftX = 0.0;
          _quizCardTransform = 0.0;
        });
      } else {
        setState(() {
          _quizCardSwipeLeftX = _slideValue;
          _quizCardTransform = _swipeLeftCurve.transform(_slideValue);
        });
      }
    }
  }

  void _swipeActionCancel() async {
    if(!_isFlipped && _isSwipable) {
      if(_hasSeenAnswer) {
        setState(() {
          _hasSeenAnswer = false;
          _disableChoices = true;
        });
        if(_quizCardRotate < 0.01 || _quizCardRotate > 0.99) {
          setState(() => _quizCardRotate = _quizCardRotate < 0.01? 0.0 : 1.0);
          _revealedAnswer();
        } else {
          _revealedAnswer(delay: swipeDownSnapDuration);
          if(_quizCardRotate < 0.5) {
            _animateSwipe(_quizCardRotate, 0.0);
            setState(() {
              _quizCardSwipeDownY = 0.0;
              _quizCardRotate = 0.0;
            });
          } else {
            _animateSwipe(_quizCardRotate, 1.0);
            setState(() {
              _quizCardSwipeDownY = 1.0;
              _quizCardRotate = 1.0;
            });
          }
        }
      } else if(0.25 <= _quizCardRotate && _quizCardRotate <= 0.75) {
        _animateSwipe(_quizCardRotate, 0.5);
        setState(() {
          _quizCardSwipeDownY = 0.5;
          _quizCardRotate = 0.5;
        });
      }
    } else if(_showAnswer && !_resetChoices ) {
      if(_quizCardSwipeLeftX <= swipeLeftThreshold) {
        _animateSwipe(_quizCardTransform, 0.0, isSwipeDown: false);
        setState(() {
          _quizCardSwipeLeftX = 0.0;
          _quizCardTransform = 0.0;
        });
      } else {
        _animateSwipe(_quizCardTransform, 1.0, isSwipeDown: false);
        setState(() {
          _quizCardSwipeLeftX = 1.0;
          _quizCardTransform = 1.0;
          _showAnswer = false;
          _resetChoices = true;
        });      
      }  
    }
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
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
                  text: _choice1,
                  type: _choice1 == _answer? ChoiceButton.right : ChoiceButton.wrong,
                  onTap: _choice1 == _answer? _correctAnswer : _wrongAnswer,
                  showAnswer: _showAnswer,
                  justPressed: _justPressed,
                  disable: _disableChoices,
                  reset: _resetChoices,
                  resetDone: resetDone,
                  resetDuration: _resetDuration,
                  showAnswerDuration: _showAnswerDuration,
                ),
              ),
              Container(
                width: choiceSpacing,
              ),
              Expanded(
                child: ChoiceButton(
                  text: _choice2,
                  type:  _choice2 == _answer? ChoiceButton.right : ChoiceButton.wrong,
                  onTap: _choice2 == _answer? _correctAnswer : _wrongAnswer,
                  showAnswer: _showAnswer,
                  justPressed: _justPressed,
                  disable: _disableChoices,
                  reset: _resetChoices,
                  resetDone: resetDone,
                  resetDuration: _resetDuration,
                  showAnswerDuration: _showAnswerDuration,
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
                  text: _choice3,
                  type:  _choice3 == _answer? ChoiceButton.right : ChoiceButton.wrong,
                  onTap: _choice3 == _answer? _correctAnswer : _wrongAnswer,
                  showAnswer: _showAnswer,
                  justPressed: _justPressed,
                  disable: _disableChoices,
                  reset: _resetChoices,
                  resetDone: resetDone,
                  resetDuration: _resetDuration,
                  showAnswerDuration: _showAnswerDuration,
                ),
              ),
              Container(
                width: choiceSpacing,
              ),
              Expanded(
                child: ChoiceButton(
                  text: _choice4,
                  type:  _choice4 == _answer? ChoiceButton.right : ChoiceButton.wrong,
                  onTap: _choice4 == _answer? _correctAnswer : _wrongAnswer,
                  showAnswer: _showAnswer,
                  justPressed: _justPressed,
                  disable: _disableChoices,
                  reset: _resetChoices,
                  resetDone: resetDone,
                  resetDuration: _resetDuration,
                  showAnswerDuration: _showAnswerDuration,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    Matrix4 _matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(_getRotation(_isSwipeDownSnapping? _swipeAnimation.value : _quizCardRotate));

    double _heightToCardStackBottom = MediaQuery.of(context).size.height - verticalScreenPadding - ((quizChoiceButtonHeight + quizChoiceButtonElevation) * 2) - choiceSpacing - cardQuizStackBottomPadding;
    double _heightToCardStackTop = _heightToCardStackBottom - _quizCardWidth - quizCardStackTopSpace;
    setState(() => _quizCardStackHeight = _heightToCardStackBottom - _heightToCardStackTop + cardQuizStackBottomPadding);
    double _swipeRatio = _isSwipeLeftSnapping? _swipeAnimation.value : _quizCardTransform;

    Widget _quizCards = Container(
      height: _heightToCardStackBottom,
      child: Stack(
        key: _quizCardsKey,
        children: <Widget>[
          Positioned(
            top: _heightToCardStackTop + 0.0,
            left: horizontalScreenPadding + (_quizCardWidth * 0.1),
            child: QuizCard(
              kulitan: 'pieN',
              answer: 'píng',
              progress: 0.9,
              stackNumber: 3,
              isSwipable: false,
              showAnswer: false,
              width: _quizCardWidth * 0.8,
              originalWidth: _quizCardWidth,
            ),
          ),
          Positioned(
            top: _heightToCardStackTop + (quizCardStackTopSpace / 2),
            left: horizontalScreenPadding + (_quizCardWidth * 0.05),
            child: QuizCard(
              kulitan: 'pieN',
              answer: 'píng',
              progress: 0.9,
              stackNumber: 2,
              isSwipable: false,
              showAnswer: false,
              width: _quizCardWidth * 0.9,
              originalWidth: _quizCardWidth,
            ),
          ),
          Positioned(
            top: _heightToCardStackTop + quizCardStackTopSpace - (_swipeRatio * quizCardMoveUpVelocity * 150.0),
            left: horizontalScreenPadding - (_swipeRatio * quizCardMoveLeftVelocity * ((_quizCardWidth + horizontalScreenPadding) * 1.2)),
            child: Transform.rotate(
              angle: (_swipeRatio * quizCardRotateVelocity * (-math.pi / 4)),
              alignment: FractionalOffset.center,
              child: Transform(
                transform: _matrix,
                alignment:FractionalOffset.center,
                child: GestureDetector(
                  onPanUpdate: _swipeAction,
                  onPanCancel: _swipeActionCancel,
                  onPanEnd: (_) => _swipeActionCancel(),
                  child: Transform(
                    transform: _showBackCard? Matrix4.inverted(_matrix) : Matrix4.identity(),
                    alignment: FractionalOffset.center,
                    child: QuizCard(
                      kulitan: 'pieN',
                      answer: 'píng',
                      progress: _currentProgress / maxQuizCharacterProgress,
                      stackNumber: 1,
                      isSwipable: true,
                      showAnswer: _showBackCard,
                      width: _quizCardWidth * 1.0,
                      originalWidth: _quizCardWidth,
                    ), 
                  ),
                ),
              ),
            ),
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