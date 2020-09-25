import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meenforquei/models/tarefa_model.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';
import 'package:meenforquei/viewmodel/tarefas_view_model.dart';

class TarefasView extends StatefulWidget {
  final PageController pageController;
  TarefasView(this.pageController);

  @override
  _TarefasViewState createState() => _TarefasViewState();
}

class _TarefasViewState extends State<TarefasView> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _todoController = TextEditingController();

  Future<Null> _refresh() async {
    await Future.delayed(Duration(seconds: 1));
    return null;
  }

  @override
  Widget build(BuildContext context) {
    print('| => Tarefas View'); // ToDo: print Tarefas View

    final tarefaProvider = Provider.of<TarefasViewModel>(context);

    var caixaTarefa = Container(
      padding: EdgeInsets.fromLTRB(17, 1, 7, 1),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _todoController,
              decoration: InputDecoration(
                  labelText: MEString.newTarefa,
                  labelStyle: TextStyle(color: Theme.of(context).primaryColor)
              ),
            ),
          ),
          RaisedButton(
              color: Theme.of(context).primaryColor,
              child: Text(MEString.newNova),
              textColor: Colors.white,
              onPressed: (){
                // Save task
                tarefaProvider.addTarefa(title: _todoController.text);
                tarefaProvider.setEdittingTarefa(null);
                _todoController.text = "";
              }
          )
        ],
      ),
    );

    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(widget.pageController),
      appBar: AppBar(
        title: Text(MEString.titleTarefas),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                caixaTarefa,
                StreamBuilder(
                  stream: tarefaProvider.fetchTarefasAsStream(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                    switch (snapshot.connectionState){
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: Column(
                            children: <Widget>[
                              Text(MEString.carregandoMensagem),
                              CircularProgressIndicator()
                            ],
                          ),
                        );
                        break;
                      case ConnectionState.active:
                      case ConnectionState.done:
                        QuerySnapshot querySnapshot = snapshot.data;
                        if (snapshot.hasError){
                          return Text(MEString.errorLoadMensagem);
                        }else{
                          if (querySnapshot.docs.length == 0){
                            return Expanded(
                              child: Center(
                                child: Text(
                                    MEString.emptyMensagem,
                                    style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor)
                                ),
                              ),
                            );
                          }
                          return Expanded(
                            child: RefreshIndicator(
                              onRefresh: (){
                                return _refresh();
                              },
                              child: ListView.builder(
                                padding: EdgeInsets.only(top: 10),
                                itemCount: querySnapshot.docs.length,
                                itemBuilder: (context, index){
                                  // Recuperar tarefa
                                  List<DocumentSnapshot> tarefas = querySnapshot.docs.toList();
                                  DocumentSnapshot tarefa = tarefas[index];

                                  bool _completed = false;
                                  if (tarefa.data()["complete"] == null || tarefa.data()["complete"] == ""){
                                    _completed = false;
                                  }else{
                                    _completed = tarefa.data()["complete"];
                                  }
                                  final tarefaID =  tarefa.id;
                                  return Dismissible(
                                    key: UniqueKey(), // Key(item),
                                    // direction: DismissDirection.vertical,
                                    onDismissed: (direction){
                                      if (direction == DismissDirection.endToStart){
                                        tarefaProvider.deleteTarefa(tarefaID, false);

                                        final snackbar = SnackBar(
                                          backgroundColor: Theme.of(context).primaryColor,
                                          duration: Duration(seconds: 5),
                                          content: Text(MEString.removedTarefa),
                                          action: SnackBarAction(
                                            label: MEString.desfazer,
                                            onPressed: (){
                                              tarefaProvider.setEdittingTarefa(null);
                                              tarefaProvider.recuperaTarefa(tarefaID, false);
                                              _todoController.text = "";
                                            },
                                          ),
                                        );
                                        Scaffold.of(context).removeCurrentSnackBar();
                                        Scaffold.of(context).showSnackBar(snackbar);
                                      }else if(direction == DismissDirection.startToEnd){
                                        tarefaProvider.setEdittingTarefa(
                                            TarefaModel(
                                                title: tarefa.data()["title"],
                                                description: tarefa.data()["description"],
                                                cid: tarefa.data()["cid"],
                                                rid: tarefa.data()["rid"],
                                                tid: tarefaID,
                                                deleted: tarefa.data()["deleted"],
                                                date: tarefa.data()["date"],
                                                updated: tarefa.data()["updated"],
                                                complete: _completed
                                            )
                                        );
                                        _todoController.text = tarefa.data()["title"];
                                      }
                                    },
                                    background: Container(
                                      color: Colors.green,
                                      padding: EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: <Widget>[
                                          Icon(Icons.edit, color: Colors.white)
                                        ],
                                      ),
                                    ),
                                    secondaryBackground: Container(
                                      color: Colors.red,
                                      padding: EdgeInsets.all(16),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: <Widget>[
                                          Icon(Icons.delete, color: Colors.white)
                                        ],
                                      ),
                                    ),
                                    child: CheckboxListTile(
                                      title: Text(tarefa.data()["title"]),
                                      value: _completed,
                                      secondary: CircleAvatar(
                                        backgroundColor: Theme.of(context).primaryColor,
                                        child: Icon(_completed ? Icons.check : Icons.error),
                                      ),
                                      onChanged: (bool value) {
                                        tarefaProvider.setEdittingTarefa(
                                          TarefaModel(
                                              title: tarefa.data()["title"],
                                              description: tarefa.data()["description"],
                                              cid: tarefa.data()["cid"],
                                              rid: tarefa.data()["rid"],
                                              tid: tarefaID,
                                              deleted: tarefa.data()["deleted"],
                                              date: tarefa.data()["date"],
                                              updated: tarefa.data()["updated"],
                                              complete: value
                                          )
                                        );
                                        tarefaProvider.addTarefa(title: tarefa.data()["title"]);
                                      },
                                    )
                                  );
                                },
                              )
                            )
                          );
                        }
                        break;
                      default:
                        return Container(child: Text(MEString.errorMensagem));
                    }
                  }
                )
              ],
            )
          ),
        )
      ),
          // bottomBar: Checar necessidade do buttom bar

    );
  }
}
