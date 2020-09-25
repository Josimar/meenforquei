import 'package:flutter/material.dart';
import 'package:meenforquei/components/default_button.dart';

class QuizResults extends StatefulWidget {

  final int correct, incorrect, total;

  QuizResults({@required this.correct, @required this.incorrect, @required this.total});

  @override
  _QuizResultsState createState() => _QuizResultsState();
}

class _QuizResultsState extends State<QuizResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Text("${widget.correct}/${widget.total}", style: TextStyle(fontSize: 25),),
                // SizedBox(height: 8),
                Text(
                  // "You answered ${widget.correct} answer correctly and ${widget.incorrect} answer incorrectly",
                  "Your answer was registered, thank you",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: DefaultButton(
                      "Go back",
                      MediaQuery.of(context).size.width/2
                  ),
                )
              ],
            )
        ),
      ),
    );
  }
}
