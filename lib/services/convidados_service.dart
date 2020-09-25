import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:meenforquei/models/convidados_model.dart';

class ConvidadosService{

  String _sistema = "convidados";

  final CollectionReference _convidadosCollectionReference = Firestore.instance.collection('wedding');

  Future<DocumentSnapshot> getConvidadoById(String wedID, String id) {
    return _convidadosCollectionReference.document(wedID).collection(_sistema).document(id).get();
  }

  Stream<QuerySnapshot> getConvidadosAsStream(String wedID) {
    return _convidadosCollectionReference.document(wedID)
        .collection(_sistema)
        .snapshots();
  }

  Stream<List<ConvidadosModel>> getConvidadosListAsStream(String wedID) {
    CollectionReference _convidadoReference =  _convidadosCollectionReference.document(wedID)
        .collection(_sistema);

    var convidadoDocumentSnapshot = _convidadoReference.snapshots();
    return convidadoDocumentSnapshot.map((qShot) => qShot.docs
        .map((snapshot) => ConvidadosModel.fromMap(snapshot.data(), snapshot.id))
        .where((mappedItem) => mappedItem.name != null)
        .toList());
  }

  Future<QuerySnapshot> getConvidados(String wedID) {
    return _convidadosCollectionReference.doc(wedID)
        .collection(_sistema)
        .get();
  }

  Future getConvidadosOnce(String wedID) async {
    CollectionReference _convidadosReference = _convidadosCollectionReference.document(wedID)
        .collection(_sistema);

    try {
      var convidadoDocumentSnapshot = await _convidadosReference.getDocuments();
      if (convidadoDocumentSnapshot.docs.isNotEmpty){
        return convidadoDocumentSnapshot.docs
            .map((snapshot) => ConvidadosModel.fromMap(snapshot.data(), snapshot.documentID))
            .where((mappedItem) => mappedItem.name != null)
            .toList();
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future deleteConvidado(String wedID, String documentId) async {
    await _convidadosCollectionReference.document(wedID).collection(_sistema).document(documentId).delete();
  }

  Future updateConvidado(String wedID, String docID, ConvidadosModel convidadoTemp) async {
    try {
      await _convidadosCollectionReference.document(wedID).collection(_sistema).document(docID)
          .updateData(convidadoTemp.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future addConvidado(String wedID, ConvidadosModel convidadoTemp) async {
    try {
      await _convidadosCollectionReference.document(wedID).collection(_sistema).add(convidadoTemp.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }


}