import 'package:flutter/material.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/components/custom_text.dart';
import 'package:meenforquei/components/vertical_padding.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';

class NoivosView extends StatelessWidget {
  final PageController pageController;
  NoivosView(this.pageController);

  @override
  Widget build(BuildContext context) {
    print('| => Noivos View');  // ToDo: print noivos tab

    Widget _screenMain(BuildContext context, String _texto){
      return Container(
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("image/noivos.jpg"),
                  fit: BoxFit.cover
              ),
            ),
            padding: EdgeInsets.all(8),
            child: Center(
                child: VerticalPadding(child: CustomText(text: _texto, textColor: Theme.of(context).primaryColor))
            ),
          ),
        ),
      );
    }

    return Scaffold(
      drawer: CustomDrawer(pageController),
      appBar: AppBar(
        title: Text("Noivos"),
        centerTitle: true,
      ),
      body: _screenMain(context, MEString.textonoivos),
    );

  }
}
