import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:math' as math;
import './DividerNew.dart';
import '../../styles/theme.dart';
import '../../db/GameData.dart';

class _CircularProgressBarPainter extends CustomPainter {
  const _CircularProgressBarPainter({
    @required this.progress,
  });

  final double progress;

  static final GameData _gameData = GameData();

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint area = Paint()
      ..color = _gameData.getColor('circularProgressBackground')
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;
    Paint bar = Paint()
      ..color = _gameData.getColor('circularProgressForeground')
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    Offset center = new Offset(size.width / 2, size.height / 2);
    double radius = math.min((size.width / 2) - 5.0, (size.height / 2) - 5.0);
    double progressPercent = progress <= 0.995? (0.975 * progress) : ((((progress - 0.995) / 0.005) * 0.025) + 0.975);
    double progressAngle = 2 * math.pi * progressPercent;

    canvas.drawCircle(center, radius, area);

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2,
        progressAngle, false, bar);
  }
}

class CircularProgressBar extends StatefulWidget {
  const CircularProgressBar({
    this.height = 15.0,
    this.numerator,
    this.denominator,
  });
  
  final double height;
  final int numerator;
  final int denominator;

  @override
  _CircularProgressBarState createState() => _CircularProgressBarState();
}

class _CircularProgressBarState extends State<CircularProgressBar>
    with SingleTickerProviderStateMixin {
  static final GameData _gameData = GameData();
  Animation<double> _animation;
  AnimationController _controller;
  Tween<double> _tween;
  Animation _curveAnimation;

  final int _initDuration = 1000;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: _initDuration), vsync: this);
    _curveAnimation = CurvedAnimation(parent: _controller, curve: progressBarCurve);
    _tween = Tween<double>(begin: 0.0, end: _progress);
    _animation = _tween.animate(_curveAnimation)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }
  

  @override
  void didUpdateWidget(CircularProgressBar oldWidget) {
    setState(() => _progress = widget.numerator / widget.denominator);
    super.didUpdateWidget(oldWidget);
    _tween
      ..begin = _tween.evaluate(_curveAnimation)
      ..end = _progress;
    _controller
      ..value = 0.0
      ..forward();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {return FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        width: MediaQuery.of(context).size.width - (quizHorizontalScreenPadding * 2),
        height: 124.0,
        child: CustomPaint(
          painter: _CircularProgressBarPainter(
            progress: _animation.value,
          ),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(bottom: 45.0),
                child: Text(
                  '${widget.numerator}',
                  style: _gameData.getStyle('textQuizHeader'),
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: DividerNew(
                  height: 5.0,
                  width: 64.0,
                  color: _gameData.getColor('circularProgressText'),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 40.0),
                child: Text(
                  '${widget.denominator}',
                  style: _gameData.getStyle('textQuizHeader'),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}