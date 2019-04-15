import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../styles/theme.dart';

class StickyHeading extends StatelessWidget {
  StickyHeading({this.headingText, this.content});

  final String headingText;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
      header: Container(
        alignment: Alignment.center,
        color: backgroundColor,
        padding: const EdgeInsets.only(
          top: headerVerticalPadding - 8.0,
          bottom: headerVerticalPadding,
        ),
        child: Text(headingText, style: textPageTitle),
      ),
      content: content,
    );
  }
}
