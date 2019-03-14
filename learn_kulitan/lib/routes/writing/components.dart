import 'package:flutter/material.dart';
import '../../components/misc/CustomCard.dart';
import '../../components/misc/LinearProgressBar.dart';
import '../../styles/theme.dart';

class AnimatedWritingCard extends StatefulWidget {
  AnimatedWritingCard({
    @required this.kulitan,
    @required this.progress,
    @required this.cardNumber,
  });

  final String kulitan;
  final double progress;
  final int cardNumber;

  @override
  _AnimatedWritingCardState createState() => _AnimatedWritingCardState();
}

class _AnimatedWritingCardState extends State<AnimatedWritingCard> {
  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.symmetric(vertical: cardWritingVerticalPadding),
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, cardWritingVerticalPadding),
            alignment: Alignment.center,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.kulitan,
                style: kulitanWriting,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Padding(
              padding: const EdgeInsets.only(
                left: cardWritingHorizontalPadding,
                right: cardWritingHorizontalPadding,
              ),
              child: LinearProgressBar(
                progress: widget.progress,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
