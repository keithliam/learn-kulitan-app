import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../styles/theme.dart';
import '../../db/GameData.dart';

class ColorSchemeChoice extends StatefulWidget {
  const ColorSchemeChoice({
    @required this.colorScheme,
    @required this.refreshPage,
    this.locked = false,
  });

  final String colorScheme;
  final VoidCallback refreshPage;
  final bool locked;

  @override
  _ColorSchemeChoiceState createState() => _ColorSchemeChoiceState();
}

class _ColorSchemeChoiceState extends State<ColorSchemeChoice> {
  static final GameData _gameData = GameData();
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.locked) {
        await Future.delayed(const Duration(milliseconds: 500));
        setState(() => _opacity = 1.0);
      }
    });
  }

  void _pressedColorScheme() async {
    String _msg = '';
    if (widget.locked)
      _msg = 'Color is locked.';
    else
      _msg = 'Color scheme changed.';
    Fluttertoast.showToast(
      msg: _msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: toastFontSize,
    );

    if (!widget.locked) {
      await _gameData.setColorScheme(widget.colorScheme);
      widget.refreshPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _stackList = [
      Container(
        decoration: BoxDecoration(
          color: Color(colorSchemes[widget.colorScheme]['primary']),
          border: Border.all(
            color: _gameData.getColor('white'),
            width: 8.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      Align(
        alignment: Alignment(1.0, 1.0),
        child: FractionallySizedBox(
          heightFactor: 0.6,
          widthFactor: 0.6,
          child: Container(
            decoration: BoxDecoration(
              color: Color(colorSchemes[widget.colorScheme]['accent']),
              border: Border.all(
                color: _gameData.getColor('white'),
                width: 8.0,
              ),
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
        ),
      ),
      AnimatedOpacity(
        duration: const Duration(
          milliseconds: settingsColorSchemeOpacityDuration,
        ),
        curve: settingsColorSchemeOpacityCurve,
        opacity: _opacity,
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
            return Icon(
              Icons.lock,
              color: Colors.white,
              size: constraints.biggest.width * 0.2,
            );
          }),
        ),
      ),
    ];

    return GestureDetector(
      onTap: _pressedColorScheme,
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Stack(
          children: _stackList,
        ),
      ),
    );
  }
}
