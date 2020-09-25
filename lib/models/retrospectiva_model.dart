import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class RetrospectivaModel {
  String uid;

  String cid, title, description, imageurl, date;
  bool isfavorite;

  RetrospectivaModel({
    this.uid, this.cid, this.title, this.description,
    this.imageurl, this.date, this.isfavorite = false});

  fromDocument(DocumentSnapshot document){
    cid = document.id;
    title = document.data()["title"];
    description = document.data()["description"];
    imageurl = document.data()["imageurl"];
    date = document.data()["date"];
    isfavorite = document.data()["isfavorite"];
  }

  Map<String, dynamic> toMap(){
    return {
      "title": title,
      "description": description,
      "imageurl": imageurl,
      "date": date,
      "isfavorite": isfavorite
    };
  }

  static RetrospectivaModel fromMap(Map<String, dynamic> map, String documentId) {
    if (map == null) return null;

    return RetrospectivaModel(
      title: map['title'],
      description: map['description'],
      imageurl: map['imageurl'],
      date: map['date'],
      isfavorite: map['isfavorite']
    );
  }

  RetrospectivaModel.fromDummy();

  Future<List> fromJSon() async{
    /*
    try{
      http.Response response = await http.get(url);
      const JsonDecoder decoder = const JsonDecoder();  // Using the JSON class to decode the JSON String
      return decoder.convert(response.body);

    } on Exception catch(_){
      return null;
    }
    */

    String json = "[  \n" +
        "   {  \n" +
        "      \"cid\":\"23658\",\n" +
        "      \"title\":\"O impacto do coronavírus no mercado dos casamentos\",\n" +
        "      \"description\":\"No sempre lucrativo e engenhoso mercado de festas, responsável por movimentar mais de 17 bilhões de reais por ano no Brasil, a pandemia do novo coronavírus causou um estrago sem precedentes – em especial, no ramo dos casamentos. Uma vez decretadas as medidas de isolamento, sumiram do calendário todos os eventos entre março e – para os mais otimistas – meados de julho, um abate de cerca de 40% da receita anual prevista para cerimonialistas, doceiros, floristas e toda sorte de profissionais envolvidos no “felizes para sempre”. Mesmo que com a maioria das celebrações reagendadas para o segundo semestre ou para 2021 (enquanto alguns corajosos encaram a cerimônia à distância ou online – leia reportagem aqui), o impacto dificilmente será atenuado. “A maioria dos cerimonialistas, por exemplos, vive por doze meses com os rendimentos da alta temporada, entre maio e outubro. É essencial que saibam negociar com o cliente”, explica Roberto Cohen, responsável por algumas das mais portentosas cerimônias do mercado. \",\n" +
        "      \"imageurl\":\"https://firebasestorage.googleapis.com/v0/b/me-enforquei.appspot.com/o/noticias%2Fnoticias_001.jpg?alt=media&token=f12e3549-4866-4a40-9898-9cbfb218932a\",\n" +
        "      \"date\":\"2020-05-25 18:27:50\"\n" +
        "   },\n" +
        "   {  \n" +
        "      \"cid\":\"23670\",\n" +
        "      \"title\":\"Casamento às cegas\",\n" +
        "      \"description\":\"Chamado de ‘experimento’, programa leva participantes ao altar no intuito de descobrir se as emoções estão à frente da atração física\",\n" +
        "      \"imageurl\":\"https://firebasestorage.googleapis.com/v0/b/me-enforquei.appspot.com/o/noticias%2Fnoticias_002.jpg?alt=media&token=41c8cf37-eccc-45e4-9ba6-c4b7014a4ad2\",\n" +
        "      \"date\":\"2020-03-06 06:03:24\"\n" +
        "   }\n" +
        "]";

    return jsonDecode(json);
  }

  List fromDummy()  {
    List dummyRetrospectiva = [
      RetrospectivaModel(
          cid: 'p1',
          title: 'Declaração de amor',
          description: 'Não te quero por um dia, um mês ou um ano. Te quero pra vida toda.',
          imageurl: 'https://firebasestorage.googleapis.com/v0/b/me-enforquei.appspot.com/o/images%2Fcasal_001.jpg?alt=media&token=37942f5b-3940-43a3-80c1-f28edae2396e',
          date: '2020-03-06 06:15'
      ),
      RetrospectivaModel(
          cid: 'p2',
          title: 'Declaração de amor',
          description: 'Namorar com você é a razão de todos os meus sorrisos. Te amo!',
          imageurl: 'https://firebasestorage.googleapis.com/v0/b/me-enforquei.appspot.com/o/images%2Fcasal_002.jpg?alt=media&token=4255ae1b-d91f-4c2c-aaeb-38d90f66c4ed',
          date: '2020-03-05 06:15'
      ),
      RetrospectivaModel(
          cid: 'p2',
          title: 'Declaração de amor',
          description: 'Eu sei que é do seu sorriso que a minha alma precisa.',
          imageurl: 'https://firebasestorage.googleapis.com/v0/b/me-enforquei.appspot.com/o/images%2Fcasal_003.jpg?alt=media&token=98cc5172-55e1-4770-8724-d4434357570b',
          date: '2020-03-04 06:15'
      )
    ];

    return dummyRetrospectiva;
  }

}

