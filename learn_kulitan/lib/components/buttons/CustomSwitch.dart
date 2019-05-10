import 'package:flutter/material.dart';
import '../../styles/theme.dart';

class CustomSwitch extends StatefulWidget {
  const CustomSwitch({
    @required this.value,
    @required this.onChanged,
    this.disabled = false,
  });

  final bool value;
  final Function(bool) onChanged;
  final bool disabled;

  @override
  _CustomSwitchState createState() => _CustomSwitchState();
}

class _CustomSwitchState extends State<CustomSwitch>
    with SingleTickerProviderStateMixin {
  double _position = 0.0;
  double _touchPosition;
  bool _dragged = false;
  Curve _curve = customSwitchCurve;
  Duration _duration = const Duration(milliseconds: customSwitchChangeDuration);
  AnimationController _controller;
  Tween<double> _tween;
  Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _duration, vsync: this);
    final CurvedAnimation _curveAnimation =
        CurvedAnimation(parent: _controller, curve: _curve);
    _tween = Tween<double>(begin: 0.0, end: 1.0);
    _animation = _tween.animate(_curveAnimation)
      ..addListener(() => setState(() => _position = _animation.value));
    if (widget.value) _controller.forward();
  }

  @override
  void didUpdateWidget(CustomSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (!_dragged)
        _snap(isToggle: true);
      else
        _dragged = false;
    }
  }

  void _snap({bool isToggle = false}) {
    if (isToggle || (0.0 < _position && _position < 1.0)) {
      _tween.begin = _position;
      if (isToggle) {
        _duration = const Duration(milliseconds: customSwitchChangeDuration);
        _controller.duration =
            const Duration(milliseconds: customSwitchChangeDuration);
      } else {
        _duration = const Duration(milliseconds: customSwitchSnapDuration);
        _controller.duration =
            const Duration(milliseconds: customSwitchSnapDuration);
      }
      if ((isToggle && _position < 0.5) || (!isToggle && _position >= 0.5))
        _tween.end = 1.0;
      else
        _tween.end = 0.0;
      _controller.reset();
      _controller.forward();
    }
  }

  void _dragStart(_) {
    _dragged = true;
    _touchPosition = _position;
  }

  void _dragUpdate(DragUpdateDetails details) {
    final double _value = details.delta.dx / customSwitchThreshold;
    _touchPosition = _touchPosition + _value;
    if (0.0 <= _touchPosition && _touchPosition <= 1.0)
      setState(() => _position = _curve.transform(_touchPosition));
  }

  void _dragEnd() {
    if (_dragged) {
      if (!widget.value && _position >= 0.5)
        widget.onChanged(true);
      else if (widget.value && _position < 0.5)
        widget.onChanged(false);
      else
        _dragged = false;
      _snap();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !widget.disabled ? (() => widget.onChanged(!widget.value)) : null,
      onHorizontalDragStart: !widget.disabled ? _dragStart : null,
      onHorizontalDragUpdate: !widget.disabled ? _dragUpdate : null,
      onHorizontalDragCancel: !widget.disabled ? _dragEnd : null,
      onHorizontalDragEnd: !widget.disabled ? (_) => _dragEnd() : null,
      child: Container(
        padding: const EdgeInsets.only(right: 10.0),
        height: 48.0,
        width: 80.0,
        child: Center(
          child: Stack(
            children: <Widget>[
              AnimatedContainer(
                height: 32.0,
                width: 54.0,
                duration: _duration,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: Color.lerp(
                    customSwitchColor,
                    customSwitchToggleColor,
                    _position,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('A', style: kulitanSwitch),
                      SizedBox(width: 8.0),
                      Text('A', style: textSwitch),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 3.5,
                left: 3.5 + (_position * 22.0),
                child: Container(
                  height: 25.0,
                  width: 25.0,
                  decoration: BoxDecoration(
                    color: Color.lerp(
                      customSwitchToggleColor,
                      customSwitchColor,
                      _position,
                    ),
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
