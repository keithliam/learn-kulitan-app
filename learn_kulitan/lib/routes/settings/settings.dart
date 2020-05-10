import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/buttons/RoundedBackButton.dart';
import '../../components/buttons/PageButton.dart';
import '../../components/misc/StaticHeader.dart';
import '../../db/GameData.dart';
import '../../styles/theme.dart';
import './components.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage();

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static final GameData _gameData = GameData();

  void _refresh() => setState(() {});

  void _replayIntro() {
    _gameData.setTutorial('intro', true);
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/',
      (Route<dynamic> route) => false,
    );
  }

  void _restartTutorials() {
    _gameData.setTutorial('reading', true);
    _gameData.setTutorial('writing', true);
    _gameData.setTutorial('transcribe', true);
    Fluttertoast.showToast(
      msg: 'Reading, Writing, and Transcribe tutorials restarted!',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIos: 3,
      backgroundColor: _gameData.getColor('toastBackground'),
      textColor: _gameData.getColor('toastForeground'),
      fontSize: toastFontSize,
    );
  }

  Future<void> _resetGame() async {
    await _gameData.resetGameData();
  }

  Widget _getColor(String color) {
    final List<String> _unlockedColors = _gameData.getUnlockedColorSchemes();
    return ColorSchemeChoice(
      colorScheme: color,
      refreshPage: _refresh,
      locked: !_unlockedColors.contains(color),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final double _screenWidth = _mediaQuery.size.width;
    final double _screenHorizontalPadding =
        _screenWidth > maxPageWidth ? 0.0 : informationHorizontalScreenPadding;
    const double _spacing = informationHorizontalScreenPadding;

    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding,
          headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: RoundedBackButton(),
        right: SizedBox(width: 48.0, height: 48.0),
      ),
    );

    final List<Widget> _content = [];

    if (_screenWidth < maxPageWidth) {
      _content.addAll([
        Row(
          children: <Widget>[
            Expanded(child: _getColor('default')),
            SizedBox(width: _spacing),
            Expanded(child: _getColor('dark')),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: _spacing),
          child: Row(
            children: <Widget>[
              Expanded(child: _getColor('blue')),
              SizedBox(width: _spacing),
              Expanded(child: _getColor('pink')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: _spacing),
          child: Row(
            children: <Widget>[
              Expanded(child: _getColor('green')),
              SizedBox(width: _spacing),
              Expanded(child: _getColor('purple')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: _spacing),
          child: Row(
            children: <Widget>[
              Expanded(child: _getColor('amoled')),
              SizedBox(width: _spacing),
              Expanded(child: ColorSchemeChoice()),
            ],
          ),
        ),
      ]);
    } else {
      _content.addAll([
        Row(
          children: <Widget>[
            Expanded(child: _getColor('default')),
            SizedBox(width: _spacing),
              Expanded(child: _getColor('dark')),
            SizedBox(width: _spacing),
            Expanded(child: _getColor('blue')),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: _spacing),
          child: Row(
            children: <Widget>[
            Expanded(child: _getColor('pink')),
              SizedBox(width: _spacing),
              Expanded(child: _getColor('green')),
              SizedBox(width: _spacing),
              Expanded(child: _getColor('purple')),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: _spacing),
          child: Row(
            children: <Widget>[
            Expanded(child: _getColor('amoled')),
              SizedBox(width: _spacing),
              Expanded(child: ColorSchemeChoice()),
              SizedBox(width: _spacing),
              Expanded(child: ColorSchemeChoice()),
            ],
          ),
        ),
      ]);
    }

    _content.addAll([
      // Replay Introduction button
      Padding(
        padding: const EdgeInsets.only(top: _spacing),
        child: PageButton(
          onPressed: _replayIntro,
          text: 'Replay Introduction',
        ),
      ),
      // Restart Tutorials button
      Padding(
        padding: const EdgeInsets.only(top: _spacing - 10.0),
        child: PageButton(
          onPressed: _restartTutorials,
          text: 'Restart Tutorials',
        ),
      ),
      // Reset Game button
      Padding(
        padding: const EdgeInsets.only(top: _spacing - 10.0),
        child: ResetButton(onPressed: _resetGame),
      ),
    ]);

    final List<Widget> _pageStack = [
      Column(
        children: <Widget>[
          Container(
            height: 48.0 + (headerVerticalPadding * 2.0),
            width: double.infinity,
            color: _gameData.getColor('background'),
            padding: const EdgeInsets.fromLTRB(
              headerHorizontalPadding + 48.0,
              headerVerticalPadding - 8.0,
              headerHorizontalPadding + 48.0,
              10.0,
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'Kasaddian',
                style: _gameData.getStyle('textPageTitle'),
              ),
            ),
          ),
          Expanded(
            child: Scrollbar(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: _screenHorizontalPadding,
                    vertical: informationVerticalScreenPadding,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxPageWidth),
                      child: Column(children: _content),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      _header,
    ];

    return Material(
      color: _gameData.getColor('background'),
      child: SafeArea(
        child: Stack(children: _pageStack),
      ),
    );
  }
}
