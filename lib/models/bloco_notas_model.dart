import 'package:flutter/material.dart';

class BlocoNotasModel {
  final String title;
  final String description;
  final String type;
  final String imageurl;
  final String date;

  final String uid; // usuarios id
  final String did; // dpcument id

  BlocoNotasModel({
    @required this.title,
    this.description,
    this.imageurl,
    this.type,
    this.date,
    this.uid,
    this.did
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageurl': imageurl,
      'type': type,
      'date': date
    };
  }

  static BlocoNotasModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return BlocoNotasModel(
        title: map['title'],
        imageurl: map['imageurl'],
        description: map['description'],
        date: map['date'],
        type: map['type'],
        did: map['documentId']
    );
  }
}
