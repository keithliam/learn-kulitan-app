import 'package:flutter/material.dart';
import '../../components/buttons/RoundedBackButton.dart';
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
    final double _screenHorizontalPadding = _screenWidth > 600.0 ? 0.0 : informationHorizontalScreenPadding;

    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding,
          headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: RoundedBackButton(),
        right: SizedBox(width: 56.0, height: 48.0),
      ),
    );

    final Widget _content = Column(
      children: _screenWidth < 600.0
        ? <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: _getColor('default')),
              SizedBox(width: informationHorizontalScreenPadding),
              Expanded(child: _getColor('blue')),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: informationHorizontalScreenPadding),
            child: Row(
              children: <Widget>[
                Expanded(child: _getColor('pink')),
                SizedBox(width: informationHorizontalScreenPadding),
                Expanded(child: _getColor('green')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: informationHorizontalScreenPadding),
            child: Row(
              children: <Widget>[
                Expanded(child: _getColor('dark')),
                SizedBox(width: informationHorizontalScreenPadding),
                Expanded(child: _getColor('amoled')),
              ],
            ),
          ),
        ]
        : <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: _getColor('default')),
              SizedBox(width: informationHorizontalScreenPadding),
              Expanded(child: _getColor('blue')),
              SizedBox(width: informationHorizontalScreenPadding),
              Expanded(child: _getColor('pink')),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: informationHorizontalScreenPadding),
            child: Row(
              children: <Widget>[
                Expanded(child: _getColor('green')),
                SizedBox(width: informationHorizontalScreenPadding),
                Expanded(child: _getColor('dark')),
                SizedBox(width: informationHorizontalScreenPadding),
                Expanded(child: _getColor('amoled')),
              ],
            ),
          ),
        ],
    );

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
            child: Text('${MediaQuery.of(context).size.width >= 690 ? 'Pipanagpágang ' : ''}Kaburian', style: _gameData.getStyle('textPageTitle')),
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
                      child: _content,
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
