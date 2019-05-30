import 'package:flutter/material.dart';
import '../../components/buttons/IconButtonNew.dart';
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

  @override
  Widget build(BuildContext context) {
    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding,
          headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: IconButtonNew(
          icon: Icons.arrow_back_ios,
          iconSize: headerIconSize,
          color: _gameData.getColor('headerNavigation'),
          onPressed: () => Navigator.pop(context),
        ),
        right: SizedBox(width: 56.0, height: 48.0),
      ),
    );

    final List<String> _unlockedColors = _gameData.getUnlockedColorSchemes();

    final Widget _content = Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: ColorSchemeChoice(
                colorScheme: 'default',
                refreshPage: _refresh,
                locked: !_unlockedColors.contains('default'),
              ),
            ),
            SizedBox(width: informationHorizontalScreenPadding),
            Expanded(
              child: ColorSchemeChoice(
                colorScheme: 'blue',
                refreshPage: _refresh,
                locked: !_unlockedColors.contains('blue'),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: informationHorizontalScreenPadding),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ColorSchemeChoice(
                  colorScheme: 'pink',
                  refreshPage: _refresh,
                  locked: !_unlockedColors.contains('pink'),
                ),
              ),
              SizedBox(width: informationHorizontalScreenPadding),
              Expanded(
                child: ColorSchemeChoice(
                  colorScheme: 'green',
                  refreshPage: _refresh,
                  locked: !_unlockedColors.contains('green'),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: informationHorizontalScreenPadding),
          child: Row(
            children: <Widget>[
              Expanded(
                child: ColorSchemeChoice(
                  colorScheme: 'dark',
                  refreshPage: _refresh,
                  locked: !_unlockedColors.contains('dark'),
                ),
              ),
              SizedBox(width: informationHorizontalScreenPadding),
              Expanded(
                child: ColorSchemeChoice(
                  colorScheme: 'amoled',
                  refreshPage: _refresh,
                  locked: !_unlockedColors.contains('amoled'),
                ),
              ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: informationHorizontalScreenPadding,
                    vertical: informationVerticalScreenPadding,
                  ),
                  child: _content,
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
