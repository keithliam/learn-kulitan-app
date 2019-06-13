import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:sticky_headers/sticky_headers.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../styles/theme.dart';
import '../../db/GameData.dart';

class StickyHeading extends StatelessWidget {
  const StickyHeading({
    this.headingText,
    this.content,
    this.showCredits = false,
  });

  final String headingText;
  final Widget content;
  final bool showCredits;

  static final GameData _gameData = GameData();

  void _openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
        msg: "Cannot open webpage",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: _gameData.getColor('toastBackground'),
        textColor: _gameData.getColor('toastForeground'),
        fontSize: toastFontSize,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Widget _header = Container(
      height: 48.0 + headerVerticalPadding,
      alignment: Alignment.center,
      padding: const EdgeInsets.fromLTRB(
        headerHorizontalPadding + 48.0,
        headerVerticalPadding - 8.0,
        headerHorizontalPadding + 48.0,
        0.0,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(headingText, style: _gameData.getStyle('textPageTitle')),
      ),
    );

    if (!showCredits) {
      return StickyHeader(
        header: Container(
          padding: const EdgeInsets.only(bottom: headerVerticalPadding),
          color: _gameData.getColor('background'),
          child: _header,
        ),
        content: content,
      );
    } else {
      return StickyHeader(
        header: Container(
          color: _gameData.getColor('background'),
          child: Column(
            children: <Widget>[
              _header,
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(
                    informationCreditsHorizontalPadding,
                    informationCreditsVerticalPadding,
                    informationCreditsHorizontalPadding,
                    informationCreditsVerticalPadding),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: RichText(
                      text: TextSpan(
                        style: _gameData.getStyle('textInfoCredits'),
                        children: <TextSpan>[
                          TextSpan(text: 'Written by Siuálâ ding Meángûbié. '),
                          TextSpan(
                            text: 'Learn more',
                            style: _gameData.getStyle('textInfoCreditsLink'),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => _openURL('http://siuala.com'),
                          ),
                          TextSpan(text: '.'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        content: content,
      );
    }
  }
}
