import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../styles/theme.dart';
import '../../db/GameData.dart';

class ColorSchemeChoice extends StatelessWidget {
  const ColorSchemeChoice({
    @required this.colorScheme,
    @required this.refreshPage,
  });

  final String colorScheme;
  final VoidCallback refreshPage;

  static final GameData _gameData = GameData();

  void _changeColorScheme() async {
    Fluttertoast.showToast(
      msg: 'Color scheme changed.',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: toastFontSize,
    );
    await _gameData.setColorScheme(colorScheme);
    refreshPage();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _changeColorScheme,
      child: AspectRatio(
        aspectRatio: 1.5,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Color(colorSchemes[colorScheme]['primary']),
                border: Border.all(color: _gameData.getColor('white'), width: 8.0),
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
                    color: Color(colorSchemes[colorScheme]['accent']),
                    border: Border.all(
                        color: _gameData.getColor('white'),
                        width: 8.0),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
