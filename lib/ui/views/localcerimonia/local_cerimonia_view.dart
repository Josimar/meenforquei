import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';
import 'package:meenforquei/ui/widgets/item/local_cerimonia_item.dart';
import 'package:meenforquei/viewmodel/local_cerimonia_view_model.dart';

class LocalCerimoniaView extends StatelessWidget {
  final PageController pageController;
  const LocalCerimoniaView(this.pageController, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('| => Local Cerimonia View'); // ToDo: print Local Cerimonia

    bool _podeEditar = false;

    return ViewModelBuilder<LocalCerimoniaViewModel>.reactive(
        viewModelBuilder: () => LocalCerimoniaViewModel(),
        onModelReady: (model) => model.fetchLocalCerimonia(),
        builder: (context, model, child) => Scaffold(
          drawer: CustomDrawer(pageController),
          appBar: AppBar(
            title: Text(MEString.titleLocalCerimonia),
            centerTitle: true,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: model.local == null ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    )
                  ) :
                  ListView.builder(
                    itemCount: model.local.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => _podeEditar ? model.editLocal(index) : null,
                      child: LocalCerimoniaItem(
                        local: model.local[index],
                        onDeleteItem: () => model.deleteLocal(index)
                      )
                    ),
                  )
              )
            ]
          )
        )
    );
  }
}
