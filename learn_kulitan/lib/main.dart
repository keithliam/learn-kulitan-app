import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import './routes/introduction/introduction.dart';
import './routes/home/home.dart';
import './routes/reading/reading.dart';
import './routes/writing/writing.dart';
import './routes/transcribe/transcribe.dart';
import './routes/information/information.dart';
import './routes/information/routes/history.dart';
import './routes/information/routes/writingguide.dart';
import './routes/learn_more/learn_more.dart';
import './routes/about/about.dart';
import './routes/settings/settings.dart';
import './components/misc/CustomScrollBehavior.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Color(0xFFFABF40),
    systemNavigationBarColor: Color(0xFFFABF40),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(LearnKulitanApp());
}

class LearnKulitanApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MainApp();
  }
}

class MainApp extends StatelessWidget {
  static FirebaseAnalyticsObserver _firebaseObserver = FirebaseAnalyticsObserver(analytics: FirebaseAnalytics());

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        _firebaseObserver
      ],
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: CustomScrollBehavior(),
          child: child,
        );
      },
      title: 'Learn Kulitan',
      initialRoute: '/',
      routes: {
        '/': (context) => IntroductionPage(),
        '/home': (context) => HomePage(),
        '/reading': (context) => ReadingPage(),
        '/writing': (context) => WritingPage(),
        '/transcribe': (context) => TranscribePage(),
        '/information': (context) => InformationPage(),
        '/information/history': (context) => HistoryPage(),
        '/information/guide': (context) => WritingGuidePage(firebaseObserver: _firebaseObserver),
        '/learn_more': (context) => LearnMorePage(),
        '/about': (context) => AboutPage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
