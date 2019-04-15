import 'package:flutter/material.dart';
import '../../../styles/theme.dart';
import '../../../components/buttons/IconButtonNew.dart';
import '../../../components/misc/StaticHeader.dart';

class WritingGuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        middle: Padding(
          padding: const EdgeInsets.only(bottom: headerVerticalPadding),
          child: Center(
            child: Text('History', style: textPageTitle),
          ),
        ),
        right: IconButtonNew(
          icon: Icons.settings,
          iconSize: headerIconSize,
          color: headerNavigationColor,
          onPressed: null,
        ),
      ),
    );

    return Material(
      color: backgroundColor,
      child: SafeArea(
        child: Column(
          children: <Widget>[
            _header,
            Expanded(
              child: Scrollbar(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Indûng Súlat',
                        style: textPageTitle,
                      ),
                      Text(
                        'Indûng Súlat',
                        style: textPageTitle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
