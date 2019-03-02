import 'package:flutter/material.dart';
import '../../styles/theme.dart';

class CustomCard extends StatefulWidget {
  CustomCard({
    @required this.color,
    @required this.child,
    this.hasShadow = false,
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
            color: customCardShadowColor,
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