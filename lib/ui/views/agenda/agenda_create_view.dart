import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meenforquei/models/agenda_model.dart';
import 'package:meenforquei/models/user_model.dart';
import 'package:meenforquei/viewmodel/agenda_create_view_model.dart';
import 'package:meenforquei/viewmodel/agenda_view_model.dart';
import 'package:meenforquei/viewmodel/post_view_model.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';

class CreateAgendaView extends StatefulWidget {
  final AgendaModel edittingAgenda;
  final UserModel currentUser;

  CreateAgendaView({Key key, this.edittingAgenda, this.currentUser}) : super(key: key);

  @override
  _CreateAgendaViewState createState() => _CreateAgendaViewState();
}

class _CreateAgendaViewState extends State<CreateAgendaView> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  TextEditingController _title;
  TextEditingController _description;
  DateTime _eventDate;
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
  bool processing;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.edittingAgenda != null ? widget.edittingAgenda.title : "");
    _description = TextEditingController(text:  widget.edittingAgenda != null ? widget.edittingAgenda.description : "");
    _eventDate = DateTime.now();
    processing = false;
  }

  @override
  Widget build(BuildContext context) {
    final agendaProvider = Provider.of<AgendaViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.edittingAgenda != null ? "Edit Note" : "Add note"),
      ),
      key: _key,
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _title,
                  validator: (value) =>
                  (value.isEmpty) ? "Please Enter title" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "Title",
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _description,
                  minLines: 3,
                  maxLines: 5,
                  validator: (value) =>
                  (value.isEmpty) ? "Please Enter description" : null,
                  style: style,
                  decoration: InputDecoration(
                      labelText: "description",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
              const SizedBox(height: 10.0),
              ListTile(
                title: Text("Date (DD/MM/YYYY)"),
                subtitle: Text("${_eventDate.day} / ${_eventDate.month} / ${_eventDate.year}"),
                onTap: ()async{
                  DateTime picked = await showDatePicker(context: context, initialDate: _eventDate, firstDate: DateTime(_eventDate.year-5), lastDate: DateTime(_eventDate.year+5));
                  if(picked != null) {
                    setState(() {
                      _eventDate = picked;
                    });
                  }
                },
              ),

              SizedBox(height: 10.0),
              processing
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Theme.of(context).primaryColor,
                  child: MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          processing = true;
                        });
                        agendaProvider.agenda = AgendaModel(
                            title: _title.text,
                            description: _description.text,
                            date: _eventDate,
                            uid: widget.currentUser.uid,
                            did: ''
                        );
                        if(widget.edittingAgenda != null) {
                          agendaProvider.addAgenda(widget.edittingAgenda.did);
                        }else{
                          agendaProvider.addAgenda(null);
                        }
                        Navigator.pop(context);
                        setState(() {
                          processing = false;
                        });
                      }
                    },
                    child: Text(
                      "Save",
                      style: style.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    super.dispose();
  }
}