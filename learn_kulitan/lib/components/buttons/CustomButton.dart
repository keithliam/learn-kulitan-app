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
    this.color = customButtonDefaultColor,
    this.borderRadius = 0.0,
    this.elevation = 0.0,
    this.padding = const EdgeInsets.all(0.0),
    this.marginTop = 0.0,
    this.disable = false,
    this.pressDelay = defaultCustomButtonPressDuration,
    this.buttonGroup,
  });

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

  bool _checkIfPressMany() => widget.buttonGroup == null || widget.buttonGroup.presses > 1;
  bool _checkIfPressNum({int nums = 0}) => widget.buttonGroup == null || widget.buttonGroup.presses == nums;

  void _buttonTapped() async {
    final bool _toPress = _checkIfPressNum(nums: 1);
    if (_checkIfPressMany()) {
      if (_toPress && widget.onPressedImmediate != null) widget.onPressedImmediate();
      setState(() => _isPressed = false);
      await Future.delayed(Duration(milliseconds: widget.pressDelay));
      if (_toPress) widget.onPressed();
      if (widget.buttonGroup != null) widget.buttonGroup.unpress();
    } else if (
      !widget.disable &&
      (
        (_isPressed && _checkIfPressNum(nums: 1)) ||
        (!_isPressed && _checkIfPressNum())
      )
    ) {
      if (!_isPressed) {
        setState(() => _isPressed = true);
        if(widget.buttonGroup != null) widget.buttonGroup.press();
      }
      if (_toPress && widget.onPressedImmediate != null) widget.onPressedImmediate();
      await Future.delayed(Duration(milliseconds: widget.pressDelay));
      setState(() => _isPressed = false);
      await Future.delayed(Duration(milliseconds: widget.pressDelay));
      if (_toPress) widget.onPressed();
      if (widget.buttonGroup != null) widget.buttonGroup.unpress();
    }
  }

  void _buttonHoldDown() async {
    if (!widget.disable && _checkIfPressNum()) {
      setState(() => _isPressed = true);
      if(widget.buttonGroup != null) widget.buttonGroup.press();
    }
  }

  void _cancelHold() async {
    if (!widget.disable && _isPressed) {
      setState(() => _isPressed = false);
      await Future.delayed(Duration(milliseconds: widget.pressDelay));
      if(widget.buttonGroup != null) widget.buttonGroup.unpress();
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
          color: customButtonShadowColor,
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