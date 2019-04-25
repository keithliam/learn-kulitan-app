import 'package:flutter/material.dart';
import '../../styles/theme.dart';

class TextButton extends StatefulWidget {
  const TextButton({
    @required this.text,
    @required this.onPressed,
    @required this.height,
    @required this.color,
    this.width,
    this.alignment = Alignment.center,
  });

  final String text;
  final VoidCallback onPressed;
  final double height;
  final double width;
  final Color color;
  final Alignment alignment;

  @override
  _TextButtonState createState() => _TextButtonState();
}

class _TextButtonState extends State<TextButton> {
  double _opacity = 1.0;

  void _pressDown(details) => setState(() => _opacity = 0.6);

  void _cancel() => setState(() => _opacity = 1.0);

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      onTapDown: _pressDown,
      onTapUp: (_) => _cancel(),
      onTapCancel: _cancel,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48.0, minHeight: 48.0),
        child: AnimatedOpacity(
          opacity: _opacity,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 250),
          child: Container(
            alignment: widget.alignment,
            color: Colors.transparent,
            height: widget.height,
            width: widget.width,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FittedBox(
              fit: BoxFit.fitHeight,
              child: Text(widget.text, style: textHeaderButton),
            ),
          ),
        ),
      ),
    );
  }
}
