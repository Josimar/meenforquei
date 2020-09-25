import 'package:flutter/material.dart';
import 'package:meenforquei/models/meus_convidados_model.dart';

class MeuConvidadoItem extends StatelessWidget {
  final MeusConvidadosModel meuconvidado;
  final Function onDeleteItem;

  const MeuConvidadoItem({
    Key key,
    this.meuconvidado,
    this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Foi adicionado dentro de Container para adicionar margem no item
    return new Container(
      margin: const EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0, top: 0.0),
      child: new Material(
        // borderRadius: new BorderRadius.circular(8.0),
        elevation: 0.5,
        child: Card(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(child: Text(meuconvidado.name[0])),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, bottom: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(meuconvidado.name),
                    Text(meuconvidado.email),
                    Text(meuconvidado.phone),
                    /*
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: OutlineButton(
                            child: Text('Attachment'),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                            ),
                            onPressed: null,
                          ),
                        )
                      ],
                    )
                    */
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

}