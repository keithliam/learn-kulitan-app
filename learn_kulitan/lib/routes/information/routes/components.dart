import 'package:flutter/material.dart';
import '../../../styles/theme.dart';

class ImageWithCaption extends StatelessWidget {
  const ImageWithCaption({
    @required this.filename,
    @required this.caption,
    @required this.screenWidth,
    this.subcaption,
    this.orientation = Axis.vertical,
  });

  final String filename;
  final TextSpan caption;
  final String subcaption;
  final double screenWidth;
  final Axis orientation;

  @override
  Widget build(BuildContext context) {
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(0.03623 * screenWidth),
            child: Image.asset(
              'assets/images/$filename',
              width: screenWidth * (orientation == Axis.vertical ? 0.5 : 0.75),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(
          imageCaptionHorizontalPadding,
          imageCaptionTopPadding,
          imageCaptionHorizontalPadding,
          0.0,
        ),
        child: Center(
          child: Text.rich(
            caption,
            textAlign: TextAlign.justify,
            style: textInfoImageCaption,
          ),
        ),
      ),
    ];

    if (subcaption != null)
      _list
          .add(Center(child: Text(subcaption, style: textInfoImageSubCaption)));

    return Column(children: _list);
  }
}

class Paragraphs extends StatelessWidget {
  const Paragraphs({
    @required this.paragraphs,
    this.textAlign = TextAlign.justify,
  });

  final List<TextSpan> paragraphs;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: paragraphs.map((text) {
        return Padding(
          padding: const EdgeInsets.only(top: paragraphTopPadding),
          child: Text.rich(
            text,
            textAlign: textAlign,
            style: textInfoText,
          ),
        );
      }).toList(growable: false),
    );
  }
}
