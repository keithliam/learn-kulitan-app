import 'package:flutter/material.dart';

class StaticHeader extends StatefulWidget {
  StaticHeader({
    this.left = const Spacer(),
    this.middle,
    this.right = const Spacer(),
  });

  final Widget left;
  final Widget middle;
  final Widget right;

  @override
  _StaticHeader createState() => _StaticHeader();
}

class _StaticHeader extends State<StaticHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        widget.left,
        widget.middle == null
            ? const Spacer()
            : Expanded(
                child: widget.middle,
              ),
        widget.right,
      ],
    );
  }
}
