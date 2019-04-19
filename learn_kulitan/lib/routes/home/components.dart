import 'package:flutter/material.dart';
import '../../components/buttons/CustomButton.dart';
import '../../components/misc/LinearProgressBar.dart';
import '../../styles/theme.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({
    @required this.title,
    @required this.route,
    @required this.kulitanText,
    @required this.kapampanganText,
    this.height,
    this.progress = -1,
    this.padRight,
  });

  final List<Widget> kulitanText;
  final double height;
  final String title;
  final String route;
  final String kapampanganText;
  final double progress;
  final double padRight;

  @override
  Widget build(BuildContext context) {
    List<Widget> _title = [
      Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(title, style: textHomeButton),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(kapampanganText, style: textHomeButtonSub),
              ),
            ],
          ),
        ),
      ),
    ];

    if (progress > 0)
      _title.add(
        LinearProgressBar(height: 15.0, progress: progress),
      );

    return CustomButton(
      onPressed: () => Navigator.pushNamed(context, route),
      elevation: 10.0,
      borderRadius: 30.0,
      height: 100.0,
      padding: const EdgeInsets.only(right: 20.0),
      marginTop: 7.0,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 60.0,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15.0),
              margin: EdgeInsets.only(left: 10.0, right: padRight ?? 0.0),
              child: FittedBox(
                fit: BoxFit.fitHeight,
                child: Column(
                  children: kulitanText.map((kulit) {
                    return SizedBox(
                      width: 40.0,
                      child: FittedBox(
                        fit: BoxFit.fitWidth,
                        child: kulit,
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              child: Column(children: _title),
            ),
          ),
        ],
      ),
    );
  }
}
