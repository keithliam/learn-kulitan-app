import 'package:flutter/material.dart';
import './components.dart';
import '../../styles/theme.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _appTitle = Stack(
      alignment: Alignment.topCenter,
      children: <Widget>[
        Text('Learn', style: textHomeSubtitle),
        Container(
          child: Text('Kulitan', style: textHomeTitle),
          padding: const EdgeInsets.only(top: 45.0),
        ),
      ],
    );

    Widget _readingButton = Padding(
      padding: const EdgeInsets.only(top: 26.0),
      child: HomeButton(
        kulitanText: 'p\nm\nma\ns',
        kulitanTextOffset: 12.0,
        title: 'Reading',
        route: '/reading',
        progress: 0.80,
      ),
    );

    Widget _writingButton = HomeButton(
      kulitanText: 'p\nmn\neo\nlt',
      kulitanTextOffset: 12.0,
      title: 'Writing',
      route: '/writing',
      progress: 0.1,
    );

    Widget _infoButton = HomeButton(
      kulitanTextCustom: Container(
        height: 115.0,
        width: 38.0,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Text('k',
                style: kulitanHome.copyWith(fontSize: 25.0),
                textAlign: TextAlign.center),
            Positioned(
              top: 14.0,
              left: 0.0,
              right: 0.0,
              child: Text('p',
                  style: kulitanHome.copyWith(fontSize: 25.0),
                  textAlign: TextAlign.center),
            ),
            Positioned(
              top: 31.0,
              left: 0.0,
              right: 0.0,
              child: Text('b',
                  style: kulitanHome.copyWith(fontSize: 25.0),
                  textAlign: TextAlign.center),
            ),
            Positioned(
              top: 49.0,
              left: 0.0,
              right: 0.0,
              child: Text('lu\nan',
                  style: kulitanHome.copyWith(fontSize: 25.0),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
      kulitanTextOffset: 11.0,
      title: 'Information',
      route: '/',
    );

    Widget _translateButton = HomeButton(
      kulitanTextCustom: Container(
        height: 115.0,
        width: 40.0,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Text('p', style: kulitanHome, textAlign: TextAlign.center),
            Positioned(
              top: 20.0,
              left: 0.0,
              right: 0.0,
              child: Text('mg',
                  style: kulitanHome, textAlign: TextAlign.center),
            ),
            Positioned(
              top: 36.0,
              left: 0.0,
              right: 0.0,
              child: Text('s',
                  style: kulitanHome, textAlign: TextAlign.center),
            ),
            Positioned(
              top: 64.0,
              left: 0.0,
              right: 0.0,
              child: Text('lin',
                  style: kulitanHome, textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
      kulitanTextOffset: 11.0,
      title: 'Translate',
      route: '/',
    );

    Widget _aboutButton = HomeButton(
      kulitanTextCustom: Container(
        height: 115.0,
        width: 40.0,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: 5.0,
              left: 0.0,
              child: Text('ee',
                  style: kulitanHome.copyWith(fontSize: 25.0),
                  textAlign: TextAlign.center),
            ),
            Positioned(
              top: 0.0,
              left: 40.0,
              right: 0.0,
              child: Text('N',
                  style: kulitanHome.copyWith(fontSize: 25.0),
                  textAlign: TextAlign.center),
            ),
            Positioned(
              top: 27.0,
              left: 8.0,
              right: 0.0,
              child: Text('gi\nn\noa',
                  style: kulitanHome.copyWith(fontSize: 25.0),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
      kulitanTextOffset: 5.0,
      title: 'About',
      route: '/',
    );

    return Material(
      child: Container(
        color: backgroundColor,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: quizHorizontalScreenPadding, vertical: writingVerticalScreenPadding),
          children: <Widget>[
            _appTitle,
            _readingButton,
            _writingButton,
            _infoButton,
            _translateButton,
            _aboutButton,
          ],
        ),
      ),
    );
  }
}