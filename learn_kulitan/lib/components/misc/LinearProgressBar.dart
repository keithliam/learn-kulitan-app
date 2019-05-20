import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import '../../styles/theme.dart';
import '../../db/GameData.dart';

class LinearProgressBar extends StatefulWidget {
  const LinearProgressBar({
    @required this.progress,
    this.height = 15.0,
    this.animate = true,
    this.color,
  });

  final double height;
  final double progress;
  final bool animate;
  final Color color;

  @override
  _LinearProgressBarState createState() => _LinearProgressBarState();
}

class _LinearProgressBarState extends State<LinearProgressBar>
    with SingleTickerProviderStateMixin {
  static final GameData _gameData = GameData();
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
    if(widget.animate) {
      _tween
        ..begin = _tween.evaluate(_curveAnimation)
        ..end = widget.progress;
      _controller
        ..value = 0.0
        ..forward();
    } else {
      _tween.end = widget.progress;
      _controller.value = 1.0;
    }
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
        color: widget.color ?? _gameData.getColor('linearProgressBackground'),
        child: Container(
          width: _backgroundWidth * _animation.value,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: _gameData.getColor('linearProgressForeground'),
          ),
        )
      ),
    );
  }
}