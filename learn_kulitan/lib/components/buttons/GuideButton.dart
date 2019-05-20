import 'package:flutter/material.dart';
import '../../styles/theme.dart';
import '../../components/buttons/CustomButton.dart';
import '../../db/GameData.dart';

class GuideButton extends StatelessWidget {
  const GuideButton({
    @required this.text,
    @required this.controller,
    @required this.pageNumber,
  });

  final String text;
  final PageController controller;
  final int pageNumber;

  static final GameData _gameData = GameData();

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      marginTop: 7.5,
      onPressed: () => controller.animateToPage(pageNumber,
          duration: const Duration(milliseconds: informationPageScrollDuration),
          curve: informationPageScrollCurve),
      borderRadius: 30.0,
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      elevation: 7.5,
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(text, style: _gameData.getStyle('textGuideButton')),
            ),
            Container(width: 5.0),
            Text('>', style: _gameData.getStyle('textGuideButton').copyWith(color: _gameData.getColor('accent'))),
          ],
        ),
      ),
    );
  }
}
