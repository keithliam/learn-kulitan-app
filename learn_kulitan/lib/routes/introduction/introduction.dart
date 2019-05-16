import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../components/animations/Loader.dart';
import '../../components/buttons/CustomButton.dart';
import '../../routes/home/home.dart';
import '../../styles/theme.dart';
import '../../db/DatabaseHelper.dart';

class IntroductionPage extends StatefulWidget {
  const IntroductionPage();
  @override
  _IntroductionPageState createState() => _IntroductionPageState();
}

class _IntroductionPageState extends State<IntroductionPage> {
  Database _db;
  int _reading;
  int _writing;
  int _intro = 0;
  bool _disabled = true;
  bool _isLoading = true;
  double _opacity = 0.0;
  double _messageOpacity = 0.0;
  String _animation;
  String _message = '';

  void _initDB() async {
    _db = await DatabaseHelper.instance.database;
    _reading = (await _db.query('Page', columns: ['overall_progress'], where: 'name = "reading"'))[0]['overall_progress'];
    _writing = (await _db.query('Page', columns: ['overall_progress'], where: 'name = "writing"'))[0]['overall_progress'];
    final bool _result = (await _db.query('Tutorial', where: 'key = "key"', columns: ['intro']))[0]['intro'] == 'true';
    setState(() => _isLoading = false);
    if (!_result) _goToHomePage();
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
      _db.update('Tutorial', {'intro': 'true'}, where: 'key = "key"');
      _goToHomePage();
    }
  }

  void _goToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(_reading, _writing),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initDB();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        body: Container(
          color: backgroundColor,
          child: SafeArea(
            child: Loader(
              isVisible: _isLoading,
              onFinish: this.mounted ? _nextIntro : null,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height > 600 ? 50.0: 16.0),
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
                    padding: MediaQuery.of(context).size.height > 600
                      ? const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0)
                      : const EdgeInsets.symmetric(horizontal: 32.0 / 2.0, vertical : 20.0 / 2.0),
                    height: MediaQuery.of(context).size.height > 600 ? 125.0 : 80.0,
                    child: AnimatedOpacity(
                      opacity: _messageOpacity,
                      curve: introTextOpacityCurve,
                      duration: const Duration(milliseconds: introTextOpacityDuration),
                      child: Center(
                        child: AutoSizeText(_message, textAlign: TextAlign.center, style: textTutorialOverlay),
                      ),
                    ),
                  ),
                  Padding(
                    padding: MediaQuery.of(context).size.height > 600
                      ? const EdgeInsets.fromLTRB(32.0, 0.0, 32.0, 32.0)
                      : const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
                    child: CustomButton(
                      disable: _disabled,
                      onPressed: _nextIntro,
                      height: MediaQuery.of(context).size.height > 600 ? 60.0 : 50.0,
                      borderRadius: 30.0,
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      elevation: 10.0,
                      child: Center(
                        child: Text('Next', style: textInfoButton),
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
