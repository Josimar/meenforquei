
class ConvidadosModel{

  String uid;
  String name;
  String email;
  String phone;
  String urlimagem;
  bool approved;

  ConvidadosModel();

  ConvidadosModel.fromAll(this.uid, this.name, this.email, this.phone, this.urlimagem, this.approved);

  static ConvidadosModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return ConvidadosModel.fromAll(
      map['user'],
      map["name"],
      map["email"],
      map["phone"],
      map["urlimagem"],
      map["approved"]
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'urlimagem': urlimagem
    };
  }

}