import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../styles/theme.dart';
import '../components/buttons.dart';
import '../components/misc.dart';

class ChoiceButton extends StatefulWidget {
  ChoiceButton({
    @required this.text,
    @required this.onTap,
    @required this.justPressed,
    @required this.disable,
    this.type: ChoiceButton.wrong,
    this.showAnswer: false,
    this.reset: false,
    this.resetDone,
    this.resetDuration,
    this.showAnswerDuration,
  });

  static const int right = 0;
  static const int wrong = 1;

  final String text;
  final VoidCallback onTap;
  final VoidCallback justPressed;
  final bool disable;
  final int type;
  final bool showAnswer;
  final bool reset;
  final VoidCallback resetDone;
  final int resetDuration;
  final int showAnswerDuration;

  @override
  _ChoiceButtonState createState() => _ChoiceButtonState();
}

class _ChoiceButtonState extends State<ChoiceButton> with TickerProviderStateMixin {
  Animation<Color> _animation;
  AnimationController _controller;
  ColorTween _tween;

  Animation<Color> _animationText;
  AnimationController _controllerText;
  ColorTween _tweenText;
  
  TextStyle _textStyle;
  bool _isTapped = false;

  @override
  void initState() {
    super.initState();
    _textStyle = textQuizChoice;
    _controller = AnimationController(duration: Duration(milliseconds: widget.showAnswerDuration), vsync: this);
    _tween = ColorTween(begin: cardChoicesColor, end: widget.type == ChoiceButton.right? cardChoicesRightColor : cardChoicesWrongColor);
    _animation = _tween.animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controllerText = AnimationController(duration: Duration(milliseconds: widget.showAnswerDuration), vsync: this);
    _tweenText = ColorTween(begin: textQuizChoice.color, end: textQuizChoiceWrong.color);
    _animationText = _tweenText.animate(_controllerText)
      ..addListener(() {
        setState(() {});
      });
  }

  void _animateColor(Color fromColor, Color toColor, {bool isReset: false}) {
    final int _delay = isReset? widget.resetDuration : widget.showAnswerDuration;
    _tween
      ..begin = fromColor
      ..end = toColor;
    _controller
      ..value = 0.0
      ..duration = Duration(milliseconds: _delay)
      ..forward();
    if(fromColor == cardChoicesWrongColor || toColor == cardChoicesWrongColor) {
      fromColor = fromColor == cardChoicesWrongColor? textQuizChoiceWrong.color : textQuizChoice.color;
      toColor = toColor == cardChoicesWrongColor? textQuizChoiceWrong.color : textQuizChoice.color;
      _tweenText
        ..begin = fromColor
        ..end = toColor;
      _controllerText
        ..value = 0.0
        ..duration = Duration(milliseconds: _delay)
        ..forward();
    }
  }

  void _delayColorReset() async {
    await Future.delayed(Duration(milliseconds: widget.showAnswerDuration));
    _tween
      ..begin = cardChoicesRightColor;
    _controller
      ..reset();
  }

