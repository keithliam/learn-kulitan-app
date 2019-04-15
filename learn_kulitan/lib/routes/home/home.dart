import 'package:flutter/material.dart';
import './components.dart';
import '../../styles/theme.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _appTitle = Container(
      padding: const EdgeInsets.only(top: 5.0),
      height: homeTitleHeight,
      child: Center(
        child: Container(
          height: 97.0,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -13.0,
                left: 0.0,
                right: 0.0,
                child: Text('Learn', style: textHomeSubtitle, textAlign: TextAlign.center,),
              ),
              Positioned(
                top: 26.0,
                left: 0.0,
                right: 0.0,
                child: Text('Kulitan', style: textHomeTitle, textAlign: TextAlign.center,),
              ),
            ],
          ),
        ),
      ),
    );

    Widget _readingButton = Padding(
      padding: const EdgeInsets.only(top: homeVerticalScreenPadding - quizChoiceButtonElevation),
      child: HomeButton(
        kulitanTextCustom: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            height: 100.0,
            width: 40.0,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Text('k',
                    style: kulitanHome.copyWith(fontSize: 38.0),
                    textAlign: TextAlign.center),
                Positioned(
                  top: 20.0,
                  left: 0.0,
                  right: 8.0,
                  child: Text('p',
                      style: kulitanHome.copyWith(fontSize: 38.0),
                      textAlign: TextAlign.center),
                ),
                Positioned(
                  top: 40.0,
                  left: 0.0,
                  right: 8.0,
                  child: Text('m',
                      style: kulitanHome.copyWith(fontSize: 38.0),
                      textAlign: TextAlign.center),
                ),
                Positioned(
                  top: 63.0,
                  left: 0.0,
                  right: 0.0,
                  child: Text('ma',
                      style: kulitanHome.copyWith(fontSize: 25.0),
                      textAlign: TextAlign.center),
                ),
                Positioned(
                  top: 80.0,
                  left: 0.0,
                  right: 0.0,
                  child: Text('sa',
                      style: kulitanHome.copyWith(fontSize: 25.0),
                      textAlign: TextAlign.center),
                ),
              ],
            ),
          ),
        ),
        kulitanTextOffset: 14.0,
        title: 'Reading',
        route: '/reading',
        progress: 0.80,
      ),
    );

    Widget _writingButton = HomeButton(
      kulitanTextCustom: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          height: 100.0,
          width: 50.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Text('k',
                  style: kulitanHome.copyWith(fontSize: 38.0),
                  textAlign: TextAlign.center),
              Positioned(
                top: 20.0,
                left: 0.0,
                right: 8.0,
                child: Text('p',
                    style: kulitanHome.copyWith(fontSize: 38.0),
                    textAlign: TextAlign.center),
              ),
              Positioned(
                top: 42.0,
                left: 0.0,
                right: 0.0,
                child: Text('mn',
                    style: kulitanHome.copyWith(fontSize: 25.0),
                    textAlign: TextAlign.center),
              ),
              Positioned(
                top: 59.0,
                left: 0.0,
                right: 8.0,
                child: Text('suo',
                    style: kulitanHome.copyWith(fontSize: 25.0),
                    textAlign: TextAlign.center),
              ),
              Positioned(
                top: 80.0,
                left: 0.0,
                right: 0.0,
                child: Text('lt',
                    style: kulitanHome.copyWith(fontSize: 25.0),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
      kulitanTextOffset: 10.0,
      title: 'Writing',
      route: '/writing',
      progress: 0.1,
    );

    Widget _infoButton = HomeButton(
      kulitanTextCustom: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          height: 100.0,
          width: 70.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Text('k',
                  style: kulitanHome.copyWith(fontSize: 45.0),
                  textAlign: TextAlign.center),
              Positioned(
                top: 25.0,
                left: 0.0,
                right: 10.0,
                child: Text('p',
                    style: kulitanHome.copyWith(fontSize: 45.0),
                    textAlign: TextAlign.center),
              ),
              Positioned(
                top: 53.0,
                left: 0.0,
                right: 5.0,
                child: Text('b',
                    style: kulitanHome.copyWith(fontSize: 45.0),
                    textAlign: TextAlign.center),
              ),
              Positioned(
                top: 83.0,
                left: 0.0,
                right: 0.0,
                child: Text('luan',
                    style: kulitanHome.copyWith(fontSize: 20.0),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
      kulitanTextOffset: 2.0,
      title: 'Information',
      route: '/information',
    );

    Widget _transcribeButton = HomeButton(
      kulitanTextCustom: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          height: 100.0,
          width: 50.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Text('k',
                  style: kulitanHome.copyWith(fontSize: 38.0),
                  textAlign: TextAlign.center),
              Positioned(
                top: 20.0,
                left: 0.0,
                right: 8.0,
                child: Text('p',
                    style: kulitanHome.copyWith(fontSize: 38.0),
                    textAlign: TextAlign.center),
              ),
              Positioned(
                top: 44.0,
                left: 2.0,
                right: 0.0,
                child: Text('mn',
                    style: kulitanHome.copyWith(fontSize: 25.0),
                    textAlign: TextAlign.center),
              ),
              Positioned(
                top: 68.0,
                left: 0.0,
                right: 15.0,
                child: Text('lie',
                    style: kulitanHome.copyWith(fontSize: 25.0),
                    textAlign: TextAlign.center),
              ),
              Positioned(
                top: 80.0,
                left: 0.0,
                right: 0.0,
                child: Text('ks',
                    style: kulitanHome.copyWith(fontSize: 25.0),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
      kulitanTextOffset: 11.0,
      title: 'Transcribe',
      route: '/transcribe',
    );

    Widget _aboutButton = HomeButton(
      kulitanTextCustom: FittedBox(
        fit: BoxFit.scaleDown,
        child: Container(
          height: 100.0,
          width: 70.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                top: 3.0,
                left: 0.0,
                right: 19.0,
                child: Text('ee',
                    style: kulitanHome.copyWith(fontSize: 18.0),
                    textAlign: TextAlign.center),
              ),
              Positioned(
                top: 0.0,
                left: 19.0,
                right: 0.0,
                child: Text('N',
                    style: kulitanHome.copyWith(fontSize: 18.0),
                    textAlign: TextAlign.center),
              ),
              Positioned(
                top: 20.0,
                left: 0.0,
                right: 5.0,
                child: Text('g',
                    style: kulitanHome.copyWith(fontSize: 45.0),
                    textAlign: TextAlign.center),
              ),
              Positioned(
                top: 26.0,
                left: 5.0,
                right: 0.0,
                child: Text('i',
                    style: kulitanHome.copyWith(fontSize: 45.0),
                    textAlign: TextAlign.center),
              ),
              Positioned(
                top: 43.0,
                left: 0.0,
                right: 8.0,
                child: Text('n',
                    style: kulitanHome.copyWith(fontSize: 45.0),
                    textAlign: TextAlign.center),
              ),
              Positioned(
                top: 80.0,
                left: 0.0,
                right: 10.0,
                child: Text('oa',
                    style: kulitanHome.copyWith(fontSize: 25.0),
                    textAlign: TextAlign.center),
              ),
            ],
          ),
        ),
      ),
      kulitanTextOffset: 4.0,
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
              homeVerticalScreenPadding,
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