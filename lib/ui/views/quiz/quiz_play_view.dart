import 'package:flutter/material.dart';
import 'package:meenforquei/models/quiz_model.dart';
import 'package:meenforquei/models/user_model.dart';
import 'package:meenforquei/ui/views/quiz/quiz_results.dart';
import 'package:meenforquei/ui/views/quiz/quiz_tile.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/viewmodel/quiz_view_model.dart';
import 'package:provider/provider.dart';

class PlayQuizView extends StatefulWidget {
  final QuizModel edittingQuiz;
  final UserModel currentUser;

  PlayQuizView({Key key, this.edittingQuiz, this.currentUser}) : super(key: key);

  @override
  _PlayQuizViewState createState() => _PlayQuizViewState();
}

int total = 0;
int _correct = 0;
int _incorrect = 0;
int _notAttempted = 0;

class _PlayQuizViewState extends State<PlayQuizView> {

  Padding errorData(AsyncSnapshot snapshot){
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Error: ${snapshot.error}"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('| => Quiz Play View'); // ToDo: print Quiz

    final quizProvider = Provider.of<QuizViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Quiz"), //appBar(context),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        brightness: Brightness.light,
        // iconTheme: IconThemeData(color: Colors.black54),
      ),
      body: new FutureBuilder<QuizModel>(
        future: quizProvider.fetchQuizQuestion(widget.edittingQuiz),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return Text(MEString.carregando);
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) return errorData(snapshot);

              return Container(
                child: Column(
                  children: <Widget>[
                    quizProvider.quizItem.question == null ?
                    Container(
                      child: Text(MEString.emptyList)
                    ) :
                    ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: 1,
                        itemBuilder: (context, index){

                          return QuizPlayTile(
                               index: index
                          );

                        }
                    )
                  ],
                ),
              );
          }
          return null;
        }
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => QuizResults(
                correct: _correct,
                incorrect: _incorrect,
                total: total,
              )
          ));
        },
      ),
    );
  }
}

class QuizPlayTile extends StatefulWidget {
  final int index;

  QuizPlayTile({this.index});

  @override
  _QuizPlayTileState createState() => _QuizPlayTileState();
}

class _QuizPlayTileState extends State<QuizPlayTile> {
  String optionSelected = "";

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizViewModel>(context);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10),
          Text("Q${widget.index+1} - ${quizProvider.quizItem.question}", style: TextStyle(fontSize: 18, color: Colors.black87)),
          SizedBox(height: 12),
          GestureDetector(
            onTap: (){
              if (!quizProvider.quizItem.answered){
                // correct
                if (quizProvider.quizItem.option1 == quizProvider.quizItem.correctionOption){
                  optionSelected = quizProvider.quizItem.option1;
                  quizProvider.quizItem.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted -1;
                  setState(() {});
                }else{
                  optionSelected = quizProvider.quizItem.option1;
                  quizProvider.quizItem.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted -1;
                  setState(() {});
                }
                quizProvider.answerQuiz(quizProvider.quizItem.quizId, quizProvider.quizItem.questionId, 1);
              }
            },
            child: QuizTile(
              correctAnswer: quizProvider.quizItem.correctionOption,
              description: quizProvider.quizItem.option1,
              option: "A",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(height: 4),
          GestureDetector(
            onTap: (){
              if (!quizProvider.quizItem.answered){
                // correct
                if (quizProvider.quizItem.option2 == quizProvider.quizItem.correctionOption){
                  optionSelected = quizProvider.quizItem.option2;
                  quizProvider.quizItem.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted -1;
                  setState(() {});
                }else{
                  optionSelected = quizProvider.quizItem.option2;
                  quizProvider.quizItem.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted -1;
                  setState(() {});
                }
                quizProvider.answerQuiz(quizProvider.quizItem.quizId, quizProvider.quizItem.questionId, 2);
              }
            },
            child: QuizTile(
              correctAnswer: quizProvider.quizItem.correctionOption,
              description: quizProvider.quizItem.option2,
              option: "B",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(height: 4),
          GestureDetector(
            onTap: (){
              if (!quizProvider.quizItem.answered){
                // correct
                if (quizProvider.quizItem.option3 == quizProvider.quizItem.correctionOption){
                  optionSelected = quizProvider.quizItem.option3;
                  quizProvider.quizItem.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted -1;
                  setState(() {});
                }else{
                  optionSelected = quizProvider.quizItem.option3;
                  quizProvider.quizItem.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted -1;
                  setState(() {});
                }
                quizProvider.answerQuiz(quizProvider.quizItem.quizId, quizProvider.quizItem.questionId, 3);
              }
            },
            child: QuizTile(
              correctAnswer: quizProvider.quizItem.correctionOption,
              description: quizProvider.quizItem.option3,
              option: "C",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(height: 4),
          GestureDetector(
            onTap: (){
              if (!quizProvider.quizItem.answered){
                // correct
                if (quizProvider.quizItem.option4 == quizProvider.quizItem.correctionOption){
                  optionSelected = quizProvider.quizItem.option4;
                  quizProvider.quizItem.answered = true;
                  _correct = _correct + 1;
                  _notAttempted = _notAttempted -1;
                  setState(() {});
                }else{
                  optionSelected = quizProvider.quizItem.option4;
                  quizProvider.quizItem.answered = true;
                  _incorrect = _incorrect + 1;
                  _notAttempted = _notAttempted -1;
                  setState(() {});
                }
                quizProvider.answerQuiz(quizProvider.quizItem.quizId, quizProvider.quizItem.questionId, 4);
              }
            },
            child: QuizTile(
              correctAnswer: quizProvider.quizItem.option1,
              description: quizProvider.quizItem.option4,
              option: "D",
              optionSelected: optionSelected,
            ),
          ),
          SizedBox(height: 20)
        ],
      ),
    );
  }
}

