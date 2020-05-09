import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/buttons/PageButton.dart';
import '../../styles/theme.dart';
import '../../db/GameData.dart';

class ColorSchemeChoice extends StatefulWidget {
  const ColorSchemeChoice({
    this.colorScheme,
    this.refreshPage,
    this.locked = false,
  }) : assert(
         colorScheme == null || refreshPage != null,
         'refreshPage is required when colorScheme is provided.'
        );

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
            'Finish $_oneMoreR more syllables$_oneSR in Pámamásâ or $_oneMoreW more syllables$_oneSW in Pámaniúlat to unlock this color scheme.';
      else if (widget.colorScheme == 'pink')
        _msg =
            'Finish ${_oneMoreR > 0 ? '$_oneMoreR more syllables$_oneSR in Pámamásâ' : ''}${_oneMoreR > 0 && _oneMoreW > 0 ? ' and ' : ''}${_oneMoreW > 0 ? '$_oneMoreW more syllables$_oneSW in Pámaniúlat' : ''} to unlock this color scheme.';
      else if (widget.colorScheme == 'green')
        _msg =
            'Finish $_halfMoreR more syllables$_halfSR in Pámamásâ or $_halfMoreW more syllables$_halfSW in Pámaniúlat to unlock this color scheme.';
      else if (widget.colorScheme == 'purple')
        _msg =
            'Finish ${_halfMoreR > 0 ? '$_halfMoreR more syllables$_halfSR in Pámamásâ' : ''}${_halfMoreR > 0 && _halfMoreW > 0 ? ' and ' : ''}${_halfMoreW > 0 ? '$_halfMoreW more syllables$_halfSW in Pámaniúlat' : ''} to unlock this color scheme.';
      else
        _msg =
            'Finish ${_thirdMoreR > 0 ? '$_thirdMoreR more syllables$_thirdSR in Pámamásâ' : ''}${_thirdMoreR > 0 && _thirdMoreW > 0 ? ' and ' : ''}${_thirdMoreW > 0 ? '$_thirdMoreW more syllables$_thirdSW in Pámaniúlat' : ''} to unlock this color scheme.';
    } else {
      _msg = 'Color scheme changed.';
    }
    final Color _fore = widget.locked
        ? _gameData.getColor('toastForeground')
        : Color(colorSchemes[widget.colorScheme]['white']);
    final Color _back = widget.locked
        ? _gameData.getColor('toastBackground')
        : Color(colorSchemes[widget.colorScheme]['accent']);
    Fluttertoast.showToast(
      msg: _msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: _back,
      textColor: _fore,
      fontSize: toastFontSize,
    );
    if (!widget.locked) {
      await _gameData.setColorScheme(widget.colorScheme);
      widget.refreshPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _visible = widget.colorScheme != null;

    final AspectRatio _widget = AspectRatio(
      aspectRatio: 1.5,
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: _visible
                      ? Color(colorSchemes[widget.colorScheme]['primary'])
                      : Colors.transparent,
              border: Border.all(
                color: _visible ? _gameData.getColor('white') : Colors.transparent,
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
                  color: _visible
                          ? Color(colorSchemes[widget.colorScheme]['accent'])
                          : Colors.transparent,
                  border: Border.all(
                    color: _visible ? _gameData.getColor('white') : Colors.transparent,
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
                color: _visible ? Colors.black.withOpacity(0.4) : Colors.transparent,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: LayoutBuilder(builder: (_, BoxConstraints constraints) {
                return Icon(
                  Icons.lock,
                  color: _visible ? Colors.white : Colors.transparent,
                  size: constraints.biggest.width * 0.2,
                );
              }),
            ),
          ),
        ],
      ),
    );

    return widget.colorScheme != null && widget.refreshPage != null
      ? GestureDetector(
        onTap: _pressedColorScheme,
        child: AspectRatio(
          aspectRatio: 1.5,
          child: _widget,
        ),
       ) : _widget;
  }
}

class ResetButton extends StatefulWidget {
  const ResetButton({@required this.onPressed});

  final Future<void> Function() onPressed;

  @override
  _ResetButtonState createState() => _ResetButtonState();
}

class _ResetButtonState extends State<ResetButton> {
  static final GameData _gameData = GameData();
  static final int _buttonPresses = 3;

  int _presses = 0;

  void _pressed() async {
    final Color _backColor = _gameData.getColor('toastBackground');
    final Color _foreColor = _gameData.getColor('toastForeground');
    String _msg = '';
    _presses++;
    if (_presses == _buttonPresses) {
      await widget.onPressed();
      _msg = 'Game reset! ↩';
    } else if (_presses > _buttonPresses) {
      _msg = 'The game has already been reset.';
    } else {
      final int _times = _buttonPresses - _presses;
      _msg =
          'Press the button $_times more time${_times > 1 ? 's' : ''} to reset the game.';
    }
    Fluttertoast.showToast(
      msg: _msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIos: 1,
      backgroundColor: _backColor,
      textColor: _foreColor,
      fontSize: toastFontSize,
    );
    if (_presses == _buttonPresses) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageButton(
      onPressed: _pressed,
      isColored: true,
      text: 'Reset Game',
    );
  }
}
