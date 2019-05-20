import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'dart:math' show pow, sqrt;
import '../../components/misc/CustomCard.dart';
import '../../components/misc/LinearProgressBar.dart';
import '../../styles/theme.dart';

class _ShadowPainter extends CustomPainter {
  const _ShadowPainter({
    this.paths,
  });

  final List<Path> paths;

  @override
  bool shouldRepaint(_ShadowPainter oldDelegate) {
    if(oldDelegate.paths != this.paths) return true;
    else return false;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    if(this.paths.length > 0) {
      Paint _shadowPaint = Paint()
        ..color = writingShadowColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = writingDrawPointIdleWidth;
      for(Path _path in this.paths)
        canvas.drawPath(_path, _shadowPaint);
    }
  }
}

class _CurrPathPainter extends CustomPainter {
  const _CurrPathPainter({
    this.paths,
  });

  final List<Path> paths;

  @override
  bool shouldRepaint(_CurrPathPainter oldDelegate) {
    if(oldDelegate.paths != this.paths) return true;
    else return false;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    if(this.paths.length > 0) {
      Paint _pathPaint = Paint()
        ..color = writingDrawColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = writingDrawPointIdleWidth;
      for(Path _path in this.paths)
        canvas.drawPath(_path, _pathPaint);
    }
  }
}

class _CurrPointPainter extends CustomPainter {
  const _CurrPointPainter({
    this.point,
    this.pointSize,
  });

  final Offset point;
  final double pointSize;

  @override
  bool shouldRepaint(_CurrPointPainter oldDelegate) {
    if(oldDelegate.point != this.point || oldDelegate.pointSize != this.pointSize) return true;
    else return false;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    if(this.point != null) {
      Paint _strokeStartPaint = Paint()
        ..color = writingGuideColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.fill;
      canvas.drawCircle(this.point, this.pointSize, _strokeStartPaint);
    }
  }
}

class _KulitanPainter extends CustomPainter {
  const _KulitanPainter({
    this.path,
  });

  final Path path;

  @override
  bool shouldRepaint(_KulitanPainter oldDelegate) {
    if(oldDelegate.path != this.path) return true;
    else return false;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    if(this.path != null) {
      Paint _strokePaint = Paint()
        ..color = writingDrawColor
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = writingDrawPointIdleWidth;
      canvas.drawPath(this.path, _strokePaint);
    }
  }
}

class _GuideLinePainter extends CustomPainter {
  const _GuideLinePainter({
    this.path,
    this.getCubicBezier
  });

  final List<Offset> path;
  final dynamic getCubicBezier;

  @override
  bool shouldRepaint(_GuideLinePainter oldDelegate) {
    if(oldDelegate.path != this.path) return true;
    else return false;
  }
  
