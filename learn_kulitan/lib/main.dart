import 'package:flutter/material.dart';
import './components/misc/SlideLeftRoute.dart';
import './routes/home/home.dart';
import './routes/reading/reading.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => _MyApp();
}

class _MyApp extends State<MyApp> {
  GlobalKey _key = GlobalKey();
  double _screenHeight = 100.0;

  void _getScreenWidth() {
    final RenderBox _box = _key.currentContext.findRenderObject();
    setState(() => _screenHeight = _box.size.height);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _getScreenWidth());     
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        key: _key,
        title: 'Flutter Demo',
        home: HomePage(),
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/':
              return SlideLeftRoute(widget: HomePage());
              break;
            case '/reading':
              return SlideLeftRoute(widget: ReadingPage(screenHeight: _screenHeight));
              break;
          }
        });
  }
}