  @override
  void didUpdateWidget(ChoiceButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.text != oldWidget.text || widget.type != oldWidget.type || widget.onTap != oldWidget.onTap || widget.justPressed != oldWidget.justPressed || widget.showAnswer != oldWidget.showAnswer || widget.disable != oldWidget.disable || widget.reset != oldWidget.reset || widget.resetDone != oldWidget.resetDone || widget.resetDuration != oldWidget.resetDuration || widget.showAnswerDuration != oldWidget.showAnswerDuration) {
      if(widget.showAnswer && widget.type == ChoiceButton.right && !_isTapped) {
        _animateColor(cardChoicesColor, cardChoicesRightColor);
        _delayColorReset();
      }
      if(widget.reset && ((_tween.begin == whiteColor && _controller.value != 0.0) || (_tween.begin == cardChoicesRightColor && _controller.value == 0.0))) {
        _isTapped = false;
        final Color _fromColor = widget.type == ChoiceButton.right? cardChoicesRightColor : cardChoicesWrongColor;
        _animateColor(_fromColor, cardChoicesColor, isReset: true);
        widget.resetDone();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _controllerText.dispose();
    super.dispose();
  }

  void tapped() {
    if(!_isTapped) {
      setState(() {
        _isTapped = true;
      });
      Color _toColor = widget.type == ChoiceButton.wrong? cardChoicesWrongColor : cardChoicesRightColor;
      _animateColor(cardChoicesColor, _toColor);
      widget.onTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: quizChoiceButtonHeight,
      color: _animation.value,
      onPressed: widget.disable? null : tapped,
      elevation: quizChoiceButtonElevation,
      borderRadius: 15.0,
      padding: EdgeInsets.all(12.0),
      pressDelay: widget.showAnswerDuration,
      justPressed: widget.justPressed,
      child: Center(
        child: AnimatedOpacity(
          opacity: widget.reset? 0.0 : 1.0,
          duration: Duration(milliseconds: widget.resetDuration),
          curve: Curves.easeInOut,
          child: Text(
            '${widget.text}',
            style: _textStyle.copyWith(
              color: widget.type == ChoiceButton.wrong? _animationText.value : textQuizChoice.color
            ),
          ),
        ),
      ),
    );
  }
}

class _QuizCardSingle extends StatefulWidget {
  _QuizCardSingle({
    @required this.kulitan,
    @required this.answer,
    @required this.progress,
    @required this.stackNumber,
    @required this.isSwipable,
    @required this.showAnswer,
    @required this.width,
    @required this.originalWidth,
  });

  final String kulitan;
  final String answer;
  final double progress;
  final int stackNumber;
  final bool isSwipable;
  final bool showAnswer;
  final double width;
  final double originalWidth;

  @override
  _QuizCardSingleState createState() => _QuizCardSingleState();
}

class _QuizCardSingleState extends State<_QuizCardSingle> {
  @override
  Widget build(BuildContext context) {
    Widget _kulitan = Expanded(
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            widget.kulitan,
            style: kulitanQuiz,
          ),
        ),
      ),
    );

    Widget _progressBar = Padding(
      padding: EdgeInsets.only(top: 10.0),
      child: ProgressBar(
        type: ProgressBar.linear,
        offset: 128.0,
        progress: widget.progress,
      ),
    );

    List _cardContents = <Widget>[
      _kulitan,
      _progressBar,
    ];

    if(widget.showAnswer)
      _cardContents.insert(1,
        Center(
          child: Padding(
            padding:EdgeInsets.only(bottom: 15.0),
            child: Text(
              widget.answer,
              style: textQuizAnswer,
            ),
          ),
        )
      );
    else if(_cardContents.length == 3)
      _cardContents.removeAt(1);

    return CustomCard(
      color: widget.stackNumber == 1? cardQuizColor1 : widget.stackNumber == 2? cardQuizColor2 :cardQuizColor3,
      height: widget.width,
      width: widget.width,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: cardQuizHorizontalPadding, vertical: cardQuizVerticalPadding),
          height: widget.originalWidth,
          width: widget.originalWidth,
          child: Column(
            children: _cardContents,
          ),
        ),
      ),
    );
  }
}

