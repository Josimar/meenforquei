import 'package:flutter/material.dart';

class CheckListModel {
  String title;
  String description;
  String order;
  String date;
  bool finished;
  String dpid; // IDPai

  List<CheckListModel> tasks;

  final String uid; // usuarios id
  final String did; // dpcument id

  CheckListModel({
    @required this.title,
    this.description,
    this.order,
    this.date,
    this.finished,
    this.uid,
    this.did,
    this.dpid
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description == null || description.isEmpty ? title : description,
      'order': order,
      'date': date == null ? DateTime.now().toString() : date,
    };
  }

  static CheckListModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return CheckListModel(
        title: map['title'],
        description: map['description'],
        order: map['order'],
        date: map['date'],
        finished: map['finished'] == null || map['finished'] == '' ? false : map['finished'],
        did: documentId
    );
  }
}
