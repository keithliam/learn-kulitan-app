import 'package:flutter/material.dart';
import '../../db/GameData.dart';

class CustomCard extends StatelessWidget {
  static final GameData _gameData = GameData();

  const CustomCard({
    @required this.child,
    this.color,
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
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.0),
        boxShadow: hasShadow? [
          BoxShadow(
            color: _gameData.getColor('cardShadow'),
            blurRadius: 30.0,
            offset: Offset(0.0, 20.0),
          ),
        ] : null,
        color: color ?? _gameData.getColor('cardDefault'),
      ),
      child: child,
    );
  }
}