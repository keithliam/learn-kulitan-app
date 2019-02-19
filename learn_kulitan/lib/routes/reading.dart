import 'package:flutter/material.dart';
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
    if(widget.showAnswer && widget.type == ChoiceButton.right && !_isTapped) {
      _animateColor(cardChoicesColor, cardChoicesRightColor); 
    }
    if(widget.reset && _tween.begin == whiteColor && _controller.value != 0.0) {
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
      height: 62.0,
      color: _animation.value,
      onPressed: widget.disable? null : tapped,
      elevation: 10.0,
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

class ReadingPage extends StatefulWidget {
  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  int _progressNumerator;
  int _progressDenominator;
  double _overallProgress;

  String _answer;
  String _choice1;
  String _choice2;
  String _choice3;
  String _choice4;
  bool _showAnswer = false;
  bool _disableChoices = false;
  bool _resetChoices = false;
  bool _choseAnswer = false;
  int _resetDuration = 500;
  int _showAnswerDuration = 250;

  void correctAnswer() async {
    setState(() => _disableChoices = true);
    await Future.delayed(Duration(milliseconds: _showAnswerDuration));
    setState(() {
      _disableChoices = true;
      _choseAnswer = true;
      _showAnswer = true;
    });
  }
  void wrongAnswer() async {
    setState(() {
      _disableChoices = true;
      _choseAnswer = true;
    });
    await Future.delayed(Duration(milliseconds: _showAnswerDuration));
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
  }

  void swipeAction() {
    // swipe left after answer || swipe left after reveal
    if(_showAnswer && !_resetChoices ) {
      setState(() {
        _showAnswer = false;
        _resetChoices = true;
        _choseAnswer = false;
      });
    // swipe up with no answer (reveal)
    } else if(!_showAnswer && !_resetChoices && !_choseAnswer) {
      setState(() {
        _disableChoices = true;
        _showAnswer = true;
      });
    }
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

  @override
  Widget build(BuildContext context) {
    return Material(
      color: primaryColor,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(headerPadding, headerPadding, headerPadding, 0.0),
            child: StaticHeader(
              left: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                iconSize: headerIconSize,
                color: whiteColor,
                onPressed: () => Navigator.pushNamed(context, '/'),
              ),
              middle: Text(
                'Characters\nLearned',
                style: textQuizHeader,
                textAlign: TextAlign.center,
              ),
              right: IconButton(
                icon: Icon(Icons.settings),
                iconSize: headerIconSize,
                color: whiteColor,
                onPressed: null,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenPadding,
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
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(screenPadding, 0.0, screenPadding, screenPadding),
            child: Container(
              height: 300.0,
            )
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(screenPadding, 0.0, screenPadding, screenPadding),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ChoiceButton(
                        text: _choice1,
                        type: _choice1 == _answer? ChoiceButton.right : ChoiceButton.wrong,
                        onTap: _choice1 == _answer? correctAnswer : wrongAnswer,
                        showAnswer: _showAnswer,
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
                        onTap: _choice2 == _answer? correctAnswer : wrongAnswer,
                        showAnswer: _showAnswer,
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
                        onTap: _choice3 == _answer? correctAnswer : wrongAnswer,
                        showAnswer: _showAnswer,
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
                        onTap: _choice4 == _answer? correctAnswer : wrongAnswer,
                        showAnswer: _showAnswer,
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
            )
          ),
        ],
      ),
    );
  }
}
