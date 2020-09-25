import 'dart:async';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meenforquei/models/post_model.dart';

class PostService {

  String _sistema = "post";

  final CollectionReference _postCollectionReference = Firestore.instance
      .collection('wedding');

  Future<DocumentSnapshot> getPostById(String wedID, String id) {
    return _postCollectionReference.doc(wedID)
        .collection(_sistema).doc(id).get();
  }

  Stream<QuerySnapshot> getPostAsStream(String wedID) {
    return _postCollectionReference.doc(wedID).collection(_sistema).snapshots();
  }

  Future<QuerySnapshot> getPost(String wedID) {
    return _postCollectionReference.doc(wedID).collection(_sistema).get();
  }


  Future getPostsOnceOff(String wedID) async {
    try {
      var postDocumentSnapshot = await _postCollectionReference.doc(wedID)
          .collection('post').get();
      if (postDocumentSnapshot.docs.isNotEmpty) {
        return postDocumentSnapshot.docs
            .map((snapshot) =>
            PostModel.fromMap(snapshot.data(), snapshot.id))
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

  Future deletePost(String wedID, String documentId) async {
    await _postCollectionReference.doc(wedID)
        .collection('post').doc(documentId).delete();
  }

  Future updatePost(String wedID, PostModel post) async {
    try {
      await _postCollectionReference.doc(wedID).collection('post').doc(post.documentId)
          .update(post.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

  Future addPost(String wedID, PostModel post) async {
    try {
      await _postCollectionReference.doc(wedID).collection('post').add(post.toMap());
    } catch (e) {
      if (e is PlatformException) {
        return e.message;
      }

      return e.toString();
    }
  }

}