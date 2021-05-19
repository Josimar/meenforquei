import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meenforquei/models/conversa_model.dart';
import 'package:meenforquei/models/convidados_model.dart';
import 'package:meenforquei/models/mensagem_model.dart';
import 'package:meenforquei/models/user_model.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/size_config.dart';
import 'package:meenforquei/viewmodel/mensagem_view_model.dart';
import 'package:provider/provider.dart';

class CreateMensagemView extends StatefulWidget  {
  final ConvidadosModel convidadoModel;
  final UserModel currentUser;

  CreateMensagemView({Key key, this.convidadoModel, this.currentUser}) : super(key: key);

  @override
  _CreateMensagemViewState createState() => _CreateMensagemViewState();
}

class _CreateMensagemViewState extends State<CreateMensagemView> {
  TextEditingController _controllerMensagem = TextEditingController();
  ScrollController _scrollMensagem = ScrollController();
  bool _subindoImagem = false;

  _enviarMensagem(){
    String txtMensagem = _controllerMensagem.text;

    if (txtMensagem.isNotEmpty){
      MensagemModel mensagem = MensagemModel();
      mensagem.cid = widget.currentUser.uid;
      mensagem.mensagem = txtMensagem;
      mensagem.urlimagem = "";
      mensagem.tipo = "texto";
      mensagem.date = DateTime.now().toString();
      mensagem.time = Timestamp.now().toString();

      // Remetente
      _salvarMensagem(widget.currentUser.uid, widget.convidadoModel.uid, mensagem);

      // Destinatário
      _salvarMensagem(widget.convidadoModel.uid, widget.currentUser.uid, mensagem);

      _salvarConversa(widget.currentUser.uid, widget.convidadoModel.uid, mensagem);
    }
  }

  _salvarMensagem(String idRemetente, String idDestinatario, MensagemModel msg) async {
    /*
    + mensagens
      + fulano
        + ciclano
          + documentIDMensagem
            + mensagem
    */

    FirebaseFirestore db = FirebaseFirestore.instance;

    await db.collection("wedding").doc(widget.currentUser.wedding)
        .collection("mensagens").doc(idRemetente.trim())
        .collection(idDestinatario.trim()).add(msg.toMap());

    _controllerMensagem.clear();
  }

  _salvarConversa(String idRemetente, String idDestinatario, MensagemModel msg){
    // salvar remetente
    ConversaModel cRemetente = ConversaModel();
    cRemetente.idRemetente = idRemetente.trim();
    cRemetente.idDestinatario = idDestinatario.trim();
    cRemetente.mensagem = msg.mensagem;
    cRemetente.nome = widget.convidadoModel.name;
    cRemetente.imageurl = widget.convidadoModel.urlimagem;
    cRemetente.tipoMensagem = msg.tipo;

    _salvarNoFirebase(idRemetente.trim(), idDestinatario.trim(), cRemetente);

    // salvar destinatário
    ConversaModel cDestinatario = ConversaModel();
    cDestinatario.idRemetente = idRemetente.trim();
    cDestinatario.idDestinatario = idDestinatario.trim();
    cDestinatario.mensagem = msg.mensagem;
    cDestinatario.nome = widget.currentUser.name;
    cDestinatario.imageurl = widget.currentUser.avatarUrl;
    cDestinatario.tipoMensagem = msg.tipo;

    _salvarNoFirebase(idDestinatario.trim(), idRemetente.trim(), cDestinatario);
  }

  _salvarNoFirebase(String idRemetente, String idDestinatario, ConversaModel msg) async {
    Firestore db = Firestore.instance;
    /*
    + conversas
      + fulano
        + ultima conversa
          + ciclano
            idDestinatario
            idRemetente
    */
    await db.collection("wedding").document(widget.currentUser.wedding)
        .collection("conversas").document(idRemetente)
        .collection("ultima").document(idDestinatario).setData(msg.toMap());
  }

  _enviarFoto() async {
    PickedFile pickedFile;
    final picker = ImagePicker();
    pickedFile = await picker.getImage(source: ImageSource.gallery);
    File _imagem = File(pickedFile.path);

    FirebaseStorage fireStorage = FirebaseStorage.instance;
    StorageReference storageRef = fireStorage.ref();

    String nomeImagem = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference arquivo = storageRef.child("mensagens")
        .child(widget.currentUser.uid).child(nomeImagem + ".jpg");

    // upload da imagem
    StorageUploadTask task = arquivo.putFile(_imagem);

    // Controlar progresso
    task.events.listen((StorageTaskEvent storageTaskEvent){
      if (storageTaskEvent.type == StorageTaskEventType.progress) {
        setState(() {
          _subindoImagem = true;
        });
      }else if (storageTaskEvent.type == StorageTaskEventType.success){
        setState(() {
          _subindoImagem = false;
        });
      }
    });

    // Recuperando url da imagem
    task.onComplete.then((StorageTaskSnapshot snapshot){
      _recuperarUrlImagem(snapshot);
    });
  }

  Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    MensagemModel mensagem = MensagemModel();
    mensagem.cid = widget.currentUser.uid;
    mensagem.mensagem = "";
    mensagem.urlimagem = url;
    mensagem.tipo = "imagem";
    mensagem.date = DateTime.now().toString();
    mensagem.time = Timestamp.now().toString();

