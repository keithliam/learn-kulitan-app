import 'package:flutter/material.dart';
import './components/misc.dart';
import './routes/home.dart';
import './routes/reading.dart';

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
          }
        });
  }
}
