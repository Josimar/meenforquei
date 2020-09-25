import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meenforquei/components/custom_text.dart';
import 'package:meenforquei/components/vertical_padding.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/viewmodel/login_view_model.dart';
import 'package:stacked/stacked.dart';

class CasalView extends StatefulWidget {
  final PageController pageController;

  CasalView(this.pageController);

  @override
  _CasalViewState createState() => _CasalViewState();
}

class _CasalViewState extends State<CasalView> {
  String _nomecasal, _data;

  @override
  Widget build(BuildContext context) {
    print('| => Casal View');  // ToDo: print casal view

    Widget _screenMain(){
      return Container(
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("image/home.jpg"),
                  fit: BoxFit.cover
              ),
            ),
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 15),
                _nomecasal != null
                    ?
                    VerticalPadding(child: CustomText(text: _nomecasal, textColor: Theme.of(context).primaryColor))
                    : Container(),
                Expanded(flex: 1, child: CustomText(text: '')),
                _data != null
                    ?
                    VerticalPadding(child: CustomText(text: _data, fontSize: 25, textColor: Theme.of(context).primaryColor))
                    : Container(), // ToDo: Formatar a data
              ],
            ),
          ),
        ),
      );
    }

    return ViewModelBuilder<LoginViewModel>.reactive(
      viewModelBuilder: () => LoginViewModel(),
      // onModelReady: (model) => model.fetchPosts(),
      builder: (context, model, child) {

        if (model.currentUser.nomecasal == null){
          model.quemSouEu(model.currentUser.uid);
        }

        _nomecasal = model.currentUser.nomecasal;
        _data = model.currentUser.data;

        return Scaffold(
          // key: _scaffoldKey,
          drawer: CustomDrawer(widget.pageController),
          appBar: AppBar(
            title: Text(MEString.dashboard),
            centerTitle: true,
            elevation: Platform.isIOS ? 0 : 4, // ToDo: tratar em todas páginas
          ),
          body: _screenMain(),
          // bottomBar: Checar necessidade do buttom bar
        );
      }
    );

  }
}
