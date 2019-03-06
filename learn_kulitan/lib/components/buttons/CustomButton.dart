import 'package:flutter/material.dart';
import '../../styles/theme.dart';

class CustomButton extends StatefulWidget {
  CustomButton({
    @required this.onPressed,
    @required this.child,
    @required this.height,
    this.color = customButtonDefaultColor,
    this.borderRadius = 0.0,
    this.elevation = 0.0,
    this.padding = const EdgeInsets.all(0.0),
    this.marginTop = 0.0,
    this.disable = false,
    this.pressDelay = 250,
    this.presses,
    this.pressAlert,
    this.pressStopAlert,
  });

  final VoidCallback onPressed;
  final Widget child;
  final double height;
  final Color color;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final double marginTop;
  final bool disable;
  final int presses;
  final int pressDelay;
  final VoidCallback pressAlert;
  final VoidCallback pressStopAlert;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  double _elevation = 0;
  bool _doneTapping = true;

  bool _checkIfPressNum({int num = 0}) {
    return (widget.presses != null && widget.presses == num) || widget.presses == null;
  }

  void buttonPressed() {
    if(!widget.disable)
      setState(() => _elevation = widget.elevation);
      if(_doneTapping)
        setState(() => _elevation = 0.0);
  }

  void buttonHoldDown() async {
    if(!widget.disable && _checkIfPressNum()) {
      setState(() {
        _elevation = widget.elevation;
        _doneTapping = false;
      });
      if(widget.pressAlert != null) {
        widget.pressAlert();
      }
      await Future.delayed(Duration(milliseconds: widget.pressDelay));
      setState(() => _doneTapping = true);        
    }
  }

  void buttonHoldUp() async {
    if(!widget.disable || _elevation == widget.elevation) {
      double _elev = _elevation;
      if(!_doneTapping)
        await Future.delayed(Duration(milliseconds: widget.pressDelay));
      setState(() => _elevation = 0);
      await Future.delayed(Duration(milliseconds: widget.pressDelay));
      if(_elev == widget.elevation && _checkIfPressNum(num: 1))
        widget.onPressed();
      if(widget.pressStopAlert != null && _elev == widget.elevation)
        widget.pressStopAlert();
    }
  }

  void buttonCancel() async {
    if(!widget.disable && _elevation == widget.elevation) {
      setState(() => _elevation = 0);
      if(widget.pressStopAlert != null) {
        await Future.delayed(Duration(milliseconds: widget.pressDelay));
        widget.pressStopAlert();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _button = AnimatedPositioned(
      duration: Duration(
        milliseconds: widget.pressDelay,
      ),
      curve: customButtonPressCurve,
      top: _elevation,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: buttonPressed,
        onTapDown: (_) => buttonHoldDown(),
        onTapUp: (_) => buttonHoldUp(),
        onTapCancel: buttonCancel,
        child: Container(
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
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          color: customButtonShadowColor,
        ),
      ),
    );

    return Container(
      padding: EdgeInsets.only(top: widget.marginTop),
      height: widget.height + widget.elevation + widget.marginTop,
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