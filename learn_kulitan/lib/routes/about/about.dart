import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'
    show TapGestureRecognizer, GestureRecognizer;
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../styles/theme.dart';
import '../../components/buttons/IconButtonNew.dart';
import '../../components/buttons/BackToStartButton.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/StickyHeading.dart';
import '../../components/misc/ImageWithCaption.dart';
import '../../components/misc/Paragraphs.dart';
import './components.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final _scrollController = ScrollController();
  FlutterLogoStyle _flutterLogoStyle = FlutterLogoStyle.markOnly;
  double _flutterLogoSize = 50.0;

  bool _showBackToStartFAB = false;

  @override
  void initState() {
    super.initState();
    _scrollController..addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _scrollListener() async {
    final double _position = _scrollController.offset;
    final double _threshold =
        historyFABThreshold * _scrollController.position.maxScrollExtent;
    if (_position <= _threshold && _showBackToStartFAB == true)
      setState(() => _showBackToStartFAB = false);
    else if (_position > _threshold && !_showBackToStartFAB)
      setState(() => _showBackToStartFAB = true);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent &&
        _flutterLogoSize == 50.0) {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        _flutterLogoStyle = FlutterLogoStyle.horizontal;
        _flutterLogoSize = 150.0;
      });
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: informationPageScrollDuration),
        curve: Curves.ease,
      );
    }
  }

  void _openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
        msg: "Cannot open webpage",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: toastFontSize,
      );
    }
  }

  TextSpan _romanText(String text, [GestureRecognizer recognizer]) {
    return TextSpan(
      text: text,
      style: recognizer == null ? textInfoText : textInfoLink,
      recognizer: recognizer,
    );
  }

  TextSpan _italicRomanText(String text) =>
      TextSpan(text: text, style: textInfoTextItalic);

  TextSpan _kulitanText(String text) =>
      TextSpan(text: text, style: kulitanInfoText);

  @override
  Widget build(BuildContext context) {
    final double _width = MediaQuery.of(context).size.width;

    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding,
          headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: IconButtonNew(
          icon: Icons.arrow_back_ios,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: () => Navigator.of(context).pop(),
        ),
        right: IconButtonNew(
          icon: Icons.settings,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: null,
        ),
      ),
    );

    final Widget _about = Column(
      children: <Widget>[
        Paragraphs(
          padding: 0.0,
          paragraphs: <TextSpan>[
            _romanText(
                'This mobile application was developed with the goal of providing an easily accessible way for learning the Kulitan script (Súlat Kapampángan) with ease of use in mind. This application was not meant as a substitute for formal learning of the script through workshops and seminars. It provides just a glimpse of what the script has to offer aside from being the perfect and most appropriate script for writing the Kapampangan language.'),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: aboutSubtitleTopPadding),
          child: Text('The Developer', style: textAboutSubtitle),
        ),
        ImageWithCaption(
          filename: 'keith.jpg',
          screenWidth: _width,
        ),
        Paragraphs(
          paragraphs: [
            _romanText(
                'Keith Liam Manaloto is currently an undergraduate Computer Science student at the University of the Philippines Los Baños. He is a Kapampangan resident of Angeles City. His development of this aplication was primarily driven by his passion to preserve the culture and heritage of his hometown. During his free time, he likes to travel, take photographs, listen to podcasts, and read tech news & articles.'),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(top: paragraphTopPadding),
          child: IntrinsicWidth(
            child: Column(
              children: <Widget>[
                SocialMediaLink(
                  filename: 'twitter.png',
                  name: 'KeithManaloto_',
                  link: 'https://twitter.com/KeithManaloto_',
                  topPadding: 0.0,
                ),
                SocialMediaLink(
                  filename: 'instagram.png',
                  name: 'keithliam',
                  link: 'https://instagram.com/keithliam',
                ),
                SocialMediaLink(
                  filename: 'behance.png',
                  name: 'keithliam',
                  link: 'https://behance.net/keithliam',
                ),
                SocialMediaLink(
                  filename: 'github.png',
                  name: 'keithliam',
                  link: 'https://github.com/keithliam',
                ),
                SocialMediaLink(
                  filename: 'gmail.png',
                  name: 'keithliamm@gmail.com',
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: aboutSubtitleTopPadding),
          child: Text('Acknowledgements', style: textAboutSubtitle),
        ),
        ImageWithCaption(
          filename: 'mike.jpeg',
          screenWidth: _width,
          captionAlignment: TextAlign.center,
          caption: TextSpan(
            text: 'Michael Raymon M. Pangilinan\n(Siuálâ ding Meángûbié)',
          ),
        ),
        Paragraphs(
          paragraphs: [
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'Special thanks to the “living Kapampangan culture resource center”, Mr. Mike Pangilinan for his extensive research regarding the Kulitan script, for making sure that the application\'s contents were correct, and for his big contribution to the Information pages. His comments and suggestions led to significant improvements of this mobile application. Visit his website at '),
                _romanText(
                  'siuala.com',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL('http://siuala.com/'),
                ),
                _romanText(
                    ' for more information about Kapampangan language, script, history, cuisine, culture, and heritage.'),
              ],
            ),
            _romanText(
                'I would also like to thank Mr. Kevin Bätscher of University of Hawaiʻi for his contributions to the Kulitan keyboard made for the application.'),
            _romanText(
                'Lastly, I am most grateful to my girlfriend, Shaira Lapus, for motivating me to do my best and to deliver the best application that I could possibly create. She also did most of the laborous plotting work for the Kulitan strokes in the writing page. Thank you, love.')
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: aboutSubtitleTopPadding),
          child: Text('Resources', style: textAboutSubtitle),
        ),
        Padding(
          padding: const EdgeInsets.only(top: paragraphTopPadding),
          child: RichText(
            text: TextSpan(
              style: textAboutFooter,
              children: <TextSpan>[
                _romanText('This application was developed using '),
                _romanText(
                  'Flutter',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL('https://flutter.io/'),
                ),
                _romanText('.'),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 20.0,
            bottom: aboutVerticalScreenPadding,
          ),
          child: FlutterLogo(
            size: _flutterLogoSize,
            style: _flutterLogoStyle,
            textColor: paragraphTextColor,
          ),
        ),
        // Kulitan Font download
        // This application was developed as Special Problem blabla see the paper at blabla
      ],
    );

    List<Widget> _pageStack = [
      Scrollbar(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: <Widget>[
              StickyHeading(
                headingText: 'Reng Gínawá',
                content: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    aboutHorizontalScreenPadding,
                    aboutVerticalScreenPadding,
                    aboutHorizontalScreenPadding,
                    aboutVerticalScreenPadding - headerVerticalPadding + 8.0,
                  ),
                  child: _about,
                ),
              ),
            ],
          ),
        ),
      ),
      _header,
    ];

    if (_showBackToStartFAB) {
      _pageStack.add(
        BackToStartButton(
          onPressed: () {
            _scrollController.animateTo(
              0.0,
              duration:
                  const Duration(milliseconds: informationPageScrollDuration),
              curve: informationPageScrollCurve,
            );
          },
        ),
      );
    }

    return Material(
      color: backgroundColor,
      child: SafeArea(
        child: Stack(
          children: _pageStack,
        ),
      ),
    );
  }
}
