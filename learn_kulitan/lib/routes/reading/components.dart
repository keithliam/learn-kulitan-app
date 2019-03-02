import 'package:flutter/material.dart';
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

class QuizCard extends StatefulWidget {
  QuizCard({
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
  _QuizCardState createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
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
      padding: const EdgeInsets.only(top: 10.0),
      child: LinearProgressBar(
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
            padding: const EdgeInsets.only(bottom: 15.0),
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