import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'dart:math' as math;
import '../styles/theme.dart';

class SlideLeftRoute extends PageRouteBuilder {
  final Widget widget;
  SlideLeftRoute({this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        });
}

class _CircularProgressBarPainter extends CustomPainter {
  _CircularProgressBarPainter({
    @required this.progress,
  });

  final double progress;

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Paint area = Paint()
      ..color = whiteColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;
    Paint bar = Paint()
      ..color = accentColor
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

class Divider extends StatelessWidget {
  Divider({
    @required this.height,
    @required this.color,
    this.width: -1,
  });

  final double width;
  final double height;
  final Color color;

  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width < 0? MediaQuery.of(context).size.width : this.width,
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.circular(100.0),
      ),
    );
  }
}

class ProgressBar extends StatefulWidget {
  ProgressBar({
    @required this.type,
    @required this.progress,
    @required this.offset,
    this.height = 15.0,
    this.numerator,
    this.denominator,
  });

  static const int linear = 0;
  static const int circular = 1;

  final int type;
  final double height;
  final double progress;
  final double offset;
  final int numerator;
  final int denominator;

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  Tween<double> _tween;
  Animation _curveAnimation;

  final int _initDuration = 1000;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: Duration(milliseconds: _initDuration), vsync: this);
    _curveAnimation = CurvedAnimation(parent: _controller, curve: progressBarCurve);
    _tween = Tween<double>(begin: 0.0, end: widget.progress);
    _animation = _tween.animate(_curveAnimation)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
  }
  

  @override
  void didUpdateWidget(ProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _tween
      ..begin = _tween.evaluate(_curveAnimation)
      ..end = widget.progress;
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
  Widget build(BuildContext context) {
    Widget _linearProgressBar = ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Container(
        height: widget.height,
        alignment: Alignment.centerLeft,
        color: snowColor,
        child: Container(
          width: (MediaQuery.of(context).size.width - widget.offset) * _animation.value,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: accentColor,
          ),
        )
      ),
    );

    Widget _circularProgressBar = FittedBox(
      fit: BoxFit.scaleDown,
      child: Container(
        width: MediaQuery.of(context).size.width - (horizontalScreenPadding * 2),
        height: 124.0,
        child: CustomPaint(
          painter: _CircularProgressBarPainter(
            progress: _animation.value,
          ),
          child: Stack(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(bottom: 45.0),
                child: Text(
                  '${widget.numerator}',
                  style: textQuizHeader,
                  textAlign: TextAlign.center,
                ),
              ),
              Center(
                child: Divider(
                  height: 5.0,
                  width: 64.0,
                  color: whiteColor,
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(top: 40.0),
                child: Text(
                  '${widget.denominator}',
                  style: textQuizHeader,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (widget.type == ProgressBar.linear) {
      return _linearProgressBar;
    } else {
      return _circularProgressBar;
    }
  }
}

class StaticHeader extends StatefulWidget {
  StaticHeader({
    this.left,
    this.middle: const Spacer(),
    this.right: const Spacer(),
  });

  final Widget left;
  final Widget middle;
  final Widget right;

  @override
  _StaticHeader createState() => _StaticHeader();
}

class _StaticHeader extends State<StaticHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        widget.left,
        widget.middle,
        widget.right,
      ],
    );
  }
}

class CustomCard extends StatefulWidget {
  CustomCard({
    @required this.color,
    @required this.child,
    this.hasShadow: false,
    this.padding,
    this.height,
    this.width,
  });

  final Color color;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final bool hasShadow;
  final double height;
  final double width;

  @override
  _CustomCardState createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height != null? widget.height : null,
      width: widget.width != null? widget.height : null,
      padding: widget.padding != null? widget.padding : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: widget.hasShadow? [
          BoxShadow(
            color: Color(0x21000000),
            blurRadius: 30.0,
            offset: Offset(0.0, 20.0),
          ),
        ] : null,
        color: widget.color,
      ),
      child: widget.child,
    );
  }
}