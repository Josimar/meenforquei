import 'package:flutter/material.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:stacked/stacked.dart';
import 'package:meenforquei/models/noticia_model.dart';
import 'package:meenforquei/viewmodel/noticias_create_model.dart';

class DetailNoticiasView extends StatelessWidget {
  final titleController = TextEditingController();
  final NoticiaModel edittingNoticia;

  DetailNoticiasView({Key key, this.edittingNoticia}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateNoticiaViewModel>.reactive(
      viewModelBuilder: () => CreateNoticiaViewModel(),
      onModelReady: (model){
        titleController.text = edittingNoticia?.title ?? '';  // update the text in the titleController
        model.setEdittingNoticia(edittingNoticia);
      },
      builder: (context, model, child) => Scaffold(
        appBar: new AppBar(
          title: Text(MEString.voltar)
        ),
        body: new Container(
          margin: new EdgeInsets.all(10.0),
          child: new Material(
            elevation: 4.0,
            borderRadius: new BorderRadius.circular(6.0),
            child: new ListView(
              children: <Widget>[
                _getImageNetwork(edittingNoticia.imageurl),
                _getBody(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _getImageNetwork(url){
    return new Container(
        height: 200.0,
        child: new Image.network(
            url,
            fit: BoxFit.cover)
    );
  }

  Widget _getBody(){
    return new Container(
      margin: new EdgeInsets.all(15.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getTittle(edittingNoticia.title),
          _getDate(edittingNoticia.date),
          _getDescription(edittingNoticia.description),
        ],
      ),
    );
  }

  _getTittle(tittle) {
    return new Text(tittle,
      style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0),
    );
  }

  _getDate(date) {
    return new Container(
        margin: new EdgeInsets.only(top: 5.0),
        child: new Text(date,
          style: new TextStyle(
              fontSize: 10.0,
              color: Colors.grey
          ),
        )
    );
  }

  _getDescription(description) {
    return new Container(
      margin: new  EdgeInsets.only(top: 20.0),
      child: new Text(description),
    );
  }
}