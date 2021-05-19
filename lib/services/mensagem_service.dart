import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meenforquei/models/conversa_model.dart';
import 'package:meenforquei/models/convidados_model.dart';
import 'package:meenforquei/models/mensagem_model.dart';

class MessageService {

  String _sistema = "mensagens";

  final CollectionReference _messageCollectionReference = FirebaseFirestore.instance.collection('wedding');

  Future<DocumentSnapshot> getMensagemById(String wedID, String id) {
    return _messageCollectionReference.doc(wedID).collection(_sistema).doc(id).get();
  }

  Stream<QuerySnapshot> getMensagemAsStream(String wedID, String remetenteId, String destinatarioId) {
    return _messageCollectionReference.doc(wedID)
        .collection(_sistema)
        .doc(remetenteId)
        .collection(destinatarioId)
        .orderBy("time", descending: false)
        .snapshots();
  }

  Future<QuerySnapshot> getMensagem(String wedID) {
    return _messageCollectionReference.doc(wedID)
        .collection(_sistema)
        .get();
  }

  Future deleteMensagem(String wedID, String documentId) async {
    CollectionReference _mensagensCollectionReference = Firestore.instance
        .collection('wedding').doc(wedID)
        .collection('mensagens');

    await _mensagensCollectionReference.doc(documentId).delete();
  }

  Future getMensagensOnceOff(String wedID) async {
    CollectionReference _mensagensCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('mensagens');

    try {
      var mensagensDocumentSnapshot = await _mensagensCollectionReference.get();
      if (mensagensDocumentSnapshot.docs.isNotEmpty){
        return mensagensDocumentSnapshot.docs
            .map((snapshot) => MensagemModel.fromMap(snapshot.data(), snapshot.id))
            .where((mappedItem) => mappedItem.tipo != null)
            .toList();
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  // ToDo: teste de snapshot
  Stream<QuerySnapshot> streamMensagemCollection(String wedID, String uid, String destUid) {
//    await Future.delayed(const Duration(seconds: 2));

    return FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection("mensagens").doc(uid)
        .collection(destUid)
        .orderBy("date", descending: false)
        .snapshots();
  }

  Future getContatoOnce(String wedID, String uid) async {
    CollectionReference _contatoCollectionReference = Firestore.instance
        .collection('wedding').doc(wedID)
        .collection('convidados');

    CollectionReference _casalCollectionReference = Firestore.instance
        .collection('wedding').doc(wedID)
        .collection('casal');

    try {
      List<ConvidadosModel> listCasal, listContato;

      var contatoDocumentSnapshot = await _contatoCollectionReference.get();
      if (contatoDocumentSnapshot.docs.isNotEmpty){
        listContato = contatoDocumentSnapshot.docs
            .map((snapshot) => ConvidadosModel.fromMap(snapshot.data(), snapshot.id))
            .where((mappedItem) => mappedItem.uid != uid)
            .toList();
      }

      var casalDocumentSnapshot = await _casalCollectionReference.getDocuments();
      if (casalDocumentSnapshot.docs.isNotEmpty){
        listCasal = casalDocumentSnapshot.docs
            .map((snapshot) => ConvidadosModel.fromMap(snapshot.data(), snapshot.documentID))
            .where((mappedItem) => mappedItem.uid != uid)
            .toList();
      }

      return new List<ConvidadosModel>.from(listCasal)..addAll(listContato);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }

  }

  Future getConversaOnce(String wedID, String uid) async {
    CollectionReference _conversasCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('conversas').doc(uid)
        .collection("ultima");

    try {
      var conversasDocumentSnapshot = await _conversasCollectionReference.get();
      if (conversasDocumentSnapshot.docs.isNotEmpty){
        return conversasDocumentSnapshot.docs
            .map((snapshot) => ConversaModel.fromMap(snapshot.data(), snapshot.id))
            .where((mappedItem) => mappedItem.tipoMensagem != null)
            .toList();
      }
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }

  }
}