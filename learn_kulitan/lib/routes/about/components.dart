import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'
    show TapGestureRecognizer;
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../styles/theme.dart';
import '../../db/GameData.dart';

class SocialMediaLink extends StatelessWidget {
  const SocialMediaLink({
    @required this.filename,
    @required this.name,
    this.topPadding = 8.0,
    this.link,
    this.emailAddress = '',
  });

  final String filename;
  final String name;
  final double topPadding;
  final String link;
  final String emailAddress;

  static final GameData _gameData = GameData();

  void _openURL(String url) async {
    String _message;
    if (await canLaunch(url)) {
      _message = 'Opening link...';
      await launch(url);
    } else {
      _message = 'Cannot open link';
    }
    Fluttertoast.showToast(
      msg: _message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: toastFontSize,
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
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: toastFontSize,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: topPadding),
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10.0),
            height: 30.0,
            width: 30.0,
            child: Container(
              child: Image.asset(
                'assets/images/$filename',
                fit: BoxFit.contain,
              ),
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: name,
                style: link == null && emailAddress == null
                    ? _gameData.getStyle('textInfoText')
                    : _gameData.getStyle('textInfoText').copyWith(
                        decoration: TextDecoration.underline),
                recognizer: link == null && emailAddress == null
                    ? null
                    : (TapGestureRecognizer()
                      ..onTap = () {
                        if (link != null)
                          _openURL(link);
                        else
                          _sendEmail(emailAddress);
                      }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
