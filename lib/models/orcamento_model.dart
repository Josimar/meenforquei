import 'package:flutter/material.dart';

class OrcamentoModel {
  final String title;
  final String description;
  final String imageurl;
  final String date;

  final String uid; // usuarios id
  final String did; // dpcument id

  OrcamentoModel({
    @required this.title,
    this.description,
    this.imageurl,
    this.date,
    this.uid,
    this.did
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageurl': imageurl,
      'description': description,
      'date': date
    };
  }

  static OrcamentoModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return OrcamentoModel(
        title: map['title'],
        imageurl: map['imageurl'],
        description: map['description'],
        date: map['date'],
        did: map['documentId']
    );
  }
}
