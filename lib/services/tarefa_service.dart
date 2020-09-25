import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meenforquei/models/tarefa_model.dart';

class TarefaService {

  String _sistema = "tarefas";

  final CollectionReference _tarefaCollectionReference = Firestore.instance
      .collection('wedding');

  Future<DocumentSnapshot> getTarefaById(String wedID, String id) {
    return _tarefaCollectionReference.doc(wedID)
        .collection(_sistema)
        .doc(id)
        .get();
  }

  Stream<QuerySnapshot> getTarefaAsStream(String wedID) {
    return _tarefaCollectionReference.doc(wedID)
        .collection(_sistema)
        .where('deleted', isEqualTo: false)
        .orderBy("date", descending: true)
        .orderBy("updated", descending: false)
        .snapshots();
  }

  Future getTarefas(String wedID) async {
    CollectionReference _tarefasCollectionReference = Firestore.instance
        .collection("wedding").doc(wedID)
        .collection('tarefas');

    try {
      var tarefasDocumentSnapshot = await _tarefasCollectionReference.orderBy('date', descending: true).getDocuments();
      if (tarefasDocumentSnapshot.docs.isNotEmpty){
        return tarefasDocumentSnapshot.docs
            .map((snapshot) => TarefaModel.fromMap(snapshot.data(), snapshot.documentID))
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

  Future addTarefa(String wedID, TarefaModel tarefa) async {

    CollectionReference _tarefaCollectionReference = Firestore.instance
        .collection('wedding').doc(wedID)
        .collection('tarefas');

    if (tarefa.date == null || tarefa.date == ""){
      tarefa.date = DateTime.now().toString();
    }
    if (tarefa.updated == null || tarefa.updated == ""){
      tarefa.updated = DateTime.now().toString();
    }
    if (tarefa.rid == null || tarefa.rid == ""){
      tarefa.rid = tarefa.cid;
    }
    if (tarefa.complete == null){
      tarefa.complete = false;
    }
    if (tarefa.deleted == null){
      tarefa.deleted = false;
    }

    try {
      await _tarefaCollectionReference.add(tarefa.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future updateTarefa(String wedID, TarefaModel tarefa) async {
    CollectionReference _tarefaCollectionReference = Firestore.instance
        .collection('wedding').doc(wedID)
        .collection('tarefas');

    if (tarefa.date == null || tarefa.date == ""){
      tarefa.date = DateTime.now().toString();
    }
    if (tarefa.updated == null || tarefa.updated == ""){
      tarefa.updated = DateTime.now().toString();
    }
    if (tarefa.rid == null || tarefa.rid == ""){
      tarefa.rid = tarefa.cid;
    }
    if (tarefa.complete == null){
      tarefa.complete = false;
    }
    if (tarefa.deleted == null){
      tarefa.deleted = false;
    }

    try {
      await _tarefaCollectionReference.doc(tarefa.tid).updateData(tarefa.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future deleteTarefa(String wedID, String documentId, bool isDeleted) async {
    CollectionReference _tarefaCollectionReference = Firestore.instance
        .collection('wedding').doc(wedID)
        .collection('tarefas');

    try {
      if (isDeleted){
        await _tarefaCollectionReference.doc(documentId).delete();
      }else{
        await _tarefaCollectionReference.doc(documentId).update({'deleted': true});
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future recuperaTarefa(String wedID, String documentId) async {
    CollectionReference _tarefaCollectionReference = Firestore.instance
        .collection('wedding').doc(wedID)
        .collection('tarefas');

    try {
      await _tarefaCollectionReference.doc(documentId).update({'deleted': false});
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }


}