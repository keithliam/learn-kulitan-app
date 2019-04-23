import 'package:flutter/material.dart';
import '../../styles/theme.dart';

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
