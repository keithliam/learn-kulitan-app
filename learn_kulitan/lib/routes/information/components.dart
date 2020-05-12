import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:audioplayers/audio_cache.dart';
import '../../db/GameData.dart';
import '../../styles/theme.dart';

class KulitanInfoCell extends StatefulWidget {
  const KulitanInfoCell(this.kulitan, this.caption, this.audioPlayer);

  final String kulitan;
  final String caption;
  final AudioCache audioPlayer;

  @override
  _KulitanInfoCellState createState() => _KulitanInfoCellState();
}

class _KulitanInfoCellState extends State<KulitanInfoCell> {
  static final GameData _gameData = GameData();

  bool _isPressed = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
  }

  void _onTapDown(_) async {
    setState(() {
      _isPressed = true;
      _isPlaying = true;
    });
    try {
      final AudioPlayer player = await widget.audioPlayer.play('syllable_sound_${widget.kulitan}.mp3');
      player.onPlayerCompletion.listen((event) {
        setState(() => _isPlaying = false);
      });
    } catch (_) {
      setState(() => _isPlaying = false);
      Fluttertoast.showToast(
        msg: "Cannot play sound",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIos: 1,
        backgroundColor: _gameData.getColor('toastBackground'),
        textColor: _gameData.getColor('toastForeground'),
        fontSize: toastFontSize,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: !_isPlaying && !_isPressed ? _onTapDown : null,
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: SizedBox(
        height: 80.0,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            AnimatedOpacity(
              opacity: _isPressed || _isPlaying ? keyboardPressOpacity : 0.0,
              duration: const Duration(milliseconds: informationPageKulitanPressDuration),
              curve: informationPageKulitanPressCurve,
              child: ColoredBox(color: _gameData.getColor('keyboardPress')),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.all(5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.kulitan,
                        style: _gameData.getStyle('kulitanInfo'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25.0,
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        widget.caption,
                        style: _gameData.getStyle('textInfoCaption'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}
