import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meenforquei/models/quiz_model.dart';

class QuizService {
  final CollectionReference _quizCollectionReference = Firestore.instance.collection('wedding');

  Future<DocumentSnapshot> getQuizById(String wedID, String id) {
    return _quizCollectionReference.doc(wedID)
        .collection('quiz').doc(id).get();
  }

  Stream<QuerySnapshot> getQuizAsStream(String wedID) {
    return _quizCollectionReference.doc(wedID).collection('quiz').snapshots();
  }

  Future<QuerySnapshot> getQuiz(String wedID) {
    return _quizCollectionReference.doc(wedID).collection('quiz').get();
  }

  Future<QuerySnapshot> getQuizQuestion(String wedID, String quizId) {
    return _quizCollectionReference.doc(wedID)
        .collection('quiz').doc(quizId)
        .collection("questions").get();
  }

  Future getQuizOnce(String wedID) async {
    try {
      var quizDocumentSnapshot = await _quizCollectionReference
          .document(wedID).collection('quiz').get();

      if (quizDocumentSnapshot.docs.isNotEmpty) {
        return quizDocumentSnapshot.docs
            .map((snapshot) =>
            QuizModel.fromMap(snapshot.data(), snapshot.documentID))
            .where((mappedItem) => mappedItem.title != null)
            .toList();
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future<DocumentReference> addQuiz(String wedID, Map data) {
    return _quizCollectionReference.doc(wedID).collection('quiz').add(data);
  }

  Future removeQuiz(String wedID, String id) {
    return _quizCollectionReference.doc(wedID)
        .collection('quiz').doc(id).delete();
  }

  Future<void> updateQuiz(String wedID, String id, Map data) {
    return _quizCollectionReference.doc(wedID)
        .collection('quiz').doc(id).update(data);
  }

  Future<void> answerQuiz(String wedID, String quizId, String questionId, Map data) {
    return _quizCollectionReference.doc(wedID)
        .collection('quiz').doc(quizId)
        .collection('questions').doc(questionId)
        .update(data);
  }

  Future<int> getQtdVotos(String wedID, String quizId, String questionId, int option) async {
    int qtdVotos = 1;

    await _quizCollectionReference.doc(wedID)
        .collection('quiz').doc(quizId)
        .collection('questions').doc(questionId).get().then((DocumentSnapshot ds) {

      if (option == 1){
        print(ds.data()["qtdoption1"]);
        qtdVotos = ds.data()["qtdoption1"] == null || ds.data()["qtdoption1"] == "" ? 1 : ds.data()["qtdoption1"];
      }else if (option == 2){
        print(ds.data()["qtdoption2"]);
        qtdVotos = ds.data()["qtdoption2"] == null || ds.data()["qtdoption2"] == "" ? 1 : ds.data()["qtdoption2"];
      }else if (option == 3){
        print(ds.data()["qtdoption3"]);
        qtdVotos = ds.data()["qtdoption3"] == null || ds.data()["qtdoption3"] == "" ? 1 : ds.data()["qtdoption3"];
      }else if (option == 4){
        print(ds.data()["qtdoption4"]);
        qtdVotos = ds.data()["qtdoption4"] == null || ds.data()["qtdoption4"] == "" ? 1 : ds.data()["qtdoption4"];
      }

    });

    return qtdVotos;
  }

}