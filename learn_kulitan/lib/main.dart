import 'package:flutter/material.dart';
import './components/misc/SlideLeftRoute.dart';
import './routes/home/home.dart';
import './routes/reading/reading.dart';
import './routes/writing/writing.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
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
          }
        });
  }
}
