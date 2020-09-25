import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meenforquei/locator.dart';
import 'package:meenforquei/models/quiz_model.dart';
import 'package:meenforquei/services/dialog_service.dart';
import 'package:meenforquei/services/navigation_service.dart';
import 'package:meenforquei/services/quiz_service.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/route_names.dart';
import 'package:meenforquei/utils/utilitarios.dart';
import 'package:meenforquei/viewmodel/base_model.dart';

class QuizViewModel extends BaseModel{
  final NavigationService _navigationService = locator<NavigationService>();
  final QuizService _quizService = locator<QuizService>();
  final DialogService _dialogService = locator<DialogService>();

  List<QuizModel> _quiz;
  List<QuizModel> get quiz => _quiz;
  QuizModel quizItem;

  Future<List<QuizModel>> fetchQuiz() async {
    // setBusy(true);
    var quizResult = await _quizService.getQuizOnce(currentUser.wedding);
    // setBusy(false);

    if (quizResult == null){
      quizResult = new List<QuizModel>();
    }

    if (quizResult is List<QuizModel>){
      _quiz = quizResult;
      // notifyListeners();
    }else{
      await _dialogService.showDialog(
          title: MEString.accessFailed,
          description: quizResult != null ? quizResult : MEString.emptyList
      );
    }

    return quizResult;
  }

  void playQuiz({QuizModel quizTemp}) {
    _navigationService.navigateInTo(PlayQuizViewRoute, arguments: RouteArguments(quizTemp, currentUser));
  }

  Future<QuizModel> fetchQuizQuestion(QuizModel quizTemp) async {
    quizItem = quizTemp;

    QuerySnapshot querySnapshot = await _quizService.getQuizQuestion(currentUser.wedding, quizTemp.did);
    if (querySnapshot == null){
      return quizItem;
    }

    if (querySnapshot.docs.length == 0){
      return quizItem;
    }

    DocumentSnapshot docSnapshot = querySnapshot.docs[0];
    quizItem.question = docSnapshot.data()["question"];
    quizItem.questionId = docSnapshot.id;

    List<String> options = [
      docSnapshot.data()["option1"],
      docSnapshot.data()["option2"],
      docSnapshot.data()["option3"],
      docSnapshot.data()["option4"],
    ];
    options.shuffle();

    quizItem.option1 = options[0];
    quizItem.option2 = options[1];
    quizItem.option3 = options[2];
    quizItem.option4 = options[3];
    quizItem.correctionOption = docSnapshot.data()["option1"];
    quizItem.answered = false;

    return quizItem;
  }

  Future<QuizModel> answerQuiz(String quizId, String questionId, int question) async{

    int qtdVotos = await _quizService.getQtdVotos(currentUser.wedding, quizId, questionId, question);
    Map<String,int> data;

    if (question == 1){
      data = {'qtdoption1': qtdVotos + 1};
    }else if (question == 2){
      data = {'qtdoption2': qtdVotos + 1};
    }else if (question == 3){
      data = {'qtdoption3': qtdVotos + 1};
    }else if (question == 4){
      data = {'qtdoption4': qtdVotos + 1};
    }

    await _quizService.answerQuiz(currentUser.wedding, quizId, questionId, data) ;
    // notifyListeners();
    return null;
  }







  void newQuiz(){
    _navigationService.navigateInTo(CreateQuizViewRoute);
  }

  void editQuiz(int index){
    _navigationService.navigateInTo(CreateQuizViewRoute, arguments: _quiz[index]);
  }

  Future deleteQuiz(int index) async {
    var dialogResponse = await _dialogService.showConfirmationDialog(
        title: MEString.temCerteza,
        description: MEString.querExcluir,
        confirmationTitle: MEString.sim,
        cancelTitle: MEString.nao
    );

    if (dialogResponse.confirmed){
      setBusy(true);
      // await _quizService.deleteQuiz(currentUser.wedding, _quiz[index].did); // ToDo: Error
      setBusy(false);
    }
  }

}