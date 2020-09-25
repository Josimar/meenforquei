
class MensagemModel {
  String mensagem;
  String tipo;
  String urlimagem;
  String date;
  bool isliked;
  bool unread;
  String time;

  String cid; // usuarios id
  String did; // document id

  MensagemModel();

  MensagemModel.fromAll(
    this.tipo,
    this.mensagem,
    this.urlimagem,
    this.date,
    this.time,
    this.isliked,
    this.unread,
    this.cid,
    this.did
  );

  Map<String, dynamic> toMap() {
    return {
      'tipo': tipo,
      'urlimagem': urlimagem,
      'mensagem': mensagem,
      'isliked': isliked,
      'unread': unread,
      'date': date,
      'time': time,
      'cid': cid
    };
  }

  static MensagemModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return MensagemModel.fromAll(
        map['tipo'],
        map['mensagem'],
        map['urlimagem'],
        map['date'],
        map['time'],
        map['isliked'],
        map['unread'],
        map['cid'],
        map['documentId']
    );
  }

}
