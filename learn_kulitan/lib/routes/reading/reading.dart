import 'package:flutter/material.dart';
import 'dart:async';
import '../../styles/theme.dart';
import '../../components/buttons/IconButtonNew.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/CircularProgressBar.dart';
import './components.dart';

class ReadingPage extends StatefulWidget {
  ReadingPage({
    @required this.screenHeight,
  });

  final double screenHeight;

  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
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
  int _resetDuration = 500;
  int _showAnswerDuration = 250;

  GlobalKey _quizCardsKey = GlobalKey();
  double _quizCardWidth = 100.0;
  double _heightToQuizCardTop = 100.0;
  double _quizCardStackHeight = 100.0;
  double _heightToCardStackBottom = 200.0;
 

  void _justPressed() {
    _disableSwipeController.sink.add(true);
    setState(() => _disableChoices = true);
  }

  final _flipStreamController = StreamController.broadcast();
  final _disableSwipeController = StreamController.broadcast();
  
  void _correctAnswer() async {
    await Future.delayed(Duration(milliseconds: _showAnswerDuration + revealAnswerOffset));
    _flipStreamController.sink.add(null);
    await Future.delayed(Duration(milliseconds: autoSwipeDownDuration));
    setState(() => _showAnswer = true);
    await Future.delayed(Duration(milliseconds: updateQuizCardProgressOffset));
    setState(() => _currentProgress = _currentProgress < maxQuizCharacterProgress? _currentProgress + 1 : _currentProgress);
    await Future.delayed(Duration(milliseconds: linearProgressBarChangeDuration));
    _disableSwipeController.sink.add(false);
    // TODO : reset()
  }
  void _wrongAnswer() async {
    await Future.delayed(Duration(milliseconds: _showAnswerDuration + revealAnswerOffset));
    _flipStreamController.sink.add(null);
    await Future.delayed(Duration(milliseconds: autoSwipeDownDuration + revealAnswerOffset));
    setState(() => _showAnswer = true);
    await Future.delayed(Duration(milliseconds: _showAnswerDuration));
    setState(() => _currentProgress = _currentProgress > 0? _currentProgress - 1 : _currentProgress);
    await Future.delayed(Duration(milliseconds: linearProgressBarChangeDuration));
    _disableSwipeController.sink.add(false);
    // TODO : reset()
  }
  void _revealAnswer({int delay: 0}) async {
    // TODO : reset()
    setState(() => _disableChoices = true);
    await Future.delayed(Duration(milliseconds: delay + revealAnswerOffset));
    setState(() => _showAnswer = true);
  }
  void _swipedLeft() {
    setState(() {
      _showAnswer = false;
      _resetChoices = true;
    });
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
    WidgetsBinding.instance.addPostFrameCallback((_) => _getQuizCardsSize()); 
  }

  @override
  void dispose() {
    _flipStreamController.close();
    _disableSwipeController.close();
    super.dispose();
  }

  void _getQuizCardsSize() {
    final RenderBox _box = _quizCardsKey.currentContext.findRenderObject();
    double _width = _box.size.width - (horizontalScreenPadding * 2);
    setState(() {
      _quizCardWidth = _width;
      _heightToCardStackBottom = widget.screenHeight - verticalScreenPadding - ((quizChoiceButtonHeight + quizChoiceButtonElevation) * 2) - choiceSpacing - cardQuizStackBottomPadding;
      _heightToQuizCardTop = _heightToCardStackBottom - _quizCardWidth - quizCardStackTopSpace;
      _quizCardStackHeight = _heightToCardStackBottom - _heightToQuizCardTop + cardQuizStackBottomPadding;
    });
  }

  void resetDone() async {
    await Future.delayed(Duration(milliseconds: _resetDuration));
    _disableSwipeController.sink.add(false);
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
   
    Widget _quizCards = Container(
      height: _heightToCardStackBottom,
      child: Stack(
        key: _quizCardsKey,
        children: <Widget>[
          AnimatedQuizCard(
            kulitan: 'pieN',
            answer: 'píng',
            progress: 0.67,
            stackNumber: 3,
            stackWidth: _quizCardWidth,
            heightToStackTop: _heightToQuizCardTop,
            flipStream: _flipStreamController.stream,
            disableSwipeStream: _disableSwipeController.stream,
            revealAnswer: _revealAnswer,
            swipedLeft: _swipedLeft,
          ),
          AnimatedQuizCard(
            kulitan: 'pieN',
            answer: 'píng',
            progress: 0.35,
            stackNumber: 2,
            stackWidth: _quizCardWidth,
            heightToStackTop: _heightToQuizCardTop,
            flipStream: _flipStreamController.stream,
            disableSwipeStream: _disableSwipeController.stream,
            revealAnswer: _revealAnswer,
            swipedLeft: _swipedLeft,
          ),
          AnimatedQuizCard(
            kulitan: 'pieN',
            answer: 'píng',
            progress: _currentProgress / maxQuizCharacterProgress,
            stackNumber: 1,
            stackWidth: _quizCardWidth,
            heightToStackTop: _heightToQuizCardTop,
            flipStream: _flipStreamController.stream,
            disableSwipeStream: _disableSwipeController.stream,
            revealAnswer: _revealAnswer,
            swipedLeft: _swipedLeft,
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