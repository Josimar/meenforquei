import 'package:flutter/material.dart';

class MeusConvidadosModel {
  final String email;
  final String name;
  final bool approved;
  final String phone;
  final String imageurl;
  final String date;

  final String user; // usuarios id
  final String did; // document id

  MeusConvidadosModel({
    @required this.name,
    this.email,
    this.phone,
    this.imageurl,
    this.approved = false,
    this.date,
    this.user,
    this.did
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'imageurl': imageurl,
      'approved': approved,
      'date': date,
      'user': user
    };
  }

  static MeusConvidadosModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return MeusConvidadosModel(
        name: map['name'],
        imageurl: map['imageurl'],
        email: map['email'],
        phone: map['phone'],
        approved: map['approved'],
        date: map['date'],
        user: map['user'],
        did: map['documentId']
    );
  }
}
