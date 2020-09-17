import 'package:flutter/material.dart';
import '../../styles/theme.dart';
import '../../db/GameData.dart';

class _RoundedBackButtonPainter extends CustomPainter {
  static final GameData _gameData = GameData();

  const _RoundedBackButtonPainter({@required this.alignment});

  final Alignment alignment;

  @override
  bool shouldRepaint(_RoundedBackButtonPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final double _strokeWidth = 5.0;
    final double _strokeOffset = _strokeWidth / 2.0;
    final double _iconWidth = size.height / 2.0;
    final double _xWidthOffset = alignment == Alignment.center ? 6.5 : 2.0;
    Paint _stroke = Paint()
      ..color = _gameData.getColor('headerNavigation')
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    if (alignment == Alignment.center) {
      final Path _outline = Path()
        ..moveTo(((size.width + _iconWidth + _xWidthOffset) / 2.0) - _strokeWidth, _strokeOffset)
        ..lineTo(((size.width - _iconWidth - _xWidthOffset) / 2.0) + _strokeWidth, _iconWidth)
        ..lineTo(((size.width + _iconWidth + _xWidthOffset) / 2.0) - _strokeWidth, size.height - _strokeOffset);
      canvas.drawPath(_outline, _stroke);
    } else {
      final Path _outline = Path()
        ..moveTo(_iconWidth - _strokeOffset + _xWidthOffset, _strokeOffset)
        ..lineTo(_strokeOffset, _iconWidth)
        ..lineTo(_iconWidth - _strokeOffset + _xWidthOffset, size.height - _strokeOffset);
      canvas.drawPath(_outline, _stroke);
    }
  }
}

class RoundedBackButton extends StatefulWidget {
  const RoundedBackButton({this.alignment = Alignment.center});

  final Alignment alignment;

  @override
  _RoundedBackButtonState createState() => _RoundedBackButtonState();
}

class _RoundedBackButtonState extends State<RoundedBackButton> {
  double _opacity = 1.0;

  void _pressDown(details) => setState(() => _opacity = 0.6);

  void _cancel() => setState(() => _opacity = 1.0);

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      onTapDown: _pressDown,
      onTapUp: (_) => _cancel(),
      onTapCancel: _cancel,
      child: SizedBox(
        width: widget.alignment == Alignment.center ? 48.0 : 80.0,
        height: 48.0,
        child: AnimatedOpacity(
          opacity: _opacity,
          curve: Curves.fastOutSlowIn,
          duration: Duration(milliseconds: 250),
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            alignment: Alignment.center,
            child: SizedBox(
              height: headerIconSize,
              width: headerIconSize,
              child: CustomPaint(painter: _RoundedBackButtonPainter(alignment: widget.alignment)),
            ),
          ),
        ),
      ),
    );
  }
}
