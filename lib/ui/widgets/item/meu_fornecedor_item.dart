import 'package:flutter/material.dart';
import 'package:meenforquei/models/meus_fornecedores_model.dart';

class MeuFornecedorItem extends StatelessWidget {
  final MeusFornecedoresModel meufornecedor;
  final Function onDeleteItem;

  const MeuFornecedorItem({
    Key key,
    this.meufornecedor,
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
        child: Text('Meu Fornecedor Item'),
      ),
    );
  }

}