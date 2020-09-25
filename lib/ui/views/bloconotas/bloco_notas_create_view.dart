import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meenforquei/models/bloco_notas_model.dart';
import 'package:meenforquei/viewmodel/bloco_notas_create_view_model.dart';
import 'package:stacked/stacked.dart';

class CreateBlocoNotasView extends StatefulWidget {
  final BlocoNotasModel edittingBlocoNotas;

  CreateBlocoNotasView({Key key, this.edittingBlocoNotas}) : super(key: key);

  @override
  _CreateBlocoNotasViewState createState() => _CreateBlocoNotasViewState();
}

class _CreateBlocoNotasViewState extends State<CreateBlocoNotasView> {
  final _titleController  = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageurlController = TextEditingController();
  final _dateController = TextEditingController();

  String title, description, imageurl, date;

  getTaskTitle(title) {
    this.title = title;
  }
  getTaskDescription(description) {
    this.description = description;
  }
  getTaskDate(date) {
    this.date = date;
  }

  int _myTaskType = 0;
  String taskVal;

  void _handleTaskType(int value){
    setState(() {
      _myTaskType = value;
      switch (_myTaskType){
        case 1:
          taskVal = 'travel';
          break;
        case 2:
          taskVal = 'shopping';
          break;
        case 3:
          taskVal = 'party';
          break;
        case 4:
          taskVal = 'others';
          break;
      }
    });
  }

  createTask(){
    DocumentReference dr = Firestore.instance
        .collection('wedding').document("qldfsi9iWNMySJtV3vmq")
        .collection('notes').document(title);

    Map<String, dynamic> task = {
      'title': title,
      'description': description,
      'date': date,
      'type': taskVal
    };
    dr.setData(task).whenComplete((){
      print('Task criado com sucesso');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreateBlocosNotasViewModel>.reactive(
      viewModelBuilder: () => CreateBlocosNotasViewModel(),
      onModelReady: (model){
        // titleController.text = edittingLocal?.title ?? '';  // update the text in the titleController
        model.setEdittingBlocoNotas(widget.edittingBlocoNotas);
      },
      builder: (context, model, child) => Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: <Widget>[
              _myAppBar(),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 80,
                child: ListView(
                  children: <Widget>[
                    Padding(
                        padding:EdgeInsets.only(left: 16, right: 16),
                        child: TextField(
                          controller: _titleController,
                            //onChanged: (String title){
                            //  getTaskTitle(title);
                            //},
                          decoration: InputDecoration(labelText: "Title: ")
                        )
                    ),
                    Padding(
                        padding:EdgeInsets.only(left: 16, right: 16),
                        child: TextField(
                            controller: _descriptionController,
                            //onChanged: (String description){
                            //  getTaskDescription(description);
                            //},
                            decoration: InputDecoration(labelText: "Description: ")
                        )
                    ),
                    Padding(
                        padding:EdgeInsets.only(left: 16, right: 16),
                        child: TextField(
                            controller: _dateController,
                            //onChanged: (String date){
                            //  getTaskDate(date);
                            //},
                            decoration: InputDecoration(labelText: "Date: ")
                        )
                    ),
                    SizedBox(height: 10),
                    Center(
                        child: Text(
                            "Select Type:",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
                        )
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Radio(
                                value: 1,
                                groupValue: _myTaskType, onChanged: _handleTaskType,
                                activeColor: Theme.of(context).primaryColor,
                              ),
                              Text('Travel', style: TextStyle(fontSize: 16)),
                            ]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Radio(
                                value: 2,
                                groupValue: _myTaskType, onChanged: _handleTaskType,
                                activeColor: Theme.of(context).primaryColor,
                              ),
                              Text('Shopping', style: TextStyle(fontSize: 16)),
                            ]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Radio(
                                value: 3,
                                groupValue: _myTaskType, onChanged: _handleTaskType,
                                activeColor: Theme.of(context).primaryColor,
                              ),
                              Text('Party', style: TextStyle(fontSize: 16)),
                            ]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Radio(
                                value: 4,
                                groupValue: _myTaskType, onChanged: _handleTaskType,
                                activeColor: Theme.of(context).primaryColor,
                              ),
                              Text('Others', style: TextStyle(fontSize: 16)),
                            ]
                        )
                      ],
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            color: Color(0xFFFA7397),
                            onPressed: (){
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel", style: TextStyle(color: Theme.of(context).primaryColor)),
                          ),
                          RaisedButton(
                            color: Color(0xFFFA7397),
                            onPressed: (){
                              // createTask();
                              model.addBlocoNotas(title: _titleController.text, description: _descriptionController.text, type: taskVal);
                            },
                            child: Text("Submit", style: TextStyle(color: Theme.of(context).primaryColor)),
                          )
                        ]
                    )
                  ],
                ),
              )
            ],
          )
      )
    );
  }

  Widget _myAppBar() {
    return Container(
      height: 80,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFA7397),
            const Color(0xFFFDDE42),
          ],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp
        )
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(
                  child: IconButton(
                    icon: Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
                    onPressed: (){Navigator.pop(context);},
                  )
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  child: Text("New", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold))
                )
              )
            ]
          )
        ),
      ),
    );
  }

}