  @override
  void paint(Canvas canvas, Size size) {
    if(this.path.length > 0) {
      Paint _strokePaint = Paint()
        ..color = writingGuideColor
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke
        ..strokeWidth = writingGuideLineStrokeWidth * size.width;

      Offset _getChangeFromSlopeDist(double d, double m) {
        final double _dx = d / sqrt(1 + pow(m, 2));
        return Offset(_dx, m * _dx);
      }

      List<Offset> _points = [];
      Offset Function(double) _equation;
      double _currT = 0.0;
      double _limit;
      double _mod;
      final double _step = 0.01;
      for(int i = 1; i < path.length; i += 3) {
        _equation = getCubicBezier(path[i - 1].dx, path[i - 1].dy, path[i].dx, path[i].dy, path[i + 1].dx, path[i + 1].dy, path[i + 2].dx, path[i + 2].dy);
        _limit = (i ~/ 3) + 1.0;
        for(double j = _currT + _step; j < _limit; j += _step) {
          _mod = j % 1.0;
          _points.add(_equation(_mod == 0.0? j / 1.0 : _mod));
          _currT = j;
        }
      }
      double _dashLength = 0.02 * size.width;
      double _gapLength = 0.0375 * size.width;
      int _currPoint;
      int _nextPoint = 1;
      final _lastPoint = _points.length - 1;
      Offset _tempPoint;
      for(_currPoint = _nextPoint - 1; _nextPoint < _points.length; _currPoint = _nextPoint - 1) {
        for(; _nextPoint < _points.length; _nextPoint++) {
          if(_dashLength < getPointsDist(_points[_currPoint], _points[_nextPoint]) || _nextPoint == _lastPoint) {
            _tempPoint = _nextPoint == _lastPoint? _points[_lastPoint] : _points[_nextPoint];
            canvas.drawLine(_points[_currPoint], _tempPoint, _strokePaint);
            _currPoint = _nextPoint;
            while(++_nextPoint < _points.length)
              if(_gapLength < getPointsDist(_points[_currPoint], _points[_nextPoint]))
                break;
            break;
          }
        }
      }
      final Offset _lastOffset = _points[_lastPoint];
      final Offset _lastLastOffset = _points[_lastPoint - 1];
      final double _slope = (_lastOffset.dy - _lastLastOffset.dy) / (_lastOffset.dx - _lastLastOffset.dx);
      final _arrowWidth = (size.width * 0.0375);
      final _arrowHeight = (size.width * 0.03576);
      if(_slope == 0) {
        canvas.drawPath(
          Path()
            ..moveTo(_lastOffset.dx, _lastOffset.dy - _arrowHeight)
            ..lineTo(_lastOffset.dx + (_lastOffset.dx > _lastLastOffset.dx? _arrowWidth : -_arrowWidth), _lastOffset.dy)
            ..lineTo(_lastOffset.dx, _lastOffset.dy + _arrowHeight),
          _strokePaint,
        );
      } else if(_slope.isInfinite) {
        canvas.drawPath(
          Path()
            ..moveTo(_lastOffset.dx - _arrowWidth, _lastOffset.dy)
            ..lineTo(_lastOffset.dx, _lastOffset.dy + (_lastOffset.dy < _lastLastOffset.dy? -_arrowHeight : _arrowHeight))
            ..lineTo(_lastOffset.dx + _arrowWidth, _lastOffset.dy),
          _strokePaint,
        );
      } else {
        final Offset _heightChange = _getChangeFromSlopeDist(_arrowHeight, _slope);
        final Offset _widthChange = _getChangeFromSlopeDist(_arrowWidth, -1 / _slope /* perpendicular slope */);
        final Offset _left = Offset(_lastOffset.dx - _widthChange.dx, _lastOffset.dy - _widthChange.dy);
        final Offset _right = Offset(_lastOffset.dx + _widthChange.dx, _lastOffset.dy + _widthChange.dy);
        Offset _middle = _lastOffset.dx > _lastLastOffset.dx? Offset(_lastOffset.dx + _heightChange.dx, _lastOffset.dy + _heightChange.dy) : Offset(_lastOffset.dx - _heightChange.dx, _lastOffset.dy - _heightChange.dy);
        canvas.drawPath(
          Path()..moveTo(_left.dx, _left.dy)..lineTo(_middle.dx, _middle.dy)..lineTo(_right.dx, _right.dy),
          _strokePaint,
        );
      }
    }
  }
}

class _GuideLabelPainter extends CustomPainter {
  const _GuideLabelPainter({
    this.offset,
  });

  final Offset offset;

  @override
  bool shouldRepaint(_GuideLabelPainter oldDelegate) => false; // TODO: check
  
  @override
  void paint(Canvas canvas, Size size) {
    Paint _strokePaint = Paint()
      ..color = writingGuideColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = writingGuideCircleStrokeWidth * size.width;
    canvas.drawCircle(Offset(offset.dx * size.width, offset.dy * size.width), writingGuideCircleRadius * size.width, _strokePaint);
  }
}

class _AnimatedWritingCard extends StatefulWidget {
  const _AnimatedWritingCard({
    @required this.kulitan,
    @required this.progress,
    @required this.stackNumber,
    @required this.writingDone,
  });

  final String kulitan;
  final double progress;
  final int stackNumber;
  final VoidCallback writingDone;

  @override
  _AnimatedWritingCardState createState() => _AnimatedWritingCardState();
}

