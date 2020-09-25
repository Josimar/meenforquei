import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';
import 'package:meenforquei/ui/widgets/item/noticia_item.dart';
import 'package:meenforquei/viewmodel/noticias_view_model.dart';

class NoticiasView extends StatelessWidget {
  final PageController pageController;
  NoticiasView(this.pageController);

  @override
  Widget build(BuildContext context) {
    print('| => Noticias View'); // ToDo: print Noticias

    bool _podeEditar = false;

    return ViewModelBuilder<NoticiasViewModel>.reactive(
        viewModelBuilder: () => NoticiasViewModel(),
        onModelReady: (model) => model.fetchNoticias(),
        builder: (context, model, child) => Scaffold(
          drawer: CustomDrawer(pageController),
          appBar: AppBar(
            title: Text(MEString.titleNoticias),
            centerTitle: true,
          ),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Expanded(
                child: model.noticia == null ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    )
                ) : model.noticia.length == 0 ? Center(
                    child: Text(MEString.emptyNoticia)
                ) :
                   ListView.builder(
                    itemCount: model.noticia.length,
                    padding: new EdgeInsets.only(top: 5.0),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => _podeEditar ? model.editNoticia(index) : model.detailNoticia(index),
                        child: NoticiaItem(
                            noticia: model.noticia[index],
                            onDeleteItem: () => model.deleteNoticia(index)
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
