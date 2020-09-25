import 'package:flutter/foundation.dart';

class TarefaModel {
  String tid; // tarefa id - documentId
  final String cid; // quem criou
  String rid; // quem é o responsavel
  final String title;
  String description;
  String date;
  bool complete;
  String updated;
  bool deleted;

  TarefaModel({
    @required this.cid,
    @required this.title,
    @required this.description,
    this.tid,
    this.rid,
    this.date,
    this.updated,
    this.deleted,
    this.complete
  });

  Map<String, dynamic> toMap() {
    return {
      'tid': tid,
      'cid': cid,
      'rid': rid,
      'title': title,
      'description': description,
      'date': date,
      'complete': complete,
      'updated': updated,
      'deleted': deleted,
    };
  }

  static TarefaModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return TarefaModel(
      tid: documentId,
      cid: map['cid'],
      rid: map['rid'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      complete: map['complete'],
      updated: map['updated'],
      deleted: map['deleted'],
    );
  }
}