    // Remetente
    _salvarMensagem(widget.currentUser.uid, widget.convidadoModel.uid, mensagem);

    // Destinatário
    _salvarMensagem(widget.convidadoModel.uid, widget.currentUser.uid, mensagem);
  }

  @override
  Widget build(BuildContext context) {
    print('| => Mensagem Create View'); // ToDo: print Post

    final messageProvider = Provider.of<MensagensViewModel>(context);

    var caixaMensagem = Container(
      padding: EdgeInsets.all(8),
      child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: 8),
                child: TextField(
                  controller: _controllerMensagem,
                  autofocus: true,
                  keyboardType: TextInputType.text,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(32, 8, 32, 8),
                    hintText: MEString.digiteMensagem,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32)
                    ),
                    prefixIcon:
                    _subindoImagem ? CircularProgressIndicator() :
                      IconButton(
                        icon: Icon(Icons.camera_alt),
                        onPressed: _enviarFoto,
                      )
                  ),

                )
              ),
            ),
            Platform.isIOS
                ? CupertinoButton(
                    child: Text("Enviar"),
                    onPressed: _enviarMensagem,
                  )
                : FloatingActionButton(
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Icon(Icons.send),
                    mini: true,
                    onPressed: _enviarMensagem,
                  )
          ]
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.grey,
              backgroundImage: widget.convidadoModel.urlimagem != null ?
                NetworkImage(widget.convidadoModel.urlimagem) : null,
            ),
             Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(widget.convidadoModel.name),
            )
          ]
        )
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("image/bg.png"), fit: BoxFit.cover)),
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  StreamBuilder(
                    stream: messageProvider.fetchMensagensAsStream(widget.currentUser.uid, widget.convidadoModel.uid),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                          switch (snapshot.connectionState){
                            case ConnectionState.none:
                            case ConnectionState.waiting:
                              return Center(
                                child: Column(
                                  children: <Widget>[
                                    Text(MEString.carregandoMensagem),
                                    CircularProgressIndicator()
                                  ],
                                ),
                              );
                              break;
                            case ConnectionState.active:
                            case ConnectionState.done:
                              QuerySnapshot querySnapshot = snapshot.data;
                              if (snapshot.hasError) {
                                return Text(MEString.errorLoadMensagem);
                              }else{
                                if (querySnapshot.documents.length == 0){
                                  return Expanded(
                                    child: Center(
                                      child: Text(
                                          MEString.emptyMensagem,
                                          style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                                      ),
                                    ),
                                  );
                                }
                                Timer(Duration(seconds: 1), (){
                                  _scrollMensagem.jumpTo(_scrollMensagem.position.maxScrollExtent);
                                });
                                
                                return Expanded(
                                  child: ListView.builder(
                                      controller: _scrollMensagem,
                                      itemCount: querySnapshot.documents.length,
                                      itemBuilder: (context, indice){

                                        // Recuperar mensagem
                                        List<DocumentSnapshot> mensagens = querySnapshot.documents.toList();
                                        DocumentSnapshot mensagem = mensagens[indice];

                                        double tamMaximo = MediaQuery.of(context).size.width * 0.8;
                                        Alignment alinhamento = Alignment.centerRight;
                                        Color cor = Color(0xffd2ffa5);

                                        // if (indice % 2 == 0){
                                        if (widget.currentUser.uid != mensagem.data()["cid"]){
                                          alinhamento = Alignment.centerLeft;
                                          cor = Colors.white;
                                        }

                                        // Quando atualiza o stream manda para a ultima mensagem
                                        // _scrollMensagem.jumpTo(_scrollMensagem.position.maxScrollExtent);
                                        
                                        return Align(
                                            alignment: alinhamento,
                                            child: Padding(
                                                padding: EdgeInsets.all(6),
                                                child: ConstrainedBox(
                                                  constraints: BoxConstraints(maxWidth: tamMaximo),
                                                  child: Container(
                                                    padding: EdgeInsets.all(13),
                                                    decoration: BoxDecoration(
                                                        color: cor,
                                                        borderRadius: BorderRadius.all(Radius.circular(8))
                                                    ),
                                                    child: mensagem.data()["tipo"] == "texto" ?
                                                      Text(mensagem.data()["mensagem"], style: TextStyle(fontSize: 16)) :
                                                      Image.network(mensagem.data()["urlimagem"])
                                                  ),
                                                )
                                            )
                                        );

                                      }
                                  ),
                                );
                              }

                              break;
                            default:
                              return Container(child: Text(MEString.errorMensagem));
                          }
                        }
                    ),
                    caixaMensagem,
                  ],
                )
              )
            ),
          )
        );


  }
}
