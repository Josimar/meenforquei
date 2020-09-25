import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {

  final String text;
  final Color cor;
  final Color textColor;
  final double fontSize;
  final TextAlign textAlign;

  CustomText({@required this.text, this.cor = Colors.transparent,
    this.textColor = Colors.white,
    this.fontSize = 32, this.textAlign = TextAlign.center});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      color: cor,
      child: Text(text,
        style: TextStyle(color: textColor, fontSize: fontSize),
        textAlign: textAlign,
      ),
    );
  }
}
