import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import '../../styles/theme.dart';
import '../../db/GameData.dart';

class Paragraphs extends StatelessWidget {
  const Paragraphs({
    @required this.paragraphs,
    this.padding = paragraphTopPadding,
    this.textAlign = TextAlign.justify,
  });

  final List<TextSpan> paragraphs;
  final double padding;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: paragraphs.map((text) {
        return Padding(
          padding: EdgeInsets.only(top: padding),
          child: RichText(
            text: TextSpan(children: <TextSpan>[text]),
            textAlign: textAlign,
          ),
        );
      }).toList(growable: false),
    );
  }
}

class RomanText extends TextSpan {
  static final GameData _gameData = GameData();

  RomanText(String text, [TapGestureRecognizer recognizer])
      : super(
          text: text,
          style: recognizer == null
              ? _gameData.getStyle('textInfoText')
              : _gameData.getStyle('textInfoLink'),
          recognizer: recognizer,
        );
}

class BoldRomanText extends TextSpan {
  static final GameData _gameData = GameData();

  BoldRomanText(String text)
      : super(
          text: text,
          style: _gameData
              .getStyle('textInfoTextItalic')
              .copyWith(fontWeight: FontWeight.w600),
        );
}

class ItalicRomanText extends TextSpan {
  static final GameData _gameData = GameData();

  ItalicRomanText(String text)
      : super(text: text, style: _gameData.getStyle('textInfoTextItalic'));
}

class KulitanText extends TextSpan {
  static final GameData _gameData = GameData();

  KulitanText(String text)
      : super(text: text, style: _gameData.getStyle('kulitanInfoText'));
}
