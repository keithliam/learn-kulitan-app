import 'package:flutter/material.dart';
import '../styles/theme.dart';

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
    this.pressDelay = 250,
    this.justPressed
  });

  final VoidCallback onPressed;
  final VoidCallback justPressed;
  final Widget child;
  final double height;
  final Color color;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final double marginTop;
  final int pressDelay;

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  double _initElevation;
  double _elevation = 0;

  @override
  void initState() {
    super.initState();
    _initElevation = widget.elevation;
  }

  void buttonPressed(func) async {
    setState(() => _elevation = _initElevation);
    await Future.delayed(Duration(milliseconds: widget.pressDelay));
    setState(() => _elevation = 0);
  }

  void buttonHoldDown() {
    setState(() => _elevation = _initElevation);
  }

  void buttonHoldUp(func) async {
    if(widget.justPressed != null)
      widget.justPressed();
    setState(() => _elevation = 0);
    await Future.delayed(Duration(milliseconds: widget.pressDelay));
    func();
  }

  void buttonCancel() {
    setState(() => _elevation = 0);
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
        onTap: () => widget.onPressed != null? buttonPressed(widget.onPressed) : null,
        onTapDown: (_) => widget.onPressed != null? buttonHoldDown() : null,
        onTapUp: (_) => widget.onPressed != null? buttonHoldUp(widget.onPressed) : null,
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

class IconButtonNew extends StatefulWidget {
  IconButtonNew({
    @required this.icon,
    @required this.onPressed,
    @required this.iconSize,
    this.color = iconButtonDefaultColor,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double iconSize;
  final Color color;

  @override
  _IconButtonNewState createState() => _IconButtonNewState();
}

class _IconButtonNewState extends State<IconButtonNew> {
  double _opacity = 1.0;

  void _pressDown(details) {
    setState(() => _opacity = 0.6);
  }

  void _pressUp(details) {
    setState(() => _opacity = 1.0);
    widget.onPressed();
  }

  void _cancel() {
    setState(() => _opacity = 1.0);
  }

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _pressDown,
      onTapUp: _pressUp,
      onTapCancel: _cancel,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
        child: AnimatedOpacity(
          opacity: _opacity,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 250),
          child: Container(
            color: Colors.transparent,
            child:SizedBox(
              height: widget.iconSize,
              width: widget.iconSize,
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  widget.icon,
                  size: widget.iconSize,
                  color: widget.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}