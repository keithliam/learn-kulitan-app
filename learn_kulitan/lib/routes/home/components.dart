import 'package:flutter/material.dart';
import '../../components/buttons/CustomButton.dart';
import '../../components/misc/LinearProgressBar.dart';
import '../../styles/theme.dart';

class HomeButton extends StatelessWidget {
  HomeButton({
    @required this.kulitanTextOffset,
    @required this.title,
    @required this.route,
    this.kulitanText,
    this.kulitanTextCustom,
    this.progress = -1,
  }) : assert(kulitanText != null || kulitanTextCustom != null,
            'Must provide either kultianText or kulitanTextCustom');

  final String kulitanText;
  final Widget kulitanTextCustom;
  final double kulitanTextOffset;
  final String title;
  final String route;
  final double progress;

  Widget buildTitlePart() {
    return this.progress >= 0
        ? Column(children: <Widget>[
            Expanded(
              child: Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 5.0),
                child: Text(this.title, style: textHomeButton),
              ),
            ),
            LinearProgressBar(
                height: 15.0,
                progress: this.progress)
          ])
        : Container(
            alignment: Alignment.centerLeft,
            child: Text(this.title, style: textHomeButton),
          );
  }

  @override
  Widget build(BuildContext context) {
    return CustomButton(
      height: 115.0,
      onPressed: () => Navigator.pushNamed(context, this.route),
      elevation: 10.0,
      borderRadius: 30.0,
      padding: const EdgeInsets.fromLTRB(14.0, 14.0, 20.0, 14.0),
      marginTop: 7.0,
      child: Row(
        children: <Widget>[
          Container(
            width: 67.0,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: this.kulitanTextOffset),
            child: this.kulitanText != null
                ? Text(
                    this.kulitanText,
                    style: kulitanHome,
                    textAlign: TextAlign.center,
                  )
                : this.kulitanTextCustom,
          ),
          Expanded(
            child: buildTitlePart(),
          ),
        ],
      ),
    );
  }
}