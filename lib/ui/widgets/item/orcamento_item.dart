import 'package:flutter/material.dart';
import 'package:meenforquei/models/orcamento_model.dart';

class OrcamentoItem extends StatelessWidget {
  final OrcamentoModel orcamento;
  final Function onDeleteItem;

  const OrcamentoItem({
    Key key,
    this.orcamento,
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
        child: Text('Orçamento Item'),
      ),
    );
  }

}