import 'dart:async';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './routes/introduction/introduction.dart';
import './routes/home/home.dart';
import './routes/reading/reading.dart';
import './routes/writing/writing.dart';
import './routes/information/information.dart';
import './routes/information/routes/history.dart';
import './routes/information/routes/writingguide.dart';
import './routes/transcribe/transcribe.dart';
import './routes/about/about.dart';
import './routes/settings/settings.dart';
import './components/misc/CustomScrollBehavior.dart';
import './components/misc/MobileAd.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Color(0xFFFABF40),
    systemNavigationBarColor: Color(0xFFFABF40),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  AdMob().initialize();
  runApp(LearnKulitanApp());
}

class LearnKulitanApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MainApp();
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  static final AdMob _ads = AdMob();
  bool _videoShown = false;
  Timer _timer;

  Timer _createIdleTimer() {
    return Timer(AdMob.videoTimeout, () {
      _videoShown = true;
      _ads.showVideo(onClose: () {
        _videoShown = false;
        _timer = _createIdleTimer();
      });
      _timer?.cancel();
    });
  }

  void _resetIdleTimer(_) {
    _timer?.cancel();
    if (!_videoShown) _timer = _createIdleTimer();
  }

  @override
  void initState() {
    super.initState();
    _timer = _createIdleTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Listener(
          behavior: HitTestBehavior.translucent,
          onPointerMove: _resetIdleTimer,
          child: ScrollConfiguration(
            behavior: CustomScrollBehavior(),
            child: child,
          ),
        );
      },
      title: 'Learn Kulitan',
      initialRoute: '/',
      routes: {
        '/': (context) => IntroductionPage(),
        '/home': (context) => HomePage(),
        '/reading': (context) => ReadingPage(),
        '/writing': (context) => WritingPage(),
        '/information': (context) => InformationPage(),
        '/information/history': (context) => HistoryPage(),
        '/information/guide': (context) => WritingGuidePage(),
        '/transcribe': (context) => TranscribePage(),
        '/about': (context) => AboutPage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
