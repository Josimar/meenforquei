import 'package:flutter/material.dart';
import 'package:meenforquei/models/configuracao_model.dart';

class ConfiguracaoItem extends StatelessWidget {
  final ConfiguracaoModel configuracao;
  final Function onDeleteItem;

  const ConfiguracaoItem({
    Key key,
    this.configuracao,
    this.onDeleteItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //Foi adicionado dentro de Container para adicionar margem no item
    return new Container(
      margin: const EdgeInsets.only(
          left: 10.0, right: 10.0, bottom: 10.0, top: 0.0),
      child: new Material(
        borderRadius: new BorderRadius.circular(6.0),
        elevation: 2.0,
        child: Text('Configuração Item'),
      ),
    );
  }

}