double getPointsDist(Offset p1, Offset p2) => sqrt(pow(p2.dx - p1.dx, 2) + pow(p2.dy - p1.dy, 2));  

class _AnimatedWritingCardState extends State<_AnimatedWritingCard> with SingleTickerProviderStateMixin {
  Offset _currPoint;
  Path _drawPath;
  List<Path> _prevDrawPaths = [];
  int _currPathNo = 0;
  int _currSubPathNo = 0;
  double _currBezierT = 0.0;
  List<Path> _shadowPaths = [];
  GlobalKey _canvasKey = GlobalKey();
  double _canvasWidth = 50.0;
  final double _stepLength = 0.01;
  bool _hitTarget = false;
  Offset Function(double) _cubicBezier;
  Map<String, Offset> Function(double) _splitCubicBezier;
  bool _disableTouch = true;
  bool _animateShadowAndProgress = true;

  AnimationController _pointController;
  CurvedAnimation _pointCurve;
  Tween<double> _pointTween;
  Animation<double> _pointAnimation;
  Curve _touchPointOpacityCurve = drawTouchPointOpacityUpCurve;
  Duration _touchPointOpacityDuration = const Duration(milliseconds: writingInitOpacityDuration);
  double _touchPointOpacity = 0.0;
  double _shadowOffset = 0.0;
  Curve _guideOpacityCurve = drawGuidesOpacityUpCurve;
  Duration _guideOpacityDuration = const Duration(milliseconds: writingInitOpacityDuration);
  double _guideOpacity = 0.0;

  Offset Function(double) _getCubicBezier(double x0, double y0, double x1, double y1, double x2, double y2, double x3, double y3) {
    x0 *= _canvasWidth;
    y0 *= _canvasWidth;
    x1 *= _canvasWidth;
    y1 *= _canvasWidth;
    x2 *= _canvasWidth;
    y2 *= _canvasWidth;
    x3 *= _canvasWidth;
    y3 *= _canvasWidth;
    return (double t) {
      double _getPoint(double z0, double z1, double z2, double z3) => (pow(1 - t, 3) * z0) + (3 * t * pow(1 - t, 2) * z1) + (3 * pow(t, 2) * (1 - t) * z2) + (pow(t, 3) * z3);
      return Offset(_getPoint(x0, x1, x2, x3), _getPoint(y0, y1, y2, y3));
    };
  }

  Map<String, Offset> Function(double) _getSplitCubicBezier(double x0, double y0, double x1, double y1, double x2, double y2, double x3, double y3) {
    x0 *= _canvasWidth;
    y0 *= _canvasWidth;
    x1 *= _canvasWidth;
    y1 *= _canvasWidth;
    x2 *= _canvasWidth;
    y2 *= _canvasWidth;
    x3 *= _canvasWidth;
    y3 *= _canvasWidth;
    return (double t) {
      double _interp(double num1, double num2) => ((num1 - num2) * t) + num2;
      final double _x01 = _interp(x1, x0);
      final double _y01 = _interp(y1, y0);
      final double _x12 = _interp(x2, x1);
      final double _y12 = _interp(y2, y1);
      final double _x23 = _interp(x3, x2);
      final double _y23 = _interp(y3, y2);
      final double _x012 = _interp(_x12, _x01);
      final double _y012 = _interp(_y12, _y01);
      final double _x123 = _interp(_x23, _x12);
      final double _y123 = _interp(_y23, _y12);
      final double _x0123 = _interp(_x123, _x012);
      final double _y0123 = _interp(_y123, _y012);
      return {
        'p0': Offset(x0, y0),
        'a0': Offset(x1, y1),
        'a1': Offset(_x012, _y012),
        'p1': Offset(_x0123, _y0123),
      };
    };
  }

  void _cardTouched(BuildContext context, Offset offset) {
    if(!_disableTouch) {
      final RenderBox _box = context.findRenderObject();
      final Offset _localOffset = _box.globalToLocal(offset);
      final Offset _touchLoc = Offset(_localOffset.dx, _localOffset.dy - 20.0);
      if(_isWithinTouchArea(_touchLoc)){
        _animateTouchPoint();
        _hitTarget = true;
      }
    }
  }

