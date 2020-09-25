import 'package:flutter/material.dart';
import 'package:meenforquei/models/user_model.dart';

class QuizModel {
  UserModel user;

  String question, option1, option2, option3, option4, correctionOption;
  String quizId, questionId;
  bool answered;

  String category;
  String type;
  String difficulty;
  String correctAnswer;
  List<String> allAnswers;

  String title;
  String description;
  String imageurl;
  String date;

  String uid; // usuarios id
  String did; // dpcument id

  QuizModel(this.user);

  QuizModel.all({
    this.quizId,
    this.did,
    @required this.title,
    this.imageurl,
    this.description,
    this.date
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageurl': imageurl,
      'description': description,
      'date': date
    };
  }

  toJson() {
    return {
      'did': did,
      'title': title,
      'imageurl': imageurl,
      'description': description,
      'date': date
    };
  }

  toAnswer(qtd){
    return {
      'qtdoption' + qtd.toString(): qtd
    };
  }

  static QuizModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return QuizModel.all(
      quizId: documentId,
      did: documentId,
      title: map['title'],
      imageurl: map['imageurl'],
      description: map['description'],
      date: map['date'],
    );
  }
}
