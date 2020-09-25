import 'package:flutter/material.dart';
import 'package:meenforquei/models/bloco_notas_model.dart';

class BlocoNotasItem extends StatelessWidget {
  final BlocoNotasModel bloconotas;
  final Function onDeleteItem;

  const BlocoNotasItem({
    Key key,
    this.bloconotas,
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
        child: Text('Bloco Notas Item'),
      ),
    );
  }

}