  void _cardTouchEnded() {
    if(!_disableTouch) {
      if(_hitTarget) {
        _animateTouchPoint(isScaleUp: false);
        _hitTarget = false;
      }
      if(_currBezierT == 1.0)
        getNextPath();
    }
  }

  bool _isWithinTouchArea(Offset p1) => writingCardTouchRadius >= getPointsDist(_currPoint, p1);

  Future<Map<String, double>> _getNearestPointInCurve(Offset p1) async {  // optimize algorithm using sorting
    double _shortestDistance = double.infinity;
    double _shortestPoint;
    bool _evalDist(double i) {
      final double _dist = getPointsDist(_cubicBezier(i), p1);
      if(_dist == _shortestDistance) {
        return false;
      } else {
        if(_dist < _shortestDistance) {
          _shortestDistance = _dist;
          _shortestPoint = i;
        }
        return true;
      }
    }
    for(double i = 0.0; i < 1.0; i += _stepLength)
      if(_evalDist(i) == false)
        return null;
    if(_evalDist(1) == false)
        return null;
    else
      return {
        'point': _shortestPoint,
        'distance': _shortestDistance,
      };
  }

  Offset _adjustAnchor0(Offset p0, Offset a0, double pathRatio) {
    final double _newDist = (getPointsDist(p0, a0) * pathRatio);
    final double _slope = (a0.dy - p0.dy) / (a0.dx - p0.dx);
    if(_slope == 0) {
      return Offset(p0.dx + (a0.dx < p0.dx? -_newDist :_newDist), p0.dy);
    } else if(_slope.isInfinite) {
      return Offset(p0.dx, p0.dy + (a0.dy < p0.dy? -_newDist : _newDist));
    } else {
      final double _dx = (_newDist / sqrt(1 + pow(_slope, 2))).abs() * (a0.dx < p0.dx? -1 : 1);
      final double _dy = (_slope * _dx).abs() * (a0.dy < p0.dy? -1 : 1);
      return Offset(p0.dx + _dx, p0.dy + _dy);
    }
  }

  bool _hasNextSubStroke() => _currSubPathNo + 6 < kulitanPaths[widget.kulitan][_currPathNo].length;

