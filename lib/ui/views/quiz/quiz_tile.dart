import 'package:flutter/material.dart';

class QuizTile extends StatefulWidget {
  final String option, description, correctAnswer, optionSelected;

  QuizTile({@required this.option, @required this.description, @required this.correctAnswer, @required this.optionSelected});

  @override
  _QuizTileState createState() => _QuizTileState();
}

class _QuizTileState extends State<QuizTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: <Widget>[
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                border: Border.all(
                    color: widget.description == widget.optionSelected ?
                    widget.optionSelected == widget.correctAnswer ?
                    Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.7)
                        : Colors.grey, width: 1.4),
                borderRadius: BorderRadius.circular(30)
            ),
            alignment: Alignment.center,
            child: Text("${widget.option}",
                style: TextStyle(color: widget.description == widget.optionSelected ?
                widget.optionSelected == widget.correctAnswer ?
                Colors.green.withOpacity(0.7) : Colors.red.withOpacity(0.5)
                    : Colors.grey)
            ),
          ),
          SizedBox(width: 8),
          Text(widget.description, style: TextStyle(fontSize: 18, color: Colors.black54))
        ],
      ),
    );
  }
}
