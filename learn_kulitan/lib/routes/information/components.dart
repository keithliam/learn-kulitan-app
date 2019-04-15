import 'package:flutter/material.dart';
import '../../styles/theme.dart';

class KulitanInfoCell extends StatelessWidget {
  KulitanInfoCell(this.kulitan, this.caption);

  final String kulitan;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                kulitan,
                style: kulitanInfo,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                caption,
                style: textInfoCaption,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
