import 'package:flutter/material.dart';
import '../../db/GameData.dart';

class KulitanInfoCell extends StatelessWidget {
  const KulitanInfoCell(this.kulitan, this.caption);

  final String kulitan;
  final String caption;

  static final GameData _gameData = GameData();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                kulitan,
                style: _gameData.getStyle('kulitanInfo'),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  caption,
                  style: _gameData.getStyle('textInfoCaption'),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
