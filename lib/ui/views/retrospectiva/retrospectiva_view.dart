import 'package:flutter/material.dart';
import 'package:meenforquei/components/custom_container.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/utils/utilitarios.dart';
import 'package:meenforquei/viewmodel/retrospectiva_view_model.dart';
import 'package:stacked/stacked.dart';

class RetrospectivaView extends StatefulWidget {
  final PageController pageController;
  RetrospectivaView(this.pageController);

  @override
  _RetrospectivaViewState createState() => _RetrospectivaViewState();
}

class _RetrospectivaViewState extends State<RetrospectivaView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    print('| => Retrospectiva View'); // ToDo: print Retrospectiva View
    int _orderImagem = 0;

    return ViewModelBuilder<RetrospectivaViewModel>.reactive(
      viewModelBuilder: () => RetrospectivaViewModel(),
      onModelReady: (model) => model.fetchRetrospectivas(),
      builder: (context, model, child) => Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(widget.pageController),
        appBar: AppBar(
          title: Text("Retrospectiva"),
          centerTitle: true,
        ),
        body: model.busy ? Center(child: Column(children: <Widget>[Text("Carregando as retrospectivas"), CircularProgressIndicator()])) :
            model.retro == null
            ? Center(
              child: Text(MEString.emptyRetrospectiva),
            )
            : ListView.builder(
              itemCount: model.retro.length,
              shrinkWrap: true,
              itemBuilder: (context, index){

                _orderImagem = index % 2;

                return Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal:10, vertical:25),
                    child: Row(
                      children: <Widget>[
                        _listContainer(true, _orderImagem, model.retro[index].imageurl, model.retro[index].description),
                        SizedBox(width: 10),
                        _listContainer(false, _orderImagem, model.retro[index].imageurl, model.retro[index].description),
                      ],
                    )
                );
              },
            ),
        // bottomBar: Checar necessidade do buttom bar
    ));
  }

  Widget _listContainer(bool exibe, int ordem, String url, String texto){
    if (ordem > 0){
      exibe = !exibe;
    }
    if (exibe){
      return CustomContainer(
        size: TamanhoCaixa.Gnd,
        imgurl: url,
      );
    }else{
      return CustomContainer( // Passar para
          width: MediaQuery.of(context).size.width - 170,
          texto: texto,
          isdetail: false,
      );
    }
  }
}
