import 'package:flutter/material.dart';
import '../../../styles/theme.dart';
import '../../../components/buttons/CustomButton.dart';

class ImageWithCaption extends StatelessWidget {
  const ImageWithCaption({
    @required this.filename,
    @required this.screenWidth,
    this.captionAlignment = TextAlign.justify,
    this.caption,
    this.subcaption,
    this.hasPadding = true,
    this.orientation = Axis.vertical,
    this.borderRadius = 0.03623,
  });

  final String filename;
  final TextSpan caption;
  final String subcaption;
  final double screenWidth;
  final TextAlign captionAlignment;
  final bool hasPadding;
  final Axis orientation;
  final double borderRadius;

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
            borderRadius: BorderRadius.circular(borderRadius * screenWidth),
            child: Image.asset(
              'assets/images/$filename',
              width: screenWidth * (orientation == Axis.vertical ? 0.5 : 0.75),
              fit: BoxFit.fitWidth,
            ),
          ),
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
          .add(Center(child: Text(subcaption, style: textInfoImageSubCaption)));

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

class Paragraphs extends StatelessWidget {
  const Paragraphs({
    @required this.paragraphs,
    this.padding = paragraphTopPadding,
    this.textAlign = TextAlign.justify,
  });

  final List<TextSpan> paragraphs;
  final double padding;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: paragraphs.map((text) {
        return Padding(
          padding: EdgeInsets.only(top: padding),
          child: RichText(
            text: TextSpan(children: <TextSpan>[text]),
            textAlign: textAlign,
          ),
        );
      }).toList(growable: false),
    );
  }
}

class GuideButton extends StatelessWidget {
  const GuideButton({
    @required this.text,
    @required this.controller,
    @required this.pageNumber,
  });

  final String text;
  final PageController controller;
  final int pageNumber;

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      marginTop: 7.5,
      onPressed: () => controller.animateToPage(pageNumber,
          duration: const Duration(milliseconds: informationPageScrollDuration),
          curve: informationPageScrollCurve),
      borderRadius: 30.0,
      padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
      elevation: 7.5,
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(text, style: textGuideButton),
            ),
            Container(width: 5.0),
            Text('>', style: textGuideButton.copyWith(color: accentColor)),
          ],
        ),
      ),
    );
  }
}
