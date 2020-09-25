import 'package:flutter/foundation.dart';

class PostModel {
  final String title;
  final String imageUrl;
  final String userId;
  final String documentId;

  PostModel({
    @required this.userId,
    @required this.title,
    this.documentId,
    this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'imageUrl': imageUrl,
    };
  }

  toJson() {
    return {
      'userId': userId,
      'title': title,
      'imageUrl': imageUrl,
    };
  }

  static PostModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return PostModel(
      title: map['title'],
      imageUrl: map['imageUrl'],
      userId: map['userId'],
      documentId: map['documentId'] == null ? documentId : map['documentId'] == null,
    );
  }
}
