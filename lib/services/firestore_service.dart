import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:meenforquei/models/bloco_notas_model.dart';
import 'package:meenforquei/models/configuracao_model.dart';
import 'package:meenforquei/models/meus_convidados_model.dart';
import 'package:meenforquei/models/meus_fornecedores_model.dart';
import 'package:meenforquei/models/orcamento_model.dart';
import 'package:meenforquei/models/play_list_model.dart';
import 'package:meenforquei/models/user_model.dart';
import 'package:meenforquei/models/local_cerimonia_model.dart';
import 'package:meenforquei/models/noticia_model.dart';
import 'package:meenforquei/models/retrospectiva_model.dart';

// import 'package:sqflite/sqflite.dart' as sqlite;

class FirestoreService {
  final CollectionReference _usersCollectionReference = Firestore.instance.collection('users');
  final CollectionReference _weddingCollectionReference = Firestore.instance.collection('wedding');

  FirebaseFirestore _db = FirebaseFirestore.instance;
  String path;
  CollectionReference ref;
  // ref = _db.collection(path);

  Future<QuerySnapshot> getDataCollection() {
    return ref.get() ;
  }
  Stream<QuerySnapshot> streamDataCollection() {
    return ref.snapshots() ;
  }
  Future<DocumentSnapshot> getDocumentById(String id) {
    return ref.doc(id).get();
  }
  Future<void> removeDocument(String id){
    return ref.doc(id).delete();
  }
  Future<DocumentReference> addDocument(Map data) {
    return ref.add(data);
  }
  Future<void> updateDocument(Map data , String id) {
    return ref.doc(id).update(data) ;
  }

