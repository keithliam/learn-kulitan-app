import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import '../../components/buttons/CustomButton.dart';
import '../../components/misc/LinearProgressBar.dart';
import '../../components/misc/CustomCard.dart';
import '../../styles/theme.dart';

class ChoiceButton extends StatefulWidget {
  ChoiceButton({
    @required this.text,
    @required this.onTap,
    @required this.justPressed,
    @required this.disable,
    this.type = ChoiceButton.wrong,
    this.showAnswer = false,
    this.reset = false,
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
      padding: const EdgeInsets.all(12.0),
      pressDelay: widget.showAnswerDuration,
      justPressed: widget.justPressed,
      child: Center(
        child: AnimatedOpacity(
          opacity: widget.reset? 0.0 : 1.0,
          duration: Duration(milliseconds: widget.resetDuration),
          curve: customButtonPressCurve,
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

class QuizCard extends StatelessWidget {
  QuizCard({
    @required this.kulitan,
    @required this.answer,
    @required this.progress,
    @required this.color,
    @required this.showAnswer,
    @required this.width,
    @required this.originalWidth,
  });

  final String kulitan;
  final String answer;
  final double progress;
  final Color color;
  final bool showAnswer;
  final double width;
  final double originalWidth;

  @override
  Widget build(BuildContext context) {
    Widget _kulitan = Expanded(
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            this.kulitan,
            style: kulitanQuiz,
          ),
        ),
      ),
    );

    Widget _progressBar = Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: LinearProgressBar(
        progress: this.progress,
      ),
    );

    List _cardContents = <Widget>[
      _kulitan,
      _progressBar,
    ];

    if(this.showAnswer)
      _cardContents.insert(1,
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Text(
              this.answer,
              style: textQuizAnswer,
            ),
          ),
        )
      );
    else if(_cardContents.length == 3)
      _cardContents.removeAt(1);

    return CustomCard(
      color: this.color,
      height: this.width,
      width: this.width,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: cardQuizHorizontalPadding, vertical: cardQuizVerticalPadding),
          height: this.originalWidth,
          width: this.originalWidth,
          child: Column(
            children: _cardContents,
          ),
        ),
      ),
    );
  }
}

class AnimatedQuizCard extends StatefulWidget {
  AnimatedQuizCard({
    @required this.kulitan,
    @required this.answer,
    @required this.progress,
    @required this.stackNumber,
    @required this.stackWidth,
    @required this.heightToStackTop,
    @required this.flipStream,
    @required this.disableSwipeStream,
    @required this.forwardCardStream,
    @required this.revealAnswer,
    @required this.swipedLeft,
  });

  final String kulitan;
  final String answer;
  final double progress;
  final int stackNumber;
  final double stackWidth;
  final double heightToStackTop;
  final Stream flipStream;
  final Stream disableSwipeStream;
  final Stream forwardCardStream;
  final Function revealAnswer;
  final VoidCallback swipedLeft;

  @override
  _AnimatedQuizCard createState() => _AnimatedQuizCard();
}

class _AnimatedQuizCard extends State<AnimatedQuizCard> with SingleTickerProviderStateMixin {
  StreamSubscription _flipStreamSubscription;
  StreamSubscription _disableSwipeStreamSubscription;
  StreamSubscription _forwardCardStreamSubscription;
  Animation<double> _animation;
  AnimationController _controller;
  Tween<double> _tween;
  ColorTween _colorTween;
  Animation _colorAnimation;
  Animation _curveAnimation;
  Curve _autoSwipeDownCurve = quizCardAutoSwipeDownCurve;
  Curve _swipeDownCurve = quizCardSwipeDownCurve;
  Curve _swipeLeftCurve = quizCardSwipeLeftCurve;
  Curve _forwardCurve = quizCardForwardCurve;
  double _cardSwipeDownY = 0.5;
  double _cardRotate = 0.5;
  double _cardSwipeLeftX = 0.0;
  double _cardTransform = 0.0;
  double _cardWidth = 50.0;

