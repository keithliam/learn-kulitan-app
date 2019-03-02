import 'package:flutter/material.dart';

class DividerNew extends StatelessWidget {
  DividerNew({
    @required this.height,
    @required this.color,
    this.width = -1,
  });

  final double width;
  final double height;
  final Color color;

  Widget build(BuildContext context) {
    return Container(
      height: this.height,
      width: this.width < 0? MediaQuery.of(context).size.width : this.width,
      decoration: BoxDecoration(
        color: this.color,
        borderRadius: BorderRadius.circular(100.0),
      ),
    );
  }
}