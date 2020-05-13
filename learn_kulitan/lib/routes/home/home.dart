import 'dart:async';
import 'package:flutter/material.dart';
import '../../db/GameData.dart';
import '../../components/buttons/CustomButton.dart';
import './components.dart';
import '../../styles/theme.dart';

class HomePage extends StatefulWidget {
  const HomePage();
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final GameData _gameData = GameData();
  final CustomButtonGroup _buttonGroup = CustomButtonGroup();
  bool _disabled = false;
  int _readingProgress = -1;
  int _writingProgress = -1;

  void _loadProgresses() {
    setState(() {
      _readingProgress = _gameData.getOverallProgress('reading');
      _writingProgress = _gameData.getOverallProgress('writing');
    });
  }

  void _disableButtons() async {
    setState(() => _disabled = true);
    await Future.delayed(const Duration(milliseconds: 2 * defaultCustomButtonPressDuration));
    setState(() => _disabled = false);
  }

  void _preventAccidentalPresses() async {
    setState(() => _disabled = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() => _disabled = false);
  }

  @override
  void initState() {
    super.initState();
    _preventAccidentalPresses();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProgresses());
  }

  @override
  Widget build(BuildContext context) {
    Widget _appTitle = Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: <Widget>[
              Text('Learn', style: _gameData.getStyle('textHomeSubtitle')),
              Text('Kulitan', style: _gameData.getStyle('textHomeTitle')),
            ],
          ),
        ),
      ),
    );

    Widget _readingButton = HomeButton(
      buttonGroup: _buttonGroup,
      disabled: _disabled,
      onPressedImmediate: _disableButtons,
      kulitanText: <Widget>[
        Text('paa', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
        Text('ma  ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
        Text('maa', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
        Text('saa', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
      ],
      title: 'Pámamásâ',
      subtitle: 'READING',
      route: '/reading',
      progress: _readingProgress / totalGlyphCount,
      reload: _loadProgresses,
    );

    Widget _writingButton = HomeButton(
      buttonGroup: _buttonGroup,
      disabled: _disabled,
      onPressedImmediate: _disableButtons,
      kulitanText: <Widget>[
        Text('paa', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
        Text('man', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
        Text('suu ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
        Text('lat', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
      ],
      padRight: 5.0,
      title: 'Pámaniúlat',
      subtitle: 'WRITING',
      route: '/writing',
      progress: _writingProgress / totalGlyphCount,
      reload: _loadProgresses,
    );

    Widget _transcribeButton = HomeButton(
      buttonGroup: _buttonGroup,
      disabled: _disabled,
      onPressedImmediate: _disableButtons,
      kulitanText: <Widget>[
        Text('paa', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
        Text('man', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
        Text('lii ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
        Text('kas', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
      ],
      title: 'Pámanlíkas',
      subtitle: 'TRANSCRIBE',
      route: '/transcribe',
    );

    Widget _infoButton = HomeButton(
      buttonGroup: _buttonGroup,
      disabled: _disabled,
      onPressedImmediate: _disableButtons,
      kulitanText: <Widget>[
        Text('k   ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome').copyWith(height: 0.7)),
        Text('p   ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome').copyWith(height: 0.8)),
        Text('b   ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome').copyWith(height: 0.7)),
        Text('luan', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
      ],
      title: 'Kapabaluan',
      subtitle: 'INFORMATION',
      route: '/information',
    );

    Widget _examplesButton = HomeButton(
      buttonGroup: _buttonGroup,
      disabled: _disabled,
      onPressedImmediate: _disableButtons,
      kulitanText: <Widget>[
        Text('ka   ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome').copyWith(height: 0.7)),
        Text('la   ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome').copyWith(height: 0.6)),
        Text('lang', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome').copyWith(height: 1.0)),
        Text('an  ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome').copyWith(height: 0.9)),
      ],
      title: 'Kalalangan',
      subtitle: 'ARTWORKS',
      route: '/artworks',
    );

    Widget _learnMoreButton = HomeButton(
      buttonGroup: _buttonGroup,
      disabled: _disabled,
      onPressedImmediate: _disableButtons,
      kulitanText: <Widget>[
        Text('p    ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome').copyWith(height: 0.8)),
        Text('ki   ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome').copyWith(height: 0.8)),
        Text('b    ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome').copyWith(height: 0.55)),
        Text('luan ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
      ],
      title: 'Pakibaluan Té Pa',
      subtitle: 'LEARN MORE',
      route: '/learn_more',
    );

    Widget _aboutButton = HomeButton(
      buttonGroup: _buttonGroup,
      disabled: _disabled,
      onPressedImmediate: _disableButtons,
      kulitanText: <Widget>[
        Text('reng', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
        Text('gii  ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
        Text('n    ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome').copyWith(height: 0.6)),
        Text('waa', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome')),
      ],
      title: 'Reng Gínawá',
      subtitle: 'ABOUT THE AUTHORS',
      route: '/about',
    );

    Widget _settingsButton = HomeButton(
      buttonGroup: _buttonGroup,
      disabled: _disabled,
      onPressedImmediate: _disableButtons,
      kulitanText: <Widget>[
        Text('ka   ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome').copyWith(height: 0.5)),
        Text('sad   ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome').copyWith(height: 0.7)),
        Text('dian  ', textAlign: TextAlign.center, style: _gameData.getStyle('kulitanHome').copyWith(height: 1.0)),
      ],
      title: 'Kasaddian',
      subtitle: 'SETTINGS',
      route: '/settings',
      reload: () => setState(() {}),
    );

    return Material(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body:  Container(
          color: _gameData.getColor('background'),
          child: SafeArea(
            child: ListView(
              physics: BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                homeHorizontalScreenPadding,
                0.0,
                homeHorizontalScreenPadding,
                homeVerticalScreenPadding - quizChoiceButtonElevation,
              ),
              children: <Widget>[
                _appTitle,
                _readingButton,
                _writingButton,
                _transcribeButton,
                _infoButton,
                _examplesButton,
                _learnMoreButton,
                _aboutButton,
                _settingsButton,
              ].map((button) {
                return Align(
                  alignment: Alignment.center,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 600.0),
                    child: button,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