  double _topOffset = 0.0;
  double _leftOffset = horizontalScreenPadding;

  bool _disableSwipe = true;
  bool _isSwipeDownSnapping = false;
  bool _isSwipeLeftSnapping = false;
  bool _isColorTweening = false;
  bool _isFlipped = false;
  bool _showBackCard = false;
  bool _hasSeenAnswer = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: swipeDownSnapDuration), vsync: this);
    _curveAnimation = CurvedAnimation(parent: _controller, curve: _swipeDownCurve);
    _tween = Tween<double>(begin: 0.0, end: 1.0);
    _colorTween = ColorTween(
      begin: widget.stackNumber == 1? cardQuizColor2 : cardQuizColor3,
      end: widget.stackNumber == 1? cardQuizColor1 : widget.stackNumber == 2? cardQuizColor2 : cardQuizColor3
    );
    _colorAnimation = _colorTween.animate(_curveAnimation);
    _animation = _tween.animate(_curveAnimation)
      ..addListener(_noneListener);
    _flipStreamSubscription = widget.flipStream.listen((_) {
      if(widget.stackNumber == 1)
        _animateSwipe(_cardRotate, 1.0);
    });
    if(widget.stackNumber == 1)
      setState(() => _disableSwipe = false);
    _disableSwipeStreamSubscription = widget.disableSwipeStream.listen((disableSwipe) => _toggleDisableIfTopCard(disableSwipe));
    _forwardCardStreamSubscription = widget.forwardCardStream.listen((_) => _updatedStackNumber());
  }

  void _toggleDisableIfTopCard(bool toggle) {
    if(widget.stackNumber == 1)
      setState(() => _disableSwipe = toggle);
  }

  _updatedStackNumber() async {
    if(widget.stackNumber == 1)
      setState(() {
        _isColorTweening = true;
        _cardSwipeDownY = 0.5;
        _cardRotate = 0.5;
        _cardSwipeLeftX = 0.0;
        _cardTransform = 0.0;
        _isFlipped = false;
        _showBackCard = false;
        _hasSeenAnswer = false;
      });
    _animateSwipe(0.0, 1.0, isSwipeDown: false, isForward: true);
    await Future.delayed(Duration(milliseconds: forwardQuizCardsDuration));
    setState(() => _isColorTweening = false);
    if(widget.stackNumber == 1)
      _disableSwipe = false;
  }

  @override
  void didUpdateWidget(AnimatedQuizCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.flipStream != oldWidget.flipStream) {
      _flipStreamSubscription.cancel();
      _flipStreamSubscription = widget.flipStream.listen((_) {
        if(widget.stackNumber == 1)
          _animateSwipe(_cardRotate, 1.0);
      });
    }
    if(widget.disableSwipeStream != oldWidget.disableSwipeStream) {
      _disableSwipeStreamSubscription.cancel();
      _disableSwipeStreamSubscription = widget.disableSwipeStream.listen((disableSwipe) => _toggleDisableIfTopCard(disableSwipe));
    }
    if(widget.disableSwipeStream != oldWidget.disableSwipeStream) {
      _disableSwipeStreamSubscription.cancel();
      _disableSwipeStreamSubscription = widget.disableSwipeStream.listen((_) => _updatedStackNumber());
    }
    if(widget.heightToStackTop != oldWidget.heightToStackTop) {
      if(widget.stackNumber == 1)
        setState(() => _topOffset = widget.heightToStackTop + quizCardStackTopSpace);
      else if(widget.stackNumber == 2)
        setState(() => _topOffset = widget.heightToStackTop + (quizCardStackTopSpace / 2));
      else
        setState(() => _topOffset = widget.heightToStackTop);
    }
    if(widget.stackWidth != oldWidget.stackWidth) {
      if(widget.stackNumber == 1) {
        setState(() => _cardWidth = widget.stackWidth);
      } else if(widget.stackNumber == 2)
        setState(() {
          _leftOffset += widget.stackWidth * 0.05;
          _cardWidth = widget.stackWidth * 0.9;
        });
      else if(widget.stackNumber == 3)
        setState(() {
          _leftOffset += widget.stackWidth * 0.1;
          _cardWidth = widget.stackWidth * 0.8;
        });
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _flipStreamSubscription.cancel();
    _disableSwipeStreamSubscription.cancel();
    _forwardCardStreamSubscription.cancel();
    super.dispose();
  }

  void _noneListener() => setState(() {});

  void _swipeDownListener() {
    if(_animation.value < 0.25 || 0.75 < _animation.value)
      setState(() => _showBackCard = true);
  }

  void _forwardCardListener() {
    double _topStart = widget.stackNumber == 2? 0.0 : quizCardStackTopSpace / 2;
    double _topFin = widget.stackNumber == 3? -quizCardStackTopSpace / 2 : quizCardStackTopSpace / 2;
    double _leftStart = widget.stackNumber == 1? 0.05 : widget.stackNumber == 1? 0.05 : widget.stackNumber == 2? 0.1 : 0.15;
    double _leftFinDiff = 0.05;
    double _widthStart = widget.stackNumber == 1? 0.9 : widget.stackNumber == 2? 0.8 : 0.7;
    double _widthFinDiff = 0.1;
    setState(() {
      _topOffset = widget.heightToStackTop + _topStart + (_animation.value * _topFin);
      _leftOffset = horizontalScreenPadding + (widget.stackWidth * _leftStart - (widget.stackWidth * _animation.value * _leftFinDiff));
      _cardWidth = widget.stackWidth * _widthStart + (widget.stackWidth * _animation.value * _widthFinDiff);
    });
  }

  void _animateSwipe(double fromValue, double toValue, {bool isSwipeDown: true, bool isForward: false}) async {
    Duration _duration;
    if(isSwipeDown) {
      bool _isAuto = fromValue == 0.5 && toValue == 1.0;
      _duration = Duration(milliseconds: _isAuto? autoSwipeDownDuration : swipeDownSnapDuration);
      _tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: _autoSwipeDownCurve,
        )
      )..removeListener(_swipeDownListener)..removeListener(_forwardCardListener)..addListener(_swipeDownListener);
      if(toValue == 0.0 || toValue == 1.0)
        setState(() {
          _isFlipped = true;
          _cardRotate = toValue;
        });
    } else if(!isForward) {
      _duration = Duration(milliseconds: swipeLeftSnapDuration);
      _tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: quizCardSwipeLeftCurve,
        )
      )..removeListener(_swipeDownListener)..removeListener(_forwardCardListener);
    } else {
      _duration = Duration(milliseconds: quizCardsForwardDuration);
      _tween.animate(
        CurvedAnimation(
          parent: _controller,
          curve: _forwardCurve,
        )
      )..removeListener(_swipeDownListener)..removeListener(_forwardCardListener)..addListener(_forwardCardListener);
    }
    if(isSwipeDown) {
      setState(() => _isSwipeDownSnapping = true);
    } else if(!isForward) {
      setState(() => _isSwipeLeftSnapping = true);
      if(toValue == 1.0)
        setState(() => _disableSwipe = true);
    } else {
      setState(() => _disableSwipe = true);
    }
    _tween
      ..begin = fromValue
      ..end = toValue;
    _controller
      ..value = 0.0
      ..duration = _duration
      ..forward();
    await Future.delayed(_duration);
    if(isSwipeDown)
      setState(() => _isSwipeDownSnapping = false);
    else if(!isForward)
      setState(() => _isSwipeLeftSnapping = false);
  }

  void _swipeAction(details) {
    if(!_disableSwipe) {
      if(!_isFlipped) {
        double _swipeValue = _cardSwipeDownY + (details.delta.dy * swipeDownSensitivity * 0.002);
        if(0.0 < _swipeValue && _swipeValue < 1.0) {
          double _rotationValue = _swipeDownCurve.transform(_swipeValue);
          setState(() {
            _cardSwipeDownY = _swipeValue;
            _cardRotate = _rotationValue;
          });
          if(_showBackCard && (0.25 < _rotationValue && _rotationValue < 0.75))
            setState(() => _showBackCard = false);
          else if(!_showBackCard && ((0.0 < _rotationValue && _rotationValue < 0.25) || (0.75 < _rotationValue && _rotationValue < 1.0)))
            setState(() {
              _showBackCard = true;
              _hasSeenAnswer = true;
            });
        }
      } else {
        double _slideValue = _cardSwipeLeftX + ((-details.delta.dx * swipeLeftSensitivity) / swipeLeftMax);
        if(_slideValue > 1.0) {
          setState(() {
            _cardSwipeLeftX = 1.0;
            _cardTransform = 1.0;
            _disableSwipe = true;
          });
          widget.swipedLeft();
        } else if(_slideValue < 0.0) {
          setState(() {
            _cardSwipeLeftX = 0.0;
            _cardTransform = 0.0;
          });
        } else {
          setState(() {
            _cardSwipeLeftX = _slideValue;
            _cardTransform = _swipeLeftCurve.transform(_slideValue);
          });
        }
      }
    }
  }

  void _swipeActionCancel() async {
    if(!_disableSwipe) {
      if(!_isFlipped) {
        if(_hasSeenAnswer) {
          setState(() {
            _hasSeenAnswer = false;
            _isFlipped = true;
          });
          if(_cardRotate < 0.01 || _cardRotate > 0.99) {
            setState(() => _cardRotate = _cardRotate < 0.01? 0.0 : 1.0);
            widget.revealAnswer();
          } else {
            widget.revealAnswer(delay: swipeDownSnapDuration);
            if(_cardRotate < 0.5) {
              _animateSwipe(_cardRotate, 0.0);
              setState(() {
                _cardSwipeDownY = 0.0;
                _cardRotate = 0.0;
              });
            } else {
              _animateSwipe(_cardRotate, 1.0);
              setState(() {
                _cardSwipeDownY = 1.0;
                _cardRotate = 1.0;
              });
            }
          }
        } else if(0.25 <= _cardRotate && _cardRotate <= 0.75) {
          _animateSwipe(_cardRotate, 0.5);
          setState(() {
            _cardSwipeDownY = 0.5;
            _cardRotate = 0.5;
          });
        }
      } else {
        if(_cardSwipeLeftX <= swipeLeftThreshold) {
          _animateSwipe(_cardTransform, 0.0, isSwipeDown: false);
          setState(() {
            _cardSwipeLeftX = 0.0;
            _cardTransform = 0.0;
          });
        } else {
          _animateSwipe(_cardTransform, 1.0, isSwipeDown: false);
          setState(() {
            _cardSwipeLeftX = 1.0;
            _cardTransform = 1.0;
            _disableSwipe = true;
          });      
          await Future.delayed(Duration(milliseconds: swipeLeftSnapDuration));
          widget.swipedLeft();
        }  
      }
    }
  }

  double _getRotation(double x) {
    return (2 * x * math.pi)  - math.pi;
  }

  @override
  Widget build(BuildContext context) {
    Matrix4 _matrix = Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(_getRotation(_isSwipeDownSnapping? _animation.value : _cardRotate));
    double _swipeRatio = _isSwipeLeftSnapping? _animation.value : _cardTransform;

    return Positioned(
      top: _topOffset - (_swipeRatio * quizCardMoveUpVelocity * 150.0),
      left: _leftOffset - (_swipeRatio * quizCardMoveLeftVelocity * ((widget.stackWidth + horizontalScreenPadding) * 1.2)),
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
                kulitan: widget.kulitan,
                answer: widget.answer,
                progress: widget.progress,
                color: _isColorTweening? _colorAnimation.value : widget.stackNumber == 1? cardQuizColor1 : widget.stackNumber == 2? cardQuizColor2 : cardQuizColor3,
                showAnswer: _showBackCard,
                width: _cardWidth,
                originalWidth: widget.stackWidth,
              ), 
            ),
          ),
        ),
      ),
    );
  }
}