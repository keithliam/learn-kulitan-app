import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './routes/introduction/introduction.dart';
import './routes/reading/reading.dart';
import './routes/writing/writing.dart';
import './routes/information/information.dart';
import './routes/information/routes/history.dart';
import './routes/information/routes/writingguide.dart';
import './routes/transcribe/transcribe.dart';
import './routes/about/about.dart';
import './components/misc/CustomScrollBehavior.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Color(0xFFFABF40),
    systemNavigationBarColor: Color(0xFFFABF40),
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
        '/reading': (context) => ReadingPage(),
        '/writing': (context) => WritingPage(),
        '/information': (context) => InformationPage(),
        '/information/history': (context) => HistoryPage(),
        '/information/guide': (context) => WritingGuidePage(),
        '/transcribe': (context) => TranscribePage(),
        '/about': (context) => AboutPage(),
      },
    );
  }
}
