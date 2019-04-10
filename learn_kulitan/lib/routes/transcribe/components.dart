import 'package:flutter/material.dart';
import '../../styles/theme.dart';

class KeyboardKey extends StatelessWidget {
  KeyboardKey({this.keyType, this.height});

  final String keyType;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(keyboardKeyPadding),
      height: height,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: KeyboardKeyContainer(
          keyType: this.keyType,
        ),
      ),
    );
  }
}

class KeyboardKeyContainer extends StatelessWidget {
  const KeyboardKeyContainer({this.keyType});

  final String keyType;

  @override
  Widget build(BuildContext context) {
    if (keyType == 'a') {
      return FittedBox(
        fit: BoxFit.contain,
        child: Text(
          keyType,
          textAlign: TextAlign.center,
          style: kulitanKeyboard.copyWith(shadows: <Shadow>[
            Shadow(color: keyboardStrokeShadowColor, offset: Offset(0.75, 0.75))
          ]),
        ),
      );
    } else if (keyType == 'clear') {
      return Padding(
        padding: const EdgeInsets.all(5.0),
        child: FittedBox(
          fit: BoxFit.contain,
          child: Text(
            'CLEAR\nALL',
            textAlign: TextAlign.center,
            style: TextStyle(
              height: 0.8,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w900,
              color: keyboardStrokeColor,
              shadows: <Shadow>[
                Shadow(
                    color: keyboardStrokeShadowColor, offset: Offset(1.8, 1.8))
              ],
            ),
          ),
        ),
      );
    } else if (keyType == 'delete' || keyType == 'enter' || keyType == 'add') {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomPaint(
          painter: _KeyIconPainter(
            keyType: this.keyType,
          ),
        ),
      );
    } else {
      return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          FittedBox(
            fit: BoxFit.fitHeight,
            child: Text(
              this.keyType,
              textAlign: TextAlign.center,
              style: kulitanKeyboard.copyWith(shadows: <Shadow>[
                Shadow(
                    color: keyboardStrokeShadowColor,
                    offset: Offset(0.75, 0.75))
              ]),
            ),
          ),
          FittedBox(
            fit: BoxFit.fitHeight,
            child: Opacity(
              opacity: 0.55,
              child: Text(
                this.keyType != 'i'
                    ? this.keyType != 'u' ? this.keyType + 'i' : 'wi'
                    : 'yi',
                textAlign: TextAlign.center,
                style: kulitanKeyboard,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.fitHeight,
            child: Opacity(
              opacity: 0.55,
              child: Text(
                this.keyType != 'i'
                    ? this.keyType != 'u' ? this.keyType + 'u' : 'wu'
                    : 'yu',
                textAlign: TextAlign.center,
                style: kulitanKeyboard,
              ),
            ),
          ),
        ],
      );
    }
  }
}

class _KeyIconPainter extends CustomPainter {
  _KeyIconPainter({this.keyType});

  final String keyType;

  @override
  bool shouldRepaint(_KeyIconPainter oldDelegate) => false;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset _shadowOffset = Offset(2.5, 2.5);
    final double _strokeWidth = 3.0;
    final double _start = _strokeWidth - (_shadowOffset.dx / 2.0);
    final double _end = size.width - _strokeWidth - (_shadowOffset.dx / 2.0);
    final double _width = _end - _start;
    final double _middle = size.height / 2.0;

    Paint _stroke = Paint()
      ..color = keyboardStrokeShadowColor
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = _strokeWidth;
    if (keyType == 'delete') {
      final double _midpoint = _start + (_width * 0.66678);
      final double _offset1 = _width * 0.33391;
      final double _offset2 = _width * 0.16713;
      final Path _outline = Path()
        ..moveTo(_start, _middle)
        ..lineTo(_start + _offset1, _middle - _offset1)
        ..lineTo(_end, _middle - _offset1)
        ..lineTo(_end, _middle + _offset1)
        ..lineTo(_start + _offset1, _middle + _offset1)
        ..lineTo(_start, _middle);
      final Path _cross1 = Path()
        ..moveTo(_midpoint - _offset2, _middle - _offset2)
        ..lineTo(_midpoint + _offset2, _middle + _offset2);
      final Path _cross2 = Path()
        ..moveTo(_midpoint - _offset2, _middle + _offset2)
        ..lineTo(_midpoint + _offset2, _middle - _offset2);
      canvas.drawPath(_outline.shift(_shadowOffset), _stroke);
      canvas.drawPath(_cross1.shift(_shadowOffset), _stroke);
      canvas.drawPath(_cross2.shift(_shadowOffset), _stroke);
      canvas.drawPath(_outline, _stroke..color = keyboardStrokeColor);
      canvas.drawPath(_cross1, _stroke..color = keyboardStrokeColor);
      canvas.drawPath(_cross2, _stroke..color = keyboardStrokeColor);
    } else if (keyType == 'enter') {
      final double _offset1 = _width * 0.26544;
      final Path _head = Path()
        ..moveTo(_start + _offset1, _middle - _offset1)
        ..lineTo(_start, _middle)
        ..lineTo(_start + _offset1, _middle + _offset1);
      final Path _body = Path()
        ..moveTo(_start, _middle)
        ..lineTo(_end, _middle)
        ..lineTo(_end, _middle - (_width * 0.29824));
      canvas.drawPath(_head.shift(_shadowOffset), _stroke);
      canvas.drawPath(_body.shift(_shadowOffset), _stroke);
      canvas.drawPath(_head, _stroke..color = keyboardStrokeColor);
      canvas.drawPath(_body, _stroke..color = keyboardStrokeColor);
    } else if (keyType == 'add') {
      final double _offset = _width * 0.33391;
      final double _center = (_start + _end) / 2.0;
      final Path _topDown = Path()
        ..moveTo(_center, _middle - _offset)
        ..lineTo(_center, _middle + _offset);
      final Path _leftRight = Path()
        ..moveTo(_center - _offset, _middle)
        ..lineTo(_center + _offset, _middle);
      canvas.drawPath(_topDown.shift(_shadowOffset), _stroke);
      canvas.drawPath(_leftRight.shift(_shadowOffset), _stroke);
      canvas.drawPath(_topDown, _stroke..color = keyboardStrokeColor);
      canvas.drawPath(_leftRight, _stroke..color = keyboardStrokeColor);
    }
  }
}
