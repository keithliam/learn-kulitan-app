import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
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

class ProgressBar extends StatefulWidget {
  ProgressBar({
    Key key,
    @required this.type,
    @required this.progress,
    @required this.offset,
    this.height = 15.0,
  });

  static const int linear = 0;
  static const int circular = 1;

  final int type;
  final double height;
  final double progress;
  final double offset;

  @override
  _ProgressBarState createState() => _ProgressBarState();
}

class _ProgressBarState extends State<ProgressBar>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  Animation curve;

  final int _initDuration = 1000;
  final int _changeDuration = 1000;
  final Curve _curve = Curves.fastOutSlowIn;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: Duration(milliseconds: _initDuration), vsync: this);
    curve = CurvedAnimation(parent: controller, curve: _curve);
    animation = Tween<double>(begin: 0, end: widget.progress).animate(curve)
      ..addListener(() {
        setState(() => {});
      });
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Container(
          height: widget.height,
          alignment: Alignment.centerLeft,
          color: snowColor,
          child: AnimatedContainer(
            duration: Duration(milliseconds: _changeDuration),
            curve: _curve,
            width: (MediaQuery.of(context).size.width - widget.offset) * animation.value,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: accentColor,
            ),
          )),
    );
  }
}