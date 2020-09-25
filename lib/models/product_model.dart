import 'package:flutter/material.dart';

class ProductModel extends ChangeNotifier {
  String id;
  String title;
  String description;
  String price;
  String img;
  String imageUrl;
  bool isFavorite;

  ProductModel({this.id, this.title, this.description, this.price, this.imageUrl, this.img, this.isFavorite});

  ProductModel.fromMap(Map snapshot, String id) :
        id = id,
        title = snapshot['title'] ?? '',
        description = snapshot['description'] ?? '',
        price = snapshot['price'] ?? '',
        imageUrl = snapshot['imageUrl'] ?? '',
        img = snapshot['img'] ?? '',
        isFavorite = snapshot['isFavorite'];

  toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "price": price,
      "img": img,
      "imageUrl": (imageUrl == null || imageUrl.isEmpty || imageUrl.trim().isEmpty) ?
          (img == 'bag' ? 'https://firebasestorage.googleapis.com/v0/b/me-enforquei.appspot.com/o/images%2Fbag.jpg?alt=media&token=1ea3e057-6268-4c72-9e04-5f2fcfe80ceb' :
            (img == 'computer' ? 'https://firebasestorage.googleapis.com/v0/b/me-enforquei.appspot.com/o/images%2Fcomputer.jpg?alt=media&token=38013e4a-cd05-4640-ad47-15d872e1223c' :
              (img == 'dress' ? 'https://firebasestorage.googleapis.com/v0/b/me-enforquei.appspot.com/o/images%2Fdress.jpg?alt=media&token=5f6e6759-5aa6-4171-839c-268cfb6c0476' :
                (img == 'phone' ? 'https://firebasestorage.googleapis.com/v0/b/me-enforquei.appspot.com/o/images%2Fphone.jpg?alt=media&token=db403cee-71da-4a1f-b0bd-4db27a6a05a8' :
                  (img == 'shoes' ? 'https://firebasestorage.googleapis.com/v0/b/me-enforquei.appspot.com/o/images%2Fshoes.jpg?alt=media&token=db6d953c-f69a-4bf0-b86a-45534cc27d82' : 'error')))))
          : imageUrl,
      "isFavorite": isFavorite == null ? false : isFavorite
    };
  }

}