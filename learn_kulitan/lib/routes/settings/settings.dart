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
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIos: 1,
      backgroundColor: _gameData.getColor('toastBackground'),
      textColor: _gameData.getColor('toastForeground'),
      fontSize: toastFontSize,
    );
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
    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _screenHorizontalPadding =
        _screenWidth > 600.0 ? 0.0 : informationHorizontalScreenPadding;
    const double _spacing = informationHorizontalScreenPadding;

    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding,
          headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: RoundedBackButton(),
        right: SizedBox(width: 56.0, height: 48.0),
      ),
    );

    final List<Widget> _content = [];

    if (_screenWidth < 600.0) {
      _content.addAll([
        Row(
          children: <Widget>[
            Expanded(child: _getColor('default')),
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
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: _spacing),
          child: Row(
            children: <Widget>[
              Expanded(child: _getColor('dark')),
              SizedBox(width: _spacing),
              Expanded(child: _getColor('amoled')),
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
            Expanded(child: _getColor('blue')),
            SizedBox(width: _spacing),
            Expanded(child: _getColor('pink')),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: _spacing),
          child: Row(
            children: <Widget>[
              Expanded(child: _getColor('green')),
              SizedBox(width: _spacing),
              Expanded(child: _getColor('dark')),
              SizedBox(width: _spacing),
              Expanded(child: _getColor('amoled')),
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
        child: ResetButton(onPressed: _gameData.resetGameData),
      ),
    ]);

    final List<Widget> _pageStack = [
      Column(
        children: <Widget>[
          Container(
            color: _gameData.getColor('background'),
            padding: const EdgeInsets.fromLTRB(
              informationHorizontalScreenPadding,
              headerVerticalPadding - 8.0,
              informationHorizontalScreenPadding,
              10.0,
            ),
            child: Text(
                'Kasaddian',
                style: _gameData.getStyle('textPageTitle')),
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
                      constraints: BoxConstraints(maxWidth: 600.0),
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
