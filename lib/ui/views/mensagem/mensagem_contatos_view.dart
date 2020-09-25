import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meenforquei/models/convidados_model.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/viewmodel/mensagem_view_model.dart';
import 'package:stacked/stacked.dart';

class MensagemContatosView extends StatefulWidget {
  @override
  _MensagemContatosViewState createState() => _MensagemContatosViewState();
}

class _MensagemContatosViewState extends State<MensagemContatosView> {

  @override
  Widget build(BuildContext context) {
    print('| => Mensagem Contatos View'); // ToDo: print mensagem

    bool _podeEditar = false;

    return ViewModelBuilder<MensagensViewModel>.reactive(
        viewModelBuilder: () => MensagensViewModel(),
        onModelReady: (model) => model.fetchContatos(),
        builder: (context, model, child){
          return model.convidado == null ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
              )
          ) : model.convidado.length == 0 ? Center(
              child: Text(MEString.emptyConvidado)
          ) :
          ListView.builder(
            itemCount: model.convidado.length,
            itemBuilder: (context, indice){
              return Column(
                children: <Widget>[
                  Divider(height: 14),
                  ListTile(
                    onTap: (){
                      model.newMensagem(indice);
                    },
                    contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    leading: CircleAvatar(
                        maxRadius: 30,
                        backgroundColor: Colors.grey,
                        backgroundImage: model.convidado[indice].urlimagem != null ? NetworkImage(model.convidado[indice].urlimagem) : null
                    ),
                    title: Text(
                      model.convidado[indice].name,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      size: 14.0,
                    ),
                  )
                ],
              );

            },
          );
        }
    );

  }
}
