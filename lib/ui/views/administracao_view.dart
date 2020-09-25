import 'package:flutter/material.dart';
import 'package:meenforquei/utils/meenforquei.dart';

class AdministracaoView extends StatelessWidget {
  final PageController pageController;
  AdministracaoView(this.pageController);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
            children: <Widget>[
              Text(MEString.administracao),
              CircularProgressIndicator()
            ]
        )
    );
  }
}
