import 'package:flutter/material.dart';

class DividerNew extends StatelessWidget {
  const DividerNew({
    @required this.height,
    @required this.color,
    this.boxShadow,
    this.width = -1,
  });

  final double width;
  final double height;
  final Color color;
  final BoxShadow boxShadow;

  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width < 0? MediaQuery.of(context).size.width : width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(100.0),
        boxShadow: boxShadow != null ? [boxShadow] : null,
      ),
    );
  }
}