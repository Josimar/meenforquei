import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meenforquei/models/product_model.dart';

class ProductService {
  final CollectionReference _productsCollectionReference = Firestore.instance.collection('wedding');

  Future<DocumentSnapshot> getProductById(String wedID, String id) {
    return _productsCollectionReference.doc(wedID)
        .collection('products').doc(id).get();
  }

  Stream<QuerySnapshot> getProductsAsStream(String wedID) {
    return _productsCollectionReference.doc(wedID).collection('products').snapshots();
  }

  Future<QuerySnapshot> getProducts(String wedID, bool showFavoriteOnly) {
    if (showFavoriteOnly){
      return _productsCollectionReference.doc(wedID)
          .collection('products')
          .where('isFavorite', isEqualTo: showFavoriteOnly)
          .get();
    }else{
      return _productsCollectionReference.doc(wedID).collection('products').get();
    }
  }

  Future getProdutosOnce(String wedID) async {
    try {
      var productsDocumentSnapshot = await _productsCollectionReference
          .document(wedID).collection('products').get();
      if (productsDocumentSnapshot.docs.isNotEmpty) {
        return productsDocumentSnapshot.docs
            .map((snapshot) =>
            ProductModel.fromMap(snapshot.data(), snapshot.documentID))
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

  Future<DocumentReference> addProduct(String wedID, Map data) {
    return _productsCollectionReference.doc(wedID).collection('products').add(data);
  }

  Future removeProduct(String wedID, String id) {
    return _productsCollectionReference.doc(wedID)
        .collection('products').doc(id).delete();
  }

  Future<void> updateProduct(String wedID, String id, Map data) {
    return _productsCollectionReference.doc(wedID)
        .collection('products').doc(id).update(data);
  }

}