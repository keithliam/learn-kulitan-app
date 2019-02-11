import 'package:flutter/material.dart';
import '../styles/theme.dart';

class CustomButton extends StatefulWidget {
  CustomButton(
      {Key key,
      @required this.onPressed,
      @required this.child,
      @required this.height,
      this.color: whiteColor,
      this.borderRadius: 0.0,
      this.elevation: 0.0,
      this.padding,
      this.marginTop: 0.0})
      : super(key: key);

  final VoidCallback onPressed;
  final Widget child;
  final double height;
  final Color color;
  final double borderRadius;
  final double elevation;
  final EdgeInsetsGeometry padding;
  final double marginTop;

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  double _initElevation;
  double _elevation = 0;

  @override
  void initState() {
    _initElevation = widget.elevation;
    super.initState();
  }

  void buttonPressed(func) async {
    setState(() => _elevation = _initElevation);
    await Future.delayed(const Duration(milliseconds: 250));
    setState(() => _elevation = 0);
  }

  void buttonHoldDown() {
    setState(() => _elevation = _initElevation);
  }

  void buttonHoldUp(func) async {
    setState(() => _elevation = 0);
    await Future.delayed(const Duration(milliseconds: 250));
    func();
  }

  void buttonCancel() {
    setState(() => _elevation = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: widget.marginTop),
      height: widget.height + widget.elevation + widget.marginTop,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: widget.elevation,
            left: 0,
            right: 0,
            child: Container(
              height: widget.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                color: Color(0x22000000),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(
              milliseconds: 250,
            ),
            curve: Curves.easeInOut,
            top: _elevation,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () => buttonPressed(widget.onPressed),
              onTapDown: (_) => buttonHoldDown(),
              onTapUp: (_) => buttonHoldUp(widget.onPressed),
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
          ),
        ],
      ),
    );
  }
}