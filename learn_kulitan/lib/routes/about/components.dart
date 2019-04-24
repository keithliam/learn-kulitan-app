import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart'
    show TapGestureRecognizer, GestureRecognizer;
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../styles/theme.dart';

class SocialMediaLink extends StatelessWidget {
  const SocialMediaLink({
    @required this.filename,
    @required this.name,
    this.topPadding = 8.0,
    this.link,
  });

  final String filename;
  final String name;
  final double topPadding;
  final String link;

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
                style: link == null
                    ? textInfoText
                    : textInfoText.copyWith(
                        decoration: TextDecoration.underline
                      ),
                recognizer: link == null
                    ? null
                    : (TapGestureRecognizer()..onTap = () => _openURL(link)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