  void getNextPath() async {
    final List<List<double>> _tempGlyph = kulitanPaths[widget.kulitan];
    // Next subpath in stroke
    if(_hasNextSubStroke()) {
      final List<double> _tempPath = _tempGlyph[_currPathNo];
      final int _prevSubPathNo = _currSubPathNo;
      _currSubPathNo += 6;
      _prevDrawPaths.add(Path()..moveTo(_tempPath[_prevSubPathNo - 2] * _canvasWidth, _tempPath[_prevSubPathNo - 1] * _canvasWidth)..cubicTo(_tempPath[_prevSubPathNo] * _canvasWidth, _tempPath[_prevSubPathNo + 1] * _canvasWidth, _tempPath[_prevSubPathNo + 2] * _canvasWidth, _tempPath[_prevSubPathNo + 3] * _canvasWidth, _tempPath[_prevSubPathNo + 4] * _canvasWidth, _tempPath[_prevSubPathNo + 5] * _canvasWidth));
      _currPoint = Offset(_tempPath[_currSubPathNo - 2] * _canvasWidth, _tempPath[_currSubPathNo - 1] * _canvasWidth);
      _currBezierT = 0.0;
      _cubicBezier = _getCubicBezier(_tempPath[_currSubPathNo - 2], _tempPath[_currSubPathNo - 1], _tempPath[_currSubPathNo], _tempPath[_currSubPathNo + 1], _tempPath[_currSubPathNo + 2], _tempPath[_currSubPathNo + 3], _tempPath[_currSubPathNo + 4], _tempPath[_currSubPathNo + 5]);
      _splitCubicBezier = _getSplitCubicBezier(_tempPath[_currSubPathNo - 2], _tempPath[_currSubPathNo - 1], _tempPath[_currSubPathNo], _tempPath[_currSubPathNo + 1], _tempPath[_currSubPathNo + 2], _tempPath[_currSubPathNo + 3], _tempPath[_currSubPathNo + 4], _tempPath[_currSubPathNo + 5]);
    // Next stroke
    } else if(_currPathNo + 1 < _tempGlyph.length) {
      _disableTouch = true;
      await Future.delayed(const Duration(milliseconds: nextDrawPathDelay));
      _touchPointOpacityCurve = drawTouchPointOpacityDownCurve;
      _guideOpacityCurve = drawGuidesOpacityDownCurve;
      setState(() {
        _touchPointOpacity = 0.0;
        _guideOpacity = 0.0;
      });
      await Future.delayed(const Duration(milliseconds: drawGuidesOpacityChangeDuration * 2));
      final List<double> _prevPath = _tempGlyph[_currPathNo];
      final List<double> _tempPath = _tempGlyph[_currPathNo + 1];
      final int _prevSubPathNo = _currSubPathNo;
      _currSubPathNo = 2;
      _cubicBezier = _getCubicBezier(_tempPath[0], _tempPath[1], _tempPath[2], _tempPath[3], _tempPath[4], _tempPath[5], _tempPath[6], _tempPath[7]); 
      _splitCubicBezier = _getSplitCubicBezier(_tempPath[0], _tempPath[1], _tempPath[2], _tempPath[3], _tempPath[4], _tempPath[5], _tempPath[6], _tempPath[7]); 
      _prevDrawPaths.add(Path()..moveTo(_prevPath[_prevSubPathNo - 2] * _canvasWidth, _prevPath[_prevSubPathNo - 1] * _canvasWidth)..cubicTo(_prevPath[_prevSubPathNo] * _canvasWidth, _prevPath[_prevSubPathNo + 1] * _canvasWidth, _prevPath[_prevSubPathNo + 2] * _canvasWidth, _prevPath[_prevSubPathNo + 3] * _canvasWidth, _prevPath[_prevSubPathNo + 4] * _canvasWidth, _prevPath[_prevSubPathNo + 5] * _canvasWidth));
      _currPoint = Offset(_tempPath[0] * _canvasWidth, _tempPath[1] * _canvasWidth);
      _currBezierT = 0.0;
      _currPathNo++;
      _touchPointOpacityCurve = drawTouchPointOpacityUpCurve;
      _guideOpacityCurve = drawGuidesOpacityUpCurve;
      setState(() {
        _touchPointOpacity = 1.0;
        _guideOpacity = 1.0;
      });
      await Future.delayed(const Duration(milliseconds: drawGuidesOpacityChangeDuration));
      _disableTouch = false;
    // Finished writing
    } else {
      _disableTouch = true;
      await Future.delayed(const Duration(milliseconds: drawGuidesOpacityChangeDelay));
      _guideOpacityCurve = drawGuidesOpacityDownCurve;
      _touchPointOpacityCurve = drawTouchPointOpacityDownCurve;
      setState(() {
        _guideOpacity = 0.0;
        _touchPointOpacity = 0.0;
      });
      await Future.delayed(const Duration(milliseconds: drawGuidesOpacityChangeDuration));
      widget.writingDone();
      setState((){
        _shadowOffset = 0.03 * _canvasWidth;
      });
    }
  }

  @override
  void didUpdateWidget(_AnimatedWritingCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(oldWidget.kulitan != widget.kulitan) {
      if(oldWidget.kulitan.length > 0) {
        _animateShadowAndProgress = false;
        _currPathNo = 0;
        _currSubPathNo = 0;
        _currBezierT = 0.0;
        _shadowOffset = 0.0;
        _prevDrawPaths = [];
        _drawPath = null;
        _getPaths();
      } else {
        _getPaths(first: true);
      }
    }
  }

