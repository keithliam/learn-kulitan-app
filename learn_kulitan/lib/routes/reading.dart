import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../styles/theme.dart';
import '../components/buttons.dart';
import '../components/misc.dart';

class ChoiceButton extends StatefulWidget {
  ChoiceButton({
    @required this.text,
    @required this.onTap,
    @required this.disable,
    this.type: ChoiceButton.wrong,
    this.showAnswer: false,
    this.reset: false,
    this.resetDone,
    this.resetDuration,
    this.showAnswerDuration,
    this.isSwiping: false,
  });

  static const int right = 0;
  static const int wrong = 1;

  final String text;
  final VoidCallback onTap;
  final bool disable;
  final int type;
  final bool showAnswer;
  final bool reset;
  final VoidCallback resetDone;
  final int resetDuration;
  final int showAnswerDuration;
  final bool isSwiping;

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

  @override
  void didUpdateWidget(ChoiceButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.showAnswer && widget.type == ChoiceButton.right && !_isTapped && !widget.isSwiping) {
      _animateColor(cardChoicesColor, cardChoicesRightColor);
      _controller
        ..reset();
      _tween
        ..begin = cardChoicesRightColor;
    }
    if(widget.reset && ((_tween.begin == whiteColor && _controller.value != 0.0) || (_tween.begin == cardChoicesRightColor && _controller.value == 0.0))) {
      _isTapped = false;
      final Color _fromColor = widget.type == ChoiceButton.right? cardChoicesRightColor : cardChoicesWrongColor;
      _animateColor(_fromColor, cardChoicesColor, isReset: true);
      widget.resetDone();
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
  Curve _swipeLeftCurve = quizCardSwipeLeftCurve;
  double _quizCardRotationX = 0.0;
  double _quizCardSwipeLeftX = 0.0;
  double _quizCardTransform = 0.0;
  bool _isSwipeDownSnapping = false;
  bool _isSwipeLeftSnapping = false;
  bool _isFlipped = false;
  bool _showBackCard = false;
  bool _isSwiping = false;

  void _animateSwipe(double fromValue, double toValue, {bool isSwipeDown: true}) async {
    Duration _duration;
    Curve _curve;
    if(isSwipeDown) {
      bool _isAuto = fromValue == 0.0 && toValue == math.pi;
      _duration = Duration(milliseconds: _isAuto? autoSwipeUpDuration : swipeUpSnapDuration);
      _curve = quizCardSwipeUpCurve;
    } else {
      _duration = Duration(milliseconds: swipeLeftSnapDuration);
      _curve = quizCardSwipeLeftCurve;
    }
    if(toValue == math.pi || toValue == -math.pi)
      setState(() {
        _disableChoices = true;
        _isFlipped = true;
        _quizCardRotationX = toValue;
      });
    if(isSwipeDown)
      setState(() => _isSwipeDownSnapping = true);
    else
      setState(() => _isSwipeLeftSnapping = true);
    _swipeTween
      ..begin = fromValue
      ..end = toValue;
    _swipeAnimation = _swipeTween.animate(
      CurvedAnimation(
        parent: _swipeController,
        curve: _curve,
      )
    );
    _swipeController
      ..value = 0.0
      ..duration = _duration
      ..forward();
    await Future.delayed(_duration);
    if(isSwipeDown)
      setState(() => _isSwipeDownSnapping = false);
    else
      setState(() => _isSwipeLeftSnapping = false);
    if(toValue == 0.0)
      setState(() => _disableChoices = false);
    setState(() => _isSwiping = false);
  }

  void _correctAnswer() async {
    setState(() {
      _disableChoices = true;
      _isSwipable = false;
    });
    await Future.delayed(Duration(milliseconds: _showAnswerDuration + revealAnswerOffset));
    _animateSwipe(_quizCardRotationX, math.pi);
    await Future.delayed(Duration(milliseconds: swipeUpSnapDuration));
    setState(() => _showAnswer = true);
  }
  void _wrongAnswer() async {
    setState(() {
      _disableChoices = true;
      _isSwipable = false;
    });
    await Future.delayed(Duration(milliseconds: _showAnswerDuration + revealAnswerOffset));
    _animateSwipe(_quizCardRotationX, math.pi);
    await Future.delayed(Duration(milliseconds: swipeUpSnapDuration));
    setState(() => _showAnswer = true);
  }
  void _revealedAnswer() async {
    setState(() => _disableChoices = true);
    await Future.delayed(Duration(milliseconds: revealAnswerOffset));
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
    });
    _swipeController = AnimationController(duration: Duration(milliseconds: swipeUpSnapDuration), vsync: this);
    _swipeCurveAnimation = CurvedAnimation(parent: _swipeController, curve: quizCardSwipeUpCurve);
    _swipeTween = Tween<double>(begin: 0.0, end: 1.0);
    _swipeAnimation = _swipeTween.animate(_swipeCurveAnimation)
      ..addListener(() {
        setState(() {});
      });
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

