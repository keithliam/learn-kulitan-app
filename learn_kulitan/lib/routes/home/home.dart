import 'package:flutter/material.dart';
import './components.dart';
import '../../styles/theme.dart';

class HomePage extends StatelessWidget {
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
      kapampanganText: 'PÁMAMÁSÂ',
      title: 'Reading',
      route: '/reading',
      progress: 0.80,
    );

    Widget _writingButton = HomeButton(
      kulitanText: <Widget>[
        Text('paa', textAlign: TextAlign.center, style: kulitanHome),
        Text(' man ', textAlign: TextAlign.center, style: kulitanHome),
        Text('suu', textAlign: TextAlign.center, style: kulitanHome),
        Text(' lat ', textAlign: TextAlign.center, style: kulitanHome),
      ],
      padRight: 5.0,
      kapampanganText: 'PÁMANIÚLAT',
      title: 'Writing',
      route: '/writing',
      progress: 0.1,
    );

    Widget _infoButton = HomeButton(
      kulitanText: <Widget>[
        Text('k ', textAlign: TextAlign.center, style: kulitanHome.copyWith(height: 0.7)),
        Text('p ', textAlign: TextAlign.center, style: kulitanHome.copyWith(height: 0.9)),
        Text('b ', textAlign: TextAlign.center, style: kulitanHome.copyWith(height: 0.7)),
        Text('luan', textAlign: TextAlign.center, style: kulitanHome),
      ],
      kapampanganText: 'KAPABALUAN',
      title: 'Information',
      route: '/information',
    );

    Widget _transcribeButton = HomeButton(
      kulitanText: <Widget>[
        Text('paa', textAlign: TextAlign.center, style: kulitanHome),
        Text('man  ', textAlign: TextAlign.center, style: kulitanHome),
        Text('lii', textAlign: TextAlign.center, style: kulitanHome),
        Text('kas  ', textAlign: TextAlign.center, style: kulitanHome),
      ],
      kapampanganText: 'PÁMANLÍKAS',
      title: 'Transcribe',
      route: '/transcribe',
    );

    Widget _aboutButton = HomeButton(
      kulitanText: <Widget>[
        Text('reng    ', textAlign: TextAlign.center, style: kulitanHome),
        Text('gii', textAlign: TextAlign.center, style: kulitanHome),
        Text('n  ', textAlign: TextAlign.center, style: kulitanHome.copyWith(height: 0.8)),
        Text('waa', textAlign: TextAlign.center, style: kulitanHome),
      ],
      kapampanganText: 'DENG GÍNAWÁ',
      title: 'About',
      route: '/',
    );

    return Material(
      child: Container(
        color: backgroundColor,
        child: SafeArea(
          child: ListView(
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
              _infoButton,
              _transcribeButton,
              _aboutButton,
            ],
          ),
        ),
      ),
    );
  }
}
