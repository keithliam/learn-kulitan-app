import 'package:flutter/material.dart';
import '../../styles/theme.dart';

class CustomButtonGroup {
  CustomButtonGroup({ this.onTapDown, this.onTapUp });
  
  final VoidCallback onTapDown;
  final VoidCallback onTapUp;
  
  int _presses = 0;

  get presses => _presses;

  void press() {
    _presses++;
    if (onTapDown != null && onTapDown != null) onTapDown();
  }

  void unpress() {
    if(_presses > 0) _presses--;
    if(_presses == 0 && onTapUp != null) onTapUp();
  }
}


class CustomButton extends StatefulWidget {
  CustomButton({
    @required this.onPressed,
    @required this.child,
    this.onPressedImmediate,
    this.height,
    this.color = buttonDefaultColor,
    this.borderRadius = 0.0,
    this.elevation = 0.0,
    this.padding = const EdgeInsets.all(0.0),
    this.marginTop = 0.0,
    this.disable = false,
    this.pressDelay = defaultCustomButtonPressDuration,
    CustomButtonGroup buttonGroup,
  }) : buttonGroup = buttonGroup ?? CustomButtonGroup();

  final VoidCallback onPressed;
  final VoidCallback onPressedImmediate;
  final Widget child;
  final double height;
  final Color color;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final double marginTop;
  final bool disable;
  final int pressDelay;
  final CustomButtonGroup buttonGroup;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  final GlobalKey _key = GlobalKey();
  double _height = 0.0;
  bool _isPressed = false;
  bool _pressingUp = false;
  bool _pressingDown = false;
  int _called = 0;

  void _buttonTapped() async {
    _called++;
    final bool _toPress = widget.buttonGroup.presses == 1;
    final bool _pressedMany = widget.buttonGroup.presses > 1;
    if (
      _pressedMany || (
      !widget.disable &&
      (
        (_isPressed && widget.buttonGroup.presses == 1) ||
        (!_isPressed && widget.buttonGroup.presses == 0)
      ))
    ) {
      final bool _pressed = _isPressed;
      if (!_isPressed) {
        if (_toPress && widget.onPressedImmediate != null) widget.onPressedImmediate();
        setState(() => _isPressed = true);
        widget.buttonGroup.press();
      }
      if (!_pressingUp) {
        if (!_pressedMany || _pressed || _pressingDown) await Future.delayed(Duration(milliseconds: widget.pressDelay));
        setState(() => _isPressed = false);
        _pressingUp = true;
        await Future.delayed(Duration(milliseconds: widget.pressDelay));
        _pressingUp = false;
        if (_toPress && _called == 1) widget.onPressed();
        widget.buttonGroup.unpress();
      }
    }
    _called--;
  }

  void _buttonHoldDown() async {
    if (!widget.disable && widget.buttonGroup.presses == 0) {
      setState(() => _isPressed = true);
      _pressingDown = true;
      widget.buttonGroup.press();
      await Future.delayed(Duration(milliseconds: widget.pressDelay));
      _pressingDown = false;
    }
  }

  void _cancelHold() async {
    if (!widget.disable && _isPressed) {
      setState(() => _isPressed = false);
      await Future.delayed(Duration(milliseconds: widget.pressDelay));
      widget.buttonGroup.unpress();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {
      final RenderBox _renderBox = _key.currentContext.findRenderObject();
      _height = _renderBox.size.height;
    }));
  }

  @override
  Widget build(BuildContext context) {
    Widget _button = AnimatedPositioned(
      duration: Duration(
        milliseconds: widget.pressDelay,
      ),
      curve: customButtonPressCurve,
      top: _isPressed ? widget.elevation : 0.0,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: _buttonTapped,
        onTapDown: (_) => _buttonHoldDown(),
        onTapCancel: _cancelHold,
        child: Container(
          key: _key,
          height: widget.height,
          padding: widget.padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: widget.color,
          ),
          child: widget.child,
        ),
      ),
    );

    Widget _buttonShadow = Positioned(
      top: widget.elevation,
      left: 0,
      right: 0,
      child: Container(
        height: _height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: buttonShadowColor,
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.only(top: widget.marginTop),
      height: _height + widget.elevation + widget.marginTop,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _buttonShadow,
          _button,
        ],
      ),
    );
  }
}