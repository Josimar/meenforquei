import 'package:flutter/material.dart';
import 'package:meenforquei/ui/widgets/item/meu_fornecedor_item.dart';
import 'package:meenforquei/viewmodel/meus_fornecedores_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';

class MeusFornecedoresView extends StatelessWidget {
  final PageController pageController;
  MeusFornecedoresView(this.pageController);

  @override
  Widget build(BuildContext context) {
    print('| => Meus Fornecedores View'); // ToDo: print Meus Fornecedores

    bool _podeEditar = false;

    return ViewModelBuilder<MeusFornecedoresViewModel>.reactive(
        viewModelBuilder: () => MeusFornecedoresViewModel(),
        onModelReady: (model) => model.fetchMeusFornecedores(),
        builder: (context, model, child) => Scaffold(
          drawer: CustomDrawer(pageController),
          appBar: AppBar(
            title: Text(MEString.titleMeusFornecedores),
            centerTitle: true,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: model.meusfornecedores == null ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    )
                ) : model.meusfornecedores.length == 0 ? Center(
                    child: Text(
                      MEString.emptyMeusFornecedores,
                        style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                    )
                ) :
                ListView.builder(
                    itemCount: model.meusfornecedores.length,
                    padding: new EdgeInsets.only(top: 5.0),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () => _podeEditar ? model.editMeusFornecedores(index) : null, // model.detailMeuFornecedor(index),
                          child: MeuFornecedorItem(
                              meufornecedor: model.meusfornecedores[index],
                              onDeleteItem: () => model.deleteMeusFornecedores(index)
                          )
                      );
                    }
                ),
              )
            ],
          ),
        )
    );

  }
}
