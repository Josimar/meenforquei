import 'package:flutter/material.dart';

class VerticalPadding extends StatelessWidget {
  final double padding;
  final Widget child;
  final Color color;

  VerticalPadding({@required this.child, this.padding = 16, this.color = Colors.transparent});

  @override
  Widget build(BuildContext context) {
    return Container(
        color: color,
        child: child,
        padding: EdgeInsets.symmetric(vertical: padding)
    );
  }
}
