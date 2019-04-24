import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import '../../components/animations/Loader.dart';
import './components.dart';
import '../../styles/theme.dart';
import '../../db/DatabaseHelper.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;  
  int _readingProgress = -1;
  int _writingProgress = -1;

  void _initDB() async {
    final Database _db = await DatabaseHelper.instance.database;
    final int _reading = (await _db.query('Page', columns: ['overall_progress'], where: 'name = "reading"'))[0]['overall_progress'];
    final int _writing = (await _db.query('Page', columns: ['overall_progress'], where: 'name = "writing"'))[0]['overall_progress'];
    setState(() {
      _readingProgress = _reading;
      _writingProgress = _writing;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initDB();
  }

  @override
  Widget build(BuildContext context) {
    Widget _appTitle = Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Column(
        children: <Widget>[
          Text('Learn', style: textHomeSubtitle),
          Text('Kulitan', style: textHomeTitle),
        ],
      ),
    );

    Widget _readingButton = HomeButton(
      kulitanText: <Widget>[
        Text('paa', textAlign: TextAlign.center, style: kulitanHome),
        Text('ma', textAlign: TextAlign.center, style: kulitanHome),
        Text('maa', textAlign: TextAlign.center, style: kulitanHome),
        Text('saa', textAlign: TextAlign.center, style: kulitanHome),
      ],
      title: 'Pámamásâ',
      subtitle: 'READING',
      route: '/reading',
      progress: _readingProgress / totalGlyphCount,
    );

    Widget _writingButton = HomeButton(
      kulitanText: <Widget>[
        Text('paa', textAlign: TextAlign.center, style: kulitanHome),
        Text(' man ', textAlign: TextAlign.center, style: kulitanHome),
        Text('suu', textAlign: TextAlign.center, style: kulitanHome),
        Text(' lat ', textAlign: TextAlign.center, style: kulitanHome),
      ],
      padRight: 5.0,
      title: 'Pámaniúlat',
      subtitle: 'WRITING',
      route: '/writing',
      progress: _writingProgress / totalGlyphCount,
    );

    Widget _transcribeButton = HomeButton(
      kulitanText: <Widget>[
        Text('paa', textAlign: TextAlign.center, style: kulitanHome),
        Text('man  ', textAlign: TextAlign.center, style: kulitanHome),
        Text('lii', textAlign: TextAlign.center, style: kulitanHome),
        Text('kas  ', textAlign: TextAlign.center, style: kulitanHome),
      ],
      title: 'Pámanlíkas',
      subtitle: 'TRANSCRIBE',
      route: '/transcribe',
    );

    Widget _infoButton = HomeButton(
      kulitanText: <Widget>[
        Text('k ', textAlign: TextAlign.center, style: kulitanHome.copyWith(height: 0.7)),
        Text('p ', textAlign: TextAlign.center, style: kulitanHome.copyWith(height: 0.9)),
        Text('b ', textAlign: TextAlign.center, style: kulitanHome.copyWith(height: 0.7)),
        Text('luan', textAlign: TextAlign.center, style: kulitanHome),
      ],
      title: 'Kapabaluan',
      subtitle: 'INFORMATION',
      route: '/information',
    );

    Widget _aboutButton = HomeButton(
      kulitanText: <Widget>[
        Text('reng    ', textAlign: TextAlign.center, style: kulitanHome),
        Text('gii', textAlign: TextAlign.center, style: kulitanHome),
        Text('n  ', textAlign: TextAlign.center, style: kulitanHome.copyWith(height: 0.8)),
        Text('waa', textAlign: TextAlign.center, style: kulitanHome),
      ],
      title: 'Reng Gínawá',
      subtitle: 'ABOUT THE AUTHORS',
      route: '/about',
    );

    return Material(
      child: Container(
        color: backgroundColor,
        child: SafeArea(
          child: Loader(
            isVisible: _isLoading,
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
                _aboutButton,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
