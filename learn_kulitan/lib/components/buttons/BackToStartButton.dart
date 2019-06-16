import 'package:flutter/material.dart';
import '../../db/GameData.dart';

class BackToStartButton extends StatefulWidget {
  const BackToStartButton({
    @required this.onPressed,
    this.direction = Axis.vertical,
  });

  final VoidCallback onPressed;
  final Axis direction;

  @override
  _BackToStartButtonState createState() => _BackToStartButtonState();
}

class _BackToStartButtonState extends State<BackToStartButton> {
  static final GameData _gameData = GameData();
  bool _isPressed = false;

  @override
  Widget build(BuildContext build) {
    return Positioned(
      bottom: 30.0,
      right: 30.0,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onPressed,
        child: Container(
          height: 60.0,
          width: 60.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            boxShadow: [
              BoxShadow(
                color: _gameData.getColor('backToStartFABShadow'),
                offset: Offset(3.0, 3.0),
              ),
            ],
            color:
                _isPressed ? _gameData.getColor('backToStartFABPressed') : _gameData.getColor('backToStartFAB'),
          ),
          child: Center(
            child: Icon(
              widget.direction == Axis.vertical
                  ? Icons.arrow_upward
                  : Icons.arrow_back,
              color: _gameData.getColor('backToStartFABIcon'),
            ),
          ),
        ),
      ),
    );
  }
}
