import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meenforquei/ui/widgets/item/configuracao_item.dart';
import 'package:meenforquei/viewmodel/configuracao_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';

class ConfiguracaoView extends StatefulWidget {
  final PageController pageController;
  ConfiguracaoView(this.pageController);

  @override
  _ConfiguracaoViewState createState() => _ConfiguracaoViewState();
}

class _ConfiguracaoViewState extends State<ConfiguracaoView> {
  String _uid, _nome, _wedding, _urlimagem;
  bool _isCasal = false;

  TextEditingController _controllerNome = TextEditingController();
  File _imagem;
  final picker = ImagePicker();
  PickedFile pickedFile;
  bool _subindoImagem = false;
  String _urlImagemRecuperada;

  Future _recuperarImagem(String origemImagem) async {
    switch (origemImagem){
      case "camera":
        pickedFile = await picker.getImage(source: ImageSource.camera);
        break;
      case "galeria":
        pickedFile = await picker.getImage(source: ImageSource.gallery);
        break;
    }

    setState(() {
      _imagem = File(pickedFile.path);
      if (_imagem != null){
        _subindoImagem = true;
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem() async {
    FirebaseStorage fireStorage = FirebaseStorage.instance;
    StorageReference storageRef = fireStorage.ref();
    StorageReference arquivo = storageRef.child("perfil").child(_uid + ".jpg");

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
    _atualizarUrlImagemFirestore(url);

    setState(() {
      _urlImagemRecuperada = url;
    });
  }

  _atualizarUrlImagemFirestore(String url){
    Firestore db = Firestore.instance;

    Map<String, dynamic> dadosAtualizar = {
      "urlimagem": url
    };
    db.collection("users").document(_uid).updateData(dadosAtualizar);

    if (_isCasal){
      db.collection("wedding").document(_wedding).collection("casal").document(_uid).updateData(dadosAtualizar);
    }else{
      db.collection("wedding").document(_wedding).collection("convidados").document(_uid).updateData(dadosAtualizar);
    }

  }

  _atualizaNomeFirestore(){
    // ToDo: quando atualizar dados atualizar em users e todos outros pontos
    Firestore db = Firestore.instance;

    String nome = _controllerNome.text;

    Map<String, dynamic> dadosAtualizar = {
      "name": nome
    };
    db.collection("users").document(_uid).updateData(dadosAtualizar);

    if (_isCasal){
      db.collection("wedding").document(_wedding).collection("casal").document(_uid).updateData(dadosAtualizar);
    }else{
      db.collection("wedding").document(_wedding).collection("convidados").document(_uid).updateData(dadosAtualizar);
    }
  }

  _recuperarDadosUsuario() async {
    _controllerNome.text = _nome;

    if (_urlimagem != null){
      _urlImagemRecuperada = _urlimagem;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('| => Configuração View'); // ToDo: print configuração

    bool _podeEditar = false;

    return ViewModelBuilder<ConfiguracaoViewModel>.reactive(
      viewModelBuilder: () => ConfiguracaoViewModel(),
      onModelReady: (model) => model.fetchConfiguracao(),
      builder: (context, model, child){
        _uid = model.currentUser.uid;
        _nome = model.currentUser.name;
        _wedding = model.currentUser.wedding;
        _urlimagem = model.currentUser.avatarUrl;
        _isCasal = model.currentUser.isCasal;

        _recuperarDadosUsuario();

        return Scaffold(
          drawer: CustomDrawer(widget.pageController),
          appBar: AppBar(
            title: Text(MEString.titleConfiguracao),
            centerTitle: true,
          ),
          body: Container(
            padding: EdgeInsets.all(16),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(16),
                      child: _subindoImagem ? CircularProgressIndicator() : Container(),
                    ),
                    CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey,
                      backgroundImage: _urlImagemRecuperada != null ? NetworkImage(_urlImagemRecuperada) : null
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        FlatButton(
                          child: Text(MEString.camera),
                          onPressed: (){
                            _recuperarImagem('camera');
                          },
                        ),
                        FlatButton(
                          child: Text(MEString.galeria),
                          onPressed: (){
                            _recuperarImagem('galeria');
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: _controllerNome,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          hintText: MEString.nome,
                          filled:  true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32)
                          )
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 10),
                      child: RaisedButton(
                        child: Text(MEString.salvar, style: TextStyle(color: Colors.white, fontSize: 20)),
                        color: Theme.of(context).primaryColor,
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32)
                        ),
                        onPressed: (){
                          _atualizaNomeFirestore();
                        },
                      )
                    )
                  ],
                )
              )
            )
          )
        );
      }
    );

  }
}