  void _updateTouchOffset(BuildContext context, Offset offset) async {
    if(_hitTarget && !_disableTouch) {
      final RenderBox _box = context.findRenderObject();
      final Offset _localOffset = _box.globalToLocal(offset);
      final Offset _touchLoc = Offset(_localOffset.dx, _localOffset.dy - 20.0);
      Map<String, double> _touchDetails = await _getNearestPointInCurve(_touchLoc);
      if(_touchDetails != null) {
        if(_isWithinTouchArea(_cubicBezier(_touchDetails['point'])) && _touchDetails['distance'] < writingCardTouchRadius && _touchDetails['point'] - _currBezierT < 0.5) {
          if(_touchDetails['point'] >= _currBezierT) {
            final Map<String, Offset> _points = _splitCubicBezier(_touchDetails['point']);
            final _anchor0 = _adjustAnchor0(_points['p0'], _points['a0'], _touchDetails['point']);
            _currBezierT = _touchDetails['point'];
            setState(() {
              _drawPath = Path()..moveTo(_points['p0'].dx, _points['p0'].dy)..cubicTo(_anchor0.dx, _anchor0.dy, _points['a1'].dx, _points['a1'].dy, _points['p1'].dx, _points['p1'].dy);
              _currPoint = _points['p1'];
            });
            if(_currBezierT == 1.0 && _hasNextSubStroke())
              getNextPath();
          }
        } else {
          _animateTouchPoint(isScaleUp: false);
          _hitTarget = false;
        }
      }
    }
  }

  void _getWidth() {
    final RenderBox _canvasBox = _canvasKey.currentContext.findRenderObject();
    final double _width = _canvasBox.size.width;
    setState(() => _canvasWidth = _width);
  }

  void _showPaths() async {
    await Future.delayed(const Duration(milliseconds: writingInitDelay));
    _disableTouch = false;
    _guideOpacityDuration = const Duration(milliseconds: writingInitOpacityDuration);
    _touchPointOpacityDuration = const Duration(milliseconds: writingInitOpacityDuration);
    setState(() {
      _touchPointOpacity = 1.0;
      _guideOpacity = 1.0;
    });
    await Future.delayed(const Duration(milliseconds: writingInitOpacityDuration));
    _guideOpacityDuration = const Duration(milliseconds: drawGuidesOpacityChangeDuration);
    _touchPointOpacityDuration = const Duration(milliseconds: drawGuidesOpacityChangeDuration);
  }

  void _getPaths({ first: false }) async {
    List<Path> _manyPaths = [];
    List<List<double>> _thisKulitanPaths = kulitanPaths[widget.kulitan];
    for(List<double> _path in _thisKulitanPaths) {
      for(int i = 2; i < _path.length; i += 6)
        _manyPaths.add(Path()..moveTo(_path[i - 2] * _canvasWidth, _path[i - 1] * _canvasWidth)..cubicTo(_path[i] * _canvasWidth, _path[i + 1] * _canvasWidth, _path[i + 2] * _canvasWidth, _path[i + 3] * _canvasWidth, _path[i + 4] * _canvasWidth, _path[i + 5] * _canvasWidth));
    }

    List<double> _path = kulitanPaths[widget.kulitan][0];
    _currPoint = Offset(_path[0] * _canvasWidth, _path[1] * _canvasWidth);
    _path = _thisKulitanPaths[0];
    _currSubPathNo = 2;
    _cubicBezier = _getCubicBezier(_path[0], _path[1], _path[2], _path[3], _path[4], _path[5], _path[6], _path[7]);
    _splitCubicBezier = _getSplitCubicBezier(_path[0], _path[1], _path[2], _path[3], _path[4], _path[5], _path[6], _path[7]);
    _shadowPaths = _manyPaths;
    if(first) {
      _guideOpacityDuration = const Duration(milliseconds: writingInitOpacityDuration);
      _touchPointOpacityDuration = const Duration(milliseconds: writingInitOpacityDuration);
      await Future.delayed(const Duration(milliseconds:  writingInitDelay));
    }
    if(widget.stackNumber == 1) _showPaths();
    await Future.delayed(const Duration(milliseconds: drawShadowOffsetChangeDuration));
    setState(() => _animateShadowAndProgress = true);
  }

