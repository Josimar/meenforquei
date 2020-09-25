import 'package:flutter/material.dart';

class LocalCerimoniaModel {
  final String title;
  final String imageurl;
  final String address;
  final String phone;
  final String lat;
  final String long;

  final String uid; // usuarios id
  final String did; // dpcument id

  LocalCerimoniaModel({
    @required this.title,
    this.imageurl,
    this.address,
    this.phone,
    this.lat,
    this.long,
    this.uid,
    this.did
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'imageurl': imageurl,
      'address': address,
      'phone': phone,
      'lat': lat,
      'long': long
    };
  }

  static LocalCerimoniaModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return LocalCerimoniaModel(
      title: map['title'],
      imageurl: map['imageurl'],
      address: map['address'],
      phone: map['phone'],
      lat: map['lat'],
      long: map['long'],
      did: map['documentId']
    );
  }
}
