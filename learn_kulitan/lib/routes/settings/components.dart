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
    if (widget.locked) {
      final int _batch1Len = kulitanBatches[0].length;
      final int _rProgress = _gameData.getOverallProgress('reading');
      final int _wProgress = _gameData.getOverallProgress('writing');
      final int _oneMoreR = _batch1Len - _rProgress;
      final int _oneMoreW = _batch1Len - _wProgress;
      final int _halfMoreR = halfBatchesLen - _rProgress;
      final int _halfMoreW = halfBatchesLen - _wProgress;
      final int _thirdMoreR = threeFourthBatchesLen - _rProgress;
      final int _thirdMoreW = threeFourthBatchesLen - _wProgress;
      final String _oneSR = _oneMoreR > 1 ? 's' : '';
      final String _oneSW = _oneMoreW > 1 ? 's' : '';
      final String _halfSR = _halfMoreR > 1 ? 's' : '';
      final String _halfSW = _halfMoreW > 1 ? 's' : '';
      final String _thirdSR = _thirdMoreR > 1 ? 's' : '';
      final String _thirdSW = _thirdMoreW > 1 ? 's' : '';
      if (widget.colorScheme == 'blue')
        _msg =
            'Finish $_oneMoreR more glyph$_oneSR in Pámamásâ or $_oneMoreW more glyph$_oneSW in Pámaniúlat to unlock this color scheme.';
      else if (widget.colorScheme == 'pink')
        _msg =
            'Finish ${_oneMoreR > 0 ? '$_oneMoreR more glyph$_oneSR in Pámamásâ' : ''}${_oneMoreR > 0 && _oneMoreW > 0 ? ' and ' : ''}${_oneMoreW > 0 ? '$_oneMoreW more glyph$_oneSW in Pámaniúlat' : ''} to unlock this color scheme.';
      else if (widget.colorScheme == 'green')
        _msg =
            'Finish $_halfMoreR more glyph$_halfSR in Pámamásâ or $_halfMoreW more glyph$_halfSW in Pámaniúlat to unlock this color scheme.';
      else if (widget.colorScheme == 'dark')
        _msg =
            'Finish ${_halfMoreR > 0 ? '$_halfMoreR more glyph$_halfSR in Pámamásâ' : ''}${_halfMoreR > 0 && _halfMoreW > 0 ? ' and ' : ''}${_halfMoreW > 0 ? '$_halfMoreW more glyph$_halfSW in Pámaniúlat' : ''} to unlock this color scheme.';
      else
        _msg =
            'Finish ${_thirdMoreR > 0 ? '$_thirdMoreR more glyph$_thirdSR in Pámamásâ' : ''}${_thirdMoreR > 0 && _thirdMoreW > 0 ? ' and ' : ''}${_thirdMoreW > 0 ? '$_thirdMoreW more glyph$_thirdSW in Pámaniúlat' : ''} to unlock this color scheme.';
    } else
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
