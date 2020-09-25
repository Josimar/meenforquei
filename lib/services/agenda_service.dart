import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:meenforquei/models/agenda_model.dart';

class AgendaService{

  String _sistema = "agenda";

  final CollectionReference _agendaCollectionReference = Firestore.instance.collection('wedding');

  Future<DocumentSnapshot> getAgendaById(String wedID, String id) {
    return _agendaCollectionReference.doc(wedID).collection(_sistema).doc(id).get();
  }

  Stream<QuerySnapshot> getAgendaAsStream(String wedID) {
    return _agendaCollectionReference.doc(wedID)
        .collection(_sistema)
        .snapshots();
  }

  Stream<List<AgendaModel>> getAgendaListAsStream(String wedID) {
    CollectionReference _agendaReference =  _agendaCollectionReference.document(wedID)
        .collection(_sistema);

    var agendaDocumentSnapshot = _agendaReference.snapshots();
    return agendaDocumentSnapshot.map((qShot) => qShot.docs
        .map((snapshot) => AgendaModel.fromMap(snapshot.data(), snapshot.id))
        .where((mappedItem) => mappedItem.title != null)
        .toList());
  }

  Future<QuerySnapshot> getAgenda(String wedID) {
    return _agendaCollectionReference.document(wedID)
        .collection(_sistema)
        .getDocuments();
  }

  Future getAgendaOnce(String wedID) async {
    CollectionReference _agendaReference = _agendaCollectionReference.document(wedID)
        .collection(_sistema);

    try {
      var agendaDocumentSnapshot = await _agendaReference.getDocuments();
      if (agendaDocumentSnapshot.docs.isNotEmpty){
        return agendaDocumentSnapshot.docs
            .map((snapshot) => AgendaModel.fromMap(snapshot.data(), snapshot.id))
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

  Future deleteAgenda(String wedID, String documentId) async {
    await _agendaCollectionReference.document(wedID).collection(_sistema).document(documentId).delete();
  }

  Future updateAgenda(String wedID, String docID, AgendaModel agendaTemp) async {
    try {
      await _agendaCollectionReference.document(wedID).collection(_sistema).document(docID)
          .updateData(agendaTemp.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future addAgenda(String wedID, AgendaModel agendaTemp) async {
    try {
      await _agendaCollectionReference.document(wedID).collection(_sistema).add(agendaTemp.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }


}