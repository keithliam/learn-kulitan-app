import 'package:flutter/material.dart';
import 'package:flare_dart/math/mat2d.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controller.dart';
import '../../styles/theme.dart';
import '../../db/GameData.dart';

class Loader extends StatefulWidget {
  const Loader({
    @required this.isVisible,
    @required this.child,
    this.isStartup = false,
    this.onFinish,
  });

  final bool isStartup;
  final bool isVisible;
  final Widget child;
  final VoidCallback onFinish;

  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> with FlareController {
  static final _gameData = GameData();
  OverlayEntry _overlay;
  bool _toRemove = false;
  double _animationTime = 0.0;

  @override
  void initState() {
    super.initState();
    _overlay = _createLoader();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Overlay.of(context).insert(_overlay),
    );
  }

  @override
  void didUpdateWidget(Loader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.isVisible && widget.isVisible && _overlay == null) {
      _overlay = _createLoader();
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => Overlay.of(context).insert(_overlay),
      );
    } else if (oldWidget.isVisible && !widget.isVisible && _overlay != null) {
      _toRemove = true;
    }
  }

  @override
  void initialize(FlutterActorArtboard artboard) {}

  @override
  void setViewTransform(Mat2D viewTransform) {}

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    _animationTime += elapsed / 2;
    if (_animationTime >= 3.5167 && _toRemove) {
      _overlay?.remove();
      setState(() {
        _overlay = null;
        _animationTime = 0.0;
        _toRemove = false;
      });
      if (widget.onFinish != null) widget.onFinish();
    }
    return true;
  }

  OverlayEntry _createLoader() {
    return OverlayEntry(
      builder: (context) {
        return Align(
          alignment: Alignment.center,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: const EdgeInsets.only(top: 5.0, left: 5.0),
                  constraints: BoxConstraints(minWidth: 175.0),
                  width: MediaQuery.of(context).size.width * loaderWidthPercent,
                  child: FlareActor(
                    'assets/flares/loader.flr',
                    animation: 'load',
                    color: widget.isStartup ? Color(defaultColors['accent']) : _gameData.getColor('loaderStrokeShadow'),
                    controller: this,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: BoxConstraints(minWidth: 175.0),
                  width: MediaQuery.of(context).size.width * loaderWidthPercent,
                  child: FlareActor(
                    'assets/flares/loader.flr',
                    animation: 'load',
                    color: widget.isStartup ? Color(defaultColors['white']) : _gameData.getColor('loaderStroke'),
                    controller: this,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _overlay?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        widget.child,
        IgnorePointer(
          child: AnimatedOpacity(
            opacity: _overlay == null ? 0.0 : 1.0,
            duration: const Duration(milliseconds: loaderOpacityDuration),
            curve: loaderOpacityCurve,
            child: Container(color: widget.isStartup ? Color(defaultColors['primary']) : _gameData.getColor('loaderBackground')),
          ),
        ),
      ],
    );
  }
}
