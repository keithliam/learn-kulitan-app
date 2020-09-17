import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../styles/theme.dart';
import '../../db/GameData.dart';

class ImageWithCaption extends StatelessWidget {
  const ImageWithCaption({
    @required this.filename,
    @required this.screenWidth,
    this.captionAlignment = TextAlign.justify,
    this.caption,
    this.subcaption,
    this.imageLink,
    this.hasPadding = true,
    this.orientation = Axis.vertical,
    this.borderRadius = 0.03623,
    this.percentWidth,
    this.hasBorder = false,
  });

  final String filename;
  final TextSpan caption;
  final String subcaption;
  final double screenWidth;
  final TextAlign captionAlignment;
  final String imageLink;
  final bool hasPadding;
  final Axis orientation;
  final double borderRadius;
  final double percentWidth;
  final bool hasBorder;

  static final GameData _gameData = GameData();

  void _openURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Fluttertoast.showToast(
        msg: "Cannot open webpage",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 3,
        backgroundColor: _gameData.getColor('toastBackground'),
        textColor: _gameData.getColor('toastForeground'),
        fontSize: toastFontSize,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget _image = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius * screenWidth),
      child: Image.asset(
        'assets/images/$filename',
        width: screenWidth *
            (percentWidth ?? (orientation == Axis.vertical ? 0.5 : 0.75)),
        fit: BoxFit.fitWidth,
      ),
    );

    if (hasBorder)
      _image = Container(
        padding: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular((borderRadius * screenWidth) + 1.0),
            color: _gameData.getColor('accent')),
        child: _image,
      );

    if (imageLink != null)
      _image = GestureDetector(
        child: _image,
        onTap: () => _openURL(imageLink),
      );

    List<Widget> _list = [
      ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: 10.0,
          maxWidth: 600.0,
          minHeight: 10.0,
          maxHeight: 900.0,
        ),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: _image,
        ),
      ),
    ];

    if (caption != null)
      _list.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(
            imageCaptionHorizontalPadding,
            imageCaptionTopPadding,
            imageCaptionHorizontalPadding,
            0.0,
          ),
          child: Center(
            child: RichText(
              text: caption,
              textAlign: captionAlignment,
            ),
          ),
        ),
      );

    if (subcaption != null)
      _list
          .add(Center(child: Text(subcaption, style: _gameData.getStyle('textInfoImageSubCaption'))));

    final Widget _widget = Column(children: _list);

    if (hasPadding)
      return Padding(
        padding: const EdgeInsets.only(
          top: imageTopPadding,
        ),
        child: _widget,
      );
    else
      return _widget;
  }
}