  void _animateTouchPoint({ bool isScaleUp: true }) {
    if(isScaleUp) {
      _pointCurve.curve = drawTouchPointScaleUpCurve;
      _pointController.forward();
    } else {
      _pointCurve.curve = drawTouchPointScaleDownCurve;
      _pointController.reverse();
    }
  }

  @override
  void initState() {
    super.initState();
    _pointController = AnimationController(duration: Duration(milliseconds: drawTouchPointScaleDuration), vsync: this);
    _pointCurve = CurvedAnimation(parent: _pointController, curve:drawTouchPointScaleUpCurve);
    _pointTween = Tween<double>(begin: writingDrawPointIdleWidth / 2, end: writingDrawPointTouchWidth / 2);
    _pointAnimation = _pointTween.animate(_pointCurve)
      ..addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getWidth();
      _animateShadowAndProgress = false;
      _currPathNo = 0;
      _currSubPathNo = 0;
      _currBezierT = 0.0;
      _shadowOffset = 0.0;
      _prevDrawPaths = [];
      _drawPath = null;
      _getPaths();
    });
  }

  @override
  void dispose() {
    _pointController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double _labelSize = ((writingGuideCircleRadius * 2) - 0.01) * _canvasWidth;

    return CustomCard(
      padding: const EdgeInsets.only(bottom: cardWritingVerticalPadding),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: AspectRatio(
              aspectRatio: 0.9248554913,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  AnimatedPositioned(
                    top: _shadowOffset,
                    left: _shadowOffset,
                    curve: drawShadowOffsetChangeCurve,
                    duration: Duration(milliseconds: _animateShadowAndProgress? drawShadowOffsetChangeDuration : 0),
                    child: CustomPaint(
                      painter: _ShadowPainter(
                        paths: _shadowPaths,
                      ),
                    ),
                  ),
                  CustomPaint(
                    key: _canvasKey,
                    painter: _CurrPathPainter(
                      paths: _prevDrawPaths,
                    ),
                  ),
                  AnimatedOpacity(
                    curve: _guideOpacityCurve,
                    opacity: _guideOpacity,
                    duration: _guideOpacityDuration,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        CustomPaint(
                          painter: _GuideLinePainter(
                            path: widget.kulitan.length > 0? kulitanGuides[widget.kulitan][_currPathNo]['path'] : [],
                            getCubicBezier: _getCubicBezier,
                          ),
                        ),
                        CustomPaint(
                          painter: _GuideLabelPainter(
                            offset: widget.kulitan.length > 0? kulitanGuides[widget.kulitan][_currPathNo]['labelOffset'] : Offset(0.0, 0.0),
                          ),
                        ),
                        Positioned(
                          top: widget.kulitan.length > 0? (kulitanGuides[widget.kulitan][_currPathNo]['labelOffset'].dy * _canvasWidth) - (_labelSize / 2) : 0.0,
                          left: widget.kulitan.length > 0? (kulitanGuides[widget.kulitan][_currPathNo]['labelOffset'].dx * _canvasWidth) - (_labelSize / 2) : 0.0,
                          child: Container(
                            height: _labelSize,
                            width: _labelSize,
                            child: Center(
                              child: AutoSizeText(
                                '${_currPathNo + 1}',
                                style: textWritingGuide,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomPaint(
                    painter: _KulitanPainter(
                      path: _drawPath,
                    ),
                  ),
                  AnimatedOpacity(
                    curve: _touchPointOpacityCurve,
                    opacity: _touchPointOpacity,
                    duration: _touchPointOpacityDuration,
                    child: CustomPaint(
                      painter:  _CurrPointPainter(
                        point: _currPoint,
                        pointSize: _pointAnimation.value,
                      ),
                      child: GestureDetector(
                        onPanDown: (DragDownDetails details) => _cardTouched(context, details.globalPosition),
                        onPanEnd: (_) => _cardTouchEnded(),
                        onPanCancel: () => _cardTouchEnded(),
                        onPanStart: (DragStartDetails details) => _updateTouchOffset(context, details.globalPosition),
                        onPanUpdate: (DragUpdateDetails details) => _updateTouchOffset(context, details.globalPosition),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: cardWritingHorizontalPadding,
              right: cardWritingHorizontalPadding,
            ),
            child: LinearProgressBar(
              animate: _animateShadowAndProgress,
              progress: widget.progress,
            ),
          ),
        ],
      ),
    );
  }
}

class WritingCard extends StatelessWidget {
  const WritingCard({
    @required this.displayText,
    @required this.kulitan,
    @required this.progress,
    @required this.stackNumber,
    @required this.writingDone,
  });
  
  final String displayText;
  final String kulitan;
  final double progress;
  final int stackNumber;
  final VoidCallback writingDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(writingHorizontalScreenPadding, 0.0, writingHorizontalScreenPadding, writingVerticalScreenPadding),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: quizHorizontalScreenPadding,
                vertical: 15.0,
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: _AnimatedText(
                    text: displayText,
                  ),
                ),
              ),
            ),
          ),
          _AnimatedWritingCard(
            kulitan: kulitan,
            progress: progress,
            stackNumber: stackNumber,
            writingDone: writingDone,
          ),
        ],
      ),
    );
  }
}

