import 'package:flutter/material.dart';

class AgendaModel {
  final String title;
  final String description;
  final String order;
  final DateTime date;

  final String uid; // usuarios id
  final String did; // dpcument id

  AgendaModel({
    this.title,
    this.description,
    this.order,
    this.date,
    this.uid,
    this.did
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'order': order,
      'date': date
    };
  }

  static AgendaModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return AgendaModel(
        title: map['title'],
        description: map['description'],
        order: map['order'],
        date: DateTime.parse(map['date']),
        did: documentId
    );
  }
}
