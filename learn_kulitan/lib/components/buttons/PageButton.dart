import 'package:flutter/material.dart';
import '../../db/GameData.dart';
import './CustomButton.dart';

class PageButton extends StatelessWidget {
  const PageButton({
    @required this.onPressed,
    @required this.text,
    this.isColored = false,
    this.icon,
  });

  final VoidCallback onPressed;
  final bool isColored;
  final String text;
  final IconData icon;

  static final GameData _gameData = GameData();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
        onPressed: onPressed,
        borderRadius: 30.0,
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 10.0,
        ),
        elevation: 10.0,
        color: _gameData.getColor(isColored ? 'accent' : 'white'),
        child: icon == null
            ? Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    text,
                    style: isColored
                        ? _gameData.getStyle('textAboutButton')
                        : _gameData
                            .getStyle('textAboutButton')
                            .copyWith(color: _gameData.getColor('foreground')),
                  ),
                ),
              )
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(right: 10.0),
                      alignment: Alignment.center,
                      child: Text(
                        text,
                        style: isColored
                            ? _gameData.getStyle('textAboutButton')
                            : _gameData.getStyle('textAboutButton').copyWith(
                                color: _gameData.getColor('foreground')),
                      ),
                    ),
                    Icon(
                      icon,
                      color: _gameData.getColor(isColored ? 'white' : 'accent'),
                    ),
                  ],
                ),
              ));
  }
}
