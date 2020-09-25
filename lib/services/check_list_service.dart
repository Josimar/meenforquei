import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meenforquei/models/check_list_model.dart';

class CheckListService {

  String _sistema = "checklist";

  final CollectionReference _checklistCollectionReference = Firestore.instance.collection('wedding');

  Future<DocumentSnapshot> getCheckListById(String wedID, String id) {
    return _checklistCollectionReference.document(wedID).collection(_sistema).document(id).get();
  }

  Stream<QuerySnapshot> getCheckListAsStream(String wedID) {
    return _checklistCollectionReference.document(wedID).collection(_sistema).snapshots();
  }

  Future<QuerySnapshot> getCheckList(String wedID) {
    return _checklistCollectionReference.document(wedID).collection(_sistema).getDocuments();
  }

  Future deleteCheckList(String wedID, String documentId) async {
    CollectionReference _checklistCollectionReference = Firestore.instance
        .collection('wedding').document(wedID)
        .collection(_sistema);

    await _checklistCollectionReference.document(documentId).delete();
  }

  Future getCheckListOnce(String wedID) async {
    CollectionReference _checklistCollectionReference = Firestore.instance
        .collection('wedding').document(wedID)
        .collection(_sistema);

    try {
      var checklistDocumentSnapshot = await _checklistCollectionReference.orderBy('order').getDocuments();
      if (checklistDocumentSnapshot.docs.isNotEmpty){
        return checklistDocumentSnapshot.docs
            .map((snapshot) => CheckListModel.fromMap(snapshot.data(), snapshot.id))
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

  Future getCheckListTask(String wedID, String checkID) async {
    CollectionReference _checklistCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection(_sistema).doc(checkID)
        .collection('tasks');

    try {
      var checklistDocumentSnapshot = await _checklistCollectionReference.orderBy('order').getDocuments();
      if (checklistDocumentSnapshot.docs.isNotEmpty){
        return checklistDocumentSnapshot.docs
            .map((snapshot) => CheckListModel.fromMap(snapshot.data(), snapshot.documentID))
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

  Future<DocumentReference> addCheckList(String wedID, String pId, Map data) {
    return _checklistCollectionReference.document(wedID).collection(_sistema).document(pId).collection('tasks').add(data);
  }

  Future<DocumentReference> addPeriodoCheckList(String wedID, Map data) {
    return _checklistCollectionReference.document(wedID).collection(_sistema).add(data);
  }

}