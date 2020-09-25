import 'package:flutter/material.dart';
import 'package:meenforquei/models/quiz_model.dart';
import 'package:meenforquei/ui/widgets/item/quiz_item.dart';
import 'package:meenforquei/viewmodel/quiz_view_model.dart';
import 'package:provider/provider.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';

class QuizView extends StatelessWidget {
  final PageController pageController;
  QuizView(this.pageController);

  Padding errorData(AsyncSnapshot snapshot){
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Error: ${snapshot.error}"),
          /*
          SizedBox(height: 20),
          RaisedButton(
            onPressed: (){
              quizProvider.fetchQuiz();
              setState(() {});
            },
            child: Text("Try again"),
          )
          */
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('| => Quiz View'); // ToDo: print Quiz

    final quizProvider = Provider.of<QuizViewModel>(context);
    bool _podeCriar = false;
    bool _podeEditar = false;

    return Scaffold(
      floatingActionButton: _podeCriar ? FloatingActionButton(
        onPressed: () {
          quizProvider.newQuiz();
        },
        child: Icon(Icons.add),
      ) : null,
      drawer: CustomDrawer(pageController),
      appBar: AppBar(
        title: Text(MEString.titleQuiz),
        centerTitle: true,
      ),
      body: new FutureBuilder<List<QuizModel>>(
        future: quizProvider.fetchQuiz(),
        builder: (context, snapshot) {
          switch(snapshot.connectionState){
            case ConnectionState.none:
              return Text(MEString.carregando);
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasError) return errorData(snapshot);

              return ListView.builder(
                 shrinkWrap: true,
                  itemCount: quizProvider.quiz.length,
                  itemBuilder: (context, index){
                    String quizid = quizProvider.quiz[index].did;
                    String imgUrl = quizProvider.quiz[index].imageurl;
                    String desc = quizProvider.quiz[index].description;
                    String title = quizProvider.quiz[index].title;

                    return GestureDetector(
                      onTap: (){
                        quizProvider.playQuiz(quizTemp: quizProvider.quiz[index]);
                      },
                      child: Container(
                        height: 150,
                        margin: EdgeInsets.only(bottom: 8, top: 8, left: 8, right: 8),
                        child: Stack(
                          children: <Widget>[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(imgUrl,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.black38,
                              ),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(title, style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w500)),
                                  SizedBox(height: 6),
                                  Text(desc, style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400))
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
              );
          }
          return null;
        }
      )
    );

  }
}