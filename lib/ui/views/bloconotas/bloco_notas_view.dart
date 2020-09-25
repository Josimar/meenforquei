import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meenforquei/ui/views/bloconotas/bloco_notas_create_view.dart';
import 'package:meenforquei/ui/widgets/item/bloco_notas_item.dart';
import 'package:meenforquei/viewmodel/bloco_notas_view_model.dart';
import 'package:stacked/stacked.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';

class BlocoNotasView extends StatefulWidget {
  final PageController pageController;
  BlocoNotasView(this.pageController);

  @override
  _BlocoNotasViewState createState() => _BlocoNotasViewState();
}

class _BlocoNotasViewState extends State<BlocoNotasView> {
  @override
  Widget build(BuildContext context) {
    print('| => Bloco Notas View'); // ToDo: print Bloco Notas

    bool _podeEditar = false;

    setState(() {

    });

    return ViewModelBuilder<BlocoNotasViewModel>.reactive(
        viewModelBuilder: () => BlocoNotasViewModel(),
        onModelReady: (model) => model.fetchBlocoNotas(),
        builder: (context, model, child) => Scaffold(
          resizeToAvoidBottomInset: false,
          drawer: CustomDrawer(widget.pageController),
          appBar: AppBar(
            title: Text(MEString.titleBlocoNotas),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Theme.of(context).primaryColor,
            child: Icon(FontAwesomeIcons.list, color: Colors.white),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => CreateBlocoNotasView(), fullscreenDialog: true
              ));
            },
          ),
          body: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 80,
                child: model.busy ? Center(child: Column(children: <Widget>[Text("Carregando..."), CircularProgressIndicator()])) :
                ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  itemCount: model.bloconotas.length,
                  itemBuilder: (context, index){
                    return Stack(
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 5, right: 5),
                              child: Container(
                                padding: EdgeInsets.only(top: 5),
                                width: MediaQuery.of(context).size.width,
                                height: 80,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 5, right: 5),
                                  child: Material(
                                    color: Colors.white,
                                    elevation: 14,
                                    shadowColor: Color(0x802196F3),
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            stringType('${model.bloconotas[index].type}'),
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text('${model.bloconotas[index].title}', style: TextStyle(color: Colors.black, fontSize: 20)),
                                                Text('${model.bloconotas[index].description}', style: TextStyle(color: Colors.black, fontSize: 14)),
                                              ]
                                            ),
                                            Text('${model.bloconotas[index].date}', style: TextStyle(color: Colors.black, fontSize: 10)),
                                            SizedBox(height: 50)
                                          ],
                                        )
                                      )
                                    )
                                  )
                                )
                              )
                            )
                          ]
                        )
                      ]
                    );
                  }
                ),
              ),
              /*
              new Expanded(
                child: model.bloconotas == null ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    )
                ) : model.bloconotas.length == 0 ? Center(
                    child: Text(MEString.emptyBlocoNotas)
                ) :
                ListView.builder(
                    itemCount: model.bloconotas.length,
                    padding: new EdgeInsets.only(top: 5.0),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                          onTap: () => _podeEditar ? model.editBlocoNotas(index) : null, // model.detailBlocoNotas(index),
                          child: BlocoNotasItem(
                              bloconotas: model.bloconotas[index],
                              onDeleteItem: () => model.deleteBlocoNotas(index)
                          )
                      );
                    }
                ),
              )
              */
            ],
          ),
        )
    );

  }

  Widget stringType(String iconType) {
    IconData iconval;
    Color colorval;
    switch (iconType) {
      case 'travel':
        iconval = FontAwesomeIcons.mapMarkedAlt;
        colorval = Color(0xff4158ba);
        break;
      case 'shopping':
        iconval = FontAwesomeIcons.shoppingCart;
        colorval = Color(0xfffb537f);
        break;
      case 'gym':
        iconval = FontAwesomeIcons.dumbbell;
        colorval = Color(0xff4caf50);
        break;
      case 'party':
        iconval = FontAwesomeIcons.glassCheers;
        colorval = Color(0xff9962d0);
        break;
      default:
        iconval = FontAwesomeIcons.tasks;
        colorval = Color(0xff0dc8f5);
    }

    return CircleAvatar(
      backgroundColor: colorval,
      child: Icon(iconval, color: Colors.white, size: 20),
    );

  }
}
