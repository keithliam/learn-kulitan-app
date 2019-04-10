import 'package:flutter/material.dart';
import '../../styles/theme.dart';

class _KeyboardKey extends StatefulWidget {
  _KeyboardKey({this.keyType, this.height, this.keyPressed});

  final String keyType;
  final double height;
  final Function keyPressed;

  @override
  _KeyboardKeyState createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<_KeyboardKey> {
  double _startPos = 0.0;
  double _endPos = 0.0;
  bool _isPressed = false;

  void _dragStart(DragStartDetails details) {
    _startPos = details.globalPosition.dy;
    setState(() => _isPressed = true);
  }

  void _dragUpdate(DragUpdateDetails details) =>
      _endPos = details.globalPosition.dy;
  void _dragEnd(DragEndDetails details) {
    setState(() => _isPressed = false);
    if (_startPos - (keyboardKeyMiddleZoneHeight / 2.0) <= _endPos &&
        _endPos <= _startPos + (keyboardKeyMiddleZoneHeight / 2.0)) {
      widget.keyPressed(widget.keyType);
    } else if (_startPos > _endPos) {
      if (widget.keyType == 'i')
        widget.keyPressed('yi');
      else if (widget.keyType == 'u')
        widget.keyPressed('wi');
      else
        widget.keyPressed(widget.keyType + 'i');
    } else {
      if (widget.keyType == 'i')
        widget.keyPressed('yu');
      else if (widget.keyType == 'u')
        widget.keyPressed('wu');
      else
        widget.keyPressed(widget.keyType + 'u');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Stack _mainWidget = Stack(
      fit: StackFit.expand,
      children: <Widget>[
        AnimatedOpacity(
          opacity: _isPressed ? keyboardPressOpacity : 0.0,
          duration: const Duration(milliseconds: keyboardPressOpacityDuration),
          curve: keyboardPressOpacityCurve,
          child: Container(color: keyboardPressColor),
        ),
        Container(
          padding: const EdgeInsets.all(keyboardKeyPadding),
          height: widget.height,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: _KeyboardKeyContainer(keyType: this.widget.keyType),
          ),
        ),
      ],
    );

    if (widget.keyType == 'a' ||
        widget.keyType == 'add' ||
        widget.keyType == 'clear' ||
        widget.keyType == 'delete' ||
        widget.keyType == 'enter') {
      return SizedBox(
        height: widget.height,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) => setState(() => _isPressed = false),
          onTapCancel: () => setState(() => _isPressed = false),
          onTap: () => widget.keyPressed(widget.keyType),
          child: _mainWidget,
        ),
      );
    } else {
      return SizedBox(
        height: widget.height,
        child: GestureDetector(
          onVerticalDragStart: _dragStart,
          onVerticalDragUpdate: _dragUpdate,
          onVerticalDragEnd: _dragEnd,
          child: _mainWidget,
        ),
      );
    }
  }
}

class _KeyboardKeyContainer extends StatelessWidget {
  const _KeyboardKeyContainer({this.keyType});

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

class KulitanKeyboard extends StatelessWidget {
  KulitanKeyboard({this.keyHeight});

  final double keyHeight;

  void _keyPressed(String key) {
    print(key);
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultColumnWidth: FlexColumnWidth(1.0),
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            _KeyboardKey(
              height: keyHeight,
              keyType: 'g',
              keyPressed: _keyPressed,
            ),
            _KeyboardKey(
              height: keyHeight,
              keyType: 'k',
              keyPressed: _keyPressed,
            ),
            _KeyboardKey(
              height: keyHeight,
              keyType: 'ng',
              keyPressed: _keyPressed,
            ),
            _KeyboardKey(
              height: keyHeight,
              keyType: 'a',
              keyPressed: _keyPressed,
            ),
            _KeyboardKey(
              height: keyHeight,
              keyType: 'clear',
              keyPressed: _keyPressed,
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            _KeyboardKey(
              height: keyHeight,
              keyType: 't',
              keyPressed: _keyPressed,
            ),
            _KeyboardKey(
              height: keyHeight,
              keyType: 'd',
              keyPressed: _keyPressed,
            ),
            _KeyboardKey(
              height: keyHeight,
              keyType: 'n',
              keyPressed: _keyPressed,
            ),
            _KeyboardKey(
              height: keyHeight,
              keyType: 'i',
              keyPressed: _keyPressed,
            ),
            Container(),
          ],
        ),
        TableRow(
          children: <Widget>[
            _KeyboardKey(
              height: keyHeight,
              keyType: 'l',
              keyPressed: _keyPressed,
            ),
            _KeyboardKey(
              height: keyHeight,
              keyType: 's',
              keyPressed: _keyPressed,
            ),
            _KeyboardKey(
              height: keyHeight,
              keyType: 'm',
              keyPressed: _keyPressed,
            ),
            _KeyboardKey(
              height: keyHeight,
              keyType: 'u',
              keyPressed: _keyPressed,
            ),
            _KeyboardKey(
              height: keyHeight,
              keyType: 'delete',
              keyPressed: _keyPressed,
            ),
          ],
        ),
        TableRow(
          children: <Widget>[
            _KeyboardKey(
              height: keyHeight,
              keyType: 'p',
              keyPressed: _keyPressed,
            ),
            _KeyboardKey(
              height: keyHeight,
              keyType: 'b',
              keyPressed: _keyPressed,
            ),
            Container(),
            _KeyboardKey(
              height: keyHeight,
              keyType: 'add',
              keyPressed: _keyPressed,
            ),
            _KeyboardKey(
              height: keyHeight,
              keyType: 'enter',
              keyPressed: _keyPressed,
            ),
          ],
        ),
      ],
    );
  }
}