class _AnimatedText extends StatefulWidget {
  const _AnimatedText({ @required this.text });

  final String text;

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<_AnimatedText> {
  double _opacity = 0.0;

  void _incOpacity() async {
    await Future.delayed(const Duration(milliseconds: writingTextOpacityChangeDelay));
    setState(() => _opacity = 1.0);
  }
  
  @override
  void initState() {
    super.initState();
    _incOpacity();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      curve: writingTextOpacityChangeCurve,
      duration: const Duration(milliseconds: writingInitOpacityDuration),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          widget.text.isNotEmpty? widget.text : ' ',
          style: textWriting,
        ),
      ),
    );
  }
}

class Tutorial extends StatefulWidget {
  const Tutorial({@required this.onTap});

  final VoidCallback onTap;

  @override
  _TutorialState createState() => _TutorialState();
}

class _TutorialState extends State<Tutorial> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  OverlayEntry _overlay;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _showOverlay());
  }

  void _showOverlay() async {
    if (_overlay == null) {
      await Future.delayed(const Duration(milliseconds: tutorialOverlayDelay));
      _overlay = _createOverlay();
      Overlay.of(context).insert(_overlay);
      _controller.forward();
    }
  }

  void _dismissOverlay(_) async {
    _controller.reverse();
    await Future.delayed(const Duration(milliseconds: 500));
    widget.onTap();
    _overlay?.remove();
    _overlay = null;
  }

  Widget _flare({bottom, left, height, right}) {
    final Widget _flare = FlareActor(
      'assets/flares/shaking_pointer.flr',
      color: accentColor,
      animation: 'shake',
    );

    return Positioned(
      bottom: bottom,
      left: left,
      height: height,
      right: right,
      child: IgnorePointer(
        child: Transform(
          transform: Matrix4.identity()..scale(1.0,  -1.0, 1.0),
          alignment: FractionalOffset.center,
          child: _flare,
        ),
      ),
    );
  }

  Widget _text({bottom, left, right}) {
    return Positioned(
      bottom: bottom,
      left: left,
      right: right,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: tutorialsBackgroundColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          child: IgnorePointer(
            child: Material(
              color: Colors.transparent,
              child: Text('Trace the glyph by following the guide lines and stroke orders.', style: textTutorialOverlay),
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder: (context) {
        final Size _dimensions = MediaQuery.of(context).size;
        final double _relWidth = _dimensions.width / 414.0;
        final List<Widget> _elements = [
          _flare(
            bottom: 370.0 * _relWidth,
            left: 0.0,
            right: 200.0 * _relWidth,
            height: 100.0 * _relWidth,
          ),
          _text(
            bottom: 480.0 * _relWidth,
            left: 50.0,
            right: 50.0,
          )
        ];

        return Positioned.fill(
          child: GestureDetector(
            onTapDown: _dismissOverlay,
            behavior: HitTestBehavior.translucent,
            child: FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                parent: _controller,
                curve: Curves.easeInOut,
              )),
              child: Stack(children: _elements),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _overlay?.remove();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}