import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import '../../styles/theme.dart';
import '../../components/buttons/RoundedBackButton.dart';
import '../../components/buttons/BackToStartButton.dart';
import '../../components/misc/StickyHeading.dart';
import '../../components/misc/StaticHeader.dart';
import '../../components/misc/ImageWithCaption.dart';
import '../../components/misc/Paragraphs.dart';
import '../../db/GameData.dart';

class LearnMorePage extends StatefulWidget {
  const LearnMorePage();
  @override
  _LearnMorePageState createState() => _LearnMorePageState();
}

class _LearnMorePageState extends State<LearnMorePage> {
  static final GameData _gameData = GameData();
  final ScrollController _scrollController = ScrollController();

  bool _showBackToStartFAB = false;

  @override
  void initState() {
    super.initState();
    _scrollController
      ..addListener(() {
        final double _position = _scrollController.offset;
        final double _threshold = informationFABThreshold *
            _scrollController.position.maxScrollExtent;
        if (_position <= _threshold && _showBackToStartFAB == true)
          setState(() => _showBackToStartFAB = false);
        else if (_position > _threshold && !_showBackToStartFAB)
          setState(() => _showBackToStartFAB = true);
      });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
        backgroundColor: _gameData.getColor('toastBackground'),
        textColor: _gameData.getColor('toastForeground'),
        fontSize: toastFontSize,
      );
    }
  }

  TextSpan _romanText(String text, [TapGestureRecognizer recognizer]) {
    return TextSpan(
      text: text,
      style: recognizer == null
          ? _gameData.getStyle('textInfoText')
          : _gameData.getStyle('textInfoLink'),
      recognizer: recognizer,
    );
  }

  void _sendEmail(String emailAddress) {
    FlutterEmailSender.send(Email(
      subject: 'Kulitan Handwriting Font Inquiry',
      recipients: [emailAddress],
    ));
    Fluttertoast.showToast(
      msg: 'Composing email...',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: _gameData.getColor('toastBackground'),
      textColor: _gameData.getColor('toastForeground'),
      fontSize: toastFontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    final MediaQueryData _mediaQuery = MediaQuery.of(context);
    final double _screenWidth = _mediaQuery.size.width;
    final double _screenHorizontalPadding =
        _screenWidth > maxPageWidth ? 0.0 : aboutHorizontalScreenPadding;
    final double _width = _mediaQuery.size.width > maxPageWidth
        ? maxPageWidth
        : _mediaQuery.size.width;

    Widget _header = Padding(
      padding: EdgeInsets.fromLTRB(headerHorizontalPadding,
          headerVerticalPadding, headerHorizontalPadding, 0.0),
      child: StaticHeader(
        left: RoundedBackButton(),
        right: SizedBox(width: 48.0, height: 48.0),
      ),
    );

    final Widget _about = Column(
      children: <Widget>[
        Text('Workshops', style: _gameData.getStyle('textAboutSubtitle')),
        ImageWithCaption(
          filename: 'sinupan.jpg',
          captionAlignment: TextAlign.center,
          caption: TextSpan(
              text:
                  'Sínúpan Singsing:\nCenter for Kapampángan Cultural Heritage'),
          screenWidth: _width,
          borderRadius: 1.0,
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'For a hands-on experience, you may attend basic & advanced Kulitan writing workshops organized by '),
                _romanText(
                  'Sínúpan Singsing: Center for Kapampángan Cultural Heritage',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'https://bit.ly/LearnKulitan-SinupanSingsingFacebookEventsPage'),
                ),
                _romanText(
                    ' in Angeles City, Pampanga. Upcoming events and activites can be viewed on their '),
                _romanText(
                  'Facebook page',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'https://bit.ly/LearnKulitan-SinupanSingsingFacebookEventsPage'),
                ),
                _romanText(
                    '. For related news and articles, you may also visit their official website at '),
                _romanText(
                  'sinupan.org',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'https://bit.ly/LearnKulitan-SinupanSingsingWebsite'),
                ),
                _romanText('.'),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: aboutSubtitleTopPadding),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Facebook Group',
                style: _gameData.getStyle('textAboutSubtitle')),
          ),
        ),
        ImageWithCaption(
          filename: 'kulitan_group.jpg',
          orientation: Axis.horizontal,
          captionAlignment: TextAlign.center,
          caption: TextSpan(text: 'KULITAN\n(Indigenous Kapampangan Script)'),
          subcaption: 'Facebook Group',
          screenWidth: _width,
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                _romanText('A '),
                _romanText(
                  'Facebook group',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL(
                        'https://bit.ly/LearnKulitan-KulitKulitanFacebook'),
                ),
                _romanText(
                    ' exists for Kulitan enthusiasts and those who would like to learn the indigenous Kapampangan script. You may post your own art, photographs, articles, questions, and ideas, as long as they are related to Kulitan.'),
              ],
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: aboutSubtitleTopPadding),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Kulitan Font',
                style: _gameData.getStyle('textAboutSubtitle')),
          ),
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            _romanText(
                'Prior to the development of this app, a modern Kulitan font was created by the developer. This font was designed to be display-friendly, enhancing readability on mobile devices.'),
          ],
        ),
        ImageWithCaption(
          filename: 'kulitan_font.png',
          caption: TextSpan(text: 'Kulitan Handwriting Font'),
          screenWidth: _width,
          hasBorder: true,
          percentWidth: 0.65,
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(
              children: <TextSpan>[
                _romanText(
                    'The OpenType font is free for non-commercial purposes. It is available for download at '),
                _romanText(
                  'Behance.net',
                  TapGestureRecognizer()
                    ..onTap = () => _openURL('https://bit.ly/LearnKulitan-BehanceFont'),
                ),
                _romanText(
                    '. For licensing inquiries, you may contact the developer via email at '),
                _romanText(
                  'keithliamm@gmail.com',
                  TapGestureRecognizer()
                    ..onTap = () => _sendEmail('keithliamm@gmail.com'),
                ),
                _romanText('.'),
              ],
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: aboutSubtitleTopPadding),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text('Kulitan Book',
                style: _gameData.getStyle('textAboutSubtitle')),
          ),
        ),
        ImageWithCaption(
          filename: 'kulitan_book.jpg',
          orientation: Axis.horizontal,
          captionAlignment: TextAlign.center,
          caption: TextSpan(
              text:
                  'An Introduction to Kulitan:\nThe Indigenous Kapampangan Script'),
          subcaption: 'by Michael Raymon M. Pangilinan',
          screenWidth: _width,
        ),
        Paragraphs(
          paragraphs: <TextSpan>[
            TextSpan(children: <TextSpan>[
              _romanText(
                  'To learn more about the history, rules, and uses of Kulitan, you may read the book '),
              _romanText(
                'An Introduction to Kulitan: The Indigenous Kapampangan Script',
                TapGestureRecognizer()
                  ..onTap =
                      () => _openURL('https://bit.ly/LearnKulitan-Siuala'),
              ),
              _romanText(' by '),
              _romanText(
                'Michael Raymon M. Pangilinan',
                TapGestureRecognizer()
                  ..onTap = () => _openURL(
                      'https://bit.ly/LearnKulitan-About-MikePangilinan'),
              ),
              _romanText(' (Siuálâ ding Meángûbié).'),
            ]),
            _romanText(
                'It is important to note that Kulitan shall be used for the Kapampangan language only.'),
          ],
        ),
      ],
    );

    List<Widget> _pageStack = [
      Scrollbar(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxPageWidth),
              child: Column(
                children: <Widget>[
                  StickyHeading(
                    headingText: 'Learn More',
                    content: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(
                        _screenHorizontalPadding,
                        aboutVerticalScreenPadding,
                        _screenHorizontalPadding,
                        aboutVerticalScreenPadding -
                            headerVerticalPadding +
                            8.0,
                      ),
                      child: _about,
                    ),
                  ),
                ],
              ),
            ),
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
      color: _gameData.getColor('background'),
      child: SafeArea(
        child: Stack(children: _pageStack),
      ),
    );
  }
}
