import 'package:flutter/material.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/viewmodel/mensagem_view_model.dart';
import 'package:stacked/stacked.dart';

class MensagemConversasView extends StatefulWidget {
  @override
  _MensagemConversasViewState createState() => _MensagemConversasViewState();
}

class _MensagemConversasViewState extends State<MensagemConversasView> {

  @override
  Widget build(BuildContext context) {
    print('| => Mensagem Conversa View'); // ToDo: print mensagem

    // bool _podeEditar = false;

    return ViewModelBuilder<MensagensViewModel>.reactive(
      viewModelBuilder: () => MensagensViewModel(),
      onModelReady: (model) => model.fetchConversas(),
      builder: (context, model, child){
        return model.conversa == null ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            )
        ) : model.conversa.length == 0 ? Center(
            child: Text(
              MEString.emptyMensagem,
              style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
            )
        ) :
        ListView.builder(
          itemCount: model.conversa.length,
          itemBuilder: (context, indice){
            return Column(
              children: <Widget>[
                Divider(height: 14),
                ListTile(
                  onTap: (){
                    model.newMensagemConversa(model.conversa[indice].nome, model.conversa[indice].imageurl, model.conversa[indice].idDestinatario);
                  },
                  contentPadding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                  leading: CircleAvatar(
                      maxRadius: 30,
                      backgroundColor: Colors.grey,
                      backgroundImage: model.conversa[indice].imageurl != null ? NetworkImage(model.conversa[indice].imageurl) : null
                  ),
                  title: Text(
                    model.conversa[indice].nome,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    children: <Widget>[
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("08/07/2020 - 12:00",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            model.conversa[indice].tipoMensagem == "texto" ? model.conversa[indice].mensagem : "imagem...",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ]
                      )
                    ],
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