  void _swipeAction(details) {
    if(!_isFlipped && _isSwipable) {
      double _rotationValue = _quizCardRotationX + (details.delta.dy * swipeDownSensitivity);
      if(-math.pi < _rotationValue && _rotationValue < math.pi) {
        setState(() => _quizCardRotationX = _rotationValue);
        if(_showBackCard && (-math.pi / 2 < _rotationValue && _rotationValue < math.pi / 2))
          setState(() => _showBackCard = false);
        else if(!_showBackCard && ((-math.pi < _rotationValue && _rotationValue < -math.pi / 2) || (math.pi / 2 <  _rotationValue && _rotationValue < math.pi)))
          setState(() => _showBackCard = true);
      } else {
        _revealedAnswer();
        setState(() => _isFlipped = true);   
        if(_rotationValue < 0)
          setState(() => _quizCardRotationX = -math.pi);
        else
          setState(() => _quizCardRotationX = math.pi); 
      }
    } else if(_showAnswer && !_resetChoices ) {
      setState(() => _isSwiping = true);
      double _slideValue = _quizCardSwipeLeftX + ((-details.delta.dx * swipeLeftSensitivity) / swipeLeftMax);
      if(_slideValue > 1.0) {
        setState(() {
          _quizCardSwipeLeftX = 1.0;
          _quizCardTransform = 1.0;
          _showAnswer = false;
          _resetChoices = true;
          _isSwiping = false;
        });
      } else if(_slideValue < 0) {
        setState(() {
          _quizCardSwipeLeftX = 0.0;
          _quizCardTransform = 0.0;
          _isSwiping = false;
        });
      } else {
        setState(() {
          _quizCardSwipeLeftX = _slideValue;
          _quizCardTransform = _swipeLeftCurve.transform(_slideValue);
        });
      }
    }
  }

  void _swipeActionCancel() {
    if(!_isFlipped && _isSwipable) {
      double _halfPi = math.pi / 2;
      if(-_halfPi <= _quizCardRotationX && _quizCardRotationX <= _halfPi) {
        _animateSwipe(_quizCardRotationX, 0.0);
        setState(() => _quizCardRotationX = 0.0);
      } else {
        if(_quizCardRotationX < 0) {
          _animateSwipe(_quizCardRotationX, -math.pi);
          setState(() => _quizCardRotationX = -math.pi);
        } else {
          _animateSwipe(_quizCardRotationX, math.pi);
          setState(() => _quizCardRotationX = math.pi);
        }
        _revealedAnswer();
        setState(() => _isFlipped = true);
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
                  disable: _disableChoices,
                  reset: _resetChoices,
                  resetDone: resetDone,
                  resetDuration: _resetDuration,
                  showAnswerDuration: _showAnswerDuration,
                  isSwiping: _isSwiping,
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
                  disable: _disableChoices,
                  reset: _resetChoices,
                  resetDone: resetDone,
                  resetDuration: _resetDuration,
                  showAnswerDuration: _showAnswerDuration,
                  isSwiping: _isSwiping,
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
                  disable: _disableChoices,
                  reset: _resetChoices,
                  resetDone: resetDone,
                  resetDuration: _resetDuration,
                  showAnswerDuration: _showAnswerDuration,
                  isSwiping: _isSwiping,
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
                  disable: _disableChoices,
                  reset: _resetChoices,
                  resetDone: resetDone,
                  resetDuration: _resetDuration,
                  showAnswerDuration: _showAnswerDuration,
                  isSwiping: _isSwiping,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    Matrix4 _matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(_isSwipeDownSnapping? _swipeAnimation.value : _quizCardRotationX);

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
                      progress: 0.9,
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