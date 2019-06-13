import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../db/GameData.dart';
import '../../components/animations/Loader.dart';
import '../../components/buttons/CustomButton.dart';
import '../../styles/theme.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage();
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  static final GameData _gameData = GameData();
  int _intro = 0;
  bool _disabled = true;
  bool _isLoading = true;
  bool _loaderAnimating = true;
  double _opacity = 0.0;
  double _messageOpacity = 0.0;
  String _animation;
  String _message = '';

  void _initData() async {
    await _gameData.initStorage();
    setState(() => _isLoading = false);
  }

  void _onLoaderFinish() {
    setState(() => _loaderAnimating = false);
    if (_gameData.getTutorial('intro')) _nextIntro();
    else Navigator.pushReplacementNamed(context, '/home');
    _gameData.setStatusBarColors(_gameData.getColorScheme());
  }

  void _nextIntro() async {
    _intro++;
    if (_intro == 1) {
      setState(() {
        _disabled = true;
        _animation = 'Cards Initialize';
        _message = 'Learn to recognize the glyphs of Kulitan using flash cards that become more difficult to answer over time!';
        _opacity = 1.0;
        _messageOpacity = 1.0;
      });
      await Future.delayed(const Duration(milliseconds: 1833));
      setState(() => _animation = 'Cards Swipe');
      await Future.delayed(const Duration(milliseconds: 1000));
      setState(() => _disabled = false);
    } else if (_intro == 2) {
      setState(() {
        _disabled = true;
        _animation = 'Cards To Trace';
        _messageOpacity = 0.0;
      });
      await Future.delayed(const Duration(milliseconds: introTextOpacityDuration));
      setState(() {
        _message = 'Practice writing by tracing characters with the correct stroke orders ✍️';
        _messageOpacity = 1.0;
      });
      await Future.delayed(const Duration(milliseconds: 1000 - introTextOpacityDuration));
      setState(() => _animation = 'Cards Trace');
      await Future.delayed(const Duration(milliseconds: 333));
      setState(() => _disabled = false);
    } else if (_intro == 3) {
      setState(() {
        _disabled = true;
        _animation = 'Cards To Transcribe';
        _messageOpacity = 0.0;
      });
      await Future.delayed(const Duration(milliseconds: introTextOpacityDuration));
      setState(() {
        _message = 'Can’t read something? Transcribe it using the two-way transcriber with a custom-made Kulitan keyboard! ⌨️';
        _messageOpacity = 1.0;
      });
      await Future.delayed(const Duration(milliseconds: 1283 - introTextOpacityDuration));
      setState(() => _animation = 'Cards Transcribe');
      await Future.delayed(const Duration(milliseconds: 567));
      setState(() => _disabled = false);
    } else if (_intro == 4) {
      setState(() {
        _disabled = true;
        _animation = 'Cards To Info';
        _messageOpacity = 0.0;
      });
      await Future.delayed(const Duration(milliseconds: introTextOpacityDuration));
      setState(() {
        _message = 'Are you just curious about Kulitan? The information page provided contains glyph tables, the history of Kulitan, and writing guides 📖';
        _messageOpacity = 1.0;
      });
      await Future.delayed(const Duration(milliseconds: 2216 - introTextOpacityDuration));
      setState(() => _animation = 'Cards Info');
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() => _disabled = false);
    } else {
      _gameData.setTutorial('intro', false);
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void initState() {
    super.initState();
    _initData();
  }

  @override
  Widget build(BuildContext context) {
    final double _screenWidth = MediaQuery.of(context).size.width;
    final double _screenHorizontalPadding = _screenWidth > 600.0 ? 0.0 : 32.0;

    return Material(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: Container(
          color: _gameData.getColor('background'),
          child: SafeArea(
            child: Loader(
              isStartup: true,
              isVisible: _isLoading,
              onFinish: this.mounted ? _onLoaderFinish : null,
              child: _isLoading
                ? Container()
                : Column(
                  children: <Widget>[
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height > smallHeight ? 50.0: 16.0),
                        child: Center(
                          child: AnimatedOpacity(
                            opacity: _opacity,
                            curve: Curves.easeInOut,
                            duration: const Duration(milliseconds: loaderOpacityDuration),
                            child: Container(
                              child: Transform.scale(
                                scale: 487.0 / (MediaQuery.of(context).size.width - 64.0),
                                child: FlareActor(
                                  'assets/flares/introduction.flr',
                                  fit: BoxFit.fitWidth,
                                  animation: _animation,
                                  // controller: _controller,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 600.0),
                      padding: EdgeInsets.symmetric(horizontal: _screenHorizontalPadding, vertical: 20.0),
                      height: MediaQuery.of(context).size.height > smallHeight ? 125.0 : 80.0,
                      child: AnimatedOpacity(
                        opacity: _messageOpacity,
                        curve: introTextOpacityCurve,
                        duration: const Duration(milliseconds: introTextOpacityDuration),
                        child: Center(
                          child: AutoSizeText(_message, textAlign: TextAlign.center, style: _loaderAnimating ? null : _gameData.getStyle('textTutorialOverlay')),
                        ),
                      ),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 600.0),
                      padding: EdgeInsets.fromLTRB(_screenHorizontalPadding, 0.0, _screenHorizontalPadding, 32.0),
                      child: CustomButton(
                        disable: _disabled,
                        onPressed: _nextIntro,
                        height: MediaQuery.of(context).size.height > smallHeight ? 60.0 : 50.0,
                        borderRadius: 30.0,
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        elevation: 10.0,
                        child: Center(
                          child: Text('Next', style: _loaderAnimating ? null : _gameData.getStyle('textInfoButton')),
                        ),
                      ),
                    ),
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }
}
