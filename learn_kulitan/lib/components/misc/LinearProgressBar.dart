import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import '../../styles/theme.dart';

class LinearProgressBar extends StatefulWidget {
  LinearProgressBar({
    @required this.progress,
    this.height = 15.0,
  });

  final double height;
  final double progress;

  @override
  _LinearProgressBarState createState() => _LinearProgressBarState();
}

class _LinearProgressBarState extends State<LinearProgressBar>
    with SingleTickerProviderStateMixin {
  Animation<double> _animation;
  AnimationController _controller;
  Tween<double> _tween;
  Animation _curveAnimation;

  double _backgroundWidth = 10.0;
  GlobalKey _progressBackgroundKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: linearProgressBarChangeDuration), vsync: this);
    _curveAnimation = CurvedAnimation(parent: _controller, curve: progressBarCurve);
    _tween = Tween<double>(begin: 0.0, end: widget.progress);
    _animation = _tween.animate(_curveAnimation)
      ..addListener(() {
        setState(() {});
      });
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getProgressBackgroundWidth()); 
  }

  void _getProgressBackgroundWidth() async {
    final RenderBox _box = _progressBackgroundKey.currentContext.findRenderObject();
    await Future.delayed(Duration(milliseconds: 100));
    setState(() => _backgroundWidth = _box.size.width);
  }

  @override
  void didUpdateWidget(LinearProgressBar oldWidget) {
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Container(
        key: _progressBackgroundKey,
        height: widget.height,
        alignment: Alignment.centerLeft,
        color: linearProgressBackgroundColor,
        child: Container(
          width: _backgroundWidth * _animation.value,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: linearProgressForegroundColor,
          ),
        )
      ),
    );
  }
}