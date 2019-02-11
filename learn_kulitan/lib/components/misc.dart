import 'package:flutter/material.dart';
import '../styles/theme.dart';

class SlideLeftRoute extends PageRouteBuilder {
  final Widget widget;
  SlideLeftRoute({this.widget})
      : super(pageBuilder: (BuildContext context, Animation<double> animation,
            Animation<double> secondaryAnimation) {
          return widget;
        }, transitionsBuilder: (BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child) {
          return new SlideTransition(
            position: new Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        });
}

class ProgressBar extends StatelessWidget {
  ProgressBar({
    @required this.type,
    @required this.height,
    @required this.progress,
    @required this.offset,
  });

  static const int linear = 0;
  static const int circular = 1;

  final int type;
  final double height;
  final double progress;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100.0),
      child: Container(
          height: this.height,
          alignment: Alignment.centerLeft,
          color: snowColor,
          child: Container(
            width: (MediaQuery.of(context).size.width - this.offset) *
                this.progress,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              color: accentColor,
            ),
          )),
    );
  }
}