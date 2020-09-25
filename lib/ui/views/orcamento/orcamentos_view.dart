import 'package:flutter/material.dart';
import 'package:meenforquei/ui/widgets/item/orcamento_item.dart';
import 'package:meenforquei/viewmodel/orcamento_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';

class OrcamentoView extends StatelessWidget {
  final PageController pageController;
  OrcamentoView(this.pageController);

  @override
  Widget build(BuildContext context) {
    print('| => Orçamento View'); // ToDo: print Orçamento

    bool _podeEditar = false;

    return ViewModelBuilder<OrcamentoViewModel>.reactive(
        viewModelBuilder: () => OrcamentoViewModel(),
        onModelReady: (model) => model.fetchOrcamento(),
        builder: (context, model, child) => Scaffold(
          drawer: CustomDrawer(pageController),
          appBar: AppBar(
            title: Text(MEString.titleOrcamento),
            centerTitle: true,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: model.orcamento == null ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    )
                ) : model.orcamento.length == 0 ? Center(
                    child: Text(
                        MEString.emptyOrcamento,
                        style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                    )
                ) :
                ListView.builder(
                    itemCount: model.orcamento.length,
                    padding: new EdgeInsets.only(top: 5.0),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () => _podeEditar ? model.editOrcamento(index) : null, // model.detailOrcamento(index),
                          child: OrcamentoItem(
                              orcamento: model.orcamento[index],
                              onDeleteItem: () => model.deleteOrcamento(index)
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
