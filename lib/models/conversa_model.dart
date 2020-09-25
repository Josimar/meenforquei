class ConversaModel{
  String idRemetente;
  String idDestinatario;
  String nome;
  String mensagem;
  String imageurl;
  String tipoMensagem; // texto ou imagem

  ConversaModel();

  ConversaModel.fromAll(this.nome, this.mensagem, this.imageurl,
      this.idRemetente, this.idDestinatario, this.tipoMensagem);

  static ConversaModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return ConversaModel.fromAll(
        map['nome'],
        map['mensagem'],
        map['imageurl'],
        map['idRemetente'],
        map['idDestinatario'],
        map['tipoMensagem']
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "idRemetente": idRemetente,
      "idDestinatario": idDestinatario,
      "nome": nome,
      "mensagem": mensagem,
      "imageurl": imageurl,
      "tipoMensagem": tipoMensagem,
    };
  }
}