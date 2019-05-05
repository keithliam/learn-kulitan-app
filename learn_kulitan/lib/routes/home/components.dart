import 'package:flutter/material.dart';
import '../../components/buttons/CustomButton.dart';
import '../../components/misc/LinearProgressBar.dart';
import '../../styles/theme.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({
    @required this.title,
    @required this.route,
    @required this.kulitanText,
    @required this.subtitle,
    @required this.buttonGroup,
    @required this.disabled,
    @required this.onPressedImmediate,
    this.reload,
    this.height,
    this.progress = -1,
    this.padRight,
  });

  final List<Widget> kulitanText;
  final double height;
  final String title;
  final String route;
  final String subtitle;
  final double progress;
  final double padRight;
  final bool disabled;
  final VoidCallback reload;
  final VoidCallback onPressedImmediate;
  final CustomButtonGroup buttonGroup;

  void _onPressed(BuildContext context) {
    if (reload != null) {
      Navigator.pushNamed(context, route).then((_) => reload());
    } else {
      Navigator.pushNamed(context, route);
    }
  }

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
              FittedBox(
                fit: BoxFit.contain,
                child: Text(title, style: textHomeButton),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Text(subtitle, style: textHomeButtonSub),
              ),
            ],
          ),
        ),
      ),
    ];

    if (progress > 0)
      _title.add(
        LinearProgressBar(
          height: MediaQuery.of(context).size.width > 340.0 ? 15.0 : 11.0,
          progress: progress,
        ),
      );

    return CustomButton(
      onPressed: () => _onPressed(context),
      elevation: MediaQuery.of(context).size.height > 600.0 ? 10.0 : 7.0,
      borderRadius: 30.0,
      height: 100.0,
      padding: const EdgeInsets.only(right: 20.0),
      marginTop: 7.0,
      buttonGroup: buttonGroup,
      disable: disabled,
      onPressedImmediate: onPressedImmediate,
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
