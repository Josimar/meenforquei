import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meenforquei/utils/meenforquei.dart';
import 'package:provider/provider.dart';
import 'package:meenforquei/models/user_model.dart';
import 'package:meenforquei/models/check_list_model.dart';
import 'package:meenforquei/viewmodel/check_list_view_model.dart';

class CreateCheckListView extends StatefulWidget {
  final CheckListModel edittingCheckList;
  final UserModel currentUser;

  CreateCheckListView({Key key, this.edittingCheckList, this.currentUser})
      : super(key: key);

  @override
  _CreateCheckListViewState createState() => _CreateCheckListViewState();
}

class _CreateCheckListViewState extends State<CreateCheckListView> {
  final _formKey = GlobalKey<FormState>();
  String periodo, title, description, order = '0';

  @override
  Widget build(BuildContext context) {
    final checklistProvider = Provider.of<CheckListViewModel>(context);

    checklistProvider.setEdittingCheckList(widget.edittingCheckList);
    if (widget.edittingCheckList != null) {
      title = widget.edittingCheckList.title;
      description = widget.edittingCheckList.description;
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: !checklistProvider.busy
            ? Icon(Icons.check)
            : CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Colors.white),
              ),
        onPressed: () {
          if (!checklistProvider.busy) {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              checklistProvider.addCheckList(periodo, CheckListModel(title: title, description: description, order: order, finished: false));
            }
          }
        },
        backgroundColor: !checklistProvider.busy
            ? Theme.of(context).primaryColor
            : Colors.grey[600],
      ),
      appBar: AppBar(title: Text(MEString.titleCheckList)),
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Form(
            key: _formKey,
            child: ListView(children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance.collection("wedding").document("ZEcjdTjdjSG79GX96u3K")
                        .collection("checklist").snapshots(),
                    builder: (context, snapshot){
                      if (!snapshot.hasData){
                        return Center(child: Text(MEString.loading));
                      }else{
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(FontAwesomeIcons.folderOpen, size: 25, color: Theme.of(context).primaryColor),
                              SizedBox(width: 50),
                              DropdownButton<String>(
                                  items: snapshot.data.docs.map<DropdownMenuItem<String>>((value) {
                                    return DropdownMenuItem<String>(
                                      value: value.id,
                                      child: new Text(value.data()['title']),
                                    );
                                  }).toList(),
                                  onChanged: (currencyValue){
//                                    final snackBar = SnackBar(
//                                      content: Text("Selected $currencyValue"),
//                                    );
//                                    Scaffold.of(context).showSnackBar(snackBar);
                                    setState((){
                                      periodo = currencyValue;
                                    });
                                  },
                                  value: periodo,
                                  isExpanded: false,
                                  hint: new Text("Choose período"),
                              ),
                            ]
                        );
                      }
                    }
                  ),
                ],
              ),
              SizedBox(height: 15),
              TextFormField(
                  textInputAction: TextInputAction.next,
                  initialValue: title,
                  decoration: InputDecoration(
                    icon: Icon(
                        FontAwesomeIcons.folder,
                        color: Theme.of(context).primaryColor
                    ),
                    labelText: MEString.titleformCheckList,
                    border: InputBorder.none,
                    // hintText: MEString.titleCheckList,
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return MEString.titleValidate;
                    }
                    return null;
                  },
                  onSaved: (value) => title = value),
              SizedBox(height: 15),
              TextFormField(
                  initialValue: title,
                  decoration: InputDecoration(
                    icon: Icon(
                      FontAwesomeIcons.fileArchive,
                      color: Theme.of(context).primaryColor
                    ),
                    labelText: MEString.descriptionCheckList,
                    border: InputBorder.none,
                    // hintText: MEString.descriptionCheckList,
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return MEString.descriptionValidate;
                    }
                    return null;
                  },
                  onSaved: (value) => description = value),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(FontAwesomeIcons.sortAmountDown, size: 25, color: Theme.of(context).primaryColor),
                  SizedBox(width: 50),
                  DropdownButton<String>(
                    value: order,
                    onChanged: (String newValue) {
                      setState(() {
                        order = newValue;
                      });
                    },
                    items: <String>[
                              '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
                              '11', '12', '13', '14', '15', '16', '17', '18', '19', '20',
                           ]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),

            ])),
      ),
    );
  }
}
