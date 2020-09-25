import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:meenforquei/models/check_list_model.dart';
import 'package:meenforquei/ui/widgets/custom_drawer.dart';
import 'package:meenforquei/viewmodel/check_list_view_model.dart';

class CheckListView extends StatefulWidget {
  final PageController pageController;
  CheckListView(this.pageController, {Key key}) : super(key: key);

  @override
  _CheckListViewState createState() => _CheckListViewState();
}

class NewItem {
  bool isExpanded;
  final String header;
  final Widget body;
  final Icon iconpic;
  NewItem(this.isExpanded, this.header, this.body, this.iconpic);
}

class _CheckListViewState extends State<CheckListView> {
  List<CheckListModel> checklist;

  @override
  Widget build(BuildContext context) {
    print('| => Check List View'); // ToDo: print Check List

    bool _podeEditar = true;

    final checklistProvider = Provider.of<CheckListViewModel>(context);

    List<NewItem> items = <NewItem>[
      NewItem(
          false, // isExpanded ?
          'Header', // header
          Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                  children: <Widget>[
                    Text('data'),
                    Text('data'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text('data'),
                        Text('data'),
                        Text('data'),
                      ],
                    ),
                    Radio(value: null, groupValue: null, onChanged: null)
                  ]
              )
          ), // body
          Icon(Icons.image) // iconPic
      ),
    ];

        return Scaffold(
            floatingActionButton: _podeEditar ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              child: !checklistProvider.busy ? Icon(Icons.add) : CircularProgressIndicator(),
              onPressed: checklistProvider.newCheckList,
            ) : null,
            drawer: CustomDrawer(widget.pageController),
            appBar: AppBar(
              title: Text(MEString.titleCheckList),
              centerTitle: true,
            ),
          body: new FutureBuilder<List<CheckListModel>>(
            future: checklistProvider.fetchCheckList(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);

              return snapshot.hasData ?
                ListView.builder(
                    itemCount: checklistProvider.checklist.length,
                    itemBuilder: (context, index) {
                      return ExpansionTile(
                          title: Text(checklistProvider.checklist[index].title),
                          children: <Widget>[
                            for (var i = 0; i < checklistProvider.checklist[index].tasks.length; i++)
                              CheckboxListTile(
                                title: Text(checklistProvider.checklist[index].tasks[i].description),
                                subtitle: Text(checklistProvider.checklist[index].title),
                                value: false,
                                onChanged: (val){
                                  print(checklistProvider.checklist[index].tasks[i].did);
                                },
                              )
                          ]
                      );
                }) :
                Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor),
                    )
                );
            }
          ),
        );

  }

}