  Future createUser(UserModel user) async {
    try {
      await _usersCollectionReference.doc(user.uid).set(user.toResumeMap());
    } catch (e) {
      // TODO: Find or create a way to repeat error handling without so much repeated code
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }


  /// **************    Notícias    ************** ///
  Future getNoticiaOnceOff(String wedID) async {
    CollectionReference _noticiasCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('news');

    try {
      var noticiasDocumentSnapshot = await _noticiasCollectionReference.get();
      if (noticiasDocumentSnapshot.docs.isNotEmpty){
        return noticiasDocumentSnapshot.docs
            .map((snapshot) => NoticiaModel.fromMap(snapshot.data(), snapshot.id))
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


  Future addNoticia(String wedID, NoticiaModel noticia) async {
    CollectionReference _noticiasCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('news');

    try {
      await _noticiasCollectionReference.add(noticia.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future updateNoticia(String wedID, NoticiaModel noticia) async {
    CollectionReference _noticiasCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('news');

    try {
      await _noticiasCollectionReference.doc(noticia.did)
          .update(noticia.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future deleteNoticia(String wedID, String documentId) async {
    CollectionReference _noticiasCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('news');

    await _noticiasCollectionReference.doc(documentId).delete();
  }
  /// **********END     Notícias     END********** ///

  Future createUsuario(Map<String, dynamic> userData, String userID) async {
    try {
      await _usersCollectionReference.doc(userID).set(userData);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future createCasal(String wedID, String uid, Map<String, dynamic> userData){
    try{
      _weddingCollectionReference.doc(wedID).collection("casal").doc().set(userData);
    } catch (e) {
      if (e is PlatformException) {
        print(e.message);
      }

      print(e.toString());
    }
  }

  Future<String> createWedding({
    String tagCasal,
    String nomePar1,
    String nomePar2})
  async {
    try {
      DocumentReference refWedding = await _weddingCollectionReference.add({
        "tagcasal": tagCasal,
        "nome1": nomePar1,
        "nome2": nomePar2
      });

      return refWedding.id;
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future getUser(String uid) async {
    try {
      var userData = await _usersCollectionReference.doc(uid).get();
      return UserModel.fromData(userData.data(), uid);
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  /// **********    Local Cerimonia    ********** ///
  Future getLocalCerimoniaOnceOff(String wedID) async {
    CollectionReference _localCerimoniaCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('places');

    try {
      var localCerimoniaDocumentSnapshot = await _localCerimoniaCollectionReference.get();
      if (localCerimoniaDocumentSnapshot.docs.isNotEmpty){
        return localCerimoniaDocumentSnapshot.docs
            .map((snapshot) => LocalCerimoniaModel.fromMap(snapshot.data(), snapshot.id))
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

  Future addLocal(String wedID, LocalCerimoniaModel local) async {
    CollectionReference _localCerimoniaCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('places');

    try {
      await _localCerimoniaCollectionReference.add(local.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future updateLocal(String wedID, LocalCerimoniaModel local) async {
    CollectionReference _localCerimoniaCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('places');

    try {
      await _localCerimoniaCollectionReference.doc(local.did).update(local.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future deleteLocalCerimonia(String wedID, String documentId) async {
    CollectionReference _localCerimoniaCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('places');

    await _localCerimoniaCollectionReference.doc(documentId).delete();
  }
  /// **********END     Local Cerimonia     END********** ///



  /// **********    Quiz    ********** ///
  Future deleteQuiz(String wedID, String documentId) async {
    CollectionReference _quizCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('quiz');

    await _quizCollectionReference.doc(documentId).delete();
  }
  /// **********END     Quiz     END********** ///

  /// **********    Play List    ********** ///
  Future deletePlayList(String wedID, String documentId) async {
      CollectionReference _playlistCollectionReference = FirebaseFirestore.instance
          .collection('wedding').doc(wedID)
          .collection('playlist');

      await _playlistCollectionReference.doc(documentId).delete();
  }

  Future getPlayListOnceOff(String wedID) async {
    CollectionReference _playlistCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('playlist');

    try {
      var playlistDocumentSnapshot = await _playlistCollectionReference.get();
      if (playlistDocumentSnapshot.docs.isNotEmpty){
        return playlistDocumentSnapshot.docs
            .map((snapshot) => PlayListModel.fromMap(snapshot.data(), snapshot.id))
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
  /// **********END     Play List     END********** ///


  /// **********    Meus Fornecedores    ********** ///
  Future deleteMeusFornecedores(String wedID, String documentId) async {
    CollectionReference _meusfornecedoresCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('meusfornecedores');

    await _meusfornecedoresCollectionReference.doc(documentId).delete();
  }

  Future getMeusFornecedoresOnceOff(String wedID) async {
    CollectionReference _meusfornecedoresCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('meusfornecedores');

    try {
      var meusfornecedoresDocumentSnapshot = await _meusfornecedoresCollectionReference.get();
      if (meusfornecedoresDocumentSnapshot.docs.isNotEmpty){
        return meusfornecedoresDocumentSnapshot.docs
            .map((snapshot) => MeusFornecedoresModel.fromMap(snapshot.data(), snapshot.id))
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
  /// **********END     Meus Fornecedores     END********** ///

  /// **********    Bloco Notas    ********** ///
  Future deleteBlocoNotas(String wedID, String documentId) async {
    CollectionReference _bloconotasCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('bloconotas');

    await _bloconotasCollectionReference.doc(documentId).delete();
  }

  Future getBlocoNotasOnceOff(String wedID) async {
    CollectionReference _bloconotasCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('notes');

    try {
      var bloconotasDocumentSnapshot = await _bloconotasCollectionReference.get();
      if (bloconotasDocumentSnapshot.docs.isNotEmpty){
        return bloconotasDocumentSnapshot.docs
            .map((snapshot) => BlocoNotasModel.fromMap(snapshot.data(), snapshot.id))
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

  Stream<QuerySnapshot> getBlocoNotasRealTime({String wedID, int offset, int limit}){
    final CollectionReference _bloconotasCollectionReference = FirebaseFirestore.instance
        .collection("wedding").doc(wedID)
        .collection('notes');

    Stream<QuerySnapshot> snapshots = _bloconotasCollectionReference.snapshots();

    if (offset != null){
      snapshots = snapshots.skip(offset);
    }

    if (limit != null){
      snapshots = snapshots.take(limit);
    }

    return snapshots;
  }

  Future addBlocoNotas(String wedID, BlocoNotasModel bloconotas) async {
    CollectionReference _bloconotasCollectionReference = FirebaseFirestore.instance
        .collection("wedding").doc(wedID)
        .collection('notes');

    try {
      await _bloconotasCollectionReference.add(bloconotas.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future<BlocoNotasModel> addBlocoNota(String wedID, BlocoNotasModel bloconotas) async {
    CollectionReference _bloconotasCollectionReference = FirebaseFirestore.instance
        .collection("wedding").doc(wedID)
        .collection('notes');

    final TransactionHandler createTransaction = (Transaction trans) async {
      final DocumentSnapshot ds = await trans.get(_bloconotasCollectionReference.doc());

      // final BlocoNotasModel model = BlocoNotasModel();
      final Map<String, dynamic> data = bloconotas.toMap();
      await trans.set(ds.reference, data);
      return data;
    };

    return FirebaseFirestore.instance.runTransaction(createTransaction).then((mapData){
      return BlocoNotasModel.fromMap(mapData, "ToDo: docID");
    }).catchError((onError){
      print('Error: $onError');
      return null;
    });
  }
  /// **********END     Bloco Notas     END********** ///

  /// **********    Retrospectivas    ********** ///
  Future getRetrospectivaOnceOff(String wedID) async {
    CollectionReference _retrospectivaCollectionReference = FirebaseFirestore.instance
        .collection("wedding").doc(wedID)
        .collection('retrospectiva');

    try {
      var retrospectivaDocumentSnapshot = await _retrospectivaCollectionReference.get();
      if (retrospectivaDocumentSnapshot.docs.isNotEmpty){
        return retrospectivaDocumentSnapshot.docs
            .map((snapshot) => RetrospectivaModel.fromMap(snapshot.data(), snapshot.id))
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
  /// **********END     Retrospectivas     END********** ///

  /// **********    Meus Convidados    ********** ///

  Future<MeusConvidadosModel> addConvidado(String wedID, MeusConvidadosModel convidadosModel) async {
    CollectionReference _meusconvidadosCollectionReference = FirebaseFirestore.instance
        .collection("wedding").doc(wedID)
        .collection('convidados');

    final TransactionHandler createTransaction = (Transaction trans) async {
      final DocumentSnapshot ds = await trans.get(_meusconvidadosCollectionReference.doc());

      final Map<String, dynamic> data = convidadosModel.toMap();
      await trans.set(ds.reference, data);
      return data;
    };

    return FirebaseFirestore.instance.runTransaction(createTransaction).then((mapData){
      return MeusConvidadosModel.fromMap(mapData, "ToDo: docID");
    }).catchError((onError){
      print('Error: $onError');
      return null;
    });
  }

  Future deleteMeusConvidados(String wedID, String documentId) async {
    CollectionReference _meusconvidadosCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('convidados');

    await _meusconvidadosCollectionReference.doc(documentId).delete();
  }

  Future getMeusConvidadosOnceOff(String wedID) async {
    CollectionReference _meusconvidadosCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('convidados');

    try {
      var meusconvidadosDocumentSnapshot = await _meusconvidadosCollectionReference.get();
      if (meusconvidadosDocumentSnapshot.docs.isNotEmpty){
        return meusconvidadosDocumentSnapshot.docs
            .map((snapshot) => MeusConvidadosModel.fromMap(snapshot.data(), snapshot.id))
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
  /// **********END     Meus Convidados     END********** ///


  /// **********    Orçamento    ********** ///
  Future deleteOrcamento(String wedID, String documentId) async {
    CollectionReference _orcamentoCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('orcamento');

    await _orcamentoCollectionReference.doc(documentId).delete();
  }

  Future getOrcamentoOnceOff(String wedID) async {
    CollectionReference _orcamentoCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('orcamento');

    try {
      var orcamentoDocumentSnapshot = await _orcamentoCollectionReference.get();
      if (orcamentoDocumentSnapshot.docs.isNotEmpty){
        return orcamentoDocumentSnapshot.docs
            .map((snapshot) => OrcamentoModel.fromMap(snapshot.data(), snapshot.id))
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
  /// **********END     Orçamento     END********** ///

  /// **********    Orçamento    ********** ///
  Future deleteConfiguracao(String wedID, String documentId) async {
    CollectionReference _configuracaoCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('configuracao');

    await _configuracaoCollectionReference.doc(documentId).delete();
  }

  Future getConfiguracaoOnceOff(String wedID) async {
    CollectionReference _configuracaoCollectionReference = FirebaseFirestore.instance
        .collection('wedding').doc(wedID)
        .collection('onfiguracao');

    try {
      var configuracaoDocumentSnapshot = await _configuracaoCollectionReference.get();
      if (configuracaoDocumentSnapshot.docs.isNotEmpty){
        return configuracaoDocumentSnapshot.docs
            .map((snapshot) => ConfiguracaoModel.fromMap(snapshot.data(), snapshot.id))
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
  /// **********END     Orçamento     END********** ///

}
