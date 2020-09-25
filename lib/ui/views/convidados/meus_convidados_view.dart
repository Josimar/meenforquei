import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';
import 'package:meenforquei/ui/widgets/item/meus_convidado_item.dart';
import 'package:meenforquei/viewmodel/meus_convidados_view_model.dart';

class MeusConvidadosView extends StatelessWidget {
  final PageController pageController;
  MeusConvidadosView(this.pageController);

  @override
  Widget build(BuildContext context) {
    print('| => Meus Convidados View'); // ToDo: print meus convidados

    bool _podeEditar = false;

    final convidadoProvider = Provider.of<MeusConvidadosViewModel>(context);

    return ViewModelBuilder<MeusConvidadosViewModel>.reactive(
        viewModelBuilder: () => MeusConvidadosViewModel(),
        onModelReady: (model) => model.fetchMeusConvidados(),
        builder: (context, model, child) => Scaffold(
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: !convidadoProvider.busy ? Icon(Icons.add) : CircularProgressIndicator(),
            onPressed: convidadoProvider.addMeusConvidados,
          ),
          drawer: CustomDrawer(pageController),
          appBar: AppBar(
            title: Text(MEString.titleMeusConvidados),
            centerTitle: true,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: model.meusconvidados == null ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    )
                ) : model.meusconvidados.length == 0 ? Center(
                    child: Text(MEString.emptyConvidados)
                ) :
                ListView.builder(
                    itemCount: model.meusconvidados.length,
                    padding: new EdgeInsets.only(top: 5.0),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () => _podeEditar ? model.editMeusConvidados(index) : null, // model.detailMeusConvidados(index),
                          child: MeuConvidadoItem(
                              meuconvidado: model.meusconvidados[index],
                              onDeleteItem: () => model.deleteMeusConvidados(index)
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