class ReadingPage extends StatefulWidget {
  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> with SingleTickerProviderStateMixin {
  int _progressNumerator;
  int _progressDenominator;
  double _overallProgress;

  String _answer;
  String _choice1;
  String _choice2;
  String _choice3;
  String _choice4;
  double _currentProgress;
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
  Curve _autoSwipeUpCurve = quizCardAutoSwipeUpCurve;
  Curve _swipeUpCurve = quizCardSwipeUpCurve;
  Curve _swipeLeftCurve = quizCardSwipeLeftCurve;
  double _quizCardSwipeUpY = 0.5;
  double _quizCardRotate = 0.5;
  double _quizCardSwipeLeftX = 0.0;
  double _quizCardTransform = 0.0;
  bool _isSwipeDownSnapping = false;
  bool _isSwipeLeftSnapping = false;
  bool _isFlipped = false;
  bool _showBackCard = false;
  bool _hasSeenAnswer = false;

  void _noneListener() => setState(() {});

  void _swipeUpDownListener() {
    if(_swipeAnimation.value < 0.25 || 0.75 < _swipeAnimation.value)
      setState(() => _showBackCard = true);
  }

  void _animateSwipe(double fromValue, double toValue, {bool isSwipeDown: true}) async {
    Duration _duration;
    Animation _animation;
    if(isSwipeDown) {
      bool _isAuto = fromValue == 0.5 && toValue == 1.0;
      _duration = Duration(milliseconds: _isAuto? autoSwipeUpDuration : swipeUpSnapDuration);
      _animation = _swipeTween.animate(
        CurvedAnimation(
          parent: _swipeController,
          curve: _autoSwipeUpCurve,
        )
      )..addListener(_swipeUpDownListener);
      if(toValue == 0.0 || toValue == 1.0)
        setState(() {
          _isFlipped = true;
          _quizCardRotate = toValue;
        });
    } else {
      _duration = Duration(milliseconds: swipeLeftSnapDuration);
      _animation = _swipeTween.animate(
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
    await Future.delayed(Duration(milliseconds: autoSwipeUpDuration));
    setState(() => _showAnswer = true);
    await Future.delayed(Duration(milliseconds: updateQuizCardProgressOffset));
    setState(() => _currentProgress = _currentProgress < maxQuizCharacterProgress? _currentProgress + 1 : _currentProgress);
    // TODO : reset()
  }
  void _wrongAnswer() async {
    await Future.delayed(Duration(milliseconds: _showAnswerDuration + revealAnswerOffset));
    _animateSwipe(_quizCardRotate, 1.0);
    await Future.delayed(Duration(milliseconds: autoSwipeUpDuration + revealAnswerOffset));
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
      _progressNumerator = 78;
      _progressDenominator = 107;
      _overallProgress = _progressNumerator / _progressDenominator;
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
    _swipeController = AnimationController(duration: Duration(milliseconds: swipeUpSnapDuration), vsync: this);
    _swipeCurveAnimation = CurvedAnimation(parent: _swipeController, curve: _swipeUpCurve);
    _swipeTween = Tween<double>(begin: 0.0, end: 1.0);
    _swipeAnimation = _swipeTween.animate(_swipeCurveAnimation)
      ..addListener(_noneListener);
    WidgetsBinding.instance.addPostFrameCallback((_) => _getQuizCardsSize()); 
  }

  void _getQuizCardsSize() {
    final RenderBox _box = _quizCardsKey.currentContext.findRenderObject();
    double _width = _box.size.width - (horizontalScreenPadding * 2);
    setState(() {
      _quizCardWidth = _width;
    });
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
      double _swipeValue = _quizCardSwipeUpY + (details.delta.dy * swipeDownSensitivity * 0.002);
      if(0.0 < _swipeValue && _swipeValue < 1.0) {
        double _rotationValue = _swipeUpCurve.transform(_swipeValue);
        setState(() {
          _quizCardSwipeUpY = _swipeValue;
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
      } else if(_slideValue < 0) {
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
          _revealedAnswer(delay: swipeUpSnapDuration);
          if(_quizCardRotate < 0.5) {
            _animateSwipe(_quizCardRotate, 0.0);
            setState(() {
              _quizCardSwipeUpY = 0.0;
              _quizCardRotate = 0.0;
            });
          } else {
            _animateSwipe(_quizCardRotate, 1.0);
            setState(() {
              _quizCardSwipeUpY = 1.0;
              _quizCardRotate = 1.0;
            });
          }
        }
      } else if(0.25 <= _quizCardRotate && _quizCardRotate <= 0.75) {
        _animateSwipe(_quizCardRotate, 0.5);
        setState(() {
          _quizCardSwipeUpY = 0.5;
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
          color: whiteColor,
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
          color: whiteColor,
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
        child: ProgressBar(
          type: ProgressBar.circular,
          offset: 150.0,
          progress: _overallProgress,
          numerator: _progressNumerator,
          denominator: _progressDenominator,
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
            child: _QuizCardSingle(
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
            child: _QuizCardSingle(
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
                    child: _QuizCardSingle(
                      kulitan: 'pieN',
                      answer: 'píng',
                      progress: _currentProgress / maxQuizCharacterProgress,
                      stackNumber: 1,
                      isSwipable: true,
                      showAnswer: _showBackCard,
                      width: _quizCardWidth * 1,
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
      color: primaryColor,
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