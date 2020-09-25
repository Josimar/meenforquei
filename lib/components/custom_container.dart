import 'package:flutter/material.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/utilitarios.dart';

class CustomContainer extends StatelessWidget {
  final TamanhoCaixa size;
  final String imgurl;
  final String texto;
  final double width;
  final bool isdetail;

  CustomContainer({
    this.size = TamanhoCaixa.Peq, this.imgurl, this.texto = "", this.width = 0, this.isdetail = false
  });

  @override
  Widget build(BuildContext context) {
    double _width = 125, _height = 125;

    if (size == TamanhoCaixa.Peq) {
      _height = 100;
    }else if (size == TamanhoCaixa.Med){

    }else if (size == TamanhoCaixa.Gnd){

    }

    if (width > 0){
      _width = width;
    }

    if (texto != ""){
      return Container(
        width: _width,
        height: _height,
        alignment: Alignment.topLeft,
        child: Column(
          children: <Widget>[
            Text(texto), // ToDo: tratar textos grandes
            Expanded(flex: 1, child: Text('')),

            isdetail ?
            Center(
                child: FlatButton(
                  child: new Text(MEString.lermais),
                  onPressed: (){},
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Theme.of(context).primaryColor)
                  ),
                )
            ): Container()
          ],
        ),
      );
    }else{
      return Container(
        width: _width,
        height: _height,
        decoration: new BoxDecoration(
          image: new DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(imgurl)
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      );
    }

  }
}
