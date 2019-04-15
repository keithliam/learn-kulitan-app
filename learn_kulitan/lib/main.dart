import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './components/misc/SlideLeftRoute.dart';
import './routes/home/home.dart';
import './routes/reading/reading.dart';
import './routes/writing/writing.dart';
import './routes/information/information.dart';
import './routes/information/routes/history.dart';
import './routes/information/routes/writingguide.dart';
import './routes/transcribe/transcribe.dart';

void main() {
  SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Color(0x44AAAAAA),
  ));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Learn Kulitan',
        home: HomePage(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return SlideLeftRoute(widget: HomePage());
              break;
            case '/reading':
              return SlideLeftRoute(widget: ReadingPage());
              break;
            case '/writing':
              return SlideLeftRoute(widget: WritingPage());
              break;
            case '/information':
              return SlideLeftRoute(widget: InformationPage());
              break;
            case '/information/history':
              return SlideLeftRoute(widget: HistoryPage());
              break;
            case '/information/guide':
              return SlideLeftRoute(widget: WritingGuidePage());
              break;
            case '/transcribe':
              return SlideLeftRoute(widget: TranscribePage());
              break;
          }
        });
  